package com.thehuxley

import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject

class UserProblemService {
	
	def memcachedService

	def getIdsByUserAndStatus (user, status) {

		def miss = false
		def result = []

		def userProblemIds = memcachedService.get(
			"userproblem-user:${user.id}-status:${status}", 
			24 * 60 * 60
		) {
			
			miss = true
			def resolved = []

			UserProblem.findAllByUserAndStatus(user, status).each {
                resolved.add(it.problem.id)
	        }

	        (resolved as JSON) as String
		} 

		JSON.parse(userProblemIds).each {
			result.add(it as long)
		}

	    [result: result, miss: miss]
    }

    def invalidateCache (ShiroUser user) {
    	memcachedService.delete("userproblem-user:${user.id}-status:${UserProblem.CORRECT}")
    	memcachedService.delete("userproblem-user:${user.id}-status:${UserProblem.TRIED}")
    	memcachedService.delete("userproblem-user:${user.id}-status:${UserProblem.NEVER_TRIED}")
    }

}