# Pretasks for working with marian 

## Tasks 
* Install dependencies for marian 
* Build marian with sentence splitting option enabled 
* Create tranining corpus 

## Dependencies
Install the following dependencies before complining marian.  
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
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DUSE_SENTENCEPIECE=ON -DPROTOBUF_LIBRARY=$ppath/lib/libprotobuf.so -DPROTOBUF_INCLUDE_DIR=$ppath/include -DPROTOBUF_PROTOC_EXECUTABLE=$ppath/bin/protoc -DTCMALLOC_LIB=/software/gperftools/2.7/lib/libtcmalloc.so -DCMAKE_INSTALL_PREFIX=../bin 
make -j 4

# verify the piecing is available
./marian --help |& grep sentencepiece
```

# create lanaguge corpus for training
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
```