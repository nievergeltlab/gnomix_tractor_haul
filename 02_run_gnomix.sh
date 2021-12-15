#!/bin/bash
# export $(cat .env | xargs); sbatch --array=1-22 --time=00:45:00 --error ${WORKING_DIR}/errandout/${study}/running/run_%a.e --output ${WORKING_DIR}/errandout/${study}/running/run_%a.o  --export=ALL,study=$study,WORKING_DIR=$WORKING_DIR,REF_DIR=$REF_DIR,ref_subjects=$ref_subjects  02_run_gnomix.sh -D $WORKING_DIR

chr=$SLURM_ARRAY_TASK_ID

#Make output directory where predictions will be saved
mkdir -p ${WORKING_DIR}/predictions/${study}/${chr}

#Call into LISA temp dir
cd $TMPDIR

#Copy gnomix data over to temp dir. This is just to make it easier to deal with paths
rsync -rav ${WORKING_DIR}/gnomix/* ${TMPDIR}

#Make directories for gnomix outputs..
mkdir -p models
mkdir -p gnomix/${study}_${chr}
mkdir -p ${WORKING_DIR}/predictions/${study}/${chr}

##Create reference panel

#Copy reference data to the TEMP DIR, this should speed things up

#Copy a phased dataset for testing:
cp ${WORKING_DIR}/${study}/phased/${study}_phased_chr${chr}.vcf.gz .

#Make sure reference population origin file is tab delimited
#Make sure recomb file is tab delimited

#Run gnomix
#python3 gnomix.py <query_file>                      <genetic_map_file>                                                    <output_folder>        <chr_nr> <phase>  <path_to_model>
python3 gnomix.py ${study}_phased_chr${chr}.vcf.gz  ${WORKING_DIR}/recombination_maps/HapMapcomb_genmap_chr${chr}_tab.txt  gnomix/${study}_${chr}/ ${chr}    FALSE  ${WORKING_DIR}/models/${study}/${chr}/model_chm_${chr}.pkl

#OUTPUTS:

#Rename results file to add real file extension
mv gnomix/${study}_${chr}/query_results.msp gnomix/${study}_${chr}/query_results.msp.tsv

#Copy ancestry calls
rsync -rav gnomix/${study}_${chr}/* ${WORKING_DIR}/predictions/${study}/${chr}
