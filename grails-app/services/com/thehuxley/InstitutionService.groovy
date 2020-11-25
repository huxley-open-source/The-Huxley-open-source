package com.thehuxley

class InstitutionService {

    def publicFields(Institution instance, lazy = false) {
        def result = [
                id: instance.id,
                name: instance.name,
                phone: instance.phone,
                photo: instance.photo,
        ]

        if (!lazy) {
            result.putAll([
                //users: userService.publicFields(instance.users, true)
            ]);
        }

        result
    }

    def publicFields(List<Institution> list, lazy = false) {

        def result = []

        list.each {
            result.add(publicFields(it, lazy))
        }

        result
    }

}
