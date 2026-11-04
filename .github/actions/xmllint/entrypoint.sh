#!/bin/bash

set -eu -o pipefail

echo ""
echo "Using XMLlint on all XML example files"
echo "--------------------------------------"

if ! command -v xmllint > /dev/null 2>&1; then
    echo "xmllint not found, install libxml2-utils" >&2
    exit 1
fi

SCHEMA=epp.xsd

# --skip-unknown-ns (or XSD_SKIP_UNKNOWN_NS=1) skips examples using namespaces the schema does not load.
SKIP_UNKNOWN_NS=${XSD_SKIP_UNKNOWN_NS:-}
for arg in "$@"; do
    case "$arg" in
        --skip-unknown-ns) SKIP_UNKNOWN_NS=1 ;;
        *) echo "Usage: $0 [--skip-unknown-ns]" >&2; exit 2 ;;
    esac
done

shopt -s globstar nullglob

declare -A KNOWN_NS=() SEEN_XSD=()

# Collect the target namespaces of a schema and everything it imports or includes.
load_schema_namespaces() {
    local path target location
    path=$(realpath -m "$1")
    [[ -n "${SEEN_XSD[$path]:-}" ]] && return
    SEEN_XSD[$path]=1
    target=$(xmllint --xpath 'string(/*/@targetNamespace)' "$path" 2> /dev/null || true)
    [[ -n "$target" ]] && KNOWN_NS[$target]=1
    while read -r location; do
        load_schema_namespaces "$(dirname "$path")/$location"
    done < <(xmllint --xpath '/*/*[local-name()="import" or local-name()="include"]/@schemaLocation' "$path" 2> /dev/null \
        | sed -n 's/^ *schemaLocation="\(.*\)"$/\1/p')
}

# Print the namespaces declared in an example that the schema does not load.
unknown_namespaces() {
    local ns
    while read -r ns; do
        case "$ns" in
            http://www.w3.org/2001/XMLSchema-instance|http://www.w3.org/XML/1998/namespace) ;;
            *) [[ -z "${KNOWN_NS[$ns]:-}" ]] && echo "$ns" ;;
        esac
    done < <(xmllint --xpath '//namespace::*' "$1" 2> /dev/null | sed -n 's/^ *xmlns[^=]*="\(.*\)"$/\1/p' | sort -u)
    return 0
}

[[ -n "$SKIP_UNKNOWN_NS" ]] && load_schema_namespaces "$SCHEMA"

EXITCODE=0

# Examples under a fail/ directory must be rejected by the XSD, all others must validate.
for file in xml/**/*.xml; do
    if [[ -n "$SKIP_UNKNOWN_NS" ]]; then
        unknown=$(unknown_namespaces "$file" | paste -sd ' ')
        if [[ -n "$unknown" ]]; then
            echo "$file skipped, namespace not loaded by $SCHEMA: $unknown"
            continue
        fi
    fi
    if [[ "$file" == */fail/* ]]; then
        if xmllint --noout --schema "$SCHEMA" "$file" > /dev/null 2>&1; then
            echo "$file validates but is expected to fail"
            EXITCODE=1
        fi
    else
        xmllint --noout --schema "$SCHEMA" "$file" || EXITCODE=1
    fi
done

test $EXITCODE -eq 0 && echo "Everything looks good" || echo "XML does not comply with XSD specification"

exit $EXITCODE
