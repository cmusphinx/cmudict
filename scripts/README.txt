Maintenance scripts for cmudict
-------------------------------
[20100118] (air)

Use these scripts for checking and compiling the dictionary.

The process is the following:

1) make changes to the dictionary
 - it's assumed that the changes are manual
 - check your work by doing a svn diff with the previous version

2) run scripts/test_cmudict.pl
 EG: ./scripts/test_cmudict.pl -p cmudict.0.7a.symbols cmudict.0.7a
 - this checks for collation order, legal entry format and phonetic symbols
 - if necessary fix problems then repeat this step until no errors
 
3) run CompileDictionary*
 [converts cmudict to the Sphinx format using make_baseform.pl]
 [checks for consistency using test_dict.pl]
 - produces two *_SPHINX_40 files; one generic the other major-versioned
 
 4) use svn to update cmudict; be sure to add a proper logging message
 
 That's it!
 
 
