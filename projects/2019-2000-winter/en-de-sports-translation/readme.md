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

## Preparing the project data
Documentation can be found [here](preparingProjectData.md)

## Creating the translation model
### Creating the training model using BPE 
Documentation can be found [here](bpe.md)

### Creating the training model using marian sentence splitting
Documentation can be found [here](marian_sentencesplitting.md)

# Translation using the model
Documentation can be found [here](translation.md)

# Further resources 
* Subword to learn and apply BPE: https://github.com/rsennrich/subword-nmt
* Marian documentation for sentence piece: https://github.com/marian-nmt/marian-examples/tree/master/training-basics-sentencepiece

# Working questions
- Implement the marian sentence splitter
- marian-decode on every model and generate BLEU score
- use the highest score model on test set and report that number