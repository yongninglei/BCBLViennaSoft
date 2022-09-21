#!/bin/bash

#User inputs:
bids_root_dir=/ceph/mri.meduniwien.ac.at/projects/physics/fmri/data/bcblvie22
#Begin:
#Run heudiconv
for subj in  t001
do
	for sess in 002
	do
		unset PYTHONPATH; singularity run \
			--no-home \
			-B $bids_root_dir:/base \
			--cleanenv /ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/heudiconv/heudiconv-0.11.3.sif \
			-d /base/dicoms/sub-{subject}/ses-{session}/*.IMA \
			-f /base/jobs/heuristics.py \
			-c dcm2niix \
			-s $subj \
			-ss $sess \
			-o /base/BIDS \
			-b --overwrite \
			--grouping all &
	done
done
		#	-f /base/jobs/heuristics.py \
		#	-c dcm2niix \
