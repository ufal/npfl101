# -------------------------------------------------------------------------
# Author: James Levell
# Date: 2020-01-09
# Version: 1.0
# Comment: based on two documents (one contains the articles, one contains the sentence splitted articles) matches the sentence to the corresponding article
# History:	R1	2020-01-09	Levell James	Initial Build
# --------------------------------------------------------------------------

# Configuration area
$articleDocument = Get-Content -Path "C:\Users\jimmy\OneDrive\Dokumente\Schule\Studium\_Semester7\Competing Machine Learning\bleu\document\original_de.txt" -Encoding UTF8
$sentenceDocument = Get-Content -Path "C:\Users\jimmy\OneDrive\Dokumente\Schule\Studium\_Semester7\Competing Machine Learning\bleu\sentence\original_de.txt" -encoding UTF8
$articleID = 0
$sentenceID = 0
$result = @()

# iterate through the article and compare it to each sentence if they are present in the article. If no continue to next article
foreach($article in $articleDocument)
{
    $sentence = $sentenceDocument[$sentenceID]
    while($article -match [regex]::escape($sentence))
    {
        # the sentence is found in the article so output article id
        Write-Host $articleID

        # go to next sentence
        $sentenceID++
        $sentence = $sentenceDocument[$sentenceID]
    }

    # process next article
    $articleID++
}