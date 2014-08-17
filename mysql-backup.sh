#! /bin/bash

############################################
# Backup mysql databases
############################################

echo "Beginning mysql backup..."

MUSER=""
MPASS=""
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
UUSER=""

DIR=""
LABEL=""

mkdir -p "$DIR/$LABEL"
chown -R "$MUSER" "$DIR"
cd "$DIR/$LABEL"

DBS="$($MYSQL -u $MUSER -p$MPASS -Bse 'show databases')"

for database in $DBS; do
  echo "...backing up $database..."
  DATA="$DIR/$LABEL/$database.gz"

  $MYSQLDUMP -u $MUSER -p$MPASS $database | gzip -9 > "$DIR/$LABEL/$database.gz"
done

echo "...compressing output..."

GZIP=-9 tar czf "$DIR/$LABEL.tar.gz" "$DIR/$LABEL" && rm -rf "$DIR/$LABEL"

chown -R "$UUSER" "$DIR"

echo "...done"
