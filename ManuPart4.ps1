Write-Output "Fourth part:"
#lines about checking if table is present
$clientLOB = Read-Host -Prompt "Enter LOB "
$tableLOB = '<table id="Manuscripts' + $clientLOB
Write-Host $tableLOB
$clientName = Read-Host -Prompt "Enter client name to verfiy there is a table or not (ex. Five)"
$clientPath = 'C:\Users\Family\Desktop\TempDCT\' + $clientName + '\*'
Write-Host $clientPath
$fileName = $clientLOB + "_Product*.xml"
$versionNum = Read-Host -Prompt "Enter version number (ex. 10_41_10_0) "
#$tableFilePath = $clientPath + "\" + $max
#Write-Host $tableFilePath
#$tableLine = Get-ChildItem -Path $tableFilePath | Select-String -Pattern $tableLOB -Quiet
#Write-Host $tableLine

function newestPath($clPath){
    $newestPath = ""
    Get-ChildItem -Path $clPath | ForEach{
        if ($_.Name -gt $newestPath){
            $newestPath = $_.FullName
        }
    }
    return $newestPath
}

Get-ChildItem -Path $clientPath | ForEach{
    Write-Output $_.Name
    $old = $_.FullName+"\$fileName"
    $newPath = newestPath($old)
    if ($newPath -eq ""){
        Write-Host "NewPath: No valid version found"
    } else{
        $tableLine = Get-ChildItem -Path $newPath | Select-String -Pattern $tableLOB -Quiet
        if ($tableLine) {
            $compareString = ""
            $ifTrue = "False"
            [XML]$tableData = Get-Content $newPath
            foreach($empDetail in $tableData.table.data.row) {
                $compareString = $empDetail.value
                if ($empDetail.value.Contains($versionNum)) {
                    $ifTrue = "True"
                    break
                }
            }
            if ($ifTrue -eq "True") {
                Write-Host "Manuscript table was successfully updated"
            } else {
                Write-Host "Manuscript table failed to update successfully"
            }
        } else {
            Write-Host "No table present"
        }
    }
}

#$max = $max.Replace(".xml", "")
#Write-Output $max
#Write-Output " "
#$tableLine = Get-ChildItem -Path $newestPath | Select-String -Pattern $tableLOB -Quiet
#if ($tableLine) {
#    $compareString = ""
#    $ifTrue = "False"
#    [XML]$tableData = Get-Content $tableFilePath
#    foreach($empDetail in $tableData.table.data.row) {
#        $compareString = $empDetail.value
#        if ($empDetail.value.Contains($max)) {
#            $ifTrue = "True"
#            break
#        }
#    }
#    if ($ifTrue -eq "True") {
#        Write-Host "Manuscript table was successfully updated"
#    } else {
#        Write-Host "Manuscript table failed to update successfully"
#    }
#} else {
#    Write-Host "No table present"
#}
