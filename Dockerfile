FROM alpine/git:v2.24.3
RUN apk add --no-cache bash curl jq
COPY tagupdater /tagupdater
ENTRYPOINT ["/tagupdater"]
