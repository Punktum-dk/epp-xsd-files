#!/bin/bash

set -eu -o pipefail

echo ""
echo "Using XMLlint on all XML example files"
echo "--------------------------------------"

shopt -s globstar

command="xmllint $1 --schema $2 --noout"

#xmllint --noout --schema epp.xsd xml/{,**/}*.xml
# shellcheck disable=SC2086
#xmllint $1 --schema $2 --noout
eval $command

EXITCODE=$?

test $EXITCODE -eq 0 && echo "Everything looks good" || echo "XML does not comply with XSD specification"

exit $EXITCODE
