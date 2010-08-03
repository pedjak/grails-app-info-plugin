package com.burtbeckwith.appinfo_test

class Entry {

	static transients = ['amount']

	Invoice invoice
	Date workDate
	String description
	String notes
	BigDecimal hours = 0
	BigDecimal billRateOverride
	BigDecimal amountOverride
	Date dateCreated

	BigDecimal getAmount() {
		amountOverride ?: hours * (billRateOverride ?: invoice.customer.billRate)
	}

	@Override
	String toString() { description }

	static constraints = {
		amountOverride nullable: true
		billRateOverride nullable: true
		notes nullable: true
	}

	static List<Entry> findAllByMonth(int month, int year) {
		Calendar c = Calendar.instance
		c.clear()
		c.set Calendar.MONTH, month
		c.set Calendar.YEAR, year
		c.set Calendar.DAY_OF_MONTH, 1
		def start = c.time
		c.add Calendar.MONTH, 1
		def end = c.time

		executeQuery("FROM Entry e WHERE e.workDate >= :start AND e.workDate < :end",
				[start: start, end: end])
	}
}
