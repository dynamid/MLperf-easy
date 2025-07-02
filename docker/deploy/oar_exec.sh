oarsub \
                                -q default \
                                -p "wattmeter=YES AND cpuarch=x86_64 AND nodeset="$1"" \
                                -l host=1,walltime=00:50:00 \
                                -O "$1"/OAR_%jobid%_"$2"_"$3".out \
                                -E "$1"/OAR_%jobid%_"$2"_"$3".err \
                                -S ./exec_docker_"$2"_"$3".sh
