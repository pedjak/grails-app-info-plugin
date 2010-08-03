package com.burtbeckwith.appinfo_test

class Role {

	String authority

	static mapping = {
		cache usage: 'read-only'
		version false
	}

	static constraints = {
		authority blank: false, unique: true
	}
}
