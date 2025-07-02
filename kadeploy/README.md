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
Verify:
```
oarstat -f -j $JOB_ID | grep "assigned_hostnames" | cut -d'=' -f2 | tr -d ' '
```
Deploy:
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
