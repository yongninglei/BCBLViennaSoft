# This script will be used to morph Checkerboards to Words
import os
import cv2, time, argparse, ast
from scipy.ndimage import median_filter
from scipy.spatial import Delaunay
from scipy.interpolate import RectBivariateSpline
from matplotlib.path import Path
import numpy as np
import subprocess as sp

mfeaturegridsize = 7 # number of image divisions on each axis, for example 5 creates 5x5 = 25 automatic feature points + 4 corners come automatically
mframerate = 30 # number of transition frames to render + 1 ; for example 30 renders transiton frames 1..29
moutprefix = "f" # output image name prefix
framecnt = 0 # frame counter
msubpixel = 1 # int, min: 1, max: no hard limit, but 4 should be enough
msmoothing = 0 # median_filter smoothing
mshowfeatures = False # render automatically detected features
mscale = 1.0 # image scale

# batch morph process
# Uncomment for test running or edit here or whatever
# images = ["f0.png","f30.png","f60.png","f90.png","f120.png","f150.png"]
os.chdir('./prueba/')

images     = ["EN_CB_CB1_advice.png","EN_RW_CB1_advice.png"]
moutprefix = "RW"
batchmorph(images,mfeaturegridsize,msubpixel,mshowfeatures,mframerate,moutprefix,msmoothing,mscale)
sd  = sp.call(f'~/bin/ffmpeg -framerate 15 -i {moutprefix}%d.png {moutprefix}advice.gif', shell=True)


images     = ["EN_CB_CB1_advice.png","EN_FF_CB1_advice.png"]
moutprefix = "FF"
batchmorph(images,mfeaturegridsize,msubpixel,mshowfeatures,mframerate,moutprefix,msmoothing,mscale)
sd  = sp.call(f'~/bin/ffmpeg -framerate 15 -i {moutprefix}%d.png {moutprefix}advice.gif', shell=True)