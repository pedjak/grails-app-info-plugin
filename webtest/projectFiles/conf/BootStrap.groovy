import com.burtbeckwith.appinfo_test.Role
import com.burtbeckwith.appinfo_test.User
import com.burtbeckwith.appinfo_test.UserRole

class BootStrap {

	def sessionFactory
	def springSecurityService

	def init = { servletContext ->
		sessionFactory.statistics.statisticsEnabled = true

		// create some roles and load them to populate 2nd-level cache
		def roles = []
		def adminRole = new Role(authority: 'ROLE_ADMIN').save()
		roles << adminRole
		roles << new Role(authority: 'ROLE_USER').save()
		roles << new Role(authority: 'ROLE_SUPERUSER').save()
		roles << new Role(authority: 'ROLE_SWITCH_USER').save()

		sessionFactory.currentSession.flush()
		sessionFactory.currentSession.clear()

		roles.each { Role.get(it.id) }
		sessionFactory.currentSession.clear()
		roles.each { Role.get(it.id) }
		sessionFactory.currentSession.clear()
		roles.each { Role.get(it.id) }

		// also create a user to test authentication
		def admin = new User(username: 'admin', password: springSecurityService.encodePassword('password'), enabled: true).save()
		UserRole.create admin, adminRole, true
	}
}
