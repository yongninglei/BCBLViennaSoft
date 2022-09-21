#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 25 11:43:14 2022

@author: dlinhardt
"""

import nibabel as nib
import numpy as np
from glob import glob
from os import path
import os

baseP = '/z/fmri/data/bcblvie22/BIDS'
outP  = '/z/fmri/data/bcblvie22/derivatives/tSNR/orig'

subs  = ['t001', 'bt001', 'bt002']

for sub in subs:
    subP = path.join(baseP, f'sub-{sub}', 'ses-001', 'func')
    # ps = glob(path.join(subP, f'sub-{sub}_ses-001_task-*_run-0?_desc-preproc_bold.nii.gz'))
    ps = glob(path.join(subP, f'sub-{sub}_ses-001_task-*_run-0?_bold.nii.gz'))

    for p in ps:
        outF = path.join(outP, f'sub-{sub}', 'ses-001', path.basename(p).replace('_bold', '_tSNR'))
        if not path.isfile(outF):
            print(f'Working on {path.basename(p)}')
            f = nib.load(p)
            fDat = f.get_fdata()

            tSNR = fDat.mean(-1) / fDat.std(-1)

            if not path.isdir(oP := path.join(outP, f'sub-{sub}', 'ses-001')):
                os.makedirs(oP)
            outN = nib.Nifti1Image(tSNR, header=f.header, affine=f.affine)
            nib.save(outN, outF)
