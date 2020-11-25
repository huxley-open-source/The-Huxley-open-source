package com.thehuxley

class CourseTagLib {

    static namespace = "huxley"

    def courseService
    def problemService
    def contentService

    def courses = {attrs ->

        def lessons = []
        def maxDefault = 4;

        if (attrs.lessons) {
            def lessonIds = []

            lessons.each {
                lessonIds.add(it.id)
            }

            lessons = Lesson.findAllByIdInList(lessonIds)

        } else {
            if (attrs.max) {
                lessons = Lesson.list([max: attrs.max, sort: 'dateCreated', order: 'asc'])
            } else {
                lessons = Lesson.list([max: maxDefault, sort: 'dateCreated', order: 'asc'])
            }
        }

        out << """
            <div class="courses">
                <table class="standard-table">
                    <tbody id="result">
        """
        lessons.each {
            def progress = courseService.getProgress(it, session.profile.user)

            out << """
                                <tr>
                                    <td>
                                        <span class="title">
                                            ${g.link(controller: 'course', action: 'show',  id: it.id, class: "title", it.title)}
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
                                     <td>
                                        <div class="progress-bar">
                                            <span class="current-progress-number">${g.formatNumber(number: progress, format: '0')}%</span>
                                            <div class="current-progress" style="width: ${g.formatNumber(number: progress, format: '0')}%;"></div>
                                        </div>
                                    </td>
                                </tr>
            """
        }

        out << """
                    </tbody>
                </table>
            <div id="course-pagination"></div>
        </div>
        """
    }

    def course = { attrs ->

        def courseInstance = attrs.course
        def progress = courseService.getProgress(courseInstance, session.profile.user)

        out << """
            ${r.external dir: 'css', file: 'course.css', disposition: 'head' }
        """

        out << """
            <script type="text/javascript">
                huxleyCourse.changeProgress = function (progress) {
                    \$('#current-progress').width(progress);
                    \$('#current-progress-number').empty();
                    \$('#current-progress-number').append(document.createTextNode(progress + '%'));
                };

                huxleyCourse.changeContent = function (id) {
                    \$('.course-content').hide();
                    \$('#course-content-' + id ).show();
                    huxleyCourse.changeStatus(id);
                }

                huxleyCourse.changeStatus = function (id) {
                    \$.ajax({
                        url: '${resource(dir:'/')}course/changeStatus',
                        data: {c: id, k: ${courseInstance.id}},
                        dataType: 'json',
                        success: function (data) {
                            \$('#content-list-' + id).addClass('ok');
                            huxleyCourse.changeProgress(data.progress);
                        }
                    });
                }
            </script>
        """

        out << """
            <div class="courses"><!-- Courses -->
                <li>
                    <div class="porcents">
                        <span id="current-progress-number">${g.formatNumber(number: progress, format: '0')}%</span>
                        <div id="current-progress" class="bar" style="width: ${g.formatNumber(number: progress, format: '0')}%;"></div>
                    </div>
                    <span class="title">
                        <b>${g.message(code: "entity.course")}: ${g.link(controller: "course", action: "show", id: courseInstance.id, style: "color: #f2b500;", courseInstance.title)}</b><br />
                        <i class="description">
                            ${g.message(code: "verbosity.createBy")}
                            ${huxley.user(user: courseInstance.owner, courseInstance.owner.name)}
                            ${g.message(code: "verbosity.updatedAt")}
                            <span class="date">${formatDate(date: courseInstance.lastUpdated, format: 'dd/MM/yyyy')}</span>
                            ${formatDate(date: courseInstance.lastUpdated, format: 'HH:mm')}
                        </i>
                    </span>
                </li>
            </div>

            <div class="right">
                <h3>${g.message(code: "verbosity.content")}</h3>
                <div class="scroll-pane" style="height: 350px;">
                    <ul>
        """

        courseInstance.teachingResources.each {

            def cssClass = ""

            if (it.problem && problemService.isCorrect(it.problem, session.profile.user)) {
                cssClass = 'class="ok"'
            } else if (it.content && contentService.isComplete(it.content, session.profile.user)) {
                cssClass = 'class="ok"'
            }

            out << """
                            ${it.content ? '<li id="content-list-' + it.id + '" ' + cssClass + '>' + g.link(url: 'javascript:void(0);', onclick: "huxleyCourse.changeContent(${it.id})", it.content.title) + '</li>' : '<li ' + cssClass + '>' + g.link(url: 'javascript:void(0);', onclick: "changeContent(${it.id})", g.message(code: 'entity.questionnaire')) + '</li>'}
            """
        }

        out << """
                    </ul>
                </div>
            </div>

            <div class="left">

                <div class="course-contents">
        """

        courseInstance.teachingResources.eachWithIndex {tr, i ->

            if (tr.content) {
                out << """
                    <div class="course-content${i != 0 ? ' content-hiden' : ''}" id="course-content-${tr.id}">
                        <iframe width="420" height="236" frameborder="0" allowfullscreen="" src="${tr.content.embedded}"></iframe>
                        <hr />
                        <div class="description">
                            ${tr.content.description}
                        </div>
                    </div>
                """
            } else if (tr.problem) {
                out << """
                    <div class="course-content${i != 0 ? ' content-hiden' : ''}" id="course-content-${tr.id}">

                    </div>
                """
            }
        }

        out << """
                </div>
            </div>

            <div class="clear"></div><br />
        """
    }

}


