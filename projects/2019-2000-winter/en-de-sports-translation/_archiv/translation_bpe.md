## Translation using the model (with BPE) and evaluating the result

```
#request computing power
qsub -q gpu -l select=1:ncpus=2:ngpus=1:mem=1gb:cl_doom=True -l walltime=1:00:00 -I

#translate using the model 
export TMP=/storage/plzen1/home/levellj/temp/
module add cmake-3.6.1
module add cuda-8.0
module add gcc-5.3.0
./marian-decoder   \
  --models model/model.npz.best-translation.npz  \
  --vocabs /storage/plzen1/home/levellj/rawdata/train.bpe.src.yml /storage/plzen1/home/levellj/rawdata/train.bpe.tgt.yml \
  < /storage/plzen1/home/levellj/rawdata/1-1-test_ready.en.data \
  > test.translated-with-model-best_translation

#optimize the output
wget https://raw.githubusercontent.com/moses-smt/mosesdecoder/master/scripts/tokenizer/detokenizer.perl
chmod +x detokenizer.perl

cat test.translated-with-model-best_translation \
| sed 's/@@ //g'  \
| ./detokenizer.perl -u \
> test.translated-with-model-best_translation.detokenized.txt

#Calculate BLEU score
wget https://raw.githubusercontent.com/EdinburghNLP/nematus/master/data/multi-bleu-detok.perl
chmod +x multi-bleu-detok.perl
./multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/projectData/1-1-test_ready.de.data) \
  < test.translated-with-model-best_translation.detokenized.txt


cat test.translated-with-model-best_translation.detokenized.txt | head -10


cat /storage/plzen1/home/levellj/projectData/1-1-test_ready.en.data | head -10

```