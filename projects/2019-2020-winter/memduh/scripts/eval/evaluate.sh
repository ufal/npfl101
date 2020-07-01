if [ ! -f scripts/detokenizer.perl ]; then
wget https://raw.githubusercontent.com/moses-smt/mosesdecoder/master/scripts/tokenizer/detokenizer.perl -P scripts
fi

if [ ! -f scripts/multi-bleu-detok.perl ]; then
wget https://raw.githubusercontent.com/EdinburghNLP/nematus/master/data/multi-bleu-detok.perl -P scripts
fi

for direction in `ls translations` 
do
	postproc=translations/$direction/postproc
	mkdir -p $postproc
	for file in `ls translations/$direction`
	do
		if [ ! -f $postproc/$file ]; then
		cat translations/$direction/$file \
			| sed 's/@@ //g'  \
			| perl scripts/detokenizer.perl -u \
			> $postproc/$file
		fi
	done
done


