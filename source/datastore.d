module datastore;

/**
 * A two dimensional in memory data store with convenience methods for
 * accessing Rows, Columns, and Cells.
 */

interface IDataStore {
	size_t numRows();
	size_t numColumns();
	string[] getColumn(size_t index);
	string[] getColumn(string name);
	string[] getRow(size_t index);
	string[][] getRows();
	string getCell(size_t row, size_t column);
}

/**
 * Base class for a two dimensional dataset
 */
class DataStore : IDataStore {
	import csv;
	CSV lines;
	this() {
		lines = loadData();
	}

	size_t numRows() {
		throw new Exception("not implemented");
	}
	size_t numColumns() {
		throw new Exception("not implemented");
	}
	string[] getColumn(size_t index) {
		throw new Exception("not implemented");
	}
	string[] getColumn(string name) {
		throw new Exception("not implemented");
	}

	string[] getRow(size_t index) {
		throw new Exception("not implemented");
	}
	string[][] getRows() {
		import std.stdio;
		string[][] ret;
		foreach (row; lines) {
		writeln("lidne: ", row);
			ret ~= row;
		}
		return ret;
	}

	string getCell(size_t row, size_t column) {
		throw new Exception("not implemented");
	}
}

/**
 * Typed version of DataStore
 */
class TypedDataStore : DataStore {

}
