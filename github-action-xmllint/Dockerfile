FROM debian:jessie-slim

LABEL "com.github.actions.name"="Markdownlint"
LABEL "com.github.actions.description"="Tests all Markdownfiles"
LABEL "com.github.actions.icon"="mic"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/DK-Hostmaster/epp-xsd-files"

RUN apt-get update -y && apt-get install -y libxml2-utils

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
