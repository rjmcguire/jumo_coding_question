module datastore;

/**
 * A two dimensional in memory data store with convenience methods for
 * accessing Rows, Columns, and Cells.
 */

/**
 * Base class for a two dimensional dataset
 */
class DataStore {
	import csv;
	CSV lines;
	this() {
		lines = loadData();
	}

	string[][] getRows() {
		import std.stdio;
		string[][] ret;
		foreach (row; lines) {
			ret ~= row;
		}
		return ret;
	}
}
