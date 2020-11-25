package com.thehuxley

import grails.converters.JSON

class LicenseService {

    def memcachedService

    def getTotalLicenseType = {

        def licenseList = License.executeQuery("select distinct l, count(l.type) from License l group by l.type");

        return licenseList
    }

    def getTotalLicenseTypeByInstitution(institution){

        def licenseList = License.executeQuery("select distinct l, count(l.type) from License l where l.institution.id = ? group by l.type", [institution]);

        return licenseList
    }

    def getLicense(params){

        String institution = ""
        String where = " where "
        String type = ""
        String name = ""
        boolean and = false
        boolean addWhere = false
        def limit = 10
        def offset = 0
        if(params.get("LIMIT")){
            limit = params.get("LIMIT")
        }
        if(params.get("OFFSET")){
            offset = params.get("OFFSET")
        }
        String query = "Select l from License l"
        String countQuery = "Select count(l) from License l"
        if(params.get("INSTITUTION")){
            if(and){
                institution = " and "
            }
            institution += " l.institution = " + params.get("INSTITUTION") + " "
            addWhere = true
            and = true
        }
        if(params.get("TYPE")){
            if(and){
                type = " and "
            }
            type += " l.type.id = " + params.get("TYPE")
            addWhere = true
            and = true
        }
        if(params.get("NAME")){
            if(and){
                name = " and "
            }
            name += " l.user.name like '%" + params.get("NAME") + "%' "
            addWhere = true
            and = true
        }
        if(addWhere){
            where += institution + type + name
            query+= where
            countQuery += where
        }
        def licenseList = License.executeQuery(query + " order by l.user.name",[max:limit,offset:offset])
        def total = License.executeQuery(countQuery)
        HashMap resultMap = new HashMap<String,Object>()
        resultMap.put("TOTAL", total)
        resultMap.put("RESULT", licenseList)
        return resultMap

    }

    def getPackInfo(institution) {
        def returnMap
        if(institution) {
            returnMap = memcachedService.get(
                    "packinfo-params:${institution.id}",
                    10 * 24 * 60 * 60
            ) {
                HashMap<String, Object> packMap = new HashMap<String, Object>()
                def packList = LicensePack.executeQuery("select p from LicensePack p where p.institution.id = :institution and p.startDate <= :date and p.endDate > :date",[institution: institution.id, date: new GregorianCalendar().getTime()])
                int totalLicenses = 0
                packList.each {
                    totalLicenses += it.total
                }
                def licenseInUse = ClusterPermissions.executeQuery("select count(distinct cp.user.id) from ClusterPermissions cp where cp.group.institution.id = :institution and cp.group.endDate < :date and cp.permission = :permission",[permission: ClusterPermissions.STUDENT_PERMISSON, institution: institution.id, date: new GregorianCalendar().getTime()])[0]
//            licenseInUse += License.countByInstitutionAndType(institution, LicenseType.findByKind(LicenseType.TEACHER))
                packMap.put("TOTAL",totalLicenses)
                packMap.put("USED", licenseInUse)
                packMap.put("PACK_LIST", packList)

                (packMap as JSON) as String
            }
        } else {
            HashMap<String, Object> packMap = new HashMap<String, Object>()
            packMap.put("TOTAL",0)
            packMap.put("USED", 0)
            packMap.put("PACK_LIST", [])

            returnMap = (packMap as JSON) as String

        }


        JSON.parse(returnMap)



    }

}
