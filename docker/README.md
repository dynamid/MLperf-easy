# Testing Using Docker
Rapid execution of MLperf tests

MLperf has a comprehensive testbed for various models and frameworks. This recipe presents a quick setup for CPU-based testing with different frameworks and models.

Install requeriments

```
dnf install vim git -y
```

The first thing to do is clone the MLperf inference repo.
```
mkdir mlperf && cd mlperf/ && git clone --recurse-submodules https://github.com/mlcommons/inference.git --depth 1
```

Create the directory for the models.
```
mkdir models && cd models/
mkdir tf onnx
```

Change to the directory for TensorFlow models and download the models
```
cd tf/
wget -q https://zenodo.org/record/2535873/files/resnet50_v1.pb
wget -q https://zenodo.org/record/2269307/files/mobilenet_v1_1.0_224.tgz
# decompress
tar -xzf mobilenet_v1_1.0_224.tgz ./mobilenet_v1_1.0_224_frozen.pb -C .
```

Change to the directory for the Onnxruntime models and download the models
```
cd ../onnx
wget -q https://zenodo.org/record/4735647/files/resnet50_v1.onnx
wget -q https://zenodo.org/record/4735651/files/mobilenet_v1_1.0_224.onnx
```

Create the directory for the datasets
```
cd ../.. && mkdir data/
```

Move to the tools directory to download the datasets and download the dataset you need
```
cd inference/vision/classification_and_detection/tools/
```

Copy the contents of the "make_fake_imagenet" file:
```
cp -p make_fake_imagenet.sh make_fake_imagenet.sh.$(date +%Y%m%d-%H%M%S)
```

Copy the contents of the file located in the repo in **update/tools/make_fake_image.sh** into the **make_fake_imagenet.sh** file.

Run the program and move the dataset.
```
./make_fake_imagenet.sh && mv fake_imagenet/ ~/mlperf/data/
```


(Opcional) If you requirement use **other datasets**
```
./openimages_mlperf -d <DOWNLOAD_PATH>  -m <MAX_IMAGES>
./openimages_calibration_mlperf -d <DOWNLOAD_PATH>
Example:
./openimages_mlperf.sh -d ../../../../data/openimages -m 100
./openimages_calibration_mlperf.sh -d ../../../../data/openimages
```

Declare the variables to build the image
```
cd ..
```
- If you are using the TensorFlow framework
```
export MODEL_DIR=../../../models/tf
```
- If you are using the Onnxruntime framework
```
export MODEL_DIR=../../../models/onnx
```
- If you are using the dataset_fake
```
export MODEL_DIR=../../../data/fake_imagenet/
```
- If you are using other dataset
```
export MODEL_DIR=<DOWNLOAD_PATH>
```

Test
```
./run_and_time.sh onnxruntime mobilenet cpu --accuracy
```

P.D: The test execution is almost certain to fail, modify the `run_and_time.sh` file as it is in the repo archive.


# Deployment on OAR Platform
To carry out the deployment on the OAR platform, a group of scripts was developed, see `deploy` directory.


# Graph the results
For graphing the results, see the `result` directory.
