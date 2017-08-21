/**
 * This application outputs a csv file "output.csv" reporting the Monthly
 * total Amount and frequency of entries by Network and Product.
 *
 * Note: the csv column names are NOT considered in the field order
 * input fields are expected to be in the order:
 *     MSISDN,Network,Date,Product,Amount
 */
import std.stdio;
void runReport(File input, File output) {
	import csv;

	auto lines = loadData(input);

	// Pre-process
	NetworkEntry[string][string][string] entries;
	double documentTotal = 0, aggregateTotal = 0;
	foreach (row; lines) {
		auto entry = NetworkEntry(row);
		entries[entry.month][entry.network][entry.product] = entry;
		documentTotal += entry.amount;
	}

	// Aggregate and output
	output.writeln("Network,Product,Month,Amount,Count");
	foreach (month, monthEntries; entries) {
		size_t count;
		double total = 0;
		string productName, networkName;
		foreach (network, networkEntries; monthEntries) {
			networkName = network;
			foreach (product; networkEntries) {
				productName = product.product;
				++count;
				total += product.amount;
			}
		}
		output.writefln("%s,%s,%s,%s,%s", networkName, productName, month, total, count);
		aggregateTotal += total;
	}

	// double check totals against document total amount
	assert(aggregateTotal == documentTotal, "warning log, something went wrong");
}

/**
 * Represents a single entry in the Loans.csv input csv file
 */
struct NetworkEntry {
	string[] row;

	invariant {
		import std.format;

		assert(row.length == 0 || row.length == 5, "invalid data input format at line: %s".format(row));
	}

	/**
	 * Access each field in the CSV file according to its field name
	 */
	string opDispatch(string methodName)() {
		switch (methodName) {
			case "msisdn":
				return row[0];
			case "network":
				return row[1];
			case "date":
				return row[2];
			case "product":
				return row[3];
			default:
				assert(0, "unsupported field name");// @ %s:%s".format(file, line));
		}
	}

	string month()
	in {
		assert(this.date[2] == '-' && this.date[6] == '-');
	}
	body {
		return this.date[3 .. $];
	}

	double amount() {
		import std.conv;

		return to!double(row[4]);
	}

	string toString() {
		import std.format;
		return "msisdn=%s,network=%s,date=%s,product=%s,amount=%s".format(this.msisdn, this.network, this.date, this.product, this.amount);
	}
}

unittest {
	auto entry = NetworkEntry(["27723453455","Network 3","12-Apr-2016","Loan Product 3","1928.00"]);
	assert(entry.msisdn  == "27723453455");
	assert(entry.network == "Network 3");
	assert(entry.date   == "12-Apr-2016");
	assert(entry.product == "Loan Product 3");
	assert(entry.amount  == 1928.00);

	assert(entry.month == "Apr-2016");
}
