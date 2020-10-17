#!/bin/bash -v
#PBS -q gpu
#PBS -l select=1:ncpus=2:ngpus=1:mem=5gb:cl_adan=True
#PBS -j oe
#PBS -l walltime=0:30:00

problem=en2tr
iter=iter1000

module add cuda-8.0


MARIAN=/storage/ostrava1/home/memduh/marian/build


MARIAN_TRAIN=$MARIAN/marian
MARIAN_DECODER=$MARIAN/marian-decoder
MARIAN_VOCAB=$MARIAN/marian-vocab
MARIAN_SCORER=$MARIAN/marian-scorer


WORKSPACE=9500
N=4
EPOCHS=8
B=12

cd $PBS_O_WORKDIR 

$MARIAN_DECODER  \
  --models models/$problem.$iter.npz   \
  --vocabs data/$problem.bpe.en.yml data/$problem.bpe.tr.yml \
  < data/dev.bpe.en \
  > translations/$problem/dev.$iter

