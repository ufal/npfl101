  
#!/bin/bash

cat $1 \
    | sed 's/\@\@ //g' \
    | ../../external/moses-scripts/scripts/recaser/detruecase.perl 2> /dev/null \
    | ../../external/moses-scripts/scripts/tokenizer/detokenizer.perl -l en 2>/dev/null \
    | ../../external/moses-scripts/scripts/generic/multi-bleu-detok.perl /storage/plzen1/home/levellj/rawdata/1-1-dev_ready.de.data  \
    | sed -r 's/BLEU = ([0-9.]+),.*/\1/'
