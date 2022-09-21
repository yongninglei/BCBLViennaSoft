#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jun 10 09:57:01 2022

@author: dlinhardt
"""

from glob import glob
from os import path, symlink, unlink
from scipy.io import loadmat
import numpy as np

baseP = '/ceph/mri.meduniwien.ac.at/projects/physics/fmri/data/bcblvie22/BIDS/sourcedata/vistadisplog'

# subs = np.sort(glob(path.join(baseP, 'sub-*')))
subs = ['/ceph/mri.meduniwien.ac.at/projects/physics/fmri/data/bcblvie22/BIDS/sourcedata/vistadisplog/sub-t001']
for sub in subs:
    sub = path.basename(sub)
    sess = np.sort(glob(path.join(baseP, sub, 'ses-*')))
    for ses in sess:
        ses = path.basename(ses)
        CBn8 = 1
        PWn8 = 1
        PW10n8 = 1
        PW20n8 = 1
        RWn8 = 1
        RW10n8 = 1
        RW20n8 = 1
        CBn1 = 1
        PWn1 = 1
        PW10n1 = 1
        PW20n1 = 1
        RWn1 = 1
        RW10n1 = 1
        RW20n1 = 1
        matFiles = np.sort(glob(path.join(baseP, sub, ses, '20*.mat')))
        for matFile in matFiles:

            stimName = loadmat(matFile, simplify_cells=True)['params']['loadMatrix']
            print(stimName)

            if 'CB_' in stimName:
                if 'tr-1' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-CBtr1000_run-0{CBn1}_params.mat')
                    CBn1 += 1
                elif 'tr-0.8' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-CB_run-0{CBn8}_params.mat')
                    CBn8 += 1

            elif 'PW_' in stimName:
                if 'tr-1' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-PWtr1000_run-0{PWn1}_params.mat')
                    PWn1 += 1
                elif 'tr-0.8' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-PW_run-0{PWn8}_params.mat')
                    PWn8 += 1

            elif 'PW10_' in stimName:
                if 'tr-1' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-PW10tr1000_run-0{PW10n1}_params.mat')
                    PW10n1 += 1
                elif 'tr-0.8' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-PW10_run-0{PW10n8}_params.mat')
                    PW10n8 += 1

            elif 'PW20_' in stimName:
                if 'tr-1' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-PW20tr1000_run-0{PW20n1}_params.mat')
                    PW20n1 += 1
                elif 'tr-0.8' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-PW20_run-0{PW20n8}_params.mat')
                    PW20n8 += 1

            elif 'RW_' in stimName:
                if 'tr-1' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-RWtr1000_run-0{RWn1}_params.mat')
                    RWn1 += 1
                elif 'tr-0.8' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-RW_run-0{RWn8}_params.mat')
                    RWn8 += 1

            elif 'RW10_' in stimName:
                if 'tr-1' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-RW10tr1000_run-0{RW10n1}_params.mat')
                    RW10n1 += 1
                elif 'tr-0.8' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-RW10_run-0{RW10n8}_params.mat')
                    RW10n8 += 1

            elif 'RW20_' in stimName:
                if 'tr-1' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-RW20tr1000_run-0{RW20n1}_params.mat')
                    RW20n1 += 1
                elif 'tr-0.8' in stimName:
                    linkName = path.join(path.dirname(matFile), f'{sub}_{ses}_task-RW20_run-0{RW20n8}_params.mat')
                    RW20n8 += 1

            if path.islink(linkName):
                unlink(linkName)

            symlink(path.basename(matFile), linkName)
