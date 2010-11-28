#!/bin/awk
#########################################################################
#
#   csvprint - print plaintext csv in nicely formatted columns
#   Copyleft (cl) 2010 velusip, velusip@gmail.com
#
#########################################################################
#
#     csvprint requires awk.  Run it like so:
#     e.g. $ awk -f <thisscript.awk> input.csv | less
#
#   Protips:
#   * awk helps you sleep at night.
#
#   tnx to awk for being there when I need you most.
#
#########################################################################

#adjust the separation character here 
BEGIN {FS= ",";}

// {
	split($0, line);
	# For each field in this record. 
	for (field=1; field<=NF; field++)
		if (( fieldlen= length(tbl[NR,field]= line[field]) ) > tbl[-1,field])
			tbl[-1,field]= fieldlen;# Stow widest field width
	# Stow the number of fields for each record.
	tbl[NR,-1]= NF;
}

END {
	# Print csv with consistent column widths.
	# For all records, then all fields
	for (record=1; record<=NR; record++)
		for (field=1; field<= tbl[record,-1]; field++)
			if (field == tbl[record,-1])
				printf "%" tbl[-1,field]+length(FS) "s\n", tbl[record,field];
			else
				printf "%" tbl[-1,field]+length(FS) "s%s", tbl[record,field], FS;
}

