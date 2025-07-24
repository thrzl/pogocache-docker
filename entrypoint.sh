#!/bin/bash

exec ./pogocache \
  -h 0.0.0.0 \
  --auth "$AUTH" \
  --threads "$THREADS" \
  --shards "$SHARDS" \
  --maxconns "$MAXCONNS" \
  --maxmemory "${MAXMEMORY//\"/}" \
  --evict "${EVICT//\"/}" \
  --persist "$PERSIST"
