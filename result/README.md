# Extracting Results.

Extracting the results is simple. When you run oar_exec.sh, two files are created in the cluster directories you use. You must verify that the cluster directories exist.
Inside the cluster directory, you will find two files named `OAR_%job-id%_framework_model.err` and `OAR_%job-id%_framework_model.out`.

To download the metrics, we'll follow these steps: download the job_id metrics and start processing them. Copy the job_ids of the tests I perform to download the metrics. From the mlperf directory, enter the result directory (create it if it doesn't exist).
```
mlperf$ cd result
```
To download the metrics we will use the command recommended by the documentation.
```
curl 'https://api.grid5000.fr/stable/sites/lyon/metrics?job_id=job-id' >> job-id_framework_model
```
Let's create two directories for the frameworks.
```
mkdir tf onnx
```
Move the files to their respective framework directory
```
mv *_onnx_* onnx/
mv *_tf_* tf/
```
We are going to use the file2csv.sh script to convert the files to CSV. This script only selects a portion of the metrics (watts and cores used) and a command to automate the generation of the CSVs. Check if the job-ids have similar characters; for the example, they all start with 1885.
```
cd onnx/
find . -maxdepth 1 -name "1885*" -print0 | xargs -0 -n 1 bash -c '../file2csv.sh "$0"'
```
Repeat for `tf`, finally use the notebook `png_gen.ipynb` to graph the data and save the graphs.
