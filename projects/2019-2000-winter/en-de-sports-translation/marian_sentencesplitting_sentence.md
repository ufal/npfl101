# Creating the translation model: sentence level 

## Tasks
* Add the domain specific sentences to the training data
* Build the model using marian sentence splitting  

## Add domain specific articles to training data  

```
cp merged_data.en merged_data.en_sentence
cp merged_data.de merged_data.de_sentence

cat ../projectData_sentence/training.en >> merged_data.en_sentence
cat ../projectData_sentence/training.de >> merged_data.de_sentence
```

## Building the model using sentence splitting
```
qsub -q gpu -l select=1:ncpus=4:ngpus=2:mem=20gb:cl_adan=True -l walltime=24:00:00 -I
module add cuda-8.0 #https://wiki.metacentrum.cz/wiki/Cuda_(Nvidia) accept license before
export TMP=/storage/plzen1/home/levellj/temp/

# sentence level 
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
