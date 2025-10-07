#!/usr/bin/env bash
export PYTHONPATH="/app/lib/python3.13/site-packages:/app/lib/python3.12/site-packages:/app/lib/python3.11/site-packages:$PYTHONPATH"
cd /app/share/merk
exec python3 merk.py "$@"
