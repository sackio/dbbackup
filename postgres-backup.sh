#! /bin/bash

############################################
# Backup postgres databases
############################################

echo "Beginning postgres backup..."

PUSER=""
DUMPALL="/usr/bin/pg_dumpall"
PGDUMP="/usr/bin/pg_dump"
PSQL="/usr/bin/psql"
UUSER=""

DIR=""
LABEL="postgres_$(date +%Y-%m-%d-%H-%M)"

mkdir -p "$DIR/$LABEL"
chown -R "$PUSER" "$DIR"
cd "$DIR/$LABEL"

DBS=$(sudo -u $PUSER $PSQL -l -t | egrep -v 'template[01]' | awk '{print $1}')

sudo -u $PUSER $DUMPALL | gzip -9 > "$DIR/$LABEL/global_db.out.gz"
sudo -u $PUSER $DUMPALL -g | gzip -9 > "$DIR/$LABEL/globals.gz"

for database in $DBS; do
  if [ "$database" = "|" ]; then continue; fi

  echo "...backing up $database..."

  SCHEMA="$DIR/$LABEL/$database.schema.gz"
  DATA="$DIR/$LABEL/$database.data.gz"

  sudo -u $PUSER $PGDUMP -C -s "$database" | gzip -9 > "$SCHEMA"
  sudo -u $PUSER $PGDUMP -C "$database" | gzip -9 > "$DATA"
done

echo "...compressing output..."

GZIP=-9 tar czf "$DIR/$LABEL.tar.gz" "$DIR/$LABEL" && rm -rf "$DIR/$LABEL"

chown -R "$UUSER" "$DIR"

echo "...done"
