cmudict Notes
-------------
[20060203] (air)


cmudict.0.6d was the last publicly released version of the
dictionary. It was used in the lmtool service until 2008.

cmudict.0.7 was an extension of the 6d version and represented an
additional year or so of development work, however it was never
publicly released. At some point it removed from distribution by the
then maintainer. 

cmudict.0.7a and cmudict.0.6e are modifed versions of the above
dictionaries. 0.6e updates 0.6d with new words found in 0.7 as well as
any corrections to 0.6d entries. It should be considered a transitional
version of cmudict, or perhaps as a corrected version of 0.7.

0.7a reflects corrections to systematic errors as well as the addition 
of new words.

The modifications are as follows:

1) Entries appearing in both 0.6d and 0.7 that had different
pronunciations were examined and the appropriate version inserted in
both dictionaries. Notionally this meant taking a corrected entry 
from 0.7 and putting it into 0.6d.

2) 0.7 was examined for variant errors. Specifically, words that had >6
variants had improbable variants removed. (This should eventually be redone
using a lower threshold, say a maximum of 3 per entry).

3) Geminate consonants, typically appearing in compound words, were
collapsed.

4) Certain systematic pronunciation (actually LTS rule) errors were
corrected. (Specifically McXxxx and O'Xxxxx forms.)

5) Serendipitously discovered errors (encountered in the course of the
above clean-ups) were corrected. 

6) Proper names in the top 10k found in the 1990 US Census and not already
in these dictionaries were added.

[For modifications 2-6, all changes were propagated to 0.6d.] 
??? not sure what this means anymore 

[20070607] (air)
added words from DeepSpeak and TIMIT sx

[20070921] (air)
switched the pronunciation order for AND to make reduced form first.

[20071029] (air)
removed some bogus variants

[200803] (air)
cmudict has been placed under version control in cmusphinx on Sourceforge. 
Subsequent changes are documented there.

Additional Notes
----------------
scripts/make_baseform.pl
Takes a base cmudict and transforms it into Sphinx-compatible format.

scripts/test_dict.pl
Checks a Sphinx format dictionary for correctness (since Sphinx is
picky about format). This should not be necessary unless you manually
modify the Sphinx dictionary. You can use it to check a .handdict file
for errors (see Logios).


ToDo
----
1. a version of test_dict for the base dictionary.
2. consider moving from a flat file to an xml format such as PLS.
3. consider elininating predictable inflected forms (such as -S -'S
   -ED) to reduce the size of the dictionary.

