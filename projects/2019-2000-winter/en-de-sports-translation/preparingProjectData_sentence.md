# Preparing and polish the data: Sentence level - with sentence splitting

## Tasks
 * This task is based on the document level files (dev.en.txt, dev.de.txt and test.en.txt, test.de.txt and training.en.txt, training.de.txt) generated using [this](preparingProjectData_document.md) manual
 * Split all of these documents by sentences into dev_sentence.en, dev_sentence.de and test_sentence.en, test_sentence.de and training_sentence.en, traning_sentence.de
 * Execute honey alignment on the sets to generate parallel_corpus.dev, parallel_corpus.test, parallel_corpus.training
 * Extract the 1-1 matches of the sentnces to get dev_1_1.en, dev_1_1.de and test_1_1.en, test_1_1.de and training_1_1.en, traning_1_1.de

```
# sentence splitting (one sentence per line)
../external/sentencesplitter.py dev.en.txt en > dev_sentence.en.txt
../external/sentencesplitter.py dev.de.txt de > dev_sentence.de.txt

../external/sentencesplitter.py test.en.txt en > test_sentence.en.txt
../external/sentencesplitter.py test.de.txt de > test_sentence.de.txt

../external/sentencesplitter.py training.en.txt en > training_sentence.en.txt
../external/sentencesplitter.py training.de.txt de > training_sentence.de.txt

# execute the honey allignment and only store the 1-1 matches 
../external/allignment.perl dev_sentence.en.txt dev_sentence.de.txt | grep "^1-1"  > parallel_corpus_1_1.dev
../external/allignment.perl test_sentence.en.txt test_sentence.de.txt | grep "^1-1"  > parallel-corpus_1_1.test
../external/allignment.perl training_sentence.en.txt training_sentence.de.txt | grep "^1-1"  > parallel-corpus_1_1.training

# extract the 1-1 matches
cut -f3 parallel_corpus_1_1.dev > dev_1_1.en
cut -f3 parallel-corpus_1_1.test > test_1_1.en
cut -f3 parallel-corpus_1_1.training > training_1_1.en

cut -f4 parallel_corpus_1_1.dev > dev_1_1.de
cut -f4 parallel-corpus_1_1.test > test_1_1.de
cut -f4 parallel-corpus_1_1.training > training_1_1.de

# verify the quality 
paste dev_1_1.de dev_1_1.en /dev/null | tr '\t' '\n' | tail -12
wc dev_1_1.en dev_1_1.de
wc test_1_1.de test_1_1.en
wc training_1_1.de training_1_1.en
``` 