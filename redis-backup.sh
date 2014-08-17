#! /bin/bash

############################################
# Backup redis databases
############################################

echo "Beginning redis backup..."

RDB="/var/lib/redis"
UUSER=""

DIR=""
LABEL="redis_$(date +%Y-%m-%d-%H-%M)"

mkdir -p "$DIR/$LABEL"
cp -rf "$RDB"/* "$DIR/$LABEL"

echo "...compressing output..."

GZIP=-9 tar czf "$DIR/$LABEL.tar.gz" "$DIR/$LABEL" && rm -rf "$DIR/$LABEL"

chown -R "$UUSER" "$DIR"

echo "...done"
