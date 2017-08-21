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

/**
 * Base class for a two dimensional dataset
 */
class DataStore {
	string[] lines;
	this() {
		loadData();
	}
}

void main() {
	auto data = new DataStore();
}
