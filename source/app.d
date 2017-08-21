import report;

/**
 * An application that loads data from Loans.csv and outputs a pivot report to Output.csv
 */

void main() {
	import std.stdio;
	File input, output;

	input = File("Loans.csv");
	output = File("Output.csv", "w");
	runReport(input, output);
}
