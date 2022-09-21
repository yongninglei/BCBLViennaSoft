#!/bin/sh

baseP=/ceph/mri.meduniwien.ac.at/projects/physics/fmri/data/bcblvie22

unset PYTHONPATH; singularity run \
	-H $baseP/singularity_home \
	-B $baseP/BIDS/derivatives/fmriprep:/flywheel/v0/input \
	-B $baseP/BIDS/derivatives:/flywheel/v0/output  \
	-B $baseP/BIDS:/flywheel/v0/BIDS  \
	-B $baseP/config/prfprepare.json:/flywheel/v0/config.json \
	--cleanenv /ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/prfprepare/prfprepare_1.0.6.sif



