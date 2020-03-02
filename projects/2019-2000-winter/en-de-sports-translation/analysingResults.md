# Verifying the result of the translation 
The goal is to compare the newly created marian translation model with publicly available translators like Google translator and Deepl.  
To compare the results of each translation we are calculating the BLEU values for each translation.  The results are split for the document level and the sentence level translation.  

## Generating BLEU values for documents translated on a document level  
For the following translations the whole document was used as input.  

### Marian translation
```
external/multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/bleu/document/original_de.txt) \
  < /storage/plzen1/home/levellj/bleu/document/marian.txt

# Resulting BLEU value  
BLEU = 25.98, 62.3/35.3/23.3/16.1 (BP=0.863, ratio=0.871, hyp_len=122077, ref_len=140105)
```

### Google translation
```
external/multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/bleu/document/original_de.txt) \
  < /storage/plzen1/home/levellj/bleu/document/google.txt
  
# Resulting BLEU value
BLEU = 25.59, 59.6/31.0/19.1/12.4 (BP=0.996, ratio=0.996, hyp_len=139506, ref_len=140105)
```

### Deepl translation
```
external/multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/bleu/document/original_de.txt) \
  < /storage/plzen1/home/levellj/bleu/document/deepl.txt
  
# Resulting BLEU value
BLEU = 36.34, 65.8/42.0/30.1/22.4 (BP=0.984, ratio=0.984, hyp_len=137888, ref_len=140105)
```

## generating bleu values for document translated on a sentence level
For the following translations the only one sentence was used as input.  

### Marian translation
```
external/multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/bleu/sentence/original_de.txt) \
  < /storage/plzen1/home/levellj/bleu/sentence/marian.txt

# Resulting BLEU value  
BLEU = 28.74, 61.9/36.4/24.8/17.6 (BP=0.912, ratio=0.916, hyp_len=107783, ref_len=117662)
```

### Google tranlation
```
external/multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/bleu/sentence/original_de.txt) \
  < /storage/plzen1/home/levellj/bleu/sentence/google.txt
  
# Resulting BLEU value
BLEU = 26.02, 58.4/31.1/19.6/12.9 (BP=1.000, ratio=1.012, hyp_len=119038, ref_len=117662)
```

### Deepl translation
```
external/multi-bleu-detok.perl \
  <(cat /storage/plzen1/home/levellj/bleu/sentence/original_de.txt) \
  < /storage/plzen1/home/levellj/bleu/sentence/deepl.txt
  
# Resulting BLEU value
BLEU = 37.49, 64.9/42.3/30.9/23.3 (BP=1.000, ratio=1.000, hyp_len=117631, ref_len=117662)
```

## Conclusion 
The following conclusions can be made on the above BLEU values. 
* Our domain specifically created translation model performs better than Google Translator 
* Best translator over all is Deepl
* To reach a better performance of the translation we should always consider sentence level translation. 