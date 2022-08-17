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


###### EDIT ##########
## BCBL ##
RP = "/Users/glerma/toolboxes/BCBLViennaSoft"
triggerKey = "bcbl"

## VIENNA ##
# RP = "/local/dlinhardt/develop/BCBLViennaSoft"
# triggerKey = "6"  # "bcbl"

###### END EDIT ##########


localpath = join(RP, "local")
stimSize = 1024
maxEcc = 9
overlap = 1 / 3
# trs = [0.8, 1]
# flickerFrequency = [2.5, 2]
trs_flickerFreqs = [(1,2)] # [(0.8, 2.5), (1, 2)]
duration = 300
blank_duration = 10

# langs = ["ES","AT"]
# imnames = ["CB", "PW", "FF", "RW", "PW10", "PW20", "FF10", "FF20", "RW10", "RW20"]
langs = ["ES"]
imnames = ["CB", "PW", "RW"]


for (tr,flickerFrequency) in trs_flickerFreqs: 
    for lang in langs:
        for imname in imnames:
            imfilename = f"{lang}_{imname}_{stimSize}x{stimSize}x100.mat"
            loadImages = join(RP, "morphing", "DATA", "retWordsMagno", imfilename)
            if imname == "CB":
                stim = barStimulus(
                                    stimSize=stimSize,
                                    maxEcc=maxEcc,
                                    overlap=overlap,
                                    TR=tr,
                                    stim_duration=duration,
                                    blank_duration=blank_duration,
                                    flickerFrequency=flickerFrequency
                                )
            else:
                stim = barStimulus(
                                    stimSize=stimSize,
                                    maxEcc=maxEcc,
                                    overlap=overlap,
                                    TR=tr,
                                    stim_duration=duration,
                                    blank_duration=blank_duration,
                                    flickerFrequency=flickerFrequency,
                                    loadImages=loadImages
                                )
            oName = f"{lang}_{imname}_tr-{tr}_duration-{duration}sec" \
                    f"_size-{stimSize}.mat"
            oPath = join(localpath, oName)
            stim.saveMrVistaStimulus(oPath, triggerKey=triggerKey)
        
        
        