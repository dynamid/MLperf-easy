#!/bin/bash

# Verificar argumento
if [ $# -ne 1 ]; then
  echo "Uso: $0 <nodeset>"
  exit 1
fi

NODESET="$1"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOGFILE="${NODESET}_${TIMESTAMP}.log"

# Ejecutar en segundo plano con nohup
nohup ./02_exec_kadeploy_full.sh "$NODESET" > "$LOGFILE" 2>&1 &

echo "[INFO] Ejecutando exec_kadeploy_full.sh en segundo plano"
echo "[INFO] Salida: $LOGFILE"
