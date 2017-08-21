/**
 * This application outputs a csv file "output.csv" reporting the Monthly
 * total Amount and frequency of entries by Network and Product.
 */

void runReport() {
	import datastore;

	auto data = new TypedDataStore();

	NetworkEntry[string][string][string] entries;
	foreach (row; data.getRows()) {
		auto entry = NetworkEntry(row);
		entries[entry.month][entry.network][entry.product] = entry;
	}

	foreach (month; entries) {
		size_t count;
		double total;
		foreach (network; month) {
			foreach (product; network) {
				++count;
				total += product.amount;
			}
		}
	}
}

struct NetworkEntry {
	string[] row;

	invariant {
		import std.format;

		assert(row.length == 0 || row.length == 5, "invalid data input format at line: %s".format(row));
	}

	string opDispatch(string methodName)() {
		switch (methodName) {
			case "msisdn":
				return row[0];
			case "network":
				return row[1];
			case "month":
				return row[2];
			case "product":
				return row[3];
			default:
				assert(0, "unsupported field name");// @ %s:%s".format(file, line));
		}
	}


	double amount() {
		import std.conv;

		return to!double(row[4]);
	}
}

unittest {
	auto entry = NetworkEntry(["27723453455","Network 3","12-Apr-2016","Loan Product 3","1928.00"]);
	assert(entry.msisdn  == "27723453455");
	assert(entry.network == "Network 3");
	assert(entry.month   == "12-Apr-2016");
	assert(entry.product == "Loan Product 3");
	assert(entry.amount  == 1928.00);
}
