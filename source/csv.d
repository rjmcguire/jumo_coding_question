module csv;

/**
 * A very basic implementation of a CSV reader. Expects all input to be valid UTF8.
 * Each line is allocated on the Heap.
 */

import std.stdio;

auto readCSV(T)(T lines) {
	auto line = lines.front.idup;
	lines.popFront;
	return line;
}


void loadData() {
	auto lines = stdin.byLine;

	auto header = lines.readCSV();
	writeln(header);

	foreach (line; lines) {
		writeln(line);
	}
}
