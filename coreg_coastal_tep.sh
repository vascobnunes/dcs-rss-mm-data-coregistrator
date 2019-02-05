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


# Execute coin step 1
ciop-log "INFO" "Pre-processing COREG"
mkdir -p ${OUTPUTDIR}/output_step1
${MAIN_DIR}/pre_processing/run.sh ${LOGFILE} ${MAIN_DIR} ${TMPDIR} ${OUTPUTDIR} ${master} ${slave} ${performOpticalCalibration} ${performCropping} ${SubsetBoundingBox}
#
## List step 1 outputs
splittedCouple_list=$( ls ${OUTPUTDIR}/output_step1/*.tar )

# Execute COIN step 2
mkdir -p ${OUTPUTDIR}/output_step2
##for splittedCouple in $splittedCouple_list;
##do
ciop-log "INFO" "Processing data stacking for $splittedCouple_list"
${MAIN_DIR}/data_stacking/run.sh ${LOGFILE} ${MAIN_DIR} ${TMPDIR} ${OUTPUTDIR} ${splittedCouple_list}
#done

# Clean up
#rm -rf ${OUTPUTDIR}/output_step1/*
#rm -rf ${OUTPUTDIR}/output_step1

## Execute COIN step 3
#mkdir -p ${OUTPUTDIR}/output
#CohCalCouple_list=$( ls ${OUTPUTDIR}/output_step2/*.tar )
#ciop-log "INFO" "Processing COIN step 3"
#${MAIN_DIR}/snap_s1_coh_cal_stacking/run_step3.sh ${LOGFILE} ${MAIN_DIR} ${TMPDIR} ${OUTPUTDIR} "${CohCalCouple_list}" ${nAzLooks} ${nRgLooks} "${demType}" ${pixelSpacingInMeter} ${mapProjection}

# Clean up
#rm -rf ${OUTPUTDIR}/output_step2/*
#rm -rf ${OUTPUTDIR}/output_step2
#
#ending_time=$(echo "$(date) $line")
#ciop-log "INFO" "Run of $SCRIPT_FILENAME ends at: $ending_time"