## Translation using the model (with sentence splitting) and evaluating the result

```
#request computing power
qsub -q gpu -l select=1:ncpus=2:ngpus=1:mem=1gb:cl_doom=True -l walltime=1:00:00 -I

#translate using the model 
module add cuda-8.0
export TMP=/storage/plzen1/home/levellj/temp/

./marian-decoder   \
  --models model_old/model.npz.best-bleu-detok.npz  \
  --vocabs model_old/vocab.en.spm model/vocab.de.spm \
  < /storage/plzen1/home/levellj/rawdata/1-1-test_ready.en.data \
  > model/test.translated-with-model-best_bleu

#optimize the output
wget https://raw.githubusercontent.com/moses-smt/mosesdecoder/master/scripts/tokenizer/detokenizer.perl
chmod +x detokenizer.perl

cat model/test.translated-with-model-best_bleu \
| sed 's/@@ //g'  \
| ./detokenizer.perl -u \
> model_old/test.translated-with-model-best_bleu.detokenized.txt

#Calculate BLEU score
wget https://raw.githubusercontent.com/EdinburghNLP/nematus/master/data/multi-bleu-detok.perl
chmod +x multi-bleu-detok.perl
./multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/projectData/1-1-test_ready.de.data) \
  < model/test.translated-with-model-best_bleu.detokenized.txt


cat model/test.translated-with-model-best_bleu.detokenized.txt | head -10



cat /storage/plzen1/home/levellj/projectData/1-1-test_ready.en.data | head -10

```