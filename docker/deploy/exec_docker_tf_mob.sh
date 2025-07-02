#!/bin/bash

# Activa el modo de depuración: muestra cada comando antes de ejecutarlo
set -x

# Configura entorno Docker
g5k-setup-docker -t

# Login en DockerHub
docker login -u <user> -p 'TOKEN'

# Navegar al directorio del benchmark
cd ~/mlperf/inference/vision/classification_and_detection/

# Exportar variables de entorno
export MODEL_DIR=~/mlperf/models/tf
export DATA_DIR=~/mlperf/data/fake_imagenet/

# Ejecutar pruebas
./run_and_time.sh tf mobilenet cpu --accuracy
sleep 120
./run_and_time.sh tf mobilenet cpu --scenario SingleStream
sleep 120
./run_and_time.sh tf mobilenet cpu --scenario MultiStream
sleep 120

echo "Finalizando la sesión OAR..."
# Desactiva el modo de depuración si se desea
set +x

exit 0
