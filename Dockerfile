FROM alpine/git:v2.24.1
RUN apk add --no-cache bash
COPY entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]
