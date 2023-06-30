FROM alpine:3.13

# Install chrony
RUN set -eux; \
    apk add --no-cache chrony=4.0-r1; \
    chronyd --version; \
    chronyc --version

RUN apk add --no-cache ca-certificates
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh

EXPOSE 123/udp

HEALTHCHECK CMD chronyc tracking || exit 1

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "-d", "-x" ]