import report;

void main() {
	import std.stdio;
	File input, output;

	input = File("Loans.csv");
	output = File("Output.csv", "w");
	runReport(input, output);
}
