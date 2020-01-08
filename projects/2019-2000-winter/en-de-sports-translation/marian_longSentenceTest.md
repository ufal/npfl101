# Experiment with long sentences in marian 
Goal of the experiment was to find the length limitation of input sentences for marian.  

```
qsub -q gpu -l select=1:ncpus=4:ngpus=2:mem=20gb:cl_adan=True -l walltime=24:00:00 -I
export TMP=/storage/plzen1/home/levellj/temp/
module add cmake-3.6.1   #https://wiki.metacentrum.cz/wiki/Cuda_(Nvidia) accept license before
module add cuda-8.0
module add gcc-5.3.0

mkdir model_longSentence
./marian \
    --devices 0 1  \
    --type transformer \
    --model model_longSentence/model.npz \
    --train-sets /storage/plzen1/home/levellj/rawdata/longSentence.en /storage/plzen1/home/levellj/rawdata/longSentence.de  \
    --vocabs model_longSentence/vocab.en.spm model_longSentence/vocab.de.spm \
    --mini-batch-fit \
    --workspace 10024 \
    --layer-normalization --tied-embeddings-all \
    --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
    --early-stopping 5 --max-length 100 \
    --save-freq 10000 --disp-freq 1000 \
    --cost-type ce-mean-words --valid-metrics ce-mean-words bleu-detok \
    --log model_longSentence/train.log \
    --log-level debug \
    --overwrite --keep-best \
    --seed 1111 --exponential-smoothing \
    --normalize=0.6 --beam-size=6 --quiet-translation \
    --tempdir /storage/plzen1/home/levellj/temp
```

## Conclusion 
Input sentence cannot exceed the token length of 100.  