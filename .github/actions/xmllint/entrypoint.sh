#!/bin/bash

set -eu -o pipefail

echo ""
echo "Using XMLlint on all XML example files"
echo "--------------------------------------"

shopt -s globstar

#xmllint xml/{,**/}*.xml --schema myschema.xsd --noout
command="xmllint $1 --schema $2 --noout"

echo "$command"

# shellcheck disable=SC2086
eval $command

EXITCODE=$?

test $EXITCODE -eq 0 && echo "Everything looks good" || echo "XML does not comply with XSD specification"

exit $EXITCODE
