# Building the model using BPE

## Tasks
* Install marian and the needed tools. Please follow this guide: Documentation can be found [here](../../../training-marian-nmt/README.md)
* Download the language resources 
* Combine them into one merged corpus
* apply BPE on the merged corpus
* train the model using the merged corpus with BPE

# Langauge resources
For training the model all the provided data will be combined
 * Europarl: http://www.statmt.org/europarl/v9/training/europarl-v9.de-en.tsv.gz
 * News-commentry: http://data.statmt.org/news-commentary/v14/training/news-commentary-v14.de-en.tsv.gz
 * Wikititles: http://data.statmt.org/wikititles/v1/wikititles-v1.de-en.tsv.gz
 * ParaCrawl: https://s3.amazonaws.com/web-language-models/paracrawl/release5/en-de.classify.gz
 * Common crawl corpus: http://www.statmt.org/wmt13/training-parallel-commoncrawl.tgz

```
#ensure correct encoding
export LC_ALL=C 
export LANG="de_DE.utf8"

#download training data
cd rawdata
wget http://www.statmt.org/europarl/v9/training/europarl-v9.de-en.tsv.gz
wget http://www.statmt.org/wmt13/training-parallel-commoncrawl.tgz
wget http://data.statmt.org/news-commentary/v14/training/news-commentary-v14.de-en.tsv.gz
wget http://data.statmt.org/wikititles/v1/wikititles-v1.de-en.tsv.gz
wget https://s3.amazonaws.com/web-language-models/paracrawl/release5/en-de.bicleaner07.txt.gz

tar xzf training-parallel-commoncrawl.tgz

#build merged data 
zcat en-de.bicleaner07.txt.gz europarl-v9.de-en.tsv.gz news-commentary-v14.de-en.tsv.gz wikititles-v1.de-en.tsv.gz > merged_data

cut -f1 merged_data > merged_data.en
cut -f2 merged_data > merged_data.de

cat commoncrawl.de-en.en >> merged_data.en
cat commoncrawl.de-en.de >> merged_data.de

#add domain specific training data
cp merged_data.en merged_data.en_sentence
cp merged_data.de merged_data.de_sentence

cp merged_data.en merged_data.en_document
cp merged_data.de merged_data.de_document

cat ../projectData_sentence/training_1_1.en >> merged_data.en_sentence
cat ../projectData_sentence/training_1_1.de >> merged_data.de_sentence

cat ../projectData_document/training.en >> merged_data.en_document
cat ../projectData_document/training.de >> merged_data.de_document

# create bpe_merges file
git clone https://github.com/rsennrich/subword-nmt
qsub -I -l select=1:ncpus=4:mem=24gb -l walltime=24:00:00

cat merged_data.en merged_data.de | ../external/subword-nmt/learn_bpe.py -s 32000 -o /dev/stdout >> bpe_merges_parallel

# Apply BPE to create training data
#src: english
#tgt: german 
cat merged_data.en | ../external/subword-nmt/subword_nmt/apply_bpe.py --codes bpe_merges --input /dev/stdin --output /dev/stdout > train.bpe.src
cat merged_data.de | ../external/subword-nmt/subword_nmt/apply_bpe.py --codes bpe_merges --input /dev/stdin --output /dev/stdout > train.bpe.tgt

# Apply BPE to the dev data 
cat 1-1-dev_ready.en.data | ../external/subword-nmt/subword_nmt/apply_bpe.py --codes bpe_merges --input /dev/stdin --output /dev/stdout > dev.bpe.src
cat 1-1-dev_ready.de.data | ../external/subword-nmt/subword_nmt/apply_bpe.py --codes bpe_merges --input /dev/stdin --output /dev/stdout > dev.bpe.tgt

# request computing powe
qsub -q gpu -l select=1:ncpus=4:ngpus=2:mem=20gb:cl_doom=True -l walltime=24:00:00 -I

# train the model
# https://github.com/marian-nmt/marian-examples/tree/336740065d9c23e53e912a1befff18981d9d27ab/wmt2017-transformer
ssh doom18
export TMP=/storage/plzen1/home/levellj/temp/
module add cmake-3.6.1   #https://wiki.metacentrum.cz/wiki/Cuda_(Nvidia) accept license before
module add cuda-8.0
module add gcc-5.3.0
cd marian/build/
mkdir model
./marian \
  --devices 0 1  \
  --type transformer \
  --train-sets /storage/plzen1/home/levellj/rawdata/train.bpe.src /storage/plzen1/home/levellj/rawdata/train.bpe.tgt  \
  --model model/model.npz \
  --vocabs model/vocab.yml model/vocab.yml  \
  --mini-batch-fit \
  --workspace 10024
  --layer-normalization --dropout-rnn 0.2 --dropout-src 0.1 --dropout-trg 0.1 \
  --early-stopping 5 \
  --valid-freq 10000 --save-freq 10000 --disp-freq 1000 \
  --valid-metrics ce-mean-words perplexity translation \
  --valid-sets /storage/plzen1/home/levellj/rawdata/dev.bpe.src /storage/plzen1/home/levellj/rawdata/dev.bpe.tgt \
  --valid-script-path ./validate.sh \
  --valid-translation-output valid.bpe.en.output --quiet-translation \
  --log model/train.log --valid-log model/valid.log \
  --overwrite --keep-best \
  --seed 1111 --exponential-smoothing \
  --normalize=1 --beam-size 12  \
  --tempdir /storage/plzen1/home/levellj/temp
```

## Resources
* https://marian-nmt.github.io/examples/mtm2017/intro/