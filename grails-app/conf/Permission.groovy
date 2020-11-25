permissions = [
        ALLOWED: [
                auth: [
                        'login',
                        'signIn',
                        'signOut',
                        'requestPassword',
                        'requestPresentation',
                        'authenticate',
                        'unauthorized',
                        'sendMessage',
                        'contact',
                        'policy',
                        'validateUsername',
						'landing',
						'howItWorks'
                ],

                help: [
                        '*'
                ],

                topCoder: [
                        '*'
                ],

                topCoderREST: [
                        '*'
                ],

                errors:[
                        '*'
                ],

                teacher: [
                        '*'
                ],

                pendency: [
                        'requestGroupInvite'
                ],

				institutionREST: [
				        '*'
				],

				home: [
				        'landing'
				]
        ],

        STANDARD_ADMIN_LICENSE: [
                '*'
        ],

        STANDARD_STUDENT_LICENSE: [
                auth: [
                        'login',
                        'getTotalSubmissions',
                        'showTopCoder',
                        'signIn',
                        'signOut',
                        'notAllowed'
                ],

                home: [
                        '*'
                ],

                course: [

                ],

                submission: [
                        'index',
                        'search',
                        'save',
                        'downloadCodeSubmission',
                        'getStatusSubmission',
                        'downloadSubmission',
                        'showDiff',
                        'getStatus',
                        'getSubmissionInfo',
                        'getSubmissionInfoById',
                        'getComment',
                        'listByQuestProblem'
                ],

                forum: [
                        '*'
                ],

                group: [
                        'getUserGroups',
                        'list',
                        'requestShow',
                        'getStudents',
                        'getMasters',
                        'show',
                        'addByAccessKey'
                ],

                groupREST: [
                        '*'
                ],

                help: [

                ],

                institution: [

                ],

                institutionREST: [
                        '*'
                ],

                lesson: [

                ],

                license: [
                        'listByUser',
                        'askLicense'
                ],

                pendency: [
                        'requestGroupInvite',
                        'countPendency'
                ],

                plagiarism: [

                ],

                problem: [
                        'show',
                        'listTopics',
                        'search',
                        'index',
                        'getProblemContent',
                        'ajxGetProblemContent',
                        'ajxGetPendingSubmission',
                        'downloadInput',
                        'downloadOutput',
                        'listTopics',
                        'selectedIdList',
                        'showProblem',
                        'ajxGetPendingSubmissions',
                        'ajxGetProblemStatus',
                        'getProblemsStatus',
                        's',
                        'getProblemInfo',
                        'getTip',
                        'showTip',
                        'voteTip',
                        'getStatusLanguage'

                ],

                profile: [
                        'index',
                        'uploadImage',
                        'show',
                        'create',
                        'changePassword',
                        'save',
                        'savePassword',
                        'getDataForChart',
                        'crop'
                ],

                profileREST: [
                        '*'
                ],

                quest: [
                        'index',
                        'getClosedUserQuest',
                        'getOpenUserQuest',
                        'show',
                        'notStarted',
                        'remainingTime',
                        'getLastestQuestionnaires'
                ],

                referenceSolution: [

                ],

                report: [
                        'topCoder'
                ],

                settings: [

                ],

                user: [

                ],

                manager: [
                        'save',
                        'institutionPendency',
                        'pendency',
                ]
        ],

        STANDARD_TEACHER_ASSISTANT_LICENSE: [],

        STANDARD_TEACHER_ADMIN_ASSISTANT_LICENSE: [],

        STANDARD_TEACHER_LICENSE : [
                auth: [
                        'login',
                        'getTotalSubmissions',
                        'showTopCoder',
                        'signIn',
                        'signOut',
                        'notAllowed'
                ],

                home: [
                        '*'
                ],

                course: [

                ],

                content: [
                        'index',
                        'ajxGetContentList',
                        'show'
                ],

                submission: [
                        'index',
                        'search',
                        'save',
                        'downloadCodeSubmission',
                        'getStatusSubmission',
                        'downloadSubmission',
                        'showDiff',
                        'reEvaluate',
                        'getStatus',
                        'getSubmissionInfo',
                        'getSubmissionInfoById',
                        'getDiff',
                        'getComment',
                        'createComment',
                        'listByQuestProblem'
                ],

                forum: [
                        '*'
                ],

                group: [
                        '*'
                ],

                groupREST: [
                        '*'
                ],

                help: [

                ],

                institution: [

                ],

                institutionREST: [
                        '*'
                ],

                lesson: [

                ],

                license: [
                        'listByUser',
                        'askLicense',
                        'getLicensePackInfo',
                        'addTeacher'
                ],

                plagiarism: [

                ],

                problem: [
                        'show',
                        'listTopics',
                        'search',
                        'index',
                        'getProblemContent',
                        'ajxGetProblemContent',
                        'ajxGetPendingSubmission',
                        'ajxGetSubmissionStatus',
                        'downloadInput',
                        'downloadOutput',
                        'listTopics',
                        'selectedIdList',
                        'showProblem',
                        'ajxGetPendingSubmissions',
                        'ajxGetProblemStatus',
                        'create',
                        'save',
                        'create2',
                        'updateDescription',
                        'create3',
                        'updateTestCase',
                        'uploadImage',
                        'management',
                        'findUsage',
                        'reEvaluate',
                        'getProblemsStatus',
                        's',
                        'getProblemInfo',
                        'searchByMongo',
                        'getTip',
                        'showTip',
                        'voteTip',
                        'getStatusLanguage'
                ],

                profile: [
                        'index',
                        'uploadImage',
                        'show',
                        'create',
                        'changePassword',
                        'save',
                        'savePassword',
                        'getDataForChart',
                        'search',
                        'crop'
                ],

                profileREST: [
                        '*'
                ],

                quest: [
                        '*'
                ],

                referenceSolution: [
                        'index',
                        'getList',
                        'show',
                        'create',
                        'save',
                        'compare',
                        'listByProblem',
                        'list'
                ],

                report: [
                        'topCoder'
                ],

                settings: [

                ],

                similarity: [
                        '*'
                ],

                teacher: [
                        '*'
                ],

                user: [
                        '*'
                ],

                pendency:[
                        'countPendency',
                        'listGroupPendencies',
                        'acceptGroupPendency',
                        'rejectGroupPendency'

                ],

                manager: [
                        'save',
                        'pendency'
                ],

                payment: [
                        'confirm',
                        'success',
                        'checkout',
                        'checkCoupon'
                ]
        ],

        STANDARD_ADMIN_INST_LICENSE: [
                auth: [
                        'login',
                        'getTotalSubmissions',
                        'showTopCoder',
                        'signIn',
                        'signOut',
                        'notAllowed'
                ],

                home: [
                        '*'
                ],

                course: [

                ],

                content: [
                        'index',
                        'ajxGetContentList',
                        'show'
                ],

                submission: [
                        'index',
                        'search',
                        'save',
                        'downloadCodeSubmission',
                        'getStatusSubmission',
                        'downloadSubmission',
                        'showDiff',
                        'reEvaluate',
                        'getStatus',
                        'getSubmissionInfo',
                        'getSubmissionInfoById',
                        'getDiff',
                        'getComment',
                        'createComment',
                        'listByQuestProblem'
                ],

                forum: [
                        '*'
                ],

                group: [
                        '*'
                ],

                groupREST: [
                        '*'
                ],

                help: [

                ],

                institution: [

                ],

                institutionREST: [
                        '*'
                ],

                lesson: [

                ],

                license: [
                        'index',
                        'manage',
                        'list',
                        'create',
                        'save',
                        'getUserBoxRightList',
                        'remove',
                        'search',
                        'listByUser',
                        'askLicense',
                        'manageTeacher',
                        'addTeacher',
                        'getLicensePackInfo'


                ],

                plagiarism: [

                ],

                problem: [
                        'show',
                        'listTopics',
                        'search',
                        'index',
                        'getProblemContent',
                        'ajxGetProblemContent',
                        'ajxGetPendingSubmission',
                        'ajxGetSubmissionStatus',
                        'downloadInput',
                        'downloadOutput',
                        'listTopics',
                        'selectedIdList',
                        'showProblem',
                        'ajxGetPendingSubmissions',
                        'ajxGetProblemStatus',
                        'create',
                        'save',
                        'create2',
                        'updateDescription',
                        'create3',
                        'updateTestCase',
                        'uploadImage',
                        'management',
                        'findUsage',
                        'reEvaluate',
                        'getProblemsStatus',
                        's',
                        'getProblemInfo',
                        'searchByMongo',
                        'getTip',
                        'showTip',
                        'voteTip',
                        'getStatusLanguage'
                ],

                profile: [
                        'index',
                        'uploadImage',
                        'show',
                        'create',
                        'changePassword',
                        'save',
                        'savePassword',
                        'getDataForChart',
                        'search',
                        'crop'
                ],

                profileREST: [
                        '*'
                ],

                quest: [
                        '*'
                ],

                referenceSolution: [
                        'index',
                        'getList',
                        'show',
                        'create',
                        'save',
                        'compare',
                        'listByProblem',
                        'list'
                ],

                report: [
                        'topCoder'
                ],

                settings: [

                ],

                similarity: [
                        '*'
                ],

                teacher: [
                        '*'
                ],

                user: [
                        '*'
                ],

                pendency:[
                        'countPendency',
                        'listByInstitution',
                        'acceptPendency',
                        'rejectPendency'
                ],

                manager: [
                        'save',
                        'institutionPendency',
                        'pendency',
                        'pendencies'
                ],

                payment: [
                        'confirm',
                        'success',
                        'checkout',
                        'checkCoupon'
                ]
        ],

        BASIC_STUDENT_LICENSE: [

        ],


]