# Training Marian NMT

This file describes how to train your own NMT system using the Marian toolkit.

## Getting to MetaCentrum and a GPU machine

NMT needs large-memory GPU cards (4 GB at least, better with 8 GB, or more GPUs at once). Register at MetaCentrum to get access to a machine with such a card.

<a href="https://metavo.metacentrum.cz/pbsmon2/resource/doom.metacentrum.cz">Doom machines</a> (your MetaCentrum login is needed to access that page) have 5GB cards and Gram machines have 6GB cards. I tested doom.

There are also <a href="https://wiki.metacentrum.cz/wiki/Cluster_Adan">Adan machines</a> which have the largest GPUs.

To get to a GPU, use these commands:

```
# First get to MetaCentrum
ssh nympha.zcu.cz  # or use another entry node

# Submit an interactive PBS job to get access to a doom GPU machine
qsub -q gpu -l select=1:ncpus=2:ngpus=1:mem=20gb:cl_doom=True \
     -l walltime=03:00 -I
  # !!! the -l flags says that your job will be killed after 3 minutes
  # all -q gpu jobs will be killed after 24 hours
  # use -q gpu_long and ask for up to 168 hours
  # you can ask for 2 gpus, always ask for 2x as many CPUs as GPUs

# Submit an interactive PBS job to get access to an adan GPU machine
qsub -q gpu -l select=1:ncpus=2:ngpus=1:mem=20gb:cl_adan=True \
     -l walltime=03:00 -I
  # !!! warning, just a 3-min test only!
```

## Useful Commands

### Useful Commands for MetaCentrum

```
# Find out which CUDA versions are available in module system
module available 2>&1 | grep ^cuda

# List my running jobs:
qstat -u $USER
```

### Useful Commands for GPUs in General

```
# Check which (if any!) GPUs you are allowed to use now
echo $CUDA_VISIBLE_DEVICES

# Check if any of your jobs is running on GPU and how much memory is free
nvidia-smi

# If $CUDA_VISIBLE_DEVICES contains just one GPU, you can get details about it:
nvidia-smi -i $CUDA_VISIBLE_DEVICES

# Steal someone's allocated GPU
export CUDA_VISIBLE_DEVICES=GPU-bbe91f18-4c8c-693a-2976-75acf1fc76c2
  # put there whatever you saw in echo $CUDA_VISIBLE_DEVICES
  # obviously, never steal GPU from anyone else than yourself!
  # remember that your GPU allocation in the main job can finish and the thief
  #job can remain running, so be very careful with this.
```

## Basic Marian Compilation (SentencePiece not built in)

```
ssh nympha.zcu.cz # or another MetaCentrum entry node
ssh doom7
  # or another free node, as visible here: https://metavo.metacentrum.cz/pbsmon2/resource/doom.metacentrum.
  # for adan, ssh e.g. to adan47
```

Note: For training never just ssh to the machine, always use PBS/qsub as shown above. For compilation, you may use ssh, but check if the machine is not already overloaded (run top).

Note2: Each of the MetaCentrum clusters *has a different home*.

```
# Activate prerequisites using MetaCentrum setup tools:
module add cmake-3.6.1
module add cuda-8.0
module add gcc-5.3.0
  # this particular GCC is needed for good compatibility with CUDA

# Make sure a tempdir with sufficient quota.
# CHECK YOUR QUOTAS on the web page:
#   https://metavo.metacentrum.cz/osobniv3/quotas/user/YOUR_METACENTRUM_USERNAME
#   (use your ssh username+password to log in to these pages)
export TMP=/SOME/PATH/WHERE/100GB/FIT

# Get Marian
git clone https://github.com/marian-nmt/marian.git

cd marian

# Compile Marian
#  (these are essentially instructions from https://marian-nmt.github.io/quickstart/)
mkdir build
cd build
cmake ..
make -j
```

# Compiling Marian with SentencePiece

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

## Getting Sample Training Data

There are two options of the sample training data, you are free to choose any of them.

Dataset A is smaller and easier to train. BLEU scores on its corresponding testset will be higher, but the alignment as well as translation quality will be lower.

Dataset B is realistic, you can get a good English-Czech MT system with
it. Aside from the (much) longer training time needed, you will also need to
work with subword units, i.e. break words into short sequences of characters.
The final translation quality will be much higher.

### A: Small and Simple Dataset
Use the training, development and test corpus from WMT Multimodal Task, as available from the Multi30k Github repository.

```
# Clone the dataset
git clone https://github.com/multi30k/dataset.git multi30k-dataset
We will use only the pre-processed, i.e. tokenized and lowercased, data as available in the directory:

multi30k-dataset/data/task1/tok:
  train.lc.norm.tok.en ... English source of training data
  train.lc.norm.tok.cs ... Czech target of training data
  val.lc.norm.tok.en ... English source of the development set
  val.lc.norm.tok.cs ... Czech reference translation of the development set
  test_2016_flickr.lc.norm.tok.en  ... English source of the test set called FLICKR in HW4 below
  test_2016_flickr.lc.norm.tok.cs  ... Czech reference translation for the test set
```

### B: Realistic and Better Dataset

```
# Get the package
wget http://data.statmt.org/wmt17/nmt-training-task/wmt17-nmt-training-task-package.tgz
tar xzf wmt17-nmt-training-task-package.tgz

# Preprocess with BPE, i.e. break into pre-trained subwords
git clone https://github.com/rsennrich/subword-nmt

# Apply BPE to the training and development data
## You need to fix paths and do this for all files.
### This example shows it only for newstest2016, alias devset.
## The bpe_merges file is the same for both Czech and English.
zcat wmt17-nmt-training-task-package/newstest2016.en.gz \
| subword-nmt/subword_nmt/apply_bpe.py \
    --codes wmt17-nmt-training-task-package/bpe_merges \
    --input /dev/stdin --output /dev/stdout \
> dev.bpe.src

## When you do it for all the files you need, you will have:
##   train.bpe.src    ... English source of training data
##   train.bpe.tgt    ... Czech target of training data
##   dev.bpe.src      ... English source of the development set
##   dev.bpe.tgt      ... Czech target of the development set
Start Training
This is the baseline tested command to run interactively, if you asked for 2 GPUs:

marian \
  --devices 0 1  \
  --train-sets train.src train.tgt  \
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

Make sure to use the correct training files depending on your dataset choice: train.***.src and train.***.tgt.

The above flags saved a model about every 5 minutes  (too frequent, you will have too many models on your disk). In early stages of debugging, use --save-freq and --disp-freq of 100. For normal training, save ~every hour, e.g. ``--save-freq 10000``

Use --devices 0 if you asked for just 1 GPU.

For dataset B: add --no-shuffle, the dataset is already shuffled so no need to waste time on it.

Killing the command and starting it over will continue training from the last saved model.npz (but reading the corpus from the beginning).

The console will show things like:

```
[2017-12-05 15:03:02] [data] Loading vocabulary from train.src.yml
[2017-12-05 15:03:03] [data] Setting vocabulary size for input 0 to 43773
[2017-12-05 15:03:03] [data] Loading vocabulary from train.tgt.yml
[2017-12-05 15:03:03] [data] Setting vocabulary size for input 1 to 70560
[2017-12-05 15:03:03] [batching] Collecting statistics for batch fitting
[2017-12-05 15:03:06] [memory] Extending reserved space to 2048 MB (device 0)
[2017-12-05 15:03:06] [memory] Extending reserved space to 2048 MB (device 1)
[2017-12-05 15:03:06] [memory] Reserving 490 MB, device 0
[2017-12-05 15:03:08] [memory] Reserving 490 MB, device 0
[2017-12-05 15:03:37] [batching] Done
[2017-12-05 15:03:37] [memory] Extending reserved space to 2048 MB (device 0)
[2017-12-05 15:03:37] [memory] Extending reserved space to 2048 MB (device 1)
[2017-12-05 15:03:37] Training started
[2017-12-05 15:03:37] [memory] Reserving 490 MB, device 0
[2017-12-05 15:03:39] [memory] Reserving 490 MB, device 1
...
[2017-12-05 15:09:59] Ep. 1 : Up. 1000 : Sen. 81308 : Cost 84.54 : Time 382.09s : 2688.68 words/s
[2017-12-05 15:09:59] Saving model to model.iter1000.npz
[2017-12-05 15:10:05] Saving model to model.npz
...
```

## Non-Interactive Training
Always use non-interactive jobs for long-time training. The main reason is that if your job dies, it frees the GPU. An interactive job would wait for you to continue.

Here are MetaCentrum instructions on submitting jobs. Remember you need to ask for GPUs (and doom machines).

Also remember that you need to module add cuda-8.0 in the job script.

# Translate with the First Saved Model
The training will take very long time. We can test any saved model, independently.

## Translating on GPU (marian)

If you use a small model (e.g. for dataset A) and a big GPU (e.g. 16 GB one on
adan), you can easily keep training and testing at the same time.
Use
``nvidia-smi`` in a separate ssh connection to that machine to see how GPU
memory is being used.

In the following commands, you will have to use the corresponding vocabulary files that Marian created for you. Do not blindly copy-paste train.src.yml train.tgt.yml:

```
# interactively ask for 1 GPU for 1 hour
qsub -q gpu -l select=1:ncpus=1:ngpus=1:mem=1gb:cl_doom=True -l walltime=1:00:00 -I

marian-decoder   \
  --models model.iter1000.npz model.iter2000.npz    \
  --vocabs train.src.yml train.tgt.yml \
  < dev.src \
  > dev.translated-with-model-iter1000
```

For a huge speedup, use batched translation. Specifically, I saw these times on the test set of 2500 czengali sentences on doom machines (4.7GB GPU size):

```
No special batching flags                                      	Total time: 321.19093s wall
--mini-batch 64 --maxi-batch-sort src --maxi-batch 100 -w 2500 	Total time: 141.95220s wall
--mini-batch 64 --maxi-batch-sort src --maxi-batch 100 -w 4200 	Total time: 142.01441s wall
--mini-batch 300 --maxi-batch-sort src --maxi-batch 100 -w 4200	Total time: 243.57941s wall  # counter-intuitive: larger batch size takes more time
--mini-batch 256 --maxi-batch-sort src --maxi-batch 100 -w 4200	Total time: 219.79195s wall  # counter-intuitive: larger batch size takes more time
```

You can list several model files (--model model.iter3000.npz model.iter4000.npz), marian-decoder will ensemble them. You can even use different model types (transformer vs. s2s vs. amun).

## Translating on CPU (amun)

If you used the amun model type, you can use amun to translate with it.

```
# check if the machine is free enough with 'top'
# or ask for e.g. 4 CPUs with qsub
amun \
  --model model.iter1000.npz \
  --input-file dev.src \
  --source-vocab train.src.yml \
  --target-vocab train.tgt.yml \
  --cpu-threads 4 \
> dev.translated-with-model-iter1000
```
You can list several model files (--model model.iter3000.npz model.iter4000.npz), amun will ensemble them.

## Post-processing the Translation
If you used subwords (BPE), i.e. for dataset B, you definitely need to remove them. Simply pass the output through sed 's/@@ //g'.

For final (human) evaluation, it would be also very important use cased outputs (not lowercase as dataset A) and to detokenize the MT outputs.

```
## THIS IS OPTIONAL, WE DO NOT NEED TO EVALUATE MANUALLY
# Download the detokenizer:
wget https://raw.githubusercontent.com/moses-smt/mosesdecoder/master/scripts/tokenizer/detokenizer.perl
chmod +x detokenizer.perl

# Join BPE and detokenize MT output
# The parameter "-u" ensures that sentences get capitalized
cat dev.translated-with-model-iter1000 \
| sed 's/@@ //g'  \
| detokenizer.perl -u \
> dev.translated-with-model-iter1000.detokenized.txt
Evaluating Your Translations
We will use BLEU, as implemented by Rico Sennrich.

## Download the BLEU script:
wget https://raw.githubusercontent.com/EdinburghNLP/nematus/master/data/multi-bleu-detok.perl
# Make it executable
chmod +x multi-bleu-detok.perl

# Evaluate:
#   dev.translated-with-model-iter1000.detokenized.txt ... the system hypothesis
#   against
#   wmt17-nmt-training-task-package/newstest2016.cs.gz ... the reference
multi-bleu-detok.perl \
  <(zcat wmt17-nmt-training-task-package/newstest2016.cs.gz) \
  < dev.translated-with-model-iter1000.detokenized.txt
## NOTE the difference between <(...) and < in bash.
```

The output will be something like:

```
BLEU = 10.68, 41.7/16.0/7.3/3.4 (BP=0.942, ratio=0.944, hyp_len=51305, ref_len=54357)
```

An undef in division and output like this:

```
Use of uninitialized value in division (/) at ../multi-bleu-detok.perl line 146,  line 3005.
BLEU = 0.00, 10.3/2.3/0.0/0.0 (BP=1.000, ratio=1.676, hyp_len=70433, ref_len=42023)
```

indicates that you have no zero matched 3-grams and 4-grams (10.3/2.3/0.0/0.0) and that could be because your output is really bad, or that you forgot to de-BPE and/or detokenize.

## Producing Alignments from Marian
Marian can be used to calculate the model score (i.e. internal estimate of translation quality) given an input and a translation. The same tool, marian-scorer can also emit alignments while doing this:

```
marian-scorer -m model.iter500.npz \
  -v tok/train.lc.norm.tok.en.yml tok/train.lc.norm.tok.cs.yml \
  -t czenali.{en,cs} \
  --alignment \
> czenali.aligned-with-model-iter500.ali
```

Warning: As mentioned in the documentation, Transformer model has to be trained to produce alignments.

Format difference: The alignments from Marian contain also sentence-level score, followed by `|||'. More importantly, they are one token longer, for the end-of-sentence position. To view alignments produced by Marian, I suggest to simply add extra tokens EOS to the input sentences:

```
cat alignment-as-produced-by-marian \
| cut -d'|' -f 4- \
| paste czenali.en czenali.cs - \
| sed 's/\t/ EOS\t/g' | ./alitextview.pl | less
```
