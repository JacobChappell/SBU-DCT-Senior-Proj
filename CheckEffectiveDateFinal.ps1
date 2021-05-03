$outputswitch = Read-Host -Prompt 'Enter 1 for debugging info, 0 for basic output'
Write-Output " "
$csvswitch = Read-Host -Prompt 'Enter 1 to check a single state, or 0 to import csv file'

if($csvswitch -eq '0')
{
    $LOBList = Import-Csv C:\Users\colby.welch\Desktop\CSV.csv
}

#$path = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB"
#create arraylist of file names
#create global max variable to allow for 1st and 2nd newest files
$maxVal = @($null,$null,$null,$null)
$recentVal = @($null,$null,$null,$null)


#function for the newest file in the list
function newestFileList($clPath) {
    #usedNames will have a file name and the next index will have its maxversion array 
    $usedNames = [object][System.Collections.ArrayList]@()
    Get-ChildItem -Path $clPath | ForEach {
        $maxVer = @($null,$null,$null,$null)
        $currentVer = @($null,$null,$null,$null)
        $doubleArr = @($currentVer, $maxVer)
        #separate version number from title
        $name = ""
        $count = 0
        $splitArr = ""
        $splitArr = $_.BaseName.Split("_") 
        for ($i = 0; $i -lt $splitArr.Length; $i++) {
            if ($splitArr[$i] -match "^\d+$") {
                $currentVer[$count] = $splitArr[$i]
                $count++
            } else {
                if($name -eq "") {
                    $name += $splitArr[$i]
                }else{
                    $name += "_" + $splitArr[$i]
                }
            }
        }
        #update usedNames arraylist with file name and max version 
        $index = $usedNames.indexOf($name)
        if ($index -lt 0) {
            $usedNames.Add($name)
            $usedNames.Add($currentVer)
        } else {
            $maxVer = $usedNames[$index + 1]
            $doubleArr[0] = $currentVer
            $doubleArr[1] = $maxVer
            $compVal = compareVer($doubleArr)
            if ($compVal -eq 1){
                for ($j = 0; $j -lt $maxVer.Length; $j++) {
                    $maxVer[$j] = $currentVer[$j]
                    $maxVal[$j] = $currentVer[$j]
                }
                $usedNames[$index + 1] = $maxVer
            }
        }
    }
    $output = createFileList($usedNames)
    return $output
}


#function to compare version number arrays
#outputs 1 if first paramater is newer or 2 if second paramater is newer
function compareVer($inArr) {
    $arr1= $inArr[0]
    $arr2 = $inArr[1]
    for ($i = 0; $i -lt $arr1.count; $i++) {
        if (($arr1[$i] -gt $arr2[$i])) {
            return 1
        } elseif ($arr2[$i] -gt $arr1[$i]) {
            return 2
        }
    }
}


#function to get the 2nd newest file in the list
function secNewestFileList($clPath) {
    #usedNames will have a file name and the next index will have its maxversion array 
    $usedNames2 = [object][System.Collections.ArrayList]@()
    Get-ChildItem -Path $clPath | ForEach {
        $compVer = @($null,$null,$null,$null)
        $currentVer = @($null,$null,$null,$null)
        $doubleArr1 = @($currentVer, $compVer)
        $doubleArr2 = @($currentVer, $maxVal)
        #separate version number from title
        $name = ""
        $count=0
        $splitArr = ""
        $splitArr = $_.BaseName.Split("_") 
        for ($i = 0; $i -lt $splitArr.Length; $i++) {
            if ($splitArr[$i] -match "^\d+$") {
                $currentVer[$count] = $splitArr[$i]
                $count++
            } else {
                if ($name -eq "") {
                    $name += $splitArr[$i]
                } else {
                    $name += "_" + $splitArr[$i]
                }
            }
        }
        #update usedNames arraylist with file name and max version 
        $index = $usedNames2.indexOf($name)
        if ($index -lt 0){
            $usedNames2.Add($name)
            $usedNames2.Add($currentVer)
        } else {
            $compVer = $usedNames2[$index + 1]
            $doubleArr1[0] = $currentVer
            $doubleArr1[1] = $compVer
            $compVal = compareVer($doubleArr1)
            $doubleArr2[0] = $currentVer
            $doubleArr2[1] = $maxVal
            $compCheck = compareVer($doubleArr2)
            if ($compVal -eq 1) {
                if ($compCheck -eq 2) {
                    for ($j = 0;$j -lt $compVer.Length;$j++) {
                        $compVer[$j] = $currentVer[$j]
                        $recentVal[$j] = $currentVer[$j]
                    }
                    $usedNames2[$index + 1] = $compVer
                }
            }
        }
    }
    $output = createFileList($usedNames2)
    return $output
}


#combines array containing file names and its most recent version into single array
function createFileList($arrList) {
    $outArr = [System.Collections.ArrayList]@()
    for ($i = 0; $i -lt $arrList.count; $i+=2) {
        $versionString = ""
        $verArr = $arrList[$i + 1]
            for ($j = 0; $j -lt $verArr.count;$j++) {
                if($verArr[$j] -ne $null){
                    $versionString += "_" + $verArr[$j]
                }
            }
        $fileName = $arrList[$i] + $versionString 
        $outArr.Add($fileName)
    }
    return $outArr
}



if($csvswitch -eq "1") #check a single state
    {

    $LOB = Read-Host -Prompt 'Input LOB as state abbreviation'
    Write-Output $LOB

    $path = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB"
                
    $fileForPath = newestFileList($path)
    $fileForPath2 = secNewestFileList($path) 

    $outputArr1 = @()
    $outputArr2 = @()

    Get-ChildItem -Path $path | ForEach { 
    if($fileForPath -contains $_.BaseName) {
        $outputArr1 += $_.Name
            }
        }

    Get-ChildItem -Path $path | ForEach { 
        if($fileForPath2 -contains $_.BaseName) {
            $outputArr2 += $_.Name
            }
        }

    $temp = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB\$outputArr1"
    $temp2 = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB\$outputArr2"

    if($outputswitch -eq "1"){
        Write-Output $outputArr1
        Write-Output $outputArr2
        }


    if (Test-Path $temp){
        [xml]$File = Get-Content $temp 
        [xml]$File2 = Get-Content $temp2
        }
                
    else{
        Write-Output "Path Check Failed in file " #$loopvar
        }

    foreach($empDetail in $File.ManuScript.properties.keys.keyInfo){
                
        if($empDetail.name -eq "effectiveDateNew")
            {
                $date = $empDetail.value

            }
        }

    foreach($empDetail in $File2.ManuScript.properties.keys.keyInfo){
                
        if($empDetail.name -eq "effectiveDateNew")
            {
                $date2 = $empDetail.value

            }
        }

    if($outputswitch -eq "1"){
        Write-Output $date
        Write-Output $date2
        }
                
    if ( $File -ne $null -and $File2 -ne $null){

            if ($date2 -lt $date){
                Write-Host -ForegroundColor Green "Effective Date Valid in file $LOB" `n
            }

            elseif(($date -eq $null) -or ($date2 -eq $null))
            {
                Write-Output "Date is null"
            }

            else
            {
                Write-Host -ForegroundColor Red "Invaild Effective Date in file $LOB" `n
            }

        }

    } #if single state only


    else #import csv
            {
                foreach ($state in $LOBList)
                {
                    $LOB = $state.state
                    Write-Output $LOB

                    $path = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB"

                    $fileForPath = newestFileList($path)
                    $fileForPath2 = secNewestFileList($path) 

                    $outputArr1 = @()
                    $outputArr2 = @()

                    Get-ChildItem -Path $path | ForEach { 
                    if($fileForPath -contains $_.BaseName) {
                        $outputArr1 += $_.Name
                            }
                        }

                    Get-ChildItem -Path $path | ForEach { 
                        if($fileForPath2 -contains $_.BaseName) {
                            $outputArr2 += $_.Name
                            }
                        }

                    $temp = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB\$outputArr1"
                    $temp2 = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB\$outputArr2"

                    if($outputswitch -eq "1"){
                        Write-Output $outputArr1
                        Write-Output $outputArr2
                        }

                    if (Test-Path $temp){
                        [xml]$File = Get-Content $temp 
                        [xml]$File2 = Get-Content $temp2
                        }
                
                    else{
                        Write-Output "Path Check Failed in file " #$loopvar
                        }

                    foreach($empDetail in $File.ManuScript.properties.keys.keyInfo){
                
                        if($empDetail.name -eq "effectiveDateNew")
                            {
                                $date = $empDetail.value

                            }
                        }

                    foreach($empDetail in $File2.ManuScript.properties.keys.keyInfo){
                
                        if($empDetail.name -eq "effectiveDateNew")
                            {
                                $date2 = $empDetail.value

                            }
                        }

                    if($outputswitch -eq "1"){
                        Write-Output $date
                        Write-Output $date2
                        }
                
                    if ( $File -ne $null -and $File2 -ne $null){

                            if ($date2 -lt $date){
                                Write-Host -ForegroundColor Green "Effective Date Valid in file $LOB" `n
                            }

                            elseif(($date -eq $null) -or ($date2 -eq $null))
                            {
                                Write-Output "Date is null"
                            }

                            else
                            {
                                Write-Host -ForegroundColor Red "Invaild Effective Date in file $LOB" `n
                            }

                        }

                    }
                }#else csv


            $File = $null
            $File2 = $null