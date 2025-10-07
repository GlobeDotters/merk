#!/usr/bin/env bash
set -euo pipefail
APP_DIR="/app/share/io.github.NutjobLaboratories.Merk"
export PYTHONPATH="${APP_DIR}:${PYTHONPATH:-}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.var/app/io.github.NutjobLaboratories.Merk/config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.var/app/io.github.NutjobLaboratories.Merk/data}"
exec python3 "${APP_DIR}/merk.py"
