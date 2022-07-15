study=r2712
REF_DIR=/home/maihofer/nikos_brain/jessica
WORKING_DIR=/home/maihofer/nikos_brain/
ref_subjects=/home/maihofer/nikos_brain/lai_sims/EUR_AFR_JES.subjects



#Subset the reference panel to the variant list in the data
 
 # for chr in {1..22}
# do
# bcftools view -S eur_afr.txt -i 'EUR_AF>0.005' -m2 -M2  -Oz ALL.chr"$chr".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz > refpanel_chr"$chr".vcf.gz 
# done



sbatch --array=1-22 --time=02:00:00 --error ${WORKING_DIR}/errandout/train_%a.e --output ${WORKING_DIR}/errandout/train_%a.o  --export=ALL,study=$study,WORKING_DIR=$WORKING_DIR,REF_DIR=$REF_DIR,ref_subjects=$ref_subjects  01_train_gnomix.sh -D $WORKING_DIR


sbatch --array=1-22 --time=00:45:00 --error ${WORKING_DIR}/errandout/run_%a.e --output ${WORKING_DIR}/errandout/run_%a.o  --export=ALL,study=$study,WORKING_DIR=$WORKING_DIR,REF_DIR=$REF_DIR,ref_subjects=$ref_subjects  02_run_gnomix.sh -D $WORKING_DIR

#results expansion  for analysis step
sbatch --array=17 --time=02:00:00 --error ${WORKING_DIR}/errandout/expansion_%a.e --output ${WORKING_DIR}/errandout/expansion_%a.o  --export=ALL,study=$study,WORKING_DIR=$WORKING_DIR  03_run_lanc_expansion.sh -D $WORKING_DIR

#PLotting step (Does not depend on expansion)
sbatch --time=2:00:00 --error ${WORKING_DIR}/errandout/${study}/plotting/plot_all.e --output ${WORKING_DIR}/errandout/${study}/plotting/plot_all.o  --export=ALL,study=$study,WORKING_DIR=$WORKING_DIR  04_run_lanc_plotting.sh -D $WORKING_DIR

