package com.thehuxley

class TopicTagLib {

    static namespace = "huxley"

    def topicFilter = {attrs->
        out << """
        ${r.external dir: 'js', file: 'huxley-topic.js', disposition: 'head'}
        """
        if (!session.license.isAdmin()){
            out << """<script type="text/javascript">
                    \$(function (){
                        huxleyTopic.withOutAddOption();
                    })
                    </script>"""

        }
        out << """
    <div class="form-element">"""
    if (attrs.topicFilter){
        out << """<h3 id="topic-label-search" style="cursor: pointer;">${g.message code:"verbosity.search.by.topics"}</h3><span id="search-container" style="display:none;">"""
    }else{
        out << """<span id="search-container" style="display:inline-block;">"""
    }
    out << """
        <div>
                    <div style="float:left; margin-right: 2px;">
                        <input style="display: table;" type="text" id="topic-search-param" name="fname" class="form-element-input topic-filter-search"/>
                        <select name="box-search" multiple="true" id="box-search" class="form-element-input topic-filter"></select>
                    </div>

                    <span id="toolbar" style="float:left;">
                        <ul style="list-style-type: none;">
                            <li style="display:block;"><button id="add" ><g:message code="problem.select.single"/></button></li>
                            <li style="display:block;"><button id="play"><g:message code="problem.select.single"/></button></li>
                            <li style="display:block;"><button id="forward"><g:message code="problem.select.all"/></button></li>
                            <li style="display:block;"><button id="beginning"><g:message code="problem.deselect.single"/></button></li>
                            <li style="display:block;"><button id="rewind"><g:message code="problem.deselect.all"/></button></li>
                        </ul>
                    </span>
                    <select name="box-selected" multiple="true" id="box-selected" class="form-element-input topic-filter" style="float:left; margin-top:38px;"></select>
        </div>


            """
            if (attrs.topics){
                out << """<g:select from="${attrs.topics }" optionKey="id" id="temp-topic" name="temp-topic" style="display:none;"></g:select>"""
            }
        if (attrs.topicFilter){
            out << """

        <h3>${g.message code:"verbosity.subtopics"}</h3>
            <span style="font-size: 12px;">${g.message code:"verbosity.how.to.select.subtopics"}</span>
            <div class="form-element-input" id="topic-box" style="width: 655px; height: 150px;overflow-y: auto;"></div>
    </span>
               """
        }
        out << """ </div>
               """
    }


}
