package com.burtbeckwith.appinfo_test

import java.sql.PreparedStatement
import java.sql.ResultSet

import org.hibernate.HibernateException
import org.hibernate.usertype.UserType

class MyUserType implements UserType {

	Object assemble(Serializable arg0, Object arg1) {}

	Object deepCopy(Object arg0) {}

	Serializable disassemble(Object arg0) {}

	boolean equals(Object arg0, Object arg1) {}

	int hashCode(Object arg0) {}

	boolean isMutable() {}

	Object nullSafeGet(ResultSet arg0, String[] arg1, Object arg2) {}

	void nullSafeSet(PreparedStatement arg0, Object arg1, int arg2) {}

	Object replace(Object arg0, Object arg1, Object arg2) {}

	Class<?> returnedClass() {}

	int[] sqlTypes() {}
}
