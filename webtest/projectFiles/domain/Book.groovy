package com.burtbeckwith.appinfo_test

class Book {

	String title

	static belongsTo = Author
	static hasMany = [authors: Author]
}
