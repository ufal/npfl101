# -------------------------------------------------------------------------
# Author: James Levell
# Date: 2019-12-19
# Version: 1.0
# Comment: Given a source file, iterats through the lines and removes inline CRLF 
# History:	R1	2019-12-19	Levell James	Initial Build
# --------------------------------------------------------------------------

$sourceFile = "<please define me>"
$content = Import-Csv -Path $sourceFile -Delimiter ";" -Encoding UTF8

foreach($line in $content)
{
    if($line.en)
    {
        $line.en = $line.en.replace("`n", " ")

        if($line.en[0] -eq " ")
        {
            $line.en = $line.en.substring(1, $line.en.Length - 1)
        }
    }

    if($line.de)
    {
        $line.de = $line.de.replace("`n", " ")

        if($line.de[0] -eq " ")
        {
            $line.de = $line.de.substring(1, $line.de.Length - 1)
        }
    }
}

$content | Export-Csv -Path "C:\Users\jimmy\OneDrive\Dokumente\Schule\Studium\_Semester7\Competing Machine Learning\original_modified.csv" -Delimiter ";" -Encoding UTF8 -NoTypeInformation