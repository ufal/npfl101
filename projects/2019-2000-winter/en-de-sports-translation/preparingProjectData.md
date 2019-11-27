# Preparing the project data 

## Tasks
 * Split source file into english and german, verify encoding UTF-8, unix file type
 * Honey file allignment creating parallel corpus
 * Split parralel corpus into train, dev (3000 lines), test (3000 lines) data
 * Focus on the 1-1 sentences, create individual files 1-1-train, 1-1-test, 1-1-dev

```
#verify encoding
vim original.csv -> :set encoding=utf-8

#preprocess the file so the cutting works
csvquote original.csv | cut -d ';' -f2 | csvquote -u > en.txt
csvquote original.csv | cut -d ';' -f3 | csvquote -u  > de.txt

#remove arbitrary quotes
sed -i "s/\\\"//g" de.txt
sed -i "s/\\\"//g" en.txt

#execute the honey allignment
./allignment.perl projectData/en.txt projectData/de.txt > projectData/parallel-corpus.txt

#extract training, test and ev data
numberOfLines=($(wc parallel-corpus.txt))
numberOfLines=${numberOfLines[0]}
numberOfExamples=3000
index=1

sed -n -e "$index,$numberOfExamples p" -e "$numberOfExamples q" parallel-corpus.txt > test.data

index=$(($index + $numberOfExamples))
numberOfExamples=$(($numberOfExamples + $numberOfExamples))
sed -n -e "$index,$numberOfExamples p" -e "$numberOfExamples q" parallel-corpus.txt > dev.data

index=$(($index + $numberOfExamples))
numberOfExamples=$numberOfLines
sed -n -e "$index,$numberOfExamples p" -e "$numberOfExamples q" parallel-corpus.txt > training.data

grep "^1-1" test.data > 1-1-test.data
grep "^1-1" dev.data > 1-1-dev.data
grep "^1-1" training.data > 1-1-training.data

cut -f3 1-1-test.data > 1-1-test_ready.en.data
cut -f3 1-1-dev.data > 1-1-dev_ready.en.data
cut -f3 1-1-training.data > 1-1-training_ready.en.data

cut -f4 1-1-test.data > 1-1-test_ready.de.data
cut -f4 1-1-dev.data > 1-1-dev_ready.de.data
cut -f4 1-1-training.data > 1-1-training_ready.de.data

```