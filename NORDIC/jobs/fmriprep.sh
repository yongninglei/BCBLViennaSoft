#!/bin/bash

#User inputs:
bids_root_dir=/ceph/mri.meduniwien.ac.at/projects/physics/fmri/data/bcblvie22
nthreads=8
mem=20 #gb

#Begin:

#Convert virtual memory from gb to mb
mem=`echo "${mem//[!0-9]/}"` #remove gb at end
mem_mb=`echo $(((mem*1000)-5000))` #reduce some memory for buffer space during pre-processing

export FS_LICENSE=/ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/freesurfer


for subj in t001
do

home_dir=$bids_root_dir/singularity_home/$subj

mkdir -p $home_dir

#Run fmriprep
unset PYTHONPATH; singularity run \
	-H $home_dir \
	-B $bids_root_dir:/base -B $FS_LICENSE:/license \
	--cleanenv /ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/fmriprep/fmriprep-22.0.0.sif \
	/base/BIDS /base/derivatives/fmriprep/analysis-01 participant \
	--participant-label $subj \
	--skip-bids-validation \
	--output-spaces func fsnative fsaverage T1w MNI152NLin2009cAsym \
	--dummy-scans 0 \
	--fs-license-file /license/license.txt \
	-w /base/derivatives/fmriprep/analysis-01 \
	--nthreads $nthreads \
	--omp-nthreads $nthreads \
	--stop-on-first-crash \
	--mem_mb $mem_mb \
	--anat-derivatives /base/derivatives/fmriprep/analysis-01 &
	
done
	#--bold2t1w-init header \
	#--ignore fieldmaps \
