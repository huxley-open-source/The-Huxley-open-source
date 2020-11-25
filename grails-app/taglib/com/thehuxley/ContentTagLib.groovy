package com.thehuxley

class ContentTagLib {

    static namespace = "huxley"

    def contents = {attrs ->

        def contents = []
        def max = 4;
        if (attrs.max) {
           max = attrs.max
        }

        if (attrs.contents) {
            def contentsIds = []
            attrs.contents.each {
                contentsIds.add(it.id)
            }
            contents = Content.findAllByIdInList(contentsIds,[max: max])

        } else {
                contents = Content.list([max: max, sort: 'dateCreated', order: 'asc'])
        }

        out << """
            <div class="courses">
                <table class="standard-table">
                    <tbody id="result">
        """
        contents.each {

            out << """
                                <tr>
                                    <td>
                                        <span class="title">
                                            ${g.link(controller: 'content', action: 'show',  id: it.id, class: "title", it.title)}
                                            <br>
                                            <i class="description">
                                                ${g.message(code: "verbosity.createBy")}
                                                ${huxley.user(user: it.owner, it.owner.name)}
                                                ${g.message(code: "verbosity.updatedAt")}
                                                <span class="date">${formatDate(date: it.lastUpdated, format: 'dd/MM/yyyy')}</span>
                                                ${formatDate(date: it.lastUpdated, format: 'HH:mm')}
                                            </i>
                                        </span>
                                        <br>
                                        <br>
                                        ${attrs.description != 'false' ? """<span class="desc">${it.description}</span>""" : ''}
                                     </td>
                                </tr>
            """
        }

        out << """
                    </tbody>
                </table>
            <div id="course-pagination" class="ui-pagination"></div>
        </div>
        """
    }

    def content = { attrs ->

        def contentInstance = attrs.content

        out << """
            ${r.external dir: 'css', file: 'course.css', disposition: 'head' }
        """


        out << """
            <div class="courses">
                <li>
                    <span class="title">
                        <b>${g.message(code: "entity.content")}: ${g.link(controller: "contentInstance", action: "show", id: contentInstance.id, style: "color: #f2b500;", contentInstance.title)}</b><br />
                        <i class="description">
                            ${g.message(code: "verbosity.createBy")}
                            ${huxley.user(user: contentInstance.owner, contentInstance.owner.name)}
                            ${g.message(code: "verbosity.updatedAt")}
                            <span class="date">${formatDate(date: contentInstance.lastUpdated, format: 'dd/MM/yyyy')}</span>
                            ${formatDate(date: contentInstance.lastUpdated, format: 'HH:mm')}
                        </i>
                    </span>
                </li>
            </div>

            <div class="left">

                <div class="course-contents">
                    <div class="course-content"">
                        <iframe width="420px" height="236" align="middle" frameborder="0" allowfullscreen="" src="${contentInstance.embedded}"></iframe>
                        <hr />
                        <div class="description">
                            ${contentInstance.description}
                        </div>
                    </div>
                """



        out << """
                </div>
            </div>

            <div class="clear"></div><br />
        """
    }
}
