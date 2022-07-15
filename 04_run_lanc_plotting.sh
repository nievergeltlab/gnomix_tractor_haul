#!/bin/bash
mkdir "$WORKING_DIR"/plots/
Rscript 04_lanc_plotting.r $WORKING_DIR $study
#study=r2712

# export $(cat .env | xargs); sbatch --time=12:00:00 --error ${WORKING_DIR}/errandout/${study}/plotting/plot_all.e --output ${WORKING_DIR}/errandout/${study}/plotting/plot_all.o  --export=ALL,study=$study,WORKING_DIR=$WORKING_DIR  04_run_lanc_plotting.sh -D $WORKING_DIR

