#!/bin/bash

# -------------------------------------------------------------------------
# Author: James Levell
# Date: 2019-12-19
# Version: 1.0
# Comment: Validate script used for marian validation bsed
# Based on: https://github.com/marian-nmt/marian-examples/blob/master/wmt2017-transformer/scripts/validate.sh
# History:	R1	2019-12-19	Levell James	Initial Build
# --------------------------------------------------------------------------

cat $1 \
    | sed 's/\@\@ //g' \
    | ../../external/moses-scripts/scripts/recaser/detruecase.perl 2> /dev/null \
    | ../../external/moses-scripts/scripts/tokenizer/detokenizer.perl -l en 2>/dev/null \
    | ../../external/moses-scripts/scripts/generic/multi-bleu-detok.perl /storage/plzen1/home/levellj/rawdata/1-1-dev_ready.de.data  \
    | sed -r 's/BLEU = ([0-9.]+),.*/\1/'
