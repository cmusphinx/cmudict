#!sh
# [20080422] (air) Compile cmudict into SPHINX_40 form
# [20100118] (air) 

DIR=sphinxdict
DICT_BASE=cmudict
DICTIONARY=${DICT_BASE}.0.7a



echo "Compiling $DICTIONARY..."

# make_baseforms.pl removes stress marks and eliminates resulting duplicates
perl ./scripts/make_baseform.pl $DICTIONARY $DIR/$$_SPHINX_40


echo ""
echo "Testing sphinx cmudict... "
if ./scripts/test_dict.pl -p $DIR/SphinxPhones_40 $DIR/$$_SPHINX_40
then
    cp -p $DIR/$$_SPHINX_40 $DIR/${DICT_BASE}_SPHINX_40
    cp -p $DIR/$$_SPHINX_40 $DIR/${DICTIONARY}_SPHINX_40
    echo "Dictionary successfully compiled"
else
    if [ -e $DIR/${DICT_BASE}_SPHINX_40 ] ; then rm $DIR/${DICT_BASE}_SPHINX_40 ; fi
    if [ -e $DIR/${DICTIONARY}_SPHINX_40 ] ; then  rm $DIR/${DICTIONARY}_SPHINX_40 ; fi
    echo ""
    echo "$0 encountered errors"
    echo "dictionary compilation not completed"
fi

rm $DIR/$$_SPHINX_40

echo "Done"

#
