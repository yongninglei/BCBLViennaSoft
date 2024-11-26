#!/bin/sh
# He hecho este script para lanzar cualquier cosa, el parametro qsub que le pases generado por python lo va a ejecutar.
# >  qsub -v DIR=/path/toSubj/dir/ $myPython/RunPython.sh "PythonString entre comillas"
# Author: garikoitz@gmail.com BCBL 2014-04
# Version: 01
# 
# --- BEGIN GLOBAL DIRECTIVE --
#$ -S /bin/sh
#$ -o $HOME/sgeoutput/RunPythonOutput/$JOB_NAME.$JOB_ID.o
#$ -e $HOME/sgeoutput/RunPythonOutput/$JOB_NAME.$JOB_ID.e
#$ -q all.q
#$ -m ea
# -- END GLOBAL DIRECTIVE --
 
 
# -- BEGIN USER SCRIPT --
# http://stackoverflow.com/questions/22291816/bash-string-quoted-multi-word-args-to-array 
j=''
for a in ${1}; do
      if [ -n "$j" ]; then
        [[ $a =~ ^(.*)[\"\']$ ]] && {
          args+=("$j ${BASH_REMATCH[1]}")
          j=''
        } || j+=" $a"
       elif [[ $a =~ ^[\"\'](.*)$ ]]; then
          j=${BASH_REMATCH[1]}
       else
          args+=($a)
       fi
done
echo "Esto es lo que se va a ejecutar despues de hacer source a .bash_profile"
echo $1

# Vamos a cargar todo pq no sabemos que enviaremos ni lo que vamos a necesitar
# Aqui es donde ejecutamos lo que toque, primero cargamos modulos, luego ejecutamos
source $HOME/.bash_profile

which python
echo "Now eval-ing it: "
eval $1
 
# **********************************************************
# -- BEGIN POST-USER --
echo "----JOB [$JOB_NAME.$JOB_ID] STOP [`date`]----"
# RETURNCODE=${RETURNCODE:-0}
# exit $RETURNCODE
# fi
# -- END POST USER--
