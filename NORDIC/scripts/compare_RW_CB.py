#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 15:53:34 2022

@author: dlinhardt
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from PRFclass import PRF

varExpThresh = .1
area = ['hV4']

RW00 = PRF.from_docker('bcblvie22', 't001', '002', 'CB', '01', baseP='/Volumes/ExtremePro')
RW10 = PRF.from_docker('bcblvie22', 't001', '002', 'RW10', '01', baseP='/Volumes/ExtremePro')
RW20 = PRF.from_docker('bcblvie22', 't001', '002', 'RW20', '01', baseP='/Volumes/ExtremePro')
RW30 = PRF.from_docker('bcblvie22', 't001', '002', 'RW', '01', baseP='/Volumes/ExtremePro')

for an in [RW00,RW10,RW20,RW30]:
    an.maskVarExp(varExpThresh)
    an.maskROI(area=area, atlas='wang')
    
mask = np.all((RW00.mask, RW10.mask, RW20.mask, RW30.mask), 0)


df = pd.DataFrame()

df = pd.concat([df, pd.DataFrame({'comp':'00-10',
                                  'diffs':RW00.ecc0[mask] - RW10.ecc0[mask]})], 
               ignore_index=True)

df = pd.concat([df, pd.DataFrame({'comp':'00-20',
                                  'diffs':RW00.ecc0[mask] - RW20.ecc0[mask]})], 
               ignore_index=True)

df = pd.concat([df, pd.DataFrame({'comp':'00-30',
                                  'diffs':RW00.ecc0[mask] - RW30.ecc0[mask]})], 
               ignore_index=True)

plt.figure()
sns.violinplot(x='comp', y='diffs', data=df)
plt.ylim((-5,7))


plt.figure()
plt.plot(RW10.r0[mask], RW00.r0[mask], '.', label='10')
plt.plot(RW20.r0[mask], RW00.r0[mask], '.', label='20')
plt.plot(RW30.r0[mask], RW00.r0[mask], '.', label='30')
plt.legend()
plt.ylabel('RW00 ecc')
plt.xlabel('RW10/20/30 ecc')
plt.xticks(np.linspace(0,20,5))
plt.yticks(np.linspace(0,20,5))
plt.plot((0,20),(0,20), 'r--')
plt.grid()
plt.xlim((0,10))
plt.ylim((0,10))
plt.gca().set_aspect('equal', 'box')