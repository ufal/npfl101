mkdir -p data/tokenized
for file in turkish_mono.tr english_mono.en tr_mono_analyzed.tr
do
	if [ ! -f data/tokenized/$file ]; then
		cat data/$file | perl ~/mosesdecoder/scripts/tokenizer/tokenizer.perl > data/tokenized/$file
	fi
done


num_operations=32000
base_bpe=data/base_codes
morph_bpe=data/morph_codes

# Create the BPE-segmented training, test and dev files if they don't exist
mkdir -p data/preprocessed
if [ ! -f data/preprocessed/turkish_mono.bpe.tr ]; then
	python subword-nmt/apply_bpe.py -c $base_bpe --vocabulary data/base_vocab.tr --vocabulary-threshold 50 < data/tokenized/turkish_mono.tr > data/preprocessed/turkish_mono.bpe.tr
fi

if [ ! -f data/preprocessed/english_mono.bpe.en ]; then
	python subword-nmt/apply_bpe.py -c $base_bpe --vocabulary data/base_vocab.en --vocabulary-threshold 50 < data/tokenized/english_mono.en > data/preprocessed/english_mono.bpe.en
fi

if [ ! -f data/preprocessed/tr_mono_analyzed.bpe.tr ]; then
	python subword-nmt/apply_bpe.py -c $morph_bpe --vocabulary data/morph_vocab.tr --vocabulary-threshold 50 < data/tokenized/tr_mono_analyzed.tr > data/preprocessed/tr_mono_analyzed.bpe.tr
fi

cd data/augment/english  
if [ ! -f xaa ]; then
split -l 20000 ../../preprocessed/english_mono.bpe.en
fi
cd ../morph_turkish
if [ ! -f xaa ]; then
split -l 20000 ../../preprocessed/tr_mono_analyzed.bpe.tr
fi
cd ../turkish
if [ ! -f xaa ]; then
split -l 20000 ../../preprocessed/turkish_mono.bpe.tr
fi

