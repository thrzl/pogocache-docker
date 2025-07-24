FROM bitnami/git:latest as prep
RUN echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::BrokenProxy    true;" >> /etc/apt/apt.conf.d/99custom
RUN apt-get update && apt-get install build-essential wget -y

FROM prep as build
RUN git clone https://github.com/tidwall/pogocache
WORKDIR /pogocache
RUN make

FROM debian:stable-slim
COPY --from=build /pogocache /app
COPY /entrypoint.sh /app
WORKDIR /app
EXPOSE 9401
ENTRYPOINT ["/bin/bash", "./entrypoint.sh"]
