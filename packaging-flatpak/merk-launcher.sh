#!/usr/bin/env bash
set -euo pipefail
export PYTHONPATH="/app/share/merk:${PYTHONPATH:-}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.var/app/com.github_nutjob_laboratories.merk/config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.var/app/com.github_nutjob_laboratories.merk/data}"
exec python3 -m merk
