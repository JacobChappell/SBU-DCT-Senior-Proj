Write-Host "Fourth part:"
#This script will iterate through a file structure, find the newest version 
#of a product file (if any) and verify manuscripts table values

#Prompt user input and create pathing variables
$clientName = Read-Host -Prompt "Enter client name(ex. TESTCLIENT)"
$clientLOB = Read-Host -Prompt "Enter LOB "
$version = Read-Host -Prompt "Enter version Number (ex. 10_X_X_X)"
#$clientPath = "C:\Users\ebpag\Desktop\DuckCreek\$clientName\$clientLOB\US-INH\*_Product_*.xml"
$clientPath = "C:\SaaS\$clientName\Policy\ManuScripts\DCTTemplates\$clientLOB\US-INH\*_Product_*.xml"


#Create table lob id 
if ($clientLOB -Match "Carrier") {
    $clientLOB = $clientLOB -replace "Carrier" 
    $tableLOB = '<table id="Manuscripts' + $clientLOB
} else {
    $tableLOB = '<table id="Manuscripts' + $clientLOB
}


#Determine path of newest version
function newestVersion($clPath) {
    $maxVer = @(0, 0, 0, 0)
    $currentVer = @(0, 0, 0, 0)
    $doubleArr = @($currentVer, $maxVer)
    $output = ""
    Get-ChildItem -Path $clPath | ForEach {
        $count = 0
        $splitArr = ""
        $splitArr = $_.BaseName.Split("_") 
        for ($i = 0; $i -lt $splitArr.Length; $i++) {
            if ($splitArr[$i] -match "^\d+$") {
                $currentVer[$count] = $splitArr[$i]
                $count++
            }
        }
        $doubleArr[0] = $currentVer
        $doubleArr[1] = $maxVer
        $compVal = compareVer($doubleArr)
        if ($compVal -eq 1){
            for ($j = 0; $j -lt $maxVer.Length; $j++) {
                $maxVer[$j] = $CurrentVer[$j]
            }
            $output = $_.FullName
        } elseif($compVal -ne 2) {
            Write-Host "Error in compare output"
        }
    }
    return $output
}

#function to compare version number arrays
#outputs 1 if first paramater is newer or 2 if second paramater is newer
function compareVer($inArr) {
    $arr1= $inArr[0]
    $arr2 = $inArr[1]
    for ($i = 0; $i -lt $arr1.count; $i++) {
        if ($arr1[$i] -gt $arr2[$i]) {
            return 1
        } elseif ($arr2[$i] -gt $arr1[$i]) {
            return 2
        }
    }
}

#store output variables
$ifTrue = "False"
$newPath = newestVersion($clientPath)
#check for valid product file
if($newPath -ne "") {
    #check for valid table
    $tableLine = Get-ChildItem -Path $newPath | Select-String -Pattern $tableLOB -Quiet
    if ($tableLine) {
        [XML]$tableData = Get-Content $newPath
        $overrideCheck = 0
        #iterate through xml file
        foreach ($empDetail in $tableData.manuscript.model.object.table) {
            if ($empDetail.override -eq 1) {
                $overrideCheck = 1
            }
            $tableName = $empDetail.id
            $targetName = "Manuscripts"+$clientLOB
            #look for table with correct name
            if ($tableName -eq $targetName) {
                #stop and set flag true if valid version numbers found in table
                $compareString = $empDetail.data.row.value
                if ($compareString -match $version) {
                    $ifTrue = "True"
                    break
                }
            }
        }
        #output results of comparison
        if ($ifTrue -eq "True") {
            Write-Host "Manuscript table was successfully updated" -ForegroundColor Green
            Write-Host ""
        } else {
            Write-Host "Error: Manuscript table was not successfully updated" -ForegroundColor Red
            Write-Host ""
        }
        if ($overrideCheck -eq 1) {
            Write-Host "Manuscript table was overwritten" -ForegroundColor Yellow
            Write-Host ""
        } else {
            Write-Host "Caution: Manuscript table was not overwritten" -ForegroundColor Yellow
            Write-Host ""
        }
    } else {
        #no table was found in product file
        Write-Host "Error: No Manuscript table present" -ForegroundColor Red
        Write-Host ""
    }
}else{
    #no product file was found in folder
    Write-Host "Error: No product file found" -ForegroundColor Red
    Write-Host ""
}
