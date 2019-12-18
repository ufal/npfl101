# Building the model using marian sentence splitting

## Tasks
* Install dependencies 
* Build marian with the sentence splitting enabled
* Build the model using sentence splitting

### Requirements 
```
module add protobuf-3.11.0
module add gperftools-2.7 
module add cmake-3.6.1
module add cuda-8.0
module add gcc-5.3.0
ppath=/software/protobuf/3.11.0/
```

## Building marian with sentence splitting enabled
```
git clone https://github.com/marian-nmt/marian marian_sentencesplitting
cd marian_sentencesplitting
mkdir build
mkdir bin
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_SENTENCEPIECE=ON -DPROTOBUF_LIBRARY=$ppath/lib/libprotobuf.so -DPROTOBUF_INCLUDE_DIR=$ppath/include -DPROTOBUF_PROTOC_EXECUTABLE=$ppath/bin/protoc -DTCMALLOC_LIB=/software/gperftools/2.7/lib/libtcmalloc.so -DCMAKE_INSTALL_PREFIX=../bin 
make -j 4

# verify the piecing is available
./marian --help |& grep sentencepiece
```

## Building the model using sentence splitting
```
#build the model
qsub -q gpu -l select=1:ncpus=4:ngpus=2:mem=20gb:cl_adan=True -l walltime=24:00:00 -I
export TMP=/storage/plzen1/home/levellj/temp/
module add cmake-3.6.1   #https://wiki.metacentrum.cz/wiki/Cuda_(Nvidia) accept license before
module add cuda-8.0
module add gcc-5.3.0

#document level 
mkdir model_document
./marian \
    --devices 0 1  \
    --type transformer \
    --model model_document/model.npz \
    --train-sets /storage/plzen1/home/levellj/rawdata/merged_data.en_document /storage/plzen1/home/levellj/rawdata/merged_data.de_document  \
    --vocabs model_document/vocab.en.spm model_document/vocab.de.spm \
    --mini-batch-fit \
    --workspace 13024 \
    --valid-sets /storage/plzen1/home/levellj/projectData_document/dev.en /storage/plzen1/home/levellj/projectData_document/dev.de \
    --layer-normalization --tied-embeddings-all \
    --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
    --early-stopping 5 --max-length 100 \
    --valid-freq 10000 --save-freq 10000 --disp-freq 1000 \
    --cost-type ce-mean-words --valid-metrics ce-mean-words bleu-detok \
    --log model_document/train.log --valid-log model_document/valid.log \
    --overwrite --keep-best \
    --seed 1111 --exponential-smoothing \
    --normalize=0.6 --beam-size=6 --quiet-translation \
    --tempdir /storage/plzen1/home/levellj/temp

#sentence level 
mkdir model_sentence
./marian \
    --devices 0 1  \
    --type transformer \
    --model model_sentence/model.npz \
    --train-sets /storage/plzen1/home/levellj/rawdata/merged_data.en_sentence /storage/plzen1/home/levellj/rawdata/merged_data.de_sentence  \
    --vocabs model_sentence/vocab.en.spm model_sentence/vocab.de.spm \
    --mini-batch-fit \
    --workspace 13024 \
    --valid-sets /storage/plzen1/home/levellj/projectData_sentence/dev_1_1.en /storage/plzen1/home/levellj/projectData_sentence/dev_1_1.de \
    --layer-normalization --tied-embeddings-all \
    --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
    --early-stopping 5 --max-length 100 \
    --valid-freq 10000 --save-freq 10000 --disp-freq 1000 \
    --cost-type ce-mean-words --valid-metrics ce-mean-words bleu-detok \
    --log model_sentence/train.log --valid-log model_sentence/valid.log \
    --overwrite --keep-best \
    --seed 1111 --exponential-smoothing \
    --normalize=0.6 --beam-size=6 --quiet-translation \
    --tempdir /storage/plzen1/home/levellj/temp
```
