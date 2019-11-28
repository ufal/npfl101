# Building the model using marian sentence splitting

## Tasks
* Install dependencies 
* Build marian with the sentence splitting enabled
* Build the model using sentence splitting

### Requirements 
```
apt-get install libprotobuf10 protobuf-compiler libprotobuf-dev
```

## Building marian with sentence splitting enabled
```
git clone https://github.com/marian-nmt/marian
cd marian
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_SENTENCEPIECE=ON
make -j 8

#verify the piecing 
./marian --help |& grep sentencepiece
```


### Build marian
```
#preparing the test and dev set 
git clone https://github.com/marian-nmt/sacreBLEU.git sacreBLEU


```

## Building the model using sentence splitting
```
# create dev set
sacreBLEU/sacrebleu.py -t wmt16/dev -l ro-en --echo src > data/newsdev2016.ro
sacreBLEU/sacrebleu.py -t wmt16/dev -l ro-en --echo ref > data/newsdev2016.en

# create test set
sacreBLEU/sacrebleu.py -t wmt16 -l ro-en --echo src > data/newstest2016.ro
sacreBLEU/sacrebleu.py -t wmt16 -l ro-en --echo ref > data/newstest2016.en

#build the model
mkdir model
../../build/marian \
    --devices 0 1  \
    --type s2s \
    --model model/model.npz \
    --train-sets data/corpus.ro data/corpus.en \
    --vocabs model/vocab.roen.spm model/vocab.roen.spm \
    --dim-vocabs 32000 32000 \
    --mini-batch-fit -w 5000 \
    --layer-normalization --tied-embeddings-all \
    --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
    --early-stopping 5 --max-length 100 \
    --valid-freq 10000 --save-freq 10000 --disp-freq 1000 \
    --cost-type ce-mean-words --valid-metrics ce-mean-words bleu-detok \
    --valid-sets dev.en dev.de \
    --log model/train.log --valid-log model/valid.log --tempdir model \
    --overwrite --keep-best \
    --seed 1111 --exponential-smoothing \
    --normalize=0.6 --beam-size=6 --quiet-translation
```
