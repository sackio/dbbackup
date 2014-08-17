#! /bin/bash

############################################
# Backup sqlite and sql-type databases
############################################

echo "Beginning sql file backups..."

PATHS=""
UUSER=""

DIR=""
LABEL="sql_files_$(date +%Y-%m-%d-%H-%M)"

mkdir -p "$DIR/$LABEL"

echo "Copying files with a .db-ish extension"
for file in $(find $PATHS -iname "*.db*"); do
  echo "...copying $file..."
  cp "$file" "$DIR/$LABEL"
done

echo "Copying files with a .sql-ish extension"
for file in $(find $PATHS -iname "*.sql*"); do
  echo "...copying $file..."
  cp -rf "$file" "$DIR/$LABEL"
done

echo "...compressing output..."

GZIP=-9 tar czf "$DIR/$LABEL.tar.gz" "$DIR/$LABEL" && rm -rf "$DIR/$LABEL"

chown -R "$UUSER" "$DIR"

echo "...done"
