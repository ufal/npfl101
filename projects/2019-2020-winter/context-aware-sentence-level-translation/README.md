# context-aware-sentence-level-translation

## General info
Author: Ondřej Měkota [github.com/pixelneo](https://github.com/pixelneo)

## Goal 

- Identify context dependent senteces from monolingual data. 

## Process
- In case of monolingual data, use attention weights from a pretrained BERT-like model to estimate 'amount' of depency of sentence on its context. 
- Then build a model with the attention weights as inputs to classify whether sentence depends on its context. 
