module csv;

/**
 * A very basic implementation of a CSV reader. Expects all input to be valid UTF8.
 */

import std.stdio;

struct ByLine {
	File file;
	char[] buf;

	bool empty;
	char[] front;
	void popFront() {
		import std.stdio;
		auto n = file.readln(buf);
		if (n <= 0) {
			empty = true;
			return;
		}
		front = buf[0 .. n];
		while (front[$-1] == '\r' || front[$-1] == '\n') {
			front = front[0 .. $-1];
		}
	}
}

struct CSV {
	ByLine byline;
	alias byline this;

	public static CSV opCall(File file) {
		CSV ret;
		ret.byline = ByLine(file);
		return ret;
	}


	string[] front;
	void popFront() {
		byline.popFront;
		front.length = 0;

		auto line = byline.front;

		size_t start;
		bool inString1, inString2;
		for (size_t i=0; i < line.length; i++) {
			switch (line[i]) {
			case ',':
				front ~= line[start .. i].idup;
				start = i+1;
				goto default;
			case '"':
				if (inString1) {continue;}

				if (!inString2) {	// opening text field
					start = i+1;
				} else {			// closing text field
					front ~= line[start .. i].idup;
					do { i++; } while (line[i] == ' ' || line[i] == '\t');
					start = i+1;
				}
				inString2 = !inString2;
				goto default;
			case '\'':
				if (inString2) {continue;}

				if (!inString1) {	// opening text field
					start = i+1;
				} else {			// closing text field
					front ~= line[start .. i].idup;
					do { i++; } while (line[i] == ' ' || line[i] == '\t');
					start = i+1;
				}
				inString1 = !inString1;
				goto default;
			default:
			}
			// part of current field in csv
		}
		front ~= line[start .. $].idup;
		writeln("lidne: ", front);
		if (front[1].length > 20) {
			assert(0);
		}
	}
}

auto loadData() {
	File file;
	file = stdin;
	return CSV(file);
}
