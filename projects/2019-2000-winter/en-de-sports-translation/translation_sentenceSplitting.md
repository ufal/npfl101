# Translation using the model

```
# request computing power
qsub -q gpu -l select=1:ncpus=2:ngpus=1:mem=1gb:cl_doom=True -l walltime=1:00:00 -I

module add cuda-8.0
export TMP=/storage/plzen1/home/levellj/temp/

########################################################################################################
#sentence level translation
########################################################################################################
./marian-decoder   \
  --models model_sentence/model.npz.best-bleu-detok.npz  \
  --vocabs model_sentence/vocab.en.spm model_sentence/vocab.de.spm \
  < /storage/plzen1/home/levellj/projectData_sentence/test_1_1.en \
  > model_sentence/test.translated-with-model-best_bleu

# optimize the output
wget https://raw.githubusercontent.com/moses-smt/mosesdecoder/master/scripts/tokenizer/detokenizer.perl
chmod +x detokenizer.perl

cat model_sentence/test.translated-with-model-best_bleu \
| sed 's/@@ //g'  \
| ./detokenizer.perl -u \
> model_sentence/test.translated-with-model-best_bleu.detokenized.txt

# Calculate BLEU score
wget https://raw.githubusercontent.com/EdinburghNLP/nematus/master/data/multi-bleu-detok.perl
chmod +x multi-bleu-detok.perl
./multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/projectData_sentence/test_1_1.de) \
  < model_sentence/test.translated-with-model-best_bleu.detokenized.txt

# verify output
paste model_sentence/test.translated-with-model-best_bleu.detokenized.txt /storage/plzen1/home/levellj/projectData_sentence/test_1_1.de /storage/plzen1/home/levellj/projectData_sentence/test_1_1.en /dev/null | tr '\t' '\n' | tail -12

########################################################################################################
#document level translation
########################################################################################################
./marian-decoder   \
  --models model_document/model.npz.best-bleu-detok.npz  \
  --vocabs model_document/vocab.en.spm model_document/vocab.de.spm \
  < /storage/plzen1/home/levellj/projectData_document/test.en \
  > model_document/test.translated-with-model-best_bleu

# optimize the output
wget https://raw.githubusercontent.com/moses-smt/mosesdecoder/master/scripts/tokenizer/detokenizer.perl
chmod +x detokenizer.perl

cat model_document/test.translated-with-model-best_bleu \
| sed 's/@@ //g'  \
| ./detokenizer.perl -u \
> model_document/test.translated-with-model-best_bleu.detokenized.txt

# Calculate BLEU score
wget https://raw.githubusercontent.com/EdinburghNLP/nematus/master/data/multi-bleu-detok.perl
chmod +x multi-bleu-detok.perl
./multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/projectData_document/test.de) \
  < model_document/test.translated-with-model-best_bleu.detokenized.txt

# verify output
paste model_document/test.translated-with-model-best_bleu.detokenized.txt /storage/plzen1/home/levellj/projectData_document/test.de /storage/plzen1/home/levellj/projectData_document/test.en /dev/null | tr '\t' '\n' | tail -12
```