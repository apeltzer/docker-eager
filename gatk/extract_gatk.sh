#!/bin/bash

if [ -f /gatk/GenomeAnalysisTK*.tar.* ];then
    cd /opt/gatk/
    tar xf /gatk/GenomeAnalysisTK*.tar.*
    EC=$?
    if [ ${EC} -ne 0 ];then
        echo "untar of GATK failed with EC:${EC}"
        exit ${EC}
    fi
    #rm -f /usr/bin/gatk
    #chmod +x /usr/local/GenomeAnalysisTK.jar
    #ln -s /usr/local/GenomeAnalysisTK.jar /usr/bin/gatk
    exit 0
else
    echo "No file '/gatk/GenomeAnalysisTK*.tar.*' to extract GATK in"
fi
