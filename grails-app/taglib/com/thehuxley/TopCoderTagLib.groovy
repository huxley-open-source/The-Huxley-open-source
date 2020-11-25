package com.thehuxley

import com.thehuxley.util.HuxleyProperties

class TopCoderTagLib {

    static namespace = "huxley"
    def topCoderService

    def topCoder = {attrs ->

        def generalList = topCoderService.getTopCoderGeneralList(attrs.max)
        def guestList
        def userTagLib = new UserTagLib()

        if (attrs.group){
            guestList = topCoderService.getTopCoderGroupList(attrs.group.id,attrs.max)
        }


        out << '''
            <div class="topcoder">
                <div class="title">TOP<span>CODER</span></div>
        '''

        out << (!guestList? "" : '''
                <div class="tabs">
                    <span id="guest" onclick="huxley.topCoderTagGuests()" class="">''' + attrs.group.name + '''</span>
                    <span id="general" onclick="huxley.topCoderTagGeneral()" class="active">''' + g.message(code: "verbosity.general") + '''</span>
                </div>
        ''')

        out << '''
                <ul id="general-list">
        '''

        generalList.eachWithIndex {it, i ->
            out << """
                        <li class="user">
                            ${userTagLib.userBox(profile: it,institution: "true", positionAfter: attrs.positionAfter, photoHeight: "40px", photoWidth: "40px")}
                        </li>
            """
        }

        out << '''
                </ul>
                <ul id="guest-list" style="display:none;">
                '''

        guestList.eachWithIndex {it, i ->
            out << """
                        <li class="user">
                            ${userTagLib.userBox(profile: it, positionAfter: attrs.positionAfter, photoHeight: "40px", photoWidth: "40px", positionIndex: (i + 1))}
                        </li>
            """
        }
                out << '''
                </ul>

            </div>
        '''
    }
}
