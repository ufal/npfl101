export LC_ALL=en_US

if [ ! -f scripts/detokenizer.perl ]; then
wget https://raw.githubusercontent.com/moses-smt/mosesdecoder/master/scripts/tokenizer/detokenizer.perl -P scripts
fi

if [ ! -f scripts/multi-bleu-detok.perl ]; then
wget https://raw.githubusercontent.com/EdinburghNLP/nematus/master/data/multi-bleu-detok.perl -P scripts
fi

for model in `ls translations` 
do
	for direction in `ls translations/$model`
	do
		postproc=translations/$model/$direction/postproc
		mkdir -p $postproc
		for file in `ls translations/$model/$direction`
		do
			if [ ! -f $postproc/$file ]; then
			cat translations/$model/$direction/$file \
				| sed 's/@@ //g'  \
				| perl scripts/detokenizer.perl -u \
				> $postproc/$file
			fi
		done
	done
done

mkdir -p results/default results/transformer
if [ ! -f results/default/tr2en.txt ]; then
	for file in `ls -v translations/default/tr2en/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.en < translations/default/tr2en/postproc/$file`
		echo $file - $result >> results/default/tr2en.txt
	done
fi

if [ ! -f results/default/tr2en_analyzed.txt ]; then
	for file in `ls -v translations/default/tr2en_analyzed/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.en < translations/default/tr2en_analyzed/postproc/$file`
		echo $file - $result >> results/default/tr2en_analyzed.txt
	done
fi

if [ ! -f results/default/en2tr.txt ]; then
	for file in `ls -v translations/default/en2tr/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.tr < translations/default/en2tr/postproc/$file`
		echo $file - $result >> results/default/en2tr.txt
	done
fi

if [ ! -f results/transformer/tr2en.txt ]; then
	for file in `ls -v translations/transformer/tr2en/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.en < translations/transformer/tr2en/postproc/$file`
		echo $file - $result >> results/transformer/tr2en.txt
	done
fi

if [ ! -f results/transformer/tr2en_analyzed.txt ]; then
	for file in `ls -v translations/transformer/tr2en_analyzed/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.en < translations/transformer/tr2en_analyzed/postproc/$file`
		echo $file - $result >> results/transformer/tr2en_analyzed.txt
	done
fi

if [ ! -f results/transformer/en2tr.txt ]; then
	for file in `ls -v translations/transformer/en2tr/postproc`
	do
		result=`perl scripts/multi-bleu-detok.perl data/dev.tr < translations/transformer/en2tr/postproc/$file`
		echo $file - $result >> results/transformer/en2tr.txt
	done
fi
