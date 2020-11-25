package com.thehuxley

import net.spy.memcached.AddrUtil
import net.spy.memcached.MemcachedClient
import sun.misc.BASE64Encoder

import java.security.MessageDigest

class MemcachedService {

    def static final DEFAULT_EXP = 600
    def static final Object NULL = "NULL"
    def MemcachedClient memcachedClient

    MemcachedService() {
        memcachedClient = new MemcachedClient(AddrUtil.getAddresses("localhost:11211"))
    }

    def get(String key) {
        return memcachedClient.get(generateSecurityKey(key))
    }

    def get(String key, function) {
        def value = get(key)
        if (!value) {
            value = update(key, function)
        }
        return (value == NULL) ? null : value
    }

    def get(String key, int exp, function) {
        def value = get(key)
        if (!value) {
            value = update(key, exp, function)
        }
        return (value == NULL) ? null : value
    }

    def set(String key, Object value) {
        memcachedClient.set(generateSecurityKey(key), DEFAULT_EXP, value)
    }

    def set(String key, int exp, Object value) {
        memcachedClient.set(generateSecurityKey(key), exp, value)
    }

    def update(String key, function) {
        def value = function()
        if (!value) {
            value = NULL
        }
        set(key, value)
        return value
    }

    def update(String key, int exp, function) {
        def value = function()
        if (!value) {
            value = NULL
        }
        set(key, exp, value)
        return value
    }

    def delete(String key) {
        memcachedClient.delete(generateSecurityKey(key))
    }

    def clear() {
        memcachedClient.flush()
    }

    def generateSecurityKey(String key) {
        MessageDigest md = MessageDigest.getInstance("SHA")
        md.update(key.getBytes('UTF-8'))
        return new BASE64Encoder().encode(md.digest())
    }
}
