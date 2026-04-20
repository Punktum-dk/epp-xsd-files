#!/bin/bash

set -eu -o pipefail

echo ""
echo "Using XMLlint on all XML example files"
echo "--------------------------------------"

shopt -s globstar

FORCE_JAVASCRIPT_ACTIONS_TO_NODE24=true xmllint --noout --schema epp.xsd xml/{,**/}*.xml

EXITCODE=$?

test $EXITCODE -eq 0 && echo "Everything looks good" || echo "XML does not comply with XSD specification"

exit $EXITCODE
