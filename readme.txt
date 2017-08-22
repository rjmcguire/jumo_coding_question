# A Utility to aggregate monthly loan product amounts.

Building:
 - Install D compiler from: dlang.org
 - run `dub build` to build the executable.
 - run `dub test` to execute the unittests.


Usage:
In order to generate the Output.csv file an input file Loans.csv should be provided
in the current working directory with the format:

MSISDN,Network,Date,Product,Amount


# Assumptions
 - The format of the CSV file will not change.
 - The date format never changes.
 - The code will only ever be used in a single threaded environment.
 - Double is a perfect number format with infinite lossless precision.
 - The input file will always be valid UTF8.
 - It is assumed that objects and complexity were to be introduced on purpose.
 - I assumed that using built in CSV parser and standard map / reduce functions were not allowed.

# Performance
 - The input file is currently expected to fit in RAM.
 - There are wasteful allocations in order to build the hash table. It would be better to process the input progessively only allocating in the report itself.
 - Using stdin and stdout is more performant in many circumstances, this is implemented in one of the earlier commits.
 - For better accurancy use bignum or another 3rd party money library, though this will negetively affect performance.
 