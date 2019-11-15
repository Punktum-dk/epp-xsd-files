#!/bin/sh -l

echo ""
echo "Using XMLlint on all XML example files"
echo "--------------------------------------"

xmllint --schema epp.xsd xml/*.xml

EXITCODE=$?

test $EXITCODE -eq 0 && echo "Everything looks good" || echo "XML does not comply with XSD specification";
exit $EXITCODE
