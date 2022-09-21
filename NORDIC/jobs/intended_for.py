#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 28 10:51:30 2021

@author: dlinhardt
"""
import numpy as np
import os.path as path
from os import rename
from bids import BIDSLayout
import bids
import json

layout = BIDSLayout('/z/fmri/data/bcblvie22/BIDS')

subs = layout.get(return_type='id', target='subject')

ress = [.8, 1]

for sub in subs:

    sess = layout.get(subject=sub, return_type='id', target='session')

    print(f'working on {sub}...')

    for ses in sess:

        # load func and fmaps
        funcNiftis = layout.get(subject=sub, session=ses, extension='.nii.gz', datatype='func')
        fmapNiftis = layout.get(subject=sub, session=ses, extension='.nii.gz', datatype='fmap')

        funcNiftisMeta = [funcNiftis[i].get_metadata() for i in range(len(funcNiftis))]
        fmapNiftisMeta = [fmapNiftis[i].get_metadata() for i in range(len(fmapNiftis))]

        for res in ress:
            funcN = np.array(funcNiftis)[[i['RepetitionTime'] == res for i in funcNiftisMeta]]
            fmapN = np.array(fmapNiftis)[[i['RepetitionTime'] == res for i in fmapNiftisMeta]]

            # make list with all relative paths of func
            funcNiftisRelPaths = [path.join(*funcN[i].relpath.split('/')[1:]) for i in range(len(funcN))]
            funcNiftisRelPaths = [fp for fp in funcNiftisRelPaths if ((fp.endswith('_bold.nii.gz') or fp.endswith('_sbref.nii.gz')) and all([k not in fp for k in ['mag', 'phase']]))]

            # add list to IntendedFor field in fmap json
            for fmapNifti in fmapN:
                if not path.exists(fmapNifti.filename.replace('.nii.gz', '_orig.json')):
                    f = fmapNifti.path.replace('.nii.gz', '.json')

                    with open(f, 'r') as file:
                        j = json.load(file)

                    j['IntendedFor'] = funcNiftisRelPaths

                    rename(f, f.replace('.json', '_orig.json'))

                    with open(f, 'w') as file:
                        json.dump(j, file, indent=2)
