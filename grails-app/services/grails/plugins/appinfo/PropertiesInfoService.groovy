package grails.plugins.appinfo

import org.apache.commons.dbcp.BasicDataSource

import org.springframework.beans.BeanWrapper
import org.springframework.beans.PropertyAccessorFactory
import org.springframework.beans.SimpleTypeConverter
import org.springframework.beans.TypeMismatchException

/**
 * @author <a href='mailto:burt@burtbeckwith.com'>Burt Beckwith</a>
 */
class PropertiesInfoService {

	static final SimpleTypeConverter TYPE_CONVERTER = new SimpleTypeConverter()

	boolean transactional = false

	def dataSource
	def dataSourceUnproxied
	def grailsApplication

	/**
	 * Builds a list of maps containing the property name, value, setter method name, and
	 * return type for all DataSource properties.
	 *
	 * @return the info
	 */
	List<Map<String, String>> getDatasourceInfo() {

		def propertyInfo = []

		def realDataSource = getRealDataSource()

		BeanWrapper beanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(realDataSource)
		for (pd in beanWrapper.propertyDescriptors.sort { it.name }) {
			if (!pd.readMethod || !pd.writeMethod) {
				continue
			}

			Class<?> returnType = pd.readMethod.returnType
			if (!returnType.primitive && !Number.isAssignableFrom(returnType) && returnType != String) {
				continue
			}

			try {
				pd.readMethod.accessible = true
				propertyInfo << [name: pd.name,
									  value: pd.readMethod.invoke(realDataSource),
									  set: pd.writeMethod.name,
									  type: returnType.name]
			}
			catch (ignored) {}
		}

		propertyInfo
	}

	/**
	 * Updates data source attributes.
	 */
	void updateDataSource(Map<String, Object> values) {

		def realDataSource = getRealDataSource()

		def pds = [:]
		BeanWrapper beanWrapper = PropertyAccessorFactory.forBeanPropertyAccess(realDataSource)
		for (pd in beanWrapper.propertyDescriptors) {
			if (pd.writeMethod) {
				pds[pd.writeMethod.name] = pd
			}
		}

		values.each { name, value ->
			def pd = pds[name]
			if (pd.writeMethod.parameterTypes.length == 1) {
				String oldValue
				try {
					pd.readMethod.accessible = true
					oldValue = pd.readMethod.invoke(realDataSource)?.toString()
					if (value != oldValue) {
						try {
							value = TYPE_CONVERTER.convertIfNecessary(value, pd.writeMethod.parameterTypes[0])
							pd.writeMethod.invoke realDataSource, value
						}
						catch (TypeMismatchException e) {
							// ignore
						}
					}
				}
				catch (ignored) {}
			}
		}

		if (realDataSource instanceof BasicDataSource) {
			realDataSource.close()
		}
	}

	/**
	 * Retrieves the DataSource bean. In recent versions of Grails the real bean is proxied so
	 * the current Hibernate Session connection is returned if it's available, so we want the
	 * real underlying bean.
	 *
	 * @return the real unproxied bean
	 */
	def getRealDataSource() {

		def dataSourceRetrievalClosure = grailsApplication.config.grails.plugins.appinfo.dataSourceRetrievalClosure
		if (dataSourceRetrievalClosure instanceof Closure) {
			return dataSourceRetrievalClosure.call()
		}

		dataSourceUnproxied ?: dataSource
	}
}
