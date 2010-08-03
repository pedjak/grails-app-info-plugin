import grails.plugins.springsecurity.Secured

/**
 * Errors controller. Mappings in UrlMappings.groovy point here.
 */
@Secured(['IS_AUTHENTICATED_ANONYMOUSLY'])
class ErrorsController {

	/**
	 * Shows a page indicating that permission is required to view.
	 */
	def accessDenied = {}

	/**
	 * The not found page.
	 */
	def notFound = {
		log.debug "could not find $request.forwardURI"
	}

	/**
	 * The method not allowed page.
	 */
	def notAllowed = {}

	/**
	 * Mapped in UrlMappings for original controller urls to deny access, e.g.
	 * deny access to '/adminRole' since it should have been '/admin/role'.
	 */
	def urlMapping = {
		log.warn "unexpected call to URL-Mapped $request.forwardURI"
		render view: 'notFound'
	}
}
