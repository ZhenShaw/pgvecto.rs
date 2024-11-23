#!/usr/bin/env bash
set -e

cargo pgrx install --no-default-features --features "pg$VERSION" --release
psql -c 'ALTER SYSTEM SET shared_preload_libraries = "vectors.so"'
psql -c 'ALTER SYSTEM SET search_path TO "$user", public, vectors'

if [ "$OS" == "ubuntu-latest" ]; then
    sudo systemctl restart postgresql
    pg_lsclusters
fi
if [ "$OS" == "macos-latest" ]; then
    brew services restart postgresql@$VERSION
fi