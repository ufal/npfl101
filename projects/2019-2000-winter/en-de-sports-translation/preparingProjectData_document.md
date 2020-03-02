# Preparing and polish the data: Document level - without sentence splitting
Goal prepare the received document into dev, training and test sets for both German and English.  
The articles are left as they are and are not split by sentences.  
Therefore we can compare the translation performance on articel level to the sentence level translation. 

## Tasks
 * Split source file into dev, training and test (verify encoding UTF-8, unix file type)
 * Split document into the indivdual lanaguges (dev.en, dev.de and test.en, test.de and training.en, traning.de) 

## Code
```
# change delimeter to ;
#execute powershell script [prepareProjectData.ps1] to ensure encoding and line breaks

# migrate to unix file ending
dos2unix original.csv 

# extract training, test and ev data
numberOfLines=($(wc original.csv))
numberOfLines=${numberOfLines[0]}
numberOfExamples=3000
index=1

sed -n -e "$index,$numberOfExamples p" -e "$numberOfExamples q" original.csv > test.csv

index=$(($index + $numberOfExamples))
numberOfExamples=$(($numberOfExamples + $numberOfExamples))
sed -n -e "$index,$numberOfExamples p" -e "$numberOfExamples q" original.csv > dev.csv

index=$(($index + $numberOfExamples))
numberOfExamples=$numberOfLines
sed -n -e "$index,$numberOfExamples p" -e "$numberOfExamples q" original.csv > training.csv

#split the dev, traning and test set into the individual language, use csvquote to ensure correct splitting
csvquote dev.csv | cut -d ';' -f2 | csvquote -u > dev.en
csvquote dev.csv | cut -d ';' -f3 | csvquote -u > dev.de

csvquote test.csv | cut -d ';' -f2 | csvquote -u > test.en
csvquote test.csv | cut -d ';' -f3 | csvquote -u  > test.de

csvquote training.csv | cut -d ';' -f2 | csvquote -u > training.en
csvquote training.csv | cut -d ';' -f3 | csvquote -u > training.de

# remove arbitrary quotes
sed -i "s/\\\"//g" dev.en
sed -i "s/\\\"//g" dev.de
sed -i "s/\\\"//g" test.en
sed -i "s/\\\"//g" test.de
sed -i "s/\\\"//g" training.en
sed -i "s/\\\"//g" training.de

# ensure the quality of the data
paste training.de training.en /dev/null | tr '\t' '\n' | tail -12
wc dev.en dev.de
wc test.en test.de
wc training.en training.de
```