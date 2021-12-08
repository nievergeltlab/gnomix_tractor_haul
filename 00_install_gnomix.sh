#!/bin/bash
#install libarchive dependency for xgmix
mkdir /home/pgca1pts/libraries
export $(cat .env | xargs)

mkdir -p ${WORKING_DIR}/errandout/${study}/phasing
mkdir -p ${WORKING_DIR}/errandout/${study}/training
mkdir -p ${WORKING_DIR}/errandout/${study}/running
mkdir -p ${WORKING_DIR}/errandout/${study}/expansion
mkdir -p ${WORKING_DIR}/errandout/${study}/splitting
mkdir -p ${WORKING_DIR}/errandout/${study}/plotting

wget https://www.libarchive.org/downloads/libarchive-3.4.3.tar.gz
tar xvzf libarchive-3.4.3.tar.gz
cd libarchive-3.4.3
./configure --prefix=/home/pgca1pts/libraries
make
make install

#call into working dir
cd $WORKING_DIR

#INSTALLATION

#Run this command so it knows to look for libarchive here.
LD_LIBRARY_PATH=/home/pgca1pts/libraries/lib:$LD_LIBRARY_PATH

#Load python and MPI modules.
module load 2020
#module load CMake/3.16.4-GCCcore-9.3.0 if xgboost install is failing
module load OpenMPI/4.0.3-GCC-9.3.0
module load Python/3.8.2-GCCcore-9.3.0

#Download gnomix
wget https://github.com/AI-sandbox/gnomix/archive/master.zip
unzip master.zip

cd XGMix-master

#Need to add seaborn==0.11.0 to the requirements.txt
echo "seaborn==0.11.0" >> requirements.txt

#Install required python modules
pip install -r requirements.txt --user

#You must comment out two lines of code from the code for gnomix, it is for plotting
#/home/pgca1pts/ancestry/gnomix/gnomix.py

#comment out the following lines by putting hash tags (#) before the line starts. They should be lines 206 in gnomix.py:
#   plot_cm(cm, labels=model.population_order[idx], path=cm_plot_path.format(d))

#If all did not have errors, XGmix should now work!

#Install program for plotting local ancestry
module load 2020
module load R
echo '
install.packages("plyr")
install.packages("matrixStats")
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
Y
BiocManager::install("karyoploteR")
q("no")
'

#install BCFtools
#SEE INSTRUCTIONS ON
#http://www.htslib.org/download/

#You'll also need some directories to store files

cd $WORKING_DIR

mkdir ${WORKING_DIR}/models #For trained models
mkdir ${WORKING_DIR}/predictions #For ancestry predictions
mkdir ${WORKING_DIR}/recombination_maps #For recombination maps
