Write-Host "Fourth part:"
#lines about checking if table is present
$clientLOB = Read-Host -Prompt "Enter LOB "
$tableLOB = '<table id="Manuscripts' + $clientLOB
$clientName = Read-Host -Prompt "Enter client name to verfiy there is a table or not (ex. Five)"
$version = Read-Host -Prompt "Enter version Number (ex. 10_X_X_X)"
$clientPath = "C:\Users\ebpag\Desktop\DuckCreek\$clientName\$clientLOB"
$fileName = "Carrier_" +$clientLOB + "_Product_*.xml"
$ifTrue = "False"

#Determine path of newest version
function newestPath($clPath){
    $newestPath = ""
    Get-ChildItem -Path $clPath | ForEach{
        if($_.Name -gt $newestPath){
            $newestPath = $_.FullName
        }
    }
    return $newestPath
}

Get-ChildItem -Path $clientPath | ForEach{
    Write-Host $_.Name
    $old = $_.FullName+"\$fileName"
    $newPath = newestPath($old)

    #check for valid product file
    if($newPath -ne ""){
        #check for valid table
        $tableLine = Get-ChildItem -Path $newPath | Select-String -Pattern $tableLOB -Quiet
        if ($tableLine) {
            [XML]$tableData = Get-Content $newPath
            #iterate through xml file
            foreach($empDetail in $tableData.manuscript.model.object.table) {
                $tableName = $empDetail.id
                $targetName = "Manuscripts"+$clientLOB
                #look for table with correct name
                if($tableName -eq $targetName){
                    #stop and set flag true if valid version numbers found in table
                    $compareString = $empDetail.data.row.value
                    if ($compareString -Match $version ) {
                        $ifTrue = "True"
                        break
                    }
                }
            }
            #output results of comparison
            if ($ifTrue -eq "True") {
                Write-Host "Manuscript table was successfully updated"
                Write-Host " "
            } else {
                Write-Host "Manuscript table failed to update successfully" -ForegroundColor Red
                Write-Host " "
            }
        } else {
            Write-Host "No table present" -ForegroundColor Red
        }
    }else{
        #no product file found
        Write-Host "No product file found" -ForegroundColor Red
    }
}
