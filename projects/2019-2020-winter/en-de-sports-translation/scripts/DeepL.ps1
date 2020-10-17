# -------------------------------------------------------------------------
# Author: James Levell
# Date: 2020-01-06
# Version: 1.0
# Comment: Given a source language file, translate the content using the deepl API
# Requires: developer deepl API subscription 
# History:	R1	2020-01-06	Levell James	Initial Build
# --------------------------------------------------------------------------

# configuration section
$file = "<please provide path to source lanaguage file>"
$exportFile = $file + "_translated"
$key = "<please provide deepl key>"
$server = "https://api.deepl.com/v2/translate"

$lines = Get-Content -Path $file -Encoding UTF8
$output = @()

#get each line and get the corresponding translation
foreach($line in $lines)
{
    try
    {
        $result = Invoke-RestMethod -Uri $server -Method POST -Body @{
            auth_key = $key
            text = $line
            target_lang="DE"
        }
    }
    catch 
    {
        Write-Error "Deepl api returned not an 200 return code. Please verify"
        Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
        Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription

        exit
    }

    $bytes = [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetBytes($result.translations.text)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    $output+= $text

    #to know where we are in the translation
    Write-Host $line
}

#export the file
Set-Content -Encoding UTF8 -Value $output -Path $exportFile