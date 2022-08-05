#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 13 13:57:35 2020

@author: dlinhardt
"""

from psychopy import visual, core, event #import some libraries from PsychoPy
import random

import time
import numpy as np
import pandas as pd
import eyelinker

sub = 'test'#input('Subject: ')

#create a window
mywin = visual.Window([1280,1024],monitor="testMonitor", units="norm", allowGUI=False, fullscr=False, pos=(1280,0))


text_stim = visual.TextStim(mywin, 'Beginning EyeLinker test...')
text_stim.draw()
mywin.flip()

# Will attempt to default to MockEyeLinker if no tracker connected
tracker = eyelinker.EyeLinker(mywin, 'testfbr1.edf', 'LEFT')
# initialize
tracker.initialize_graphics()
tracker.open_edf()
tracker.initialize_tracker()
tracker.send_tracking_settings()
time.sleep(1)
mywin.flip()

tracker.display_eyetracking_instructions()
tracker.calibrate()

#create some stimuli
center      = visual.RadialStim(win=mywin, size=(1.6,2), mask=[1,1,0,0,0,0,0,0,0], radialCycles=6, angularCycles=12)
ring        = visual.RadialStim(win=mywin, size=(1.6,2), mask=[0,0,0,0,0,0,0,1,1], radialCycles=6, angularCycles=12)
center_ring = visual.RadialStim(win=mywin, size=(1.6,2), mask=[1,1,0,0,0,0,0,1,1], radialCycles=6, angularCycles=12)
empty       = visual.RadialStim(win=mywin, size=(1.6,2), mask=[0,0,0,0,0,0,0,0,0], radialCycles=6, angularCycles=12)
allStims    = np.array([empty, center, ring, center_ring])

fixCross     = visual.ShapeStim(mywin, vertices=((-.8,-1), (.8,1), (0,0), (-.8,1), (.8, -1)), lineWidth=2, closeShape=False, lineColor="purple")
fixDisk      = visual.Circle(mywin, radius=.25, fillColor="purple", lineColor="purple", units='deg')
fixDiskBlank = visual.Circle(mywin, radius=.25, fillColor="lightgreen", lineColor="lightgreen",  units='deg')

# text to show
# text      = visual.TextStim(mywin, text='Äußeren Ring gesehen?')
# textJa    = visual.TextStim(mywin, text='Ja',   color='green', pos=(-.1,-.1))
# textNein  = visual.TextStim(mywin, text='Nein', color='red',   pos=(.1,-.1))
# textEmpty = visual.TextStim(mywin, text='')


# trial parameters
TR = 1.5
stimLength  = 1 #triggers TR #s
trialLength = 6 #triggers 9  #s
minTrialLength = 5 #triggers trialLength - TR
maxTrialLength = 7 #triggers trialLength + TR

numberOfTrials = 40
trialsPerParadigm = numberOfTrials / 4

maxInRow = 3

# start values
trialN = 0
choice = -1
test   = 0

thisTrialLength = np.zeros(numberOfTrials)
stim = np.zeros(numberOfTrials, dtype=object)

result = np.zeros((numberOfTrials, 4))

triggerCount = 0    
flicker      = 0
choice       = -1

# calculate randomization beforehand
aThird   = 1/3
twoThird = 2/3
for i in range(numberOfTrials):
    lengthRand = random.random()
    thisTrialLength[i] = minTrialLength if lengthRand < aThird else maxTrialLength if lengthRand > twoThird else trialLength 

result[:,2] = np.repeat(range(4), trialsPerParadigm)

inRow = 10
inRowNow = 0
while inRow >= maxInRow:
    random.shuffle(result[:,2])
    
    inRow = 0
    for a,b in zip(result[:,2], result[1:,2]):
        if a == b:
            inRowNow += 1 
        else: 
            inRowNow = 0
        if inRowNow > inRow:
            inRow = inRowNow
            
stim = allStims[np.array(result[:,2],dtype=int)]


# last drift correction
tracker.drift_correct()
time.sleep(1)

tracker.start_recording()
time.sleep(1)


# start recording keys
keys = event.getKeys()

# fixation from beginning
fixCross.draw()
fixDisk.draw()

# wait for 6 as first trigger
event.waitKeys(keyList='6')
tracker.send_message('Experiments Starts. Time is: '+str(time.time()))


# 6 triggers baseline
#print('foo')
while triggerCount < 6:
    keys = event.getKeys()
    fixCross.draw()
    fixDisk.draw()
    if '6' in keys:
        #print('bar')
        triggerCount += 1
        
    mywin.flip()
    
triggerCount = 0

# start the timer
totalClock = core.Clock()
clock = core.Clock()

# start the presentation loop
while trialN < numberOfTrials:        
        
    # look for answer
    keys = event.getKeys()
    if '6' in keys:
        triggerCount += 1
        
    if '1' in keys:
        # textChoice = textJa
        choice = 1
    elif '2' in keys:
        # textChoice = textNein
        choice = 0
            
    # if in first s of trial then present stimulus else no stim and ask
    if triggerCount < stimLength:
        stim[trialN].contrast = -1 if flicker%2 == 0 else 1
        
        stim[trialN].draw()
        fixDisk.draw()
        fixCross.draw()

        mywin.flip()
        flicker += 1

    else:
        fixCross.draw()
        fixDiskBlank.draw()
        
        mywin.flip()

    core.wait(.113) # 125 for 8Hz - something for execution
    
    

    # prepare for new trial
    if triggerCount == thisTrialLength[trialN]:
        # log
        result[trialN,[0,1,3]] = totalClock.getTime(), clock.getTime(), choice
            
        # re-initialize
        print(flicker)
        flicker = 0
        trialN += 1
        choice = -1
        triggerCount = 0
        
        
        
        clock.reset()        
    # mywin.getMovieFrame() 

tracker.send_message('Experiments Stops. Time is: '+str(time.time()))

print(totalClock.getTime())

# mywin.saveMovieFrames(fileName='/ceph/mri.meduniwien.ac.at/departments/physics/fmrilab/lab/RETPipeline/Stimuli/forcedChoiceRPVISION.mp4', fps=8)

# print mean and save log
resultDF = pd.DataFrame(data=result, columns=['total t', 'trial t', 'stim', 'choice'])
resultDF.to_csv(sub+'.csv')

print('Correct:', (result[:,2] == result[:,3]).mean()*100, '%')
print(result)



# wait for user to stop measurement
keys = event.getKeys()
event.waitKeys(keyList='space')

tracker.stop_recording()
time.sleep(1)
tracker.close_edf()
tracker.transfer_edf()
tracker.close_connection()

# cleanup
mywin.close()
core.quit()