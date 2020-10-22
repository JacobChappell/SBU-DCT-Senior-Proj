Write-Output "Fourth part:"
#lines about checking if table is present
$clientLOB = Read-Host -Prompt "Enter LOB "
$tableLOB = '<table id="Manuscripts' + $clientLOB
Write-Host $tableLOB
$clientPath = Read-Host -Prompt "Enter client name to verfiy there is a table or not (ex. Five)"
$clientPath = 'C:\Users\Family\Desktop\TempDCT\' + $clientPath
Write-Host $clientPath
#$tableFileName = Read-Host -Prompt "Enter the client version (ex. 10_41_0_0)"
#$tableFilePath = $clientPath + '\' + $tableFileName  + '.xml'
$max = ""
Get-ChildItem -Path $clientPath | ForEach-Object {
    if ($max -lt $_.Name) {
        $max = $_.Name
        Write-Host $max
    }
}
$tableFilePath = $clientPath + "\" + $max
Write-Host $tableFilePath
#$ftableFileName = Read-Host -Prompt "Enter the first client version: (ex. PracTable.xml)"
#$ftableFilePath = $clientPath + '\' + $ftableFileName
#Write-Host $ftableFilePath
#$stableFileName = Read-Host -Prompt "Enter the second client version: (ex. PracNewTable.xml)"
#$stableFilePath = $clientPath + '\' + $stableFileName
#Write-Host $stableFilePath
#try {
$tableLine = Get-ChildItem -Path $tableFilePath | Select-String -Pattern $tableLOB -Quiet
Write-Host $tableLine
#$ftableLine = Get-ChildItem -Path $ftableFilePath -ErrorAction stop | Select-String ($tableLOB + '*') -Quiet
#Write-Host $ftableLine
#$stableLine = Get-ChildItem -Path $stableFilePath -ErrorAction stop | Select-String ($tableLOB + '*') -Quiet
#Write-Host $stableLine
#} catch [System.Exception] {
#Write-Host "An error occured "
#Write-Host $_
#}
#$tableLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\PracTable.xml | Select-String -Pattern $tableLOB
#if there or not {
$max = $max.Replace(".xml", "")
Write-Output $max
Write-Output " "
if ($tableLine) {
$compareString = ""
$ifTrue = "False"
#$XMLFile = 'C:\Users\Family\Desktop\TempDCT\PracTable.xml'
#$XMLFile = $ftableLine
[XML]$tableData = Get-Content $tableFilePath
foreach($empDetail in $tableData.table.data.row) {
    #Write-Output $empDetail.value
    $compareString = $empDetail.value
    #Write-Host $empDetail.value
    if ($empDetail.value.Contains($max)) {
        $ifTrue = "True"
        break
    }
}
if ($ifTrue -eq "True") {
    Write-Host "Manuscript table was successfully updated"
} else {
    Write-Host "Manuscript table failed to update successfully"
}
#$compareString2 = ""
#$XMLFile2 = 'C:\Users\Family\Desktop\TempDCT\PracNewTable.xml'
#$XMLFile2 = $stableLine
#[XML]$newTableData = Get-Content $XMLFile2
#foreach($empDetail2 in $newTableData.table.data.row){
    #Write-Output $empDetail2.value
#    $compareString2 += $empDetail2.value
#}
#$compareString.Equals(('*' + $clientLOB + '*' + $tableFileName + ;'*'))
} else {
    Write-Host "No table present"
}

#Write-Output " "
#if ($tableLine -eq $true) {
#$compareString = ""
#$XMLFile = 'C:\Users\Family\Desktop\TempDCT\PracTable.xml'
#$XMLFile = $ftableLine
#[XML]$tableData = Get-Content $XMLFile
#foreach($empDetail in $tableData.table.data.row){
    #Write-Output $empDetail.value
#    $compareString += $empDetail.value
#}
#Write-Output " "

#$compareString2 = ""
#$XMLFile2 = 'C:\Users\Family\Desktop\TempDCT\CopyPracTable.xml'
#$XMLFile2 = $stableLine
#[XML]$newTableData = Get-Content $XMLFile2
#foreach($empDetail2 in $newTableData.table.data.row){
    #Write-Output $empDetail2.value
#    $compareString2 += $empDetail2.value
#}
#$compareString.Equals($compareString2)
#} else {
#    Write-Host "No table present"
#}
