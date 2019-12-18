# en-de-sports-translation
## General information
Author: James Levell (leveljam@students.zhaw.ch)  

## Project setup 
The Company would like to provide their sports results also in other languages. This translation should be be provided automized.  
The origin of the text is in english and should than be automatically translated. In this part of the projcet we are focusing only on the english - german translation. 

## Project goal  
* Provide an automatic translation for sport news texts provided in english.  
* Provide a report of the quality of the translation  

## Data Sources for the translation model
 * http://www.statmt.org/wmt19/translation-task.html

# Implementation
The implementation has two main parts: 
* first preparing the received data
* secondly creating the translation model. The translation model was implemented in to different ways using BPE and using the integrated sentence splitting of marian.  

## Preparing the project data without sentence splitting
Documentation can be found [here](preparingProjectData_document.md)

## Preparing the project data with sentence splitting
Documentation can be found [here](preparingProjectData_sentence.md)

## Creating the translation model
### Creating the training model using BPE 
Documentation can be found [here](bpe.md)

### Creating the training model using marian sentence splitting
Documentation can be found [here](marian_sentencesplitting.md)

# Translation using the model
Documentation can be found for the BPE example [here](translation_bpe.md)
Documentation can be found for the sentence splitting example [here](translation_sentenceSplitting.md)

# Further resources 
* Subword to learn and apply BPE: https://github.com/rsennrich/subword-nmt
* Marian documentation for sentence piece: https://github.com/marian-nmt/marian-examples/tree/master/training-basics-sentencepiece

# Working questions
## BPE 
- cat corpus into qruncmd "generate dictionary bpe" | learn-bpe
   38  cat clip | tr ' ' '\n' | sort | uniq -c | sort -r -n
   39  cat clip | tr ' ' '\n' | sort | uniq -c | sort  -n
   40  cat clip | qruncmd --jobs=2 "tr ' ' '\n' | sort | uniq -c | sort  -n"
   41  cat clip | ./qruncmd --jobs=2 "tr ' ' '\n' | sort | uniq -c | sort  -n"

## Other
- get the model at AI working

# Questions
## project data 
* created corpus with documents
* created corpus with sentence (used sentence splitter within python and in parallell)

## Marian sentence splitting
### document level 
* running

### sentence level 
* running 

## Othery
### marian on longest sentences 
https://github.com/google/sentencepiece/blob/master/src/trainer_interface.cc

### workspace space 
The working space is now set to: workspace 13024