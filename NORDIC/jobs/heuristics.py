#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 26 14:46:55 2021

@author: dlinhardt
"""

import os


def create_key(template, outtype=('nii.gz',), annotation_classes=None):
    if template is None or not template:
        raise ValueError('Template must be a valid format string')
    return template, outtype, annotation_classes


def infotodict(seqinfo):
    """Heuristic evaluator for determining which runs belong where
    allowed template fields - follow python string module:
    item: index within category
    subject: participant id
    seqitem: run number during scanning
    subindex: sub index within group
    """
    t1_i1 = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1_inv1')
    t1_i2 = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1_inv2')
    t1_un = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1_uni')
    t1_w = create_key('sub-{subject}/{session}/anat/sub-{subject}_{session}_T1w')

    # TR==1
    AT_RW_sbref_tr1000 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RWtr1000_run-0{item:01d}_sbref')
    AT_RW_tr1000_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RWtr1000_run-0{item:01d}_phase')
    AT_RW_tr1000_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RWtr1000_run-0{item:01d}_magnitude')
    AT_PW_sbref_tr1000 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PWtr1000_run-0{item:01d}_sbref')
    AT_PW_tr1000_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PWtr1000_run-0{item:01d}_phase')
    AT_PW_tr1000_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PWtr1000_run-0{item:01d}_magnitude')
    AT_CB_sbref_tr1000 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-CBtr1000_run-0{item:01d}_sbref')
    AT_CB_tr1000_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-CBtr1000_run-0{item:01d}_phase')
    AT_CB_tr1000_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-CBtr1000_run-0{item:01d}_magnitude')

    to1_tr1000       = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_tasktr1000_dir-{item:01d}_epi')
    to_sbref_tr1000  = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_tasktr1000_dir-{item:01d}_sbref')

    # TR==0.8
    AT_RW_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW_run-0{item:01d}_sbref')
    AT_RW_tr800_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW_run-0{item:01d}_phase')
    AT_RW_tr800_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW_run-0{item:01d}_magnitude')
    AT_RW10_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW10_run-0{item:01d}_sbref')
    AT_RW10_tr800_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW10_run-0{item:01d}_phase')
    AT_RW10_tr800_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW10_run-0{item:01d}_magnitude')
    AT_RW20_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW20_run-0{item:01d}_sbref')
    AT_RW20_tr800_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW20_run-0{item:01d}_phase')
    AT_RW20_tr800_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-RW20_run-0{item:01d}_magnitude')

    AT_PW_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW_run-0{item:01d}_sbref')
    AT_PW_tr800_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW_run-0{item:01d}_phase')
    AT_PW_tr800_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW_run-0{item:01d}_magnitude')
    AT_PW10_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW10_run-0{item:01d}_sbref')
    AT_PW10_tr800_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW10_run-0{item:01d}_phase')
    AT_PW10_tr800_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW10_run-0{item:01d}_magnitude')
    AT_PW20_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW20_run-0{item:01d}_sbref')
    AT_PW20_tr800_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW20_run-0{item:01d}_phase')
    AT_PW20_tr800_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-PW20_run-0{item:01d}_magnitude')

    AT_CB_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-CB_run-0{item:01d}_sbref')
    AT_CB_tr800_P     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-CB_run-0{item:01d}_phase')
    AT_CB_tr800_M     = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-CB_run-0{item:01d}_magnitude')

    to1_tr800       = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_dir-{item:01d}_epi')
    to_sbref_tr800  = create_key('sub-{subject}/{session}/fmap/sub-{subject}_{session}_dir-{item:01d}_sbref')

    # bcbl pilot data
    ES_tr1000_P        = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-tr1000_run-0{item:01d}_phase')
    ES_tr1000_M        = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-tr1000_run-0{item:01d}_magnitude')
    ES_sbref_tr1000 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-tr1000_run-0{item:01d}_sbref')

    ES_tr800_P        = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-tr800_run-0{item:01d}_phase')
    ES_tr800_M        = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-tr800_run-0{item:01d}_magnitude')
    ES_sbref_tr800 = create_key('sub-{subject}/{session}/func/sub-{subject}_{session}_task-tr800_run-0{item:01d}_sbref')

    info = {
        t1_i1: [], t1_i2: [], t1_un: [], t1_w: [],
        AT_RW_sbref_tr1000: [], AT_RW_tr1000_P: [], AT_RW_tr1000_M: [],
        AT_PW_sbref_tr1000: [], AT_PW_tr1000_P: [], AT_PW_tr1000_M: [],
        AT_CB_sbref_tr1000: [], AT_CB_tr1000_P: [], AT_CB_tr1000_M: [],
        to1_tr1000: [], to_sbref_tr1000: [],

        AT_RW_sbref_tr800: [], AT_RW_tr800_P: [], AT_RW_tr800_M: [],
        AT_RW10_sbref_tr800: [], AT_RW10_tr800_P: [], AT_RW10_tr800_M: [],
        AT_RW20_sbref_tr800: [], AT_RW20_tr800_P: [], AT_RW20_tr800_M: [],

        AT_PW_sbref_tr800: [], AT_PW_tr800_P: [], AT_PW_tr800_M: [],
        AT_PW10_sbref_tr800: [], AT_PW10_tr800_P: [], AT_PW10_tr800_M: [],
        AT_PW20_sbref_tr800: [], AT_PW20_tr800_P: [], AT_PW20_tr800_M: [],

        AT_CB_sbref_tr800: [], AT_CB_tr800_P: [], AT_CB_tr800_M: [],
        to1_tr800: [], to_sbref_tr800: [],

        ES_tr1000_P: [], ES_tr1000_M: [], ES_sbref_tr1000: [],
        ES_tr800_P: [], ES_tr800_M: [], ES_sbref_tr800: [],
    }

    for idx, s in enumerate(seqinfo):

        # anatomy
        if (s.dim1 == 256) and ((s.dim2 == 216) or (s.dim2 == 240)) and ('mp2rage' in s.protocol_name):
            if ('_INV1' in s.series_description):
                info[t1_i1].append(s.series_id)
            elif ('_INV2' in s.series_description):
                info[t1_i2].append(s.series_id)
            elif ('_UNI' in s.series_description):
                info[t1_un].append(s.series_id)
        elif (s.dim1 == 256) and (s.dim2 == 256) and ('mprage' in s.protocol_name):
            info[t1_w].append(s.series_id)

        if s.TR == 1:
            # functional
            if (s.dim4 == 305):
                if ('AT_RW_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_RW_tr1000_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_RW_tr1000_M].append(s.series_id)
                elif ('AT_PW_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_PW_tr1000_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_PW_tr1000_M].append(s.series_id)
                elif ('AT_CB_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_CB_tr1000_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_CB_tr1000_M].append(s.series_id)
                # bcbl
                elif ('MB5_TR1000_TE36.8_2iso_60sl_FOV150' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[ES_tr1000_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[ES_tr1000_M].append(s.series_id)

            # functional SBref
            elif (s.dim4 == 1):
                if ('AT_RW_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_RW_sbref_tr1000].append(s.series_id)
                elif ('AT_PW_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_PW_sbref_tr1000].append(s.series_id)
                elif ('AT_CB_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_CB_sbref_tr1000].append(s.series_id)
            # bcbl
            elif (s.dim4 == 2) and ('SBRef' in s.series_description):
                info[ES_sbref_tr1000].append(s.series_id)

            # topup
            if ('TOPUP' in s.protocol_name.upper()):
                if 'SBRef' in s.series_description:
                    info[to_sbref_tr1000].append(s.series_id)
                else:
                    info[to1_tr1000].append(s.series_id)

        elif s.TR == 0.8:
            # functional
            if (s.dim4 == 380):
                if ('AT_RW_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_RW_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_RW_tr800_M].append(s.series_id)
                elif ('AT_RW10_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_RW10_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_RW10_tr800_M].append(s.series_id)
                elif ('AT_RW20_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_RW20_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_RW20_tr800_M].append(s.series_id)

                elif ('AT_PW_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_PW_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_PW_tr800_M].append(s.series_id)
                elif ('AT_PW10_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_PW10_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_PW10_tr800_M].append(s.series_id)
                elif ('AT_PW20_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_PW20_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_PW20_tr800_M].append(s.series_id)

                elif ('AT_CB_' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[AT_CB_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[AT_CB_tr800_M].append(s.series_id)
                # bcbl
                elif ('MB6_TR800_TE36.8_2iso_60sl_FOV150' in s.protocol_name):
                    if ('P' in s.image_type):
                        info[ES_tr800_P].append(s.series_id)
                    elif ('M' in s.image_type):
                        info[ES_tr800_M].append(s.series_id)

            # functional SBref
            elif (s.dim4 <= 2):
                if ('AT_RW_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_RW_sbref_tr800].append(s.series_id)
                elif ('AT_RW10_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_RW10_sbref_tr800].append(s.series_id)
                elif ('AT_RW20_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_RW20_sbref_tr800].append(s.series_id)

                elif ('AT_PW_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_PW_sbref_tr800].append(s.series_id)
                elif ('AT_PW10_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_PW10_sbref_tr800].append(s.series_id)
                elif ('AT_PW20_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_PW20_sbref_tr800].append(s.series_id)

                elif ('AT_CB_' in s.protocol_name) and ('SBRef' in s.series_description):
                    info[AT_CB_sbref_tr800].append(s.series_id)
            # bcbl
            elif (s.dim4 == 2) and ('SBRef' in s.series_description) and ('ES' in s.protocol_name):
                info[ES_sbref_tr800].append(s.series_id)

            # topup
            if ('TOPUP' in s.protocol_name.upper()):
                if 'SBRef' in s.series_description:
                    info[to_sbref_tr800].append(s.series_id)
                else:
                    info[to1_tr800].append(s.series_id)

    return info
