# Introduction to MLPerf
<div align="justify">
MLPerf is a standardized benchmark suite widely recognized for evaluating the performance of hardware, software, and model systems in machine learning tasks. Developed by MLCommons, MLPerf provides reproducible metrics that allow systems to be compared under homogeneous conditions. The tests cover various domains such as computer vision, natural language processing, object detection, and speech recognition, both in training and inference contexts. Its objective is to promote transparency and comparability in the development of artificial intelligence solutions, facilitating the choice of appropriate platforms and configurations based on user needs.
</div>

# Tools for Running MLPerf Tests: Docker and Kadeploy
<div align="justify">
There are different environments for running MLPerf benchmarks, with Docker and Kadeploy being two of the most widely used tools due to their ease of integration and automation.

Docker allows you to package and distribute MLPerf test environments as portable containers, simplifying the installation of dependencies and ensuring consistent environments. This option is ideal for users seeking rapid configuration or working in infrastructures where container-based virtualization is standard. With Docker, you can obtain official MLCommons images or build custom containers tailored to specific hardware or software needs.

Kadeploy is a tool primarily used in research environments such as Grid'5000. It allows you to deploy custom operating systems on physical nodes in a cluster, granting full control over the test environment. This option is recommended when low-level access to the hardware is required or precise power consumption and performance measurements are desired without interference from the host system. Kadeploy allows you to run MLPerf benchmarks from scratch in a reproducible environment, without the overhead that virtualization can introduce.

Enter the _\**Docker** or **Kadeploy** directories\_ to check out the different ways to run tests.
</div>
