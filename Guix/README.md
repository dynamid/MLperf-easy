## Warning
<div align="justify">
Exploring GUIX showed that it's possible to easily recreate environments if you have the manifests and keep the working environment clean for testing, but it was a path that was abandoned after spending several weeks trying to configure a manifest to run MLPerf. In the end, this path wasn't pursued further as it was taking too long, and the kadeploy tool proved not to require GUIX for the simpler installation of MLPerf. 
**Bad ending.**
</div>

# What's GUIX?
<div align="justify">
Guix is a transactional package manager, with support for per-user package installations. Users can install their own packages without interfering with each other, yet without unnecessarily increasing disk usage or rebuilding every package. Users can in fact create as many software environments as they like—think of it as VirtualEnv but not limited to Python, or modules but not limited to your sysadmin-provided modules.
</div>
