package com.burtbeckwith.appinfo_test

class Customer {

	String name
	String address1
	String address2
	String city
	String state
	String zipcode
	String phone
	String attn
	BigDecimal billRate
	Date dateCreated

	List<Invoice> getInvoices() {
		Invoice.findAllByCustomer(this, [sort: 'dateCreated', order: 'desc'])
	}

	@Override
	String toString() { name }

  	static transients = ['invoices']

	static constraints = {
		name unique: true
		address2 nullable: true
		phone nullable: true
		attn nullable: true
	}

	static mapping = {
		cache true
	}
}
