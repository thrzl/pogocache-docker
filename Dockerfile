FROM bitnami/git:latest as prep
RUN echo "Acquire::http::Pipeline-Depth 0;" > /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::http::No-Cache true;" >> /etc/apt/apt.conf.d/99custom && \
    echo "Acquire::BrokenProxy    true;" >> /etc/apt/apt.conf.d/99custom
RUN apt-get update && apt-get install build-essential wget -y

FROM prep as build
RUN git clone https://github.com/tidwall/pogocache
WORKDIR /pogocache
RUN make

FROM gcr.io/distroless/cc-debian12
COPY --from=build /pogocache /app
WORKDIR /app
EXPOSE 9401
ARG AUTH
ARG THREADS
ARG SHARDS
ARG MAXCONNS
ARG MAXMEMORY
ARG EVICT
ARG PERSIST
ENTRYPOINT ["./pogocache","-h","0.0.0.0", "--auth","${AUTH}", "--threads","${THREADS}", "--shards","${SHARDS}", "--maxconns","${MAXCONNS}", "--maxmemory","${MAXMEMORY}", "--evict","${EVICT}","--persist","${PERSIST}"]
