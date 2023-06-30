@"
FROM $( $VARIANT['_metadata']['distro'] ):$( $VARIANT['_metadata']['distro_version'] )

RUN apk add --no-cache ca-certificates
RUN apk add --no-cache $( $VARIANT['_metadata']['package'] )=$( $VARIANT['_metadata']['package_version'] )

"@

$VARIANT['_metadata']['components'] | % {
    $component = $_

    switch( $component ) {
        default {
            throw "No such component: $component"
        }
    }
}

@"
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

EXPOSE 123/udp

HEALTHCHECK CMD chronyc tracking || exit 1

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "-d", "-x" ]
"@
