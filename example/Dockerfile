FROM crystallang/crystal:latest AS build-env
ADD ./src /build
ADD ./shard.yml /build/shard.yml
WORKDIR /build
RUN shards build -s
RUN ldd bin/bootstrap | \
    tr -s '[:blank:]' '\n' | \
    grep '^/' | \
    xargs -I % sh -c 'mkdir -p $(dirname dependencies%); cp % dependencies%;'

FROM scratch
WORKDIR /
COPY --from=build-env /build/dependencies /
COPY --from=build-env /build/bin/bootstrap /bootstrap

CMD ["/bootstrap"]
