#!/bin/bash

set -eu -o pipefail

echo ""
echo "Using XMLlint on all XML example files"
echo "--------------------------------------"

if ! command -v xmllint > /dev/null 2>&1; then
    echo "xmllint not found, install libxml2-utils" >&2
    exit 1
fi

shopt -s globstar

EXITCODE=0

# Examples under a fail/ directory must be rejected by the XSD, all others must validate.
for file in xml/{,**/}*.xml; do
    if [[ "$file" == */fail/* ]]; then
        if xmllint --noout --schema epp.xsd "$file" > /dev/null 2>&1; then
            echo "$file validates but is expected to fail"
            EXITCODE=1
        fi
    else
        xmllint --noout --schema epp.xsd "$file" || EXITCODE=1
    fi
done

test $EXITCODE -eq 0 && echo "Everything looks good" || echo "XML does not comply with XSD specification"

exit $EXITCODE
