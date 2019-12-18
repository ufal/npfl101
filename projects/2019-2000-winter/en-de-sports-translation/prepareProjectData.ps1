$content = Import-Csv -Path "C:\Users\jimmy\OneDrive\Dokumente\Schule\Studium\_Semester7\Competing Machine Learning\original.csv" -Delimiter ";" -Encoding UTF8

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