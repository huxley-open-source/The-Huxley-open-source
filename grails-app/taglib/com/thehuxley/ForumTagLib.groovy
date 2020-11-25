package com.thehuxley

import com.thehuxley.util.HuxleyProperties
import com.thehuxley.container.forum.UserStatus
import com.thehuxley.container.forum.ForumMessage

class ForumTagLib {

    static namespace = "huxley"



    def forum = {attrs ->
        attrs.forumList.each{ forum->
            if(forum.getUserStatus(session.license.user) == UserStatus.STATUS_UNREAD){
                out << """ <div class="topic forum-unread" id="${forum.getId()}">"""
            }else{
                out << """ <div class="topic" id="${forum.getId()}">"""
            }
            out << """<div class="forum-header"> """
            if(forum.hasProblem()){
            out << """<div class="action-forum-dropbox" id="action-forum-dropbox-${forum.getId()}">
            <span id="droplabel-${forum.getId()}" onclick="huxleyForum.forumAction('${forum.getId()}')" style="color: #616161;">ações <div id="dropshow-${forum.getId()}" class="action-forum-show"></div></span>
            <div id="drop-${forum.getId()}" class="action-forum-drop" style="display: none;" >
            <li>${g.link(controller : "problem", action:"show", params : [id: forum.getProblem().id], "${g.message(code: "verbosity.show")}")}</li>
                <li>${g.link(controller : "problem", action:"downloadInput", params : [id: forum.getProblem().id], "${g.message(code: "problem.input.example")}")}</li>
            <li>${g.link(controller : "problem", action:"downloadOutput", params : [id: forum.getProblem().id], "${g.message(code: "problem.output.example")}")}</li>
            </div>
            </div>
                <h3>${forum.getProblem().name}</h3>"""
            }
            if(forum.hasSubmission()){
                out << """<div class="action-forum-dropbox" id="action-forum-dropbox-${forum.getId()}">
            <span id="droplabel-${forum.getId()}" onclick="huxleyForum.forumAction('${forum.getId()}')" style="color: #616161;">ações <div id="dropshow-${forum.getId()}" class="action-forum-show"></div></span>
            <div id="drop-${forum.getId()}" class="action-forum-drop" style="display: none;" >
            <li>${g.link(controller : "submission", action:"downloadSubmission", params : [bid: forum.getSubmission().id], "Baixar código")}</li>"""
                if(!session.license.isStudent()){
                    out << """<li>${g.link(controller : "submission", action:"showDiff", id: forum.getSubmission().id, "Ver diferenças")}</li>"""
                }
                out << """
            </div>
            </div>
                <h3>${forum.getSubmission().problem} #${forum.getSubmission().tries}</h3>"""
            }

            out << """</div>"""
            ForumMessage message = forum.getFirstMessage()
        out << """<div class="body">
            <div class="author">
                <span class="date">Em ${message.getDate().format("dd/MM/yyyy HH:mm")}</span>
            <img src="${HuxleyProperties.getInstance().get("image.profile.dir")}thumb/${Profile.findByUser(message.getUser()).smallPhoto}" width="40px" height="40px" border="0" align="left" class="photo" />
                    <h3>${message.getUser()}</h3>
                    <div class="desc">${message.getMessage().replaceAll('\n','</br>')}</div>
            </div>
            <br /><hr /><br /><div class="comments" id="comments-${forum.getId()}">"""
            forum.getMessageList().eachWithIndex{ comment , i ->
                if(i != 0 ){
                    out << huxley.forumComment(comment: comment)
                }
            }
            out << """<span id="new-comments-${forum.id}"></span><hr /><br />
                <form action="" method="post">
                <div id="newcomment">
                <textarea id="forum-new-comment-${forum.id}" name="newcomment" rows="3" placeholder="Clique aqui para escrever um comentário ou responder..." onkeyup="huxleyForum.sendComment(event, '${forum.id}')"></textarea>
                    </div>
                <input type="submit" value="Enviar" hidden="hidden" />
                </form>
            </div>
                </div>
    </div>"""

        }

    }
    def forumComment = { attrs ->
        ForumMessage comment = attrs.comment
        if (attrs.forumId){
            out <<  """<div class="comment" id="${attrs.forumId}">"""
        }else{
            out <<  """<div class="comment">"""
        }
        out <<  """<span class="date">Em ${comment.getDate().format("dd/MM/yyyy HH:mm")} </span>
                <img src="${HuxleyProperties.getInstance().get("image.profile.dir")}thumb/${Profile.findByUser(comment.getUser()).smallPhoto}" width="40px" height="40px" border="0" align="left" />
                <h3>${comment.getUser()}</h3>
                <div class="comment">${((comment && comment.getMessage()) && (!comment.getMessage().isEmpty())) ? comment.getMessage().replaceAll('\n','</br>') : "Comentário Vazio"}</div>
                        </div>"""
    }


}
