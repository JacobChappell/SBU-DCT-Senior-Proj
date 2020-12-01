Write-Output "Third part:"
$clientPath = Read-Host -Prompt "Enter client name: (ex. TESTCLIENT)"
$clientPath = 'C:\Users\Family\Desktop\TempDCT\' + $clientPath
Write-Host $clientPath
$fpathName = Read-Host -Prompt "Enter file path for the first file: (ex. PracScript.xml)"
$fpathName = $clientPath + '\' + $fpathName
Write-Host $fpathName
$spathName = Read-Host -Prompt "Enter file path for the second file: (ex. DiffPracScript.xml)"
$spathName = $clientPath + '\' + $spathName
Write-Host $spathName
if (Compare-Object -ReferenceObject  $(Get-Content $fpathName) -DifferenceObject $(Get-Content $spathName)) {
    "The files had different contents"
} else {
     "The files were the same"
}

Write-Output " "
$clientPath = Read-Host -Prompt "Enter client name: (ex. Three)"
$clientPath = 'C:\Users\Family\Desktop\TempDCT\' + $clientPath
Write-Host $clientPath
$fpathName = Read-Host -Prompt "Enter file path for the first file: (ex. PracScript.xml)"
$fpathName = $clientPath + '\' + $fpathName
Write-Host $fpathName
$spathName = Read-Host -Prompt "Enter file path for the second file: (ex. EmptyPracScript.xml)"
$spathName = $clientPath + '\' +  $spathName
Write-Host $spathName
if (Compare-Object -ReferenceObject  $(Get-Content $fpathName) -DifferenceObject $(Get-Content $spathName)) {
    "The files had different contents"
} else {
        "The files were the same"
}
