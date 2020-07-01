mkdir -p data/tokenized
for file in dev.en dev_analyzed.tr test.tr train.tr train_analyzed.tr dev.tr test.en test_analyzed.tr train.en train_analyzed.en
do
	if [ ! -f data/tokenized/$file ]; then
		cat data/$file | perl ~/mosesdecoder/scripts/tokenizer/tokenizer.perl > data/tokenized/$file
	fi
done


num_operations=32000
base_bpe=data/base_codes
morph_bpe=data/morph_codes

mkdir -p data/preprocessed

segment () { # $1 codes $£2 vocabulary $3 fname
	suffix=`echo $3 | cut -f2 -d "."`
	bpe_fname=`echo $3 | cut -f1 -d "."`
	bpe_fname=$bpe_fname.bpe.$suffix
	bpe_path=data/preprocessed/$bpe_fname
	if [ ! -f $bpe_path ]; then
		python subword-nmt/apply_bpe.py -c $1 --vocabulary $2 --vocabulary-threshold 50 < data/tokenized/$3 > $bpe_path
	fi
}

# Create the BPE-segmented training, test and dev files if they don't exist

for file in dev.en test.en train.en
do
	segment $base_bpe data/base_vocab.en $file
done

for file in test.tr train.tr dev.tr 
do
	segment $base_bpe data/base_vocab.tr $file
done

for file in dev_analyzed.tr train_analyzed.tr test_analyzed.tr 
do
	segment $morph_bpe data/morph_vocab.tr $file
done

segment $morph_bpe data/morph_vocab.en train_analyzed.en
