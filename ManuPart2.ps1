Write-Output "Second part:"
#for the first part we are working under the assumption the master script always puts the first line there, and our encoding check is based off of that
$noEncodingLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\*.xml | Where-Object {!($_ | Select-String 'encoding="utf-8' -Quiet) }
$encodingLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\*.xml | Select-String -Pattern 'encoding="utf-8"'
if ($encodingLine -eq $null) {
    "No utf-8 encoding lines found"
} else {
    "Utf-8 encoding line found in the following files: "
    $encodingLine | foreach {$_.FileName}
    Write-Output " "
    "No encoding line found in the following files: "
    $noEncodingLine | foreach {$_.Name}

}