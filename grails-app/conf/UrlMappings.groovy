class UrlMappings {

	static mappings = {

        "/1.0/groups/$id?" (controller: "groupREST") {
            action = [GET: "show", POST: "save", DELETE: "delete", PUT: "update"]
        }

        "/1.0/groups/$id/users" (controller: "groupREST") {
            action = [GET: "getUsers", POST: "save", DELETE: "delete", PUT: "update"]
        }

        "/1.0/institutions/$id?" (controller: "institutionREST") {
            action = [GET: "show", POST: "save", DELETE: "delete", PUT: "update"]
        }

        "/1.0/users/$id?" (controller: "profileREST") {
            action = [GET: "show", POST: "save", DELETE: "delete", PUT: "update"]
        }

        "/1.0/users/groups" (controller: "profileREST") {
            action = [GET: "showCurrentUserGroups"]
        }

        "/1.0/users/$id/groups/$gid?" (controller: "profileREST") {
            action = [GET: "showGroups"]
        }

        "/1.0/topcoders/$id?" (controller: "topCoderREST") {
            action = [GET: "show", POST: "save", DELETE: "delete", PUT: "update"]
        }

		"/$controller/$action?/$id?/?"{
			constraints {
				// apply constraints here
			}
		}

		"/"(controller: 'auth', action: 'landing')
		"500"(controller:'errors', action:'exception')
        "404"(controller:'errors', action:'notFound')
	}
}
