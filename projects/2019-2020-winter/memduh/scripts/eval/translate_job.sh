model=$1
src_vocab=$2
tgt_vocab=$3
to_translate=$4
output_path=$5

model_name=`echo $model | cut -f2 -d "/"`

script="#!/bin/bash -v \n
#PBS -N $model_name \n
#PBS -q gpu \n
#PBS -l select=1:ncpus=2:ngpus=1:mem=5gb:cl_adan=True:os=debian9 \n
#PBS -j oe \n
#PBS -l walltime=0:30:00 \n
module add cuda-8.0 \n
MARIAN=/storage/ostrava1/home/memduh/marian/build \n
MARIAN_TRAIN=\$MARIAN/marian \n
MARIAN_DECODER=\$MARIAN/marian-decoder \n
MARIAN_VOCAB=\$MARIAN/marian-vocab \n
MARIAN_SCORER=\$MARIAN/marian-scorer \n
cd \$PBS_O_WORKDIR  \n
\$MARIAN_DECODER --max-length-crop --models $model --vocabs $src_vocab $tgt_vocab < $to_translate > $output_path"

script_path=~/.scratch/$$.sh
echo -e $script > $script_path
qsub $script_path


