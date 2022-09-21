#!/bin/bash

baseP=/ceph/mri.meduniwien.ac.at/projects/physics/fmri/data/bcblvie22

mkdir -p $baseP/singularity_home

unset PYTHONPATH; singularity run \
	-H $baseP/singularity_home \
	-B $baseP:/flywheel/v0/input \
	-B $baseP:/flywheel/v0/output  \
	-B $baseP/config/prfanalyze-vista.json:/flywheel/v0/input/config.json \
	--cleanenv /ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/vistasoft/docker/prfanalyze-vista_local.sif \
	--verbose
