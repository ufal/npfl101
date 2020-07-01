#!/bin/bash -v
#PBS -N tr2en_morph
#PBS -q gpu
#PBS -l select=1:ncpus=4:ngpus=2:mem=50gb:scratch_local=50gb:cl_adan=True
#PBS -j oe

module add cuda-8.0
module add boost-1.60-gcc-serial

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

$MARIAN_TRAIN \
  --devices 0 1  \
  --train-sets data/preprocessed/train_analyzed.bpe.tr data/preprocessed/train_analyzed.bpe.en  \
  --model models/tr2en_analyzed.npz \
  --mini-batch-fit \
  --layer-normalization \
  --dropout-rnn 0.2 \
  --dropout-src 0.1 \
  --dropout-trg 0.1 \
  --early-stopping 5  \
  --save-freq 1000 \
  --disp-freq 1000
