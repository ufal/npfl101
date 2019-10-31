# Evaluation/Improvement of Turkish MT Models trained on spoken sentences.

## Data
The data will come from three sources:
* Gather all English-Turkish and Turkish monolingual corpora possible
* Edinburgh University data (37-37 data from Daniel)
* Czech-English interpretation data, which I will put through MT into Turkish and post-edit the output (wait until stable)
* WMT news task corpora - this will be used for evaluation

## Training Process
I will train a pairwise translation system on the Edinburgh data, and monitor its improvement as I fix the generated data etc.
* Use a morphological analyzer before input
* Use backtranslation, with a model that simplifies the backtranslated Turkish
