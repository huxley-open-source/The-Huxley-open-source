package com.thehuxley

import com.thehuxley.util.HuxleyProperties

class UserTagLib {

    static namespace = "huxley"

    def userBox = {attrs ->


        def photoHeightStyle = 'style="height: ' + attrs.photoHeight + ';"'
        def profile
        def name
        def email
        def score = 0
        if (attrs.user) {
            profile = Profile.findByUser(attrs.user);
            name = attrs.user.name
            email = attrs.user.email
            score = attrs.user.topCoderScore
        }

        if (attrs.profile) {
            profile = attrs.profile
            name = attrs.profile.user.name
            email = attrs.profile.user.email
            score = attrs.profile.user.topCoderScore
        }
        def image = """<div ${attrs.photoHeight ? photoHeightStyle : ''}><img src=" ${HuxleyProperties.getInstance().get("image.profile.dir")}thumb/thumb.jpg" border="0"  ${attrs.photoWidth ? 'width="' + attrs.photoWidth + '"' : ''} ${attrs.photoHeight ? 'height="' + attrs.photoHeight + '"' : ''}/></div>"""
        def position = attrs.positionIndex ?"""<span class="position">${attrs.positionIndex ? attrs.positionIndex : 0}º</span>""":""""""
        if(attrs.profile){
            image = """<div ${attrs.photoHeight ? photoHeightStyle : ''}><img src=" ${HuxleyProperties.getInstance().get("image.profile.dir")}thumb/$profile.smallPhoto" border="0"  ${attrs.photoWidth ? 'width="' + attrs.photoWidth + '"' : ''} ${attrs.photoHeight ? 'height="' + attrs.photoHeight + '"' : ''}/></div>"""
            position = """<span class="position">${attrs.positionIndex ? attrs.positionIndex : profile.user.topCoderPosition}º</span>"""
        }
        def width = "width: ${attrs.width}; "
        def height = "height: ${attrs.height}; "
        def maxWidth = "max-width: ${attrs.maxWidth}; "
        def maxHeight = "max-height: ${attrs.maxHeight}; "
        def style = '';
        def institution
        def showInstitution = attrs.institution != "false"

        try {
            if (profile.institution.id) {
                institution = profile.institution
            } else {
                showInstitution = false
            }
        } catch(Exception e) {
            showInstitution = false
        }

        if (attrs.width != '' || attrs.height != '' || attrs.maxWidth != '' || attrs.maxHeight != '') {
            style = 'style="';
            if (attrs.width && attrs.width != '') {
                style += width;
            }
            if (attrs.height && attrs.height != '') {
                style += height;
            }
            if (attrs.maxWidth && attrs.maxWidth != '') {
                style += maxWidth;
            }
            if (attrs.maxHeight && attrs.maxHeight != '') {
                style += maxHeight;
            }
            style += '"'
        }

        out << """
            <div class="useritem" $style>
                <div class="userbox">
                    ${(attrs.positionAfter == "true"  && attrs.position != "false") ? position : ''}
                    <div class="imagebox">
                        ${(attrs.positionAfter != "true"  && attrs.photo != "false") ? image : ''}
                    </div>
                    <div class="info">
                        ${(attrs.name != "false") ? """<span class="name">${user(profile: profile, name)}</span>""" : ''}
                        ${(attrs.email == "true") ? """<span class=\"email\">${email}</span>""" : ''}
                        ${showInstitution ? """<span class="institution">$institution.name</span>""" : ''}
                        ${(attrs.score != "false") ? """<span class="score">${g.formatNumber(number: score, type: "number", maxFractionDigits: 2)}</span>""" : ''}
                    </div>
                    ${(attrs.positionAfter != "true"  && attrs.position != "false") ? position : ''}
                    ${(attrs.positionAfter == "true"  && attrs.photo != "false") ? image : ''}
                    <span class="icon"></span>
                </div>
            </div>
        """

    }

    def user = {attrs, body ->
        def profile
        def cssClass = attrs.class? attrs.class : 'userlink'
        if (attrs.user) {
            profile = Profile.findByUser(attrs.user);
        }

        if (attrs.profile) {
            profile = attrs.profile
        }
        if(profile){
            out << g.link(class: cssClass, controller: "profile", action: "show", id: profile.hash, body())
        }else{
            out << """<span class:"$cssClass">$body()</span>"""
        }

    }

    def userDLCLeftBox = {attrs ->


        def photoHeightStyle = 'style="height: ' + attrs.photoHeight + ';"'
        def profileList = Profile.executeQuery("Select p from Profile p where (name like '%" + attrs.name + "%' or p.user.id in (Select cp.user.id from ClusterPermissions cp where cp.group.name like '%" + attrs.name + "%'))" + attrs.selectedIdList + " order by name")

        profileList.each{ profile ->
            def image = """<div ${attrs.photoHeight ? photoHeightStyle : ''}><img src=" ${HuxleyProperties.getInstance().get("image.profile.dir")}thumb/$profile.smallPhoto" border="0"  ${attrs.photoWidth ? 'width="' + attrs.photoWidth + '"' : ''} ${attrs.photoHeight ? 'height="' + attrs.photoHeight + '"' : ''}/></div>"""
            def position = """<span class="position">${profile.user.topCoderPosition}º</span>"""
            def width = "width: ${attrs.width}; "
            def height = "height: ${attrs.height}; "
            def maxWidth = "max-width: ${attrs.maxWidth}; "
            def maxHeight = "max-height: ${attrs.maxHeight}; "
            def style = '';

            if (attrs.width != '' || attrs.height != '' || attrs.maxWidth != '' || attrs.maxHeight != '') {
                style = 'style="';
                if (attrs.width && attrs.width != '') {
                    style += width;
                }
                if (attrs.height && attrs.height != '') {
                    style += height;
                }
                if (attrs.maxWidth && attrs.maxWidth != '') {
                    style += maxWidth;
                }
                if (attrs.maxHeight && attrs.maxHeight != '') {
                    style += maxHeight;
                }
                style += '"'
            }

            out << """
        <div class="useritem" $style id="${profile.user.id}">
            <span id="info-${profile.user.id}">
                <div class="userbox">
                    ${(attrs.positionAfter == "true"  && attrs.position != "false") ? position : ''}
                    <div class="imagebox">
                        ${(attrs.positionAfter != "true"  && attrs.photo != "false") ? image : ''}
                    </div>
                    <div class="info">
                        <span id="action-icon-${profile.user.id}"><a href=\"javascript:addToGroupList('${profile.user.id}')\" class=\"ui-bbutton\" style=\"float: right; padding: 6px 10px;\">+</a></span>
                        ${(attrs.name != "false") ? """<span class="name">${user(profile: profile, profile.name)}</span>""" : ''}
                        ${(attrs.email == "true") ? """<span class=\"email\">${profile.user.email}</span>""" : ''}
                        ${(attrs.score != "false") ? """<span class="score">${g.formatNumber(number: profile.user.topCoderScore, type: "number", maxFractionDigits: 2)}</span>""" : ''}
                    </div>
                    ${(attrs.positionAfter != "true"  && attrs.position != "false") ? position : ''}
                    ${(attrs.positionAfter == "true"  && attrs.photo != "false") ? image : ''}
                    <span class="icon"></span>
                </div>
            </span>
        </div>
    """


        }
    }

    def userDLCRightBox = {attrs ->


        def photoHeightStyle = 'style="height: ' + attrs.photoHeight + ';"'
        def profileList
        if (attrs.license != null && attrs.kind != null){
            profileList = Profile.executeQuery("Select p from Profile p where p.user.id in (Select Distinct l.user.id from License l where l.institution.id = " + attrs.license + " and l.type.id = " + attrs.kind + ") order by p.name")

        }else if(attrs.institution){
            profileList = Profile.executeQuery("Select p from Profile p where p.user.id in (Select Distinct user.id from Institution i left join i.users user where i.id = " + attrs.institution + ") order by p.name")
        }else{
            profileList = Profile.executeQuery("Select p from Profile p where p.user.id in (Select Distinct user.id from ClusterPermissions cp where cp.group.id = " + attrs.group + ") order by p.name")
        }



        profileList.each{ profile ->
            def image = """<div ${attrs.photoHeight ? photoHeightStyle : ''}><img src=" ${HuxleyProperties.getInstance().get("image.profile.dir")}thumb/$profile.smallPhoto" border="0"  ${attrs.photoWidth ? 'width="' + attrs.photoWidth + '"' : ''} ${attrs.photoHeight ? 'height="' + attrs.photoHeight + '"' : ''}/></div>"""
            def position = """<span class="position">${profile.user.topCoderPosition}º</span>"""
            def width = "width: ${attrs.width}; "
            def height = "height: ${attrs.height}; "
            def maxWidth = "max-width: ${attrs.maxWidth}; "
            def maxHeight = "max-height: ${attrs.maxHeight}; "
            def style = '';

            if (attrs.width != '' || attrs.height != '' || attrs.maxWidth != '' || attrs.maxHeight != '') {
                style = 'style="';
                if (attrs.width && attrs.width != '') {
                    style += width;
                }
                if (attrs.height && attrs.height != '') {
                    style += height;
                }
                if (attrs.maxWidth && attrs.maxWidth != '') {
                    style += maxWidth;
                }
                if (attrs.maxHeight && attrs.maxHeight != '') {
                    style += maxHeight;
                }
                style += '"'
            }

            out << """
        <div class="useritem" $style id="s${profile.user.id}">
            <span id="info-${profile.user.id}">
                <div class="userbox">
                    ${(attrs.positionAfter == "true"  && attrs.position != "false") ? position : ''}
                    <div class="imagebox">
                        ${(attrs.positionAfter != "true"  && attrs.photo != "false") ? image : ''}
                    </div>
                    <div class="info">
                        <span id="action-icon-${profile.user.id}"><a href=\"javascript:removeFromGroupList('${profile.user.id}')\" class=\"ui-rbutton\" style=\"float: right; padding: 6px 12px;\">-</a></span>
                        ${(attrs.name != "false") ? """<span class="name">${user(profile: profile, profile.name)}</span>""" : ''}
                        ${(attrs.email == "true") ? """<span class=\"email\">${profile.user.email}</span>""" : ''}
                        ${(attrs.score != "false") ? """<span class="score">${g.formatNumber(number: profile.user.topCoderScore, type: "number", maxFractionDigits: 2)}</span>""" : ''}
                    </div>
                    ${(attrs.positionAfter != "true"  && attrs.position != "false") ? position : ''}
                    ${(attrs.positionAfter == "true"  && attrs.photo != "false") ? image : ''}
                    <span class="icon"></span>
                </div>
            </span>"""
            if(attrs.group){
            out << """<form class="ui-custom-select"><select name="select" id="r${profile.user.id}">
                    <option value="0" selected>Aluno</option>
                    <option value="1">Professor</option>
                    </select></form>"""
            }
            out << """
        </div>
    """


        }
    }
}
