# Testing Using Kadeploy

The first thing to do is to check which images are available in kadeploy and do this with the following command:
```
kaenv3 -l
```
PD: For this case, a minimal Ubuntu 20.04 image is selected; it's similar to the one used in Docker (16.04).

The second step is to request a node using OAR in a non-interactive manner:
```
oarsub -q default -p "cpuarch='x86_64' AND nodeset='nova'" -l host=1,walltime=01:00:00 -t deploy -r now
```
PD: For this case, one of the nodes of the Nova cluster is selected, but others that are x86_64 and not very old can be selected.

The third step is to verify the node assigned by OAR and deploy the image using Kadeploy:
- Verify:
```
oarstat -f -j $JOB_ID | grep "assigned_hostnames" | cut -d'=' -f2 | tr -d ' '
```
- Deploy:
```
kadeploy3 -m $NODE_HOSTNAME -e ubuntu2004-min
```
PD: $JOB_ID is the value displayed when the job is assigned, $NODE_HOSTNAME is the value displayed when the node is checked (it may not display anything, re-run the command until it does).

The fourth step is to enter the node via SSH to configure the environment:
```
ssh root@$NODE_HOSTNAME
```
PD: If you have problems with your login credentials, use the following command to clear them:
```
ssh-keygen -f "/home/projasye/.ssh/known_hosts" -R "$NODE_HOSTNAME"
```

In step six, when you log into the node, you will need to create two scripts to install the necessary tools and run them, the entire deployment is done in the tmp directory:
```
cd /tmp
```
```
vi preinstall.sh
---
#!/bin/bash

echo "[INFO] Configurando entorno MLPerf con Miniconda"

echo "[INFO] Declarando variables"
export PYTHON_VERSION=3.7
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
export PATH=/opt/anaconda3/bin:$PATH
export HOME=/root

# Actualizar sistema e instalar dependencias base
echo "[INFO] Actualizando e instalando herramientas"
apt-get update
apt-get install -y --no-install-recommends \
    git build-essential software-properties-common \
    ca-certificates wget curl zip unzip \
    python3.8-dev python3-distutils python3-setuptools python3-pip 

# Instalar Miniconda
echo "[INFO] Instalando Miniconda"
cd /opt
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O miniconda.sh
/bin/bash ./miniconda.sh -b -p /opt/anaconda3
rm miniconda.sh
/opt/anaconda3/bin/conda clean -tipsy
ln -s /opt/anaconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh
echo ". /opt/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate base" >> ~/.bashrc
conda config --set always_yes yes --set changeps1 no

# Activar conda
echo "[INFO] Activando conda"
source /opt/anaconda3/etc/profile.d/conda.sh
conda activate base
---
bash preinstall.sh
```
```
vi mlperf-install.sh
---
#!/bin/bash

# Instalando herramientas de python
echo "[INFO] Instalando tools de python"
pip install --upgrade pip
pip install cmake
pip install future
pip install pillow
pip install opencv-python-headless
pip install Cython
pip install pycocotools
pip install pybind11
pip install "numpy<=1.24.3"
pip install "protobuf<=3.20.3"
pip install "onnx>=1.5"
pip install tensorflow
pip install onnxruntime

# Clonar MLPerf e instalar loadgen
echo "[INFO] Clonando MLPerf e instalar loadgen"
cd /tmp
git clone --recursive https://github.com/mlcommons/inference
cd inference/loadgen
CFLAGS="-std=c++14" python3 setup.py install
---
bash mlperf-install.sh
```

The eighth step is to download the models and the test dataset:
- Download models:
```
cd /tmp && mkdir -p models data && cd models/
wget -q https://zenodo.org/record/2535873/files/resnet50_v1.pb \
	https://zenodo.org/record/2269307/files/mobilenet_v1_1.0_224.tgz \
	https://zenodo.org/record/4735647/files/resnet50_v1.onnx \
	https://zenodo.org/record/4735651/files/mobilenet_v1_1.0_224.onnx
tar -xzf mobilenet_v1_1.0_224.tgz ./mobilenet_v1_1.0_224_frozen.pb
```
- Download Dataset:
```
cd ../inference/vision/classification_and_detection/tools/
./make_fake_imagenet.sh
mv fake_imagenet/ /tmp/data
```

The last step is to declare the variables that are the paths to the model and dataset directory, then setup the tool and you are ready to use the execution script:
- Variables:
```
cd ..
export MODEL_DIR=/tmp/models
export DATA_DIR=/tmp/data/fake_imagenet/
```
- Setup:
```
python3 setup.py develop
```
- Execution:
```
Example:
./run_local.sh backend model device
backend is one of [tf|onnxruntime|pytorch|tflite|tvm-onnx|tvm-pytorch]
model is one of [resnet50|retinanet|mobilenet|ssd-mobilenet|ssd-resnet34]
device is one of [cpu|gpu]

./run_local.sh tf mobilenet cpu
./run_local.sh tf resnet50 cpu --accuracy
./run_local.sh onnxruntime mobilenet cpu --scenario SingleStream
./run_local.sh onnxruntime resnet50 cpu --scenario MultiStream
```

# Fast Apply
All steps can be summarized in a script called "mlperf_kadeploy.sh", arguments such as the cluster where you want to deploy, the backend, model, device (CPU only) and type (can be --accuracy, --scenario SingleStream) can be passed to the script.
PD: Once the test is finished, the script kills the job 60s later and generates a file with the result.
