# Automatic Test Execution

In the directory where you cloned the mlperf repo, verify that deploy directory it exists.
```
mlperf$ ls -las
mlperf$ cd deploy
```

To avoid errors, you must create the cluster directory to store the `*.out` and `*.err` files.
```
mlperf/deploy$ mkdir taurus
```

Scripts must be given execution permissions.
```
mlperf/deploy$ chmod +x oar_exec. sh exec_docker_onnx_mob.sh exec_docker_onnx_res.sh exec_docker_tf_mob.sh exec_docker_tf_res.sh
```

## Execution in OAR

For the execution script, the OAR documentation was used to launch a script and basic configurations were given. The time allocated does not influence the execution in any way since the work is completed when the test is completed.

Run the `oar_exec.sh` script, which requires three arguments. This script allocates resources using three arguments: the first argument defines the cluster where the test will be deployed, and the second and third arguments define the framework and model.
Example:
```
mlperf/deploy$ ./oar_exec.sh taurus onnx mob
```

