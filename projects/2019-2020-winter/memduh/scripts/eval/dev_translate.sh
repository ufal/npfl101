for problem in tr2en en2tr tr2en_analyzed
do
	mkdir -p translations/default/$problem

	if [ "$problem" = "tr2en"  ] ; then
		dev_file=data/preprocessed/dev.bpe.tr
		src_vocab=data/preprocessed/train.bpe.tr.yml
		tgt_vocab=data/preprocessed/train.bpe.en.yml
	elif [ "$problem" = "en2tr" ] ; then
		dev_file=data/preprocessed/dev.bpe.en
		src_vocab=data/preprocessed/train.bpe.en.yml
		tgt_vocab=data/preprocessed/train.bpe.tr.yml
	elif [ "$problem" = "tr2en_analyzed" ] ; then
		dev_file=data/preprocessed/dev_analyzed.bpe.tr
		src_vocab=data/preprocessed/train_analyzed.bpe.tr.yml
		tgt_vocab=data/preprocessed/train_analyzed.bpe.en.yml
	fi

	for model in `ls models/$problem.iter*.npz`
	do
		iter_count=`echo $model | cut -f2 -d"."`
		translation_path=translations/default/$problem/$iter_count
		if [ ! -f $translation_path ]; then
			bash scripts/eval/translate_job.sh $model $src_vocab $tgt_vocab $dev_file $translation_path 
		fi
	done

	mkdir -p translations/transformer/$problem
	for model in `ls transformer_training/$problem.iter*.npz`
	do
		iter_count=`echo $model | cut -f2 -d"."`
		translation_path=translations/transformer/$problem/$iter_count
		if [ ! -f $translation_path ]; then
			bash scripts/eval/translate_job.sh $model $src_vocab $tgt_vocab $dev_file $translation_path 
		fi
	done
done
