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

#build training data
zcat en-de.bicleaner07.txt.gz europarl-v9.de-en.tsv.gz news-commentary-v14.de-en.tsv.gz wikititles-v1.de-en.tsv.gz > merged_data

cut -f1 merged_data > merged_data.de
cut -f2 merged_data > merged_data.en

cat commoncrawl.de-en.en >> merged_data.en
cat commoncrawl.de-en.de >> merged_data.de

#add domain specific training data
cat 1-1-training_ready.en.data >> merged_data.en
cat 1-1-training_ready.de.data >> merged_data.de

# create bpe_merges file
git clone https://github.com/rsennrich/subword-nmt
qsub -I -l select=1:ncpus=4:mem=12gb -l walltime=24:00:00
cat merged_data.en merged_data.de  | ../external/subword-nmt/learn_bpe.py -s 32000 -o bpe_merges

# Apply BPE to the training data
cat merged_data.de | ../external/subword-nmt/subword_nmt/apply_bpe.py --codes bpe_merges --input /dev/stdin --output /dev/stdout > train.bpe.tgt
cat merged_data.en | ../external/subword-nmt/subword_nmt/apply_bpe.py --codes bpe_merges --input /dev/stdin --output /dev/stdout > train.bpe.src

# request computing power
qsub -q gpu -l select=1:ncpus=4:ngpus=2:mem=20gb:cl_doom=True -l walltime=04:00:00 -I

# train the model
ssh doom18
export TMP=/storage/plzen1/home/levellj/temp/
module add cmake-3.6.1
module add cuda-8.0
module add gcc-5.3.0
cd marian/build/
./marian \
  --devices 0 1  \
  --train-sets /storage/plzen1/home/levellj/rawdata/train.bpe.src /storage/plzen1/home/levellj/rawdata/train.bpe.tgt  \
  --model model.npz \
  --mini-batch-fit \
  --layer-normalization \
  --dropout-rnn 0.2 \
  --dropout-src 0.1 \
  --dropout-trg 0.1 \
  --early-stopping 5  \
  --save-freq 1000 \
  --disp-freq 1000

```