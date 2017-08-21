module csv;

/**
 * A very basic implementation of a CSV reader. Expects all input to be valid UTF8.
 */

import std.stdio;

struct ByLine {
	File file;
	char[] buf;
	@disable this();
	this(File file) {
		this.file = file;
		popFront();
	}
	public static ByLine opCall(File file) {
		ByLine ret = ByLine(file);
		return ret;
	}

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
	@disable this();
	this(File file) {
		this.byline = ByLine(file);
		popFront();
	}

	public static CSV opCall(File file) {
		CSV ret = CSV(file);
		return ret;
	}


	string[] front;
	void popFront() {
		byline.popFront;
		front.length = 0;

		auto line = byline.front;
		front = parseCSV(line);
	}
}

auto loadData() {
	File file;
	file = stdin;
	return CSV(file);
}


string[] parseCSV(const char[] line) {
	string[] ret;

	size_t start;
	bool inString1, inString2;
	for (size_t i=0; i < line.length; i++) {
		switch (line[i]) {
		case ',':
			ret ~= line[start .. i].idup;
			start = i+1;
			goto default;
		case '"':
			if (inString1) {continue;}

			if (!inString2) {	// opening text field
				start = i+1;
			} else {			// closing text field
				ret ~= line[start .. i].idup;
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
				ret ~= line[start .. i].idup;
				do { i++; } while (line[i] == ' ' || line[i] == '\t');
				start = i+1;
			}
			inString1 = !inString1;
			goto default;
		default:
		}
		// part of current field in csv
	}
	ret ~= line[start .. $].idup;
	return ret;
}

unittest {
	auto row = parseCSV("asdf, 1235,'asdgij rh rh\" aisdrhjerihj', \"asdigjdrjhrhj\",123 43 222");
	assert(row.length == 5, "row length incorrect");
	assert(row[0] == "asdf", "incorrect value");
	assert(row[1] == " 1235", "incorrect value");
	assert(row[2] == "asdgij rh rh\" aisdrhjerihj", "incorrect value");
	assert(row[3] == "asdigjdrjhrhj", "incorrect value");
	assert(row[4] == "123 43 222", "incorrect value");
}
