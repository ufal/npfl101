export LC_ALL=en_US

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

mkdir -p results
if [ ! -f results/tr2en.txt ]; then
	for file in `ls -v translations/tr2en/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.en < translations/tr2en/postproc/$file`
		echo $file - $result >> results/tr2en.txt
	done
fi

if [ ! -f results/tr2en_analyzed.txt ]; then
	for file in `ls -v translations/tr2en_analyzed/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.en < translations/tr2en_analyzed/postproc/$file`
		echo $file - $result >> results/tr2en_analyzed.txt
	done
fi

if [ ! -f results/en2tr.txt ]; then
	for file in `ls -v translations/en2tr/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.tr < translations/en2tr/postproc/$file`
		echo $file - $result >> results/en2tr.txt
	done
fi
