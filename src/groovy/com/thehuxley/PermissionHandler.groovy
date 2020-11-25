package com.thehuxley

class PermissionHandler {

    def private static PermissionHandler instance = null;
    def private static config

    private PermissionHandler() {
        loadPermissions()
    }

    public static getInstance() {
        if (instance) {
            return instance
        }

        return instance = new PermissionHandler()
    }

    def checkPermission(String license, String controller, String action) {
        def permissions = config.permissions
        def allowed= permissions.get('ALLOWED')
        def allow = false

        try{
            if (allowed instanceof List && allowed.contains('*')) {
                allow =  true
            } else if (allowed.get(controller) instanceof List && allowed.get(controller).contains('*')) {
                allow = true
            } else if (allowed.get(controller) instanceof List && allowed.get(controller).contains(action)) {
                allow = true
            } else if (permissions.get(license) instanceof List && permissions.get(license).contains('*')) {
                allow = true
            } else if (permissions.get(license).get(controller) instanceof List && permissions.get(license).get(controller).contains('*')) {
                allow = true
            } else if (permissions.get(license).get(controller) instanceof List && permissions.get(license).get(controller).contains(action)) {
                allow =  true
            }

        }catch (e) {
            return false
        }

        return allow
    }

    def checkPermission(String controller, String action) {
        def permissions = config.permissions
        def allowed= permissions.get('ALLOWED')
        def allow = false

        try{
            if (allowed instanceof List && allowed.contains('*')) {
                allow =  true
            } else if (allowed.get(controller) instanceof List && allowed.get(controller).contains('*')) {
                allow = true
            } else if (allowed.get(controller) instanceof List && allowed.get(controller).contains(action)) {
                allow = true
            }
        }catch (e) {
            return false
        }

        return allow
    }

    def reloadPermissions() {
        loadPermissions()
    }

    def private static loadPermissions() {
        ClassLoader classLoader = PermissionHandler.getClassLoader()
        ConfigSlurper configSlurper =  new ConfigSlurper();

        try {
            Class scriptClass = classLoader.loadClass("Permission")
            config = configSlurper.parse(scriptClass);
        } catch (ClassNotFoundException ex) {
            println "Não encontrou a classe Permission.class. " + ex
        }

    }
}
