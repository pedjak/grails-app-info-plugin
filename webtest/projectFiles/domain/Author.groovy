package com.burtbeckwith.appinfo_test

class Author {

	String name

	static hasMany = [books: Book]

	static namedQueries = {
		prolificAuthors {
			sizeGt 'books', 5
		}
	}
}
