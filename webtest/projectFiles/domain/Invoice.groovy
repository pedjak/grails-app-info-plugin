package com.burtbeckwith.appinfo_test

class Invoice {

	Customer customer
	String description
	String number
	Date sentDate
	Date paymentDate
	String notes
	String billingPeriod
	String purchaseOrderNumber
	Date dateCreated

	BigDecimal getTotalAmount() {
		entries.collect { it.amount }.sum() ?: 0
	}

	BigDecimal getTotalHours() {
		entries.collect { it.hours }.sum() ?: 0
	}

	List<Entry> getEntries() { Entry.findAllByInvoice(this, [sort: 'workDate']) }

	@Override
	String toString() { description }

	static transients = ['totalAmount', 'totalHours', 'entries']

	static constraints = {
		paymentDate nullable: true
		sentDate nullable: true
		notes nullable: true, maxSize: 1000
		billingPeriod nullable: true
		purchaseOrderNumber nullable: true
	}

	static List<Invoice> findUnsent() {
		findAllBySentDateIsNull(sort: 'dateCreated', order: 'desc')
	}

	static List<Invoice> findUnpaid() {
		findAllBySentDateIsNotNullAndPaymentDateIsNull(sort: 'dateCreated', order: 'desc')
	}

	static List<Invoice> findPaid() {
		findAllBySentDateIsNotNullAndPaymentDateIsNotNull(sort: 'dateCreated', order: 'desc')
	}
}
