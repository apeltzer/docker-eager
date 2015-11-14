#!/bin/bash

if [ -f /opt/gatk/GenomeAnalysisTK* ];then
    cd /usr/local/
    tar xf /opt/gatk/GenomeAnalysisTK*
    EC=$?
    if [ ${EC} -ne 0 ];then
        echo "untar of GATK failed with EC:${EC}"
        exit ${EC}
    fi
    ln -s /usr/local/GenomeAnalysisTK.jar /usr/bin/gatk
    exit 0
else
    echo "No directory /opt/gatk to extract GATK in"
fi
