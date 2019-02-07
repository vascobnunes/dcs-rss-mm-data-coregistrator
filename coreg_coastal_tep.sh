#!/bin/bash

MAIN_DIR="/usr/local/ctep-user-processor/"
OUTPUTDIR=${CTEP_OUTPUT_DIR}

export LOGFILE="${OUTPUTDIR}/logfile.txt"

function ciop-log() {
	local MSG_TYPE=$1
	local MSG=$2
	echo "[${MSG_TYPE}] - ${MSG}"
	echo "[${MSG_TYPE}] - ${MSG}" >>$LOGFILE

	return 0
}

#starting_time=$(echo "$(date) $line")
#SCRIPT_FILENAME=$0
#ciop-log "INFO" "Run of $SCRIPT_FILENAME starts at $starting_time"

# create temp and output folder to store the output products and export it
TMPDIR="${CTEP_WORK_DIR}/tmp"
mkdir -p $TMPDIR
mkdir -p ${TMPDIR}/output

# Master product reference
master=$1
# Slave product reference
slave=$2
# Product polarisation
performOpticalCalibration=$3
# Orbit type
performCropping=$4
# Azimuth coherence window size
SubsetBoundingBox=$5

ciop-log "INFO" "Processor input parameters:"
ciop-log "INFO" "	master: $master"
ciop-log "INFO" "	slave: $slave"
ciop-log "INFO" "	performOpticalCalibration: ${performOpticalCalibration}"
ciop-log "INFO" "	performCropping: $performCropping"
ciop-log "INFO" "	SubsetBoundingBox: $SubsetBoundingBox"


# Execute pre-processing
ciop-log "INFO" "Pre-processing COREG"
#mkdir -p ${OUTPUTDIR}/output_step1
${MAIN_DIR}/pre_processing/run.sh ${LOGFILE} ${MAIN_DIR} ${TMPDIR} ${OUTPUTDIR} ${master} ${slave} ${performOpticalCalibration} ${performCropping} ${SubsetBoundingBox}

# Execute data stacking
ciop-log "INFO" "Processing data stacking"
${MAIN_DIR}/data_stacking/run.sh ${LOGFILE} ${MAIN_DIR} ${TMPDIR} ${OUTPUTDIR}


# Clean up
#rm -rf ${OUTPUTDIR}/output_step2/*
#rm -rf ${OUTPUTDIR}/output_step2
#
#ending_time=$(echo "$(date) $line")
#ciop-log "INFO" "Run of $SCRIPT_FILENAME ends at: $ending_time"