#!/bin/bash
# export $(cat .env | xargs); sbatch --array=1-22 --time=00:45:00 --error ${WORKING_DIR}/errandout/${study}/training/train_%a.e --output ${WORKING_DIR}/errandout/${study}/training/train_%a.o  --export=ALL,study=$study,WORKING_DIR=$WORKING_DIR,REF_DIR=$REF_DIR,ref_subjects=$ref_subjects  01_train_gnomix.sh -D $WORKING_DIR

##Ancestry panel code:
chr=$SLURM_ARRAY_TASK_ID

#Call into LISA temp dir
cd $TMPDIR

#Copy gnomix data over to temp dir. This is just to make it easier to deal with paths
rsync -rav  ${WORKING_DIR}/gnomix/*  $TMPDIR

#Make directories for gnomix outputs..
mkdir -p models/${study}_${chr}
mkdir -p ${WORKING_DIR}/models/${study}/${chr}

##Create reference panel

#Copy reference and test data to the working directory, this will enhance speed generally

#Copy reference population file
cp ${REF_DIR}/refpanel_chr${chr}.vcf.gz .

#Copy a phased dataset for testing:
cp ${WORKING_DIR}/${study}/phased/${study}_phased_chr${chr}.vcf.gz .

#Make sure reference population origin file is tab delimited
#Make sure recomb file is tab delimited

#Run xgmix
#python3 gnomix.py <query_file>                       <genetic_map_file>                                                    <output_folder>       <chr_nr> <phase> <reference_file>       <sample_map_file>
python3 gnomix.py  ${study}_phased_chr${chr}.vcf.gz  ${WORKING_DIR}/recombination_maps/HapMapcomb_genmap_chr${chr}_tab.txt  models/${study}_${chr}  ${chr}  FALSE  refpanel_chr${chr}.vcf.gz  $ref_subjects

#OUTPUTS:

#Copy ancestry calls and models
rsync -rav  models/${study}_${chr}/models/model_chm_${chr}/model_chm_${chr}.pkl  ${WORKING_DIR}/models/${study}/${chr}

#simulation data currently excluded
