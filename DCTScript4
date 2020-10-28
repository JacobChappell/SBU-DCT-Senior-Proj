Write-Output "Fourth part:"
#lines about checking if table is present
$clientLOB = Read-Host -Prompt "Enter LOB (ex. DuckCreekTech) "
$clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
$clientLOBName = Read-Host -Prompt "Enter client's LOB folder (ex. property) "
$clientPath = 'C:\SaaS\' + $clientName + '\Policy\ManuScripts\DCTTemplates\' + $clientLOBName
$fileName = $clientLOB + "_Product*"
$versionNum = Read-Host -Prompt "Enter version number (ex. 00_41) "

function newestPath($clPath){
    $newestPath = ""
    Get-ChildItem -Path $clPath | ForEach{
        if ($_.Name -gt $newestPath){
            $newestPath = $_.FullName
        }
    }
    Write-Host $newestPath
    return $newestPath
}

Get-ChildItem -Path $clientPath | ForEach{
    $old = $_.FullName+"\$fileName"
    $newPath = newestPath($old)
    if ($newPath -eq ""){
        Write-Host "**********************"
        Write-Host "No valid version found in $_"
        Write-Host "**********************"
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
                Write-Output $_.Name
                Write-Host "Manuscript table was successfully updated"
            } else {
                Write-Host "**********************"
                Write-Output $_.Name
                Write-Host "Manuscript table failed to update successfully"
                Write-Host "**********************"
            }
        } else {
            Write-Host "**********************"
            Write-Output $_.Name
            Write-Host "No table present"
            Write-Host "**********************"
        }
    }
}
