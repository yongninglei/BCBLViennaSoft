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

import os
import sys
import shutil

if sys.platform == "darwin":
    sys.path.insert(1,'/Users/glerma/soft')
    # RP = '/Users/experimentaluser/toolboxes/BCBLViennaSoft'
    # RP = '/Users/glerma/soft/si-burmuin-prf/DATA'
    # RP = '/Users/glerma/toolboxes/BCBLViennaSoft'
if sys.platform.startswith("linux"):
    sys.path.insert(1,'/bcbl/home/home_g-m/glerma/soft')
    # RP = '/export/home/glerma/glerma/toolboxes/BCBLViennaSoft'

from PRFstimulus import barStimulus

join = os.path.join

# Find root path of the repo in any computer
try:
    RP = globals()['_dh'][0]
except:
    RP = os.path.dirname(os.path.realpath(__file__))

RP = '/export/home/glerma/glerma/toolboxes/BCBLViennaSoft'    

triggerKey = "generic"  # 
# localpath = join(RP, "images")
localpath = join(RP, "morphing", "DATA", "retWordsMagno")
stimSize  = 1024
maxEccs   = [9] # 9 Vienna, 9 BCBL, 7.7806 oldBCBL from MINI 
overlap   = 1 / 3
letter_size = 25

# duration = 256.0880 This is old BCBL MINI data
duration = 300
blank_duration = 8
forceBarWidth  = 3 # original ret with David 2022 was bar 2 deg, in orig Rosemary was 4, let's test 4 for now
# Add TR and flickering, (TR, flickerFreq)
# Flickering is implemented differently in David's code than in VistaDisp and Kendrick's code. 
# We observed that when we add 2 here, there are two changes per second, for both words and CB.
# In Rosemary code, they were using 2Hz for CB and 4Hz for words, but this means that CB make 2 full cycles
# per second (meaning 4 changes), while words make 4 changes per second. 
# trs_flickerFreqs = [(0.8, 2.5)] # [(0.8, 2.5), (1, 2)]   # (TR, flickerFreq)
# trs_flickerFreqs = [(0.8, 2.5), (1, 2)]  # (TR, flickerFreq)
trs_flickerFreqs = [(2, 8)] 


# langs = ["ES","AT"]
# imnames = ["CB", "PW", "FF", "RW", "PW10", "PW20", "FF10", "FF20", "RW10", "RW20"]
langs = ["CN"] # , "IT", "FR", "AT"]  # ["ES", "IT", "AT", "FR"]  # , "AT"
# imnames = ["CB", "RW"]

# Create one imname per every step in the morphing
# imnames = []
# for nstep in range(1,30):
#     imnames.append(f"RW{nstep}")

imnames = ["FF", "RW"] # ["FF", "RW", "CB"]
# for nstep in [10, 20]:
#     imnames.append(f"RW{nstep}")
        


for (tr, flickerFrequency) in trs_flickerFreqs:
    for maxEcc in maxEccs: 
        for imname in imnames:
            for lang in langs:
                print(f"\n{tr}+{flickerFrequency}+{lang}+{imname}+{maxEcc}")
                # Used this for the non morphed ones
                imfilename = f"{lang}_{imname}_{stimSize}x{stimSize}x100_letsize-{letter_size}.mat"
                loadImages = join(RP, "morphing", "DATA", "retWordsMagno", imfilename)
                
                # Used this for the non morphed ones
                # imfilename = f"{lang}_{imname}_{stimSize}x{stimSize}x100.mat"
                # loadImages = join(RP, "local", "mats", imfilename)

                oName = f"{lang}_{imname}_tr-{tr}_duration-{duration}sec" \
                        f"_flickfreq-{flickerFrequency}Hz" \
                        f"_size-{stimSize}pix_" \
                        f"maxEcc-{maxEcc}deg_barWidth-{forceBarWidth}deg_letsize-{letter_size}.mat"

                if imname == "CB":
                    if lang == langs[0]:
                        stim = barStimulus(
                                            stimSize=stimSize,
                                            maxEcc=maxEcc,
                                            overlap=overlap,
                                            TR=tr,
                                            stim_duration=duration,
                                            blank_duration=blank_duration,
                                            flickerFrequency=flickerFrequency,
                                            forceBarWidth=forceBarWidth,
                                        )
                        A = round(9*2/1.3)
                        stim._checkerboard(nChecks=A)
                    else:
                        destName = oName.replace(langs[0], lang)
                        shutil.copy(oName, destName)
                        continue
                elif imname[0:3] == "fix":
                    center_word_size = 25
                    fname = f"{imname}_{lang}_fixation.txt"
                    fnamepath = join(RP, "morphing", "DATA", "words_for_fixation", fname)
                    with open(fnamepath, "r") as fl:
                        word_list = fl.read()
                        word_list = word_list.split("\n")
                    stim = barStimulus(
                                            stimSize=stimSize,
                                            maxEcc=maxEcc,
                                            overlap=overlap,
                                            TR=tr,
                                            stim_duration=duration,
                                            blank_duration=blank_duration,
                                            flickerFrequency=flickerFrequency,
                                            forceBarWidth=forceBarWidth,
                                        )
                    
                    stim.word_in_center(word_list, center_word_size, paradigm='continuous')
                else:
                    stim = barStimulus(
                                        stimSize=stimSize,
                                        maxEcc=maxEcc,
                                        overlap=overlap,
                                        TR=tr,
                                        stim_duration=duration,
                                        blank_duration=blank_duration,
                                        flickerFrequency=flickerFrequency,
                                        loadImages=loadImages,                    
                                        forceBarWidth=forceBarWidth,
                                    )
                
                oPath = join(localpath, oName)
                stim.saveMrVistaStimulus(oPath, triggerKey=triggerKey)
                
