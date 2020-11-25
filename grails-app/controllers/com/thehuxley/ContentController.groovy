package com.thehuxley

class ContentController {

    def index() {
        def contentList = []
        def contents = []
        def total
        if (params.k) {
            contentList = Content.findAllByTitleLike("%${params.k}%")
            total = Content.countByTitleLike("%${params.k}%")
        } else {
            contentList = Content.list()
            total = Content.count()
        }
        [total: total, k: params.k, contents : contentList]
    }

    def getContentList = {
        redirect(action: 'index', params: [k: params.title])
    }

    def ajxGetContentList = {
        def contentList = []
        def contentsInfo = []
        def totalContent
        def offset = 0
        def max = 10
        if (params.offset){
            offset = params.offset
        }
        if (params.max){
            max = params.max
        }
        if (params.k) {
            contentList = Content.findAllByTitleLike("%${params.k}%",[offset: offset,max: max])
            totalContent = Content.countByTitleLike("%${params.k}%")
        } else {
            contentList = Content.list([offset: offset,max: max])
            totalContent = Content.count()
        }

        contentList.each{
            def profile = Profile.findByUser(it.owner)
            contentsInfo.add([id: it.id, title: it.title, description: it.description, lastUpdatedDate: g.formatDate(date: it.lastUpdated, format: ('dd/MM/yyyy')), lastUpdatedHour: g.formatDate(date: it.lastUpdated, format: ('hh:mm')), ownerHash: profile.hash, ownerName: profile.name])
        }
        render(contentType:"text/json") {
            contents = contentsInfo
            total = totalContent
        }
    }
    def show = {
        Content content
        if (params.id){
            content = Content.get(params.id)
            [contentInstance : content]
        }else{
            redirect(action: "index")
        }
    }
}
