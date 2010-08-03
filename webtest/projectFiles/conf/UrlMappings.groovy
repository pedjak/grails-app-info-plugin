class UrlMappings {

	static mappings = {

		"/admin/manage/$action?"(controller: "adminManage")
		"/adminManage/$action?"(controller: "errors", action: "urlMapping")

		"/$controller/$action?/$id?" { }

		"/"(view:"/index")

		/**** Error Mappings ****/

		"403"(controller: "errors", action: "accessDenied")
		"404"(controller: "errors", action: "notFound")
		"405"(controller: "errors", action: "notAllowed")
		"500"(view: '/error')
	}
}
