"""
Create stimulus
===============
This are the instrucctions from David's email
from stimulus import barStimulus
stim = barStimulus(stimSize=1024, maxEcc=9, overlap=1/3, TR=.8, stim_duration=300, blank_duration=10, flickerFrequency=2.5, loadImages='/local/dlinhardt/develop/bcbl_stims/test_images.mat')
"stim.saveMrVistaStimulus('/local/dlinhardt/develop/bcbl_stims/words_tr-0.8_duration-300s.mat', triggerKey='s')

Maybe you have to change the \"_loadCarrierImages\" functions to read in the files correctly!
and also the params for your scanner in \"saveMrVistaStimulus\

I will do the distance measurements next week when the scanner is free.\n",

The call for the checkers:\n",

from stimulus import barStimulus
stim = barStimulus(stimSize=1024, maxEcc=9, overlap=1/3, TR=.8, stim_duration=300, blank_duration=10, flickerFrequency=2.5)
stim.saveMrVistaStimulus('/local/dlinhardt/develop/bcbl_stims/checkers_tr-0.8_duration-300s.mat', triggerKey='s')
"""
from pythoncode.stimulus import barStimulus
import os

join = os.path.join
# RP = "/Users/glerma/toolboxes/BCBLViennaSoft"
RP = "/local/dlinhardt/develop/BCBLViennaSoft"
localpath = join(RP, "local")
triggerKey = "6"  # "bcbl"
stimSize = 1024
maxEcc = 9
overlap = 1 / 3
tr = 0.8
duration = 300
blank_duration = 10
flickerFrequency = 2.5

#%% Call, all variables are in the previous cell; call for pseudo-words
loadImages = join(RP, "morphing", "DATA", "retWordsMagno", "ES_PW_768x768x100.mat")
stim = barStimulus(
    stimSize=stimSize,
    maxEcc=maxEcc,
    overlap=overlap,
    TR=tr,
    stim_duration=duration,
    blank_duration=blank_duration,
    flickerFrequency=flickerFrequency,
    loadImages=loadImages,
)
oName = join(localpath, f"words_tr-{tr}_duration-{duration}sec_size-{stimSize}.mat")
stim.saveMrVistaStimulus(oName, triggerKey=triggerKey)


#%% Call it again for checkers, same parameters
stim = barStimulus(
    stimSize=stimSize,
    maxEcc=maxEcc,
    overlap=overlap,
    TR=tr,
    stim_duration=duration,
    blank_duration=blank_duration,
    flickerFrequency=flickerFrequency,
)
oName = join(localpath, f"check_tr-{tr}_duration-{duration}sec_size-{stimSize}.mat")
stim.saveMrVistaStimulus(oName, triggerKey=triggerKey)
