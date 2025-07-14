#!/bin/bash

# ------------------------------
# Script de automatización para MLPerf en Grid'5000
# ------------------------------

set -e

# Verificar argumentos
if [ $# -ne 1 ]; then
  echo "Uso: $0 <nodeset>"
  echo "Ejemplo: $0 nova"
  exit 1
fi

NODESET=$1

# Paso 1: Reservar nodo
JOB_ID=$(oarsub \
  -q default \
  -p "wattmeter=YES AND cpuarch='x86_64' AND nodeset='$NODESET'" \
  -l host=1,walltime=03:00:00 \
  -t deploy \
  -r now | grep 'OAR_JOB_ID' | cut -d'=' -f2)

echo "[INFO] Paso 1: Reservando Nodo con el JOB_ID: $JOB_ID"

# Paso 2: Esperar nodo asignado
NODE=""
echo "[INFO] Esperando nodo asignado..."
while [ -z "$NODE" ]; do
  NODE=$(oarstat -f -j "$JOB_ID" 2>/dev/null | grep assigned_hostnames | cut -d'=' -f2 | tr -d ' ')
  sleep 10
done

echo "[INFO] Paso 2: Nodo asignado $NODE"

# Paso 3: Desplegar entorno
echo "[INFO] Paso 3: Usando Kadeploy"
kadeploy3 -m "$NODE" -e ubuntu2004-min
echo "[INFO] Finalizando Kadeploy"

# Paso 4: Borrar credencial SSH previa si existe
echo "[INFO] Paso 4: Verificando credenciales"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$NODE" || true

# Paso 5: Conectarse al nodo y ejecutar configuración
echo "[INFO] Paso 5: Conexion al nodo y ejecucion de test"
ssh root@$NODE 'bash -s' <<EOF > "${NODESET}_${JOB_ID}_run.log" 2>&1
set -e
cd /tmp
cat > preinstall.sh << EOF1
#!/bin/bash

export PYTHON_VERSION=3.7
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export PATH=/opt/anaconda3/bin:\$PATH
export HOME=/root

apt-get update
apt-get install -y --no-install-recommends \
    git build-essential software-properties-common \
    ca-certificates wget curl zip unzip \
    python3.8-dev python3-distutils python3-setuptools python3-pip

cd /opt
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O miniconda.sh
/bin/bash ./miniconda.sh -b -p /opt/anaconda3
rm miniconda.sh
/opt/anaconda3/bin/conda clean -tipsy
ln -s /opt/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
echo ". /opt/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate base" >> ~/.bashrc
source /opt/anaconda3/etc/profile.d/conda.sh
conda activate base
EOF1
  bash preinstall.sh

cat > mlperf-install.sh << EOF2
#!/bin/bash

pip install --upgrade pip
pip install cmake future pillow opencv-python-headless Cython pycocotools pybind11 "numpy<=1.24.3" "protobuf<=3.20.3" "onnx>=1.5" tensorflow onnxruntime

cd /tmp
git clone --recursive https://github.com/mlcommons/inference
cd inference/loadgen
CFLAGS="-std=c++14" python3 setup.py install
EOF2
bash mlperf-install.sh

cd /tmp && mkdir -p models data results && cd models/
wget -q https://zenodo.org/record/2535873/files/resnet50_v1.pb \
     https://zenodo.org/record/2269307/files/mobilenet_v1_1.0_224.tgz \
     https://zenodo.org/record/4735647/files/resnet50_v1.onnx \
     https://zenodo.org/record/4735651/files/mobilenet_v1_1.0_224.onnx
tar -xzf mobilenet_v1_1.0_224.tgz ./mobilenet_v1_1.0_224_frozen.pb

cd /tmp/inference/vision/classification_and_detection/tools/
./make_fake_imagenet.sh
mv fake_imagenet/ /tmp/data

mkdir -p /tmp/results
cd ..
export MODEL_DIR=/tmp/models
export DATA_DIR=/tmp/data/fake_imagenet/

python3 setup.py develop

DEVICE="cpu"
for BACKEND in onnxruntime tf; do
  for MODEL in mobilenet resnet50; do
    echo "[INFO] \$BACKEND \$MODEL \$DEVICE --accuracy"
    ./run_local.sh \$BACKEND \$MODEL \$DEVICE --accuracy
    sleep 120
    echo "[INFO] \$BACKEND \$MODEL \$DEVICE --scenario SingleStream"
    ./run_local.sh \$BACKEND \$MODEL \$DEVICE --scenario SingleStream
    sleep 120
    echo "[INFO] \$BACKEND \$MODEL \$DEVICE --scenario MultiStream"
    ./run_local.sh \$BACKEND \$MODEL \$DEVICE --scenario MultiStream
    sleep 120
  done
done
EOF

echo "[INFO] Benchmark completado y resultados guardados."

# Paso 6: Esperar 60 segundos y eliminar trabajo
sleep 60
echo "[INFO] Paso 6: Liberando recursos"
oardel $JOB_ID

echo "[INFO] Trabajo $JOB_ID eliminado correctamente."
