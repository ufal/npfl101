# encoding: utf-8

#extracts the sentences of a given file and returns them as stdout put
#Based on: https://pypi.org/project/sentence-splitter/

import sys
import os
import codecs

from concurrent.futures import ThreadPoolExecutor
from sentence_splitter import SentenceSplitter, split_text_into_sentences

##############################################################################
# Functions section
##############################################################################
def split_into_sentences(content, input_language):
    """
        Tasks with takes an input text and splits it into sentence 
        Providing the input_language
    """
    content = " ".join(content)
    sentences = split_text_into_sentences(
            text=content,
            language=input_language
        )

    for sentence in sentences:
        if  sentence:
            print(sentence)
            
##############################################################################
# main
##############################################################################

#ensure encoding
if sys.stdout.encoding != 'UTF-8':
    sys.stdout = codecs.getwriter('utf-8')(sys.stdout.buffer, 'strict')

#get argv
input_file = sys.argv[1]
input_language = sys.argv[2]
executor = ThreadPoolExecutor(max_workers=8)

#open file and give tasks to workers
with open(input_file, mode="r", encoding="utf-8") as file:
    if file.mode == "r":
        temp_lines = file.readlines(4048)
        while temp_lines:
            executor.submit(split_into_sentences(temp_lines, input_language))
            temp_lines = file.readlines(4048)
    else:
        raise Exception("file not accessable")