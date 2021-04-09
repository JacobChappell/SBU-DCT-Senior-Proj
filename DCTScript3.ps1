Write-Output "Third part:"


#input from employee
$clientName = Read-Host -Prompt "Enter client name (ex. Three) "
$clientLOB = Read-Host -Prompt "Enter client's LOB folder (ex. Property) "
$clientPath = 'C:\Users\Family\Desktop\TempDCT\' + $clientName + '\'+ $clientLOB
#$clientPath = "C:\SaaS\$clientName\Policy\ManuScripts\DCTTemplates\$clientLOB"


#create arraylist of file names
#create global max variable to allow for 1st and 2nd newest files
$maxVal = @($null,$null,$null,$null)
$recentVal = @($null,$null,$null,$null)
#funciton for the newest file in the list
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
            <# elseif ($compVal -ne 2) {
                Write-Host "Error in compare output in newest file"
            } #>
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

function compareVer2($inArr) {
    $arr1= $inArr[0]
    $arr2 = $inArr[1]
    for ($i = 0; $i -lt $arr1.count; $i++) {
        if (($arr1[$i] -lt $arr2[$i])) {
            return 1
        } elseif ($arr2[$i] -lt $arr1[$i]) {
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
            $compCheck = compareVer2($doubleArr2)
            if ($compVal -eq 1) {
                if ($compCheck -eq 1) {
                    for ($j = 0;$j -lt $compVer.Length;$j++) {
                        $compVer[$j] = $currentVer[$j]
                        $recentVal[$j] = $currentVer[$j]
                    }
                    $usedNames2[$index + 1] = $compVer
                }
            }
            <# elseif ($compVal -ne 2){
                Write-Host "Error in compare output in recent file"
            } #>
        }
    }
    $output = createFileList($usedNames2)
    return $output
}


#combines array containing file names and its most recent version into single array
function createFileList($arrList) {
    $outArr = [System.Collections.ArrayList]@()
    for ($i = 0; $i -lt (($arrList.count + 1) / 2); $i+=2) {
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


#Iterate through folders in LOB    
Get-ChildItem -Path $clientPath | ForEach {

    $LobPath = $_.FullName
    $stateName = $_.Name
    $outString = "Folder: " + $stateName + "`n"
    $newFiles = newestFileList($LobPath)
    $recentFiles = secNewestFileList($LobPath)

    if (($newFiles -ne "") -or ($recentFiles -ne "")) {
        #Write-Host $newFiles
        $ifFlag = 0
        $fileArr1 = @()
        $fileArr2 = @()
        $outputArr1 = @()
        $outputArr2 = @()
        $filePath1 = ""
        $filePath2 = ""
        $fileName1 = ""
        $fileName2 = ""

        Get-ChildItem -Path $LobPath | ForEach { 
            if($newFiles -contains $_.BaseName) {
                $fileArr1 += $_.FullName
                $outputArr1 += $_.BaseName
            }
        }

        Get-ChildItem -Path $LobPath | ForEach { 
            if($recentFiles -contains $_.BaseName) {
                $fileArr2 += $_.FullName
                $outputArr2 += $_.BaseName
            }
        }

        for ($p = 0; $p -lt $fileArr1.Length; $p++) {
            $emptyTagCheck = 0
            $numLineCheck = 0
            $possEmptyTag = 0
            $versionComp = 0
            $dateComp1 = 0
            $dateComp2 = 0
            $nameComp = 0
            $lobComp = 0
            $manuCheck = 0
            $versionIDCheck = 0
            $notesCheck = 0
            $modelCheck = 0


            $filePath1 = $fileArr1[$p]
            $filePath2 = $fileArr2[$p]
            $fileName1 = $outputArr1[$p]
            $fileName2 = $outputArr2[$p]
            $fpathName = Get-Content $filePath1
            $spathName = Get-Content $filePath2
            [XML]$fXMLFile = Get-Content $filePath1
            [XML]$sXMLFile = Get-Content $filePath2


            #Compare-Object -ReferenceObject ($filePath1) -DifferenceObject ($filePath2) -IncludeEqual
            $testVar = Compare-Object -ReferenceObject ($filePath1) -DifferenceObject ($filePath2)
            if (($fpathName.Length -eq $spathName.Length-2) -or ($fpathName.Length-2 -eq $spathName.Length)) {
                $numLineCheck = 1
            }

            $i = 0
            $varIOArr = @()
            $varSIArr = @()
            $testVar | ForEach {
                #Write-Host $testVar[0]
                $varIOArr += $testVar[$i].InputObject
                $varSIArr += $testVar[$i].SideIndicator
                $i++
            }

            $i = 0
            $varIONewFile = @()
            $varIOOldFile = @()
            while ($i -lt $varSIArr.Length) {
                if ($varSIArr[$i] -eq "=>") {
                    $varIONewFile += $varIOArr[$i]
                }
                else { 
                    $varIOOldFile += $varIOArr[$i]
                }
                $i++
            }

            $modelComp = Compare-Object $filePath1 $filePath2 | Where-Object { ($_.SideIndicator -eq "=>") -or ($_.SideIndicator -eq "<=") } | ForEach-Object { $_.InputObject }
            $i = 0
            $modelComp | ForEach {
                if ($modelComp[$i].SideIndicator -ne $null) {
                    $modelCheck = 1
                }
                $i++
            }


            $i = 0
            $j = 1
            $k = 2
            $testVarIO1 = $null
            $testVarIO2 = $null
            $testVarIO3 = $null
            while ($i -lt $testVar.Length) {
                $testVarIO1 = $varIOArr[$i]
                $varIO1Arr = $testVarIO1.toCharArray()
                $testVarIO2 = $varIOArr[$j]
                $varIO2Arr = $testVarIO2.toCharArray()
                for ($m = 0; $m -lt $varIO2Arr.Length; $m++) {
                    $varIO2Arr[$m] = $varIO2Arr[$m+1]
                }
                $varLen = $varIO2Arr.Length-1
                $varIO2Arr[$varLen] = $null
                $varIO1Arr = $varIO1Arr.ToString()
                $varIO2Arr = $varIO2Arr.ToString()
                if ($varIO1Arr -eq $varIO2Arr) {
                    $emptyTagCheck = 1
                }
                if ($k -lt $testVar.Length) {
                    $testVarIO3 = $varIOArr[$k]
                    $varIO3Arr = $testVarIO3.toCharArray()
                    for ($m = 0; $m -lt $varIO3Arr.Length; $m++) {
                        $varIO3Arr[$m] = $varIO3Arr[$m+1]
                    }
                    $varLen = $varIO3Arr.Length-1
                    $varIO3Arr[$varLen] = $null
                    $varIO2Arr = $varIO2Arr.ToString()
                    $varIO3Arr = $varIO3Arr.ToString()
                    if ($varIO2Arr -eq $varIO3Arr) {
                        $emptyTagCheck = 1
                    }
                }
                $i += 2
                $j += 2
                $k += 2
            }


            $dateArrNew1 = @($null, $null, $null, $null)
            $dateArrNew2 = @($null, $null, $null, $null)
            $dateArrRen1 = @($null, $null, $null, $null)
            $dateArrRen2 = @($null, $null, $null, $null)
            foreach ($empDetail in $fXMLFile.ManuScript.properties.keys.keyinfo) {
                foreach ($emp2Detail in $sXMLFile.ManuScript.properties.keys.keyinfo) {
                    if ($empDetail.name -eq 'effectiveDateNew' -and $emp2Detail.name -eq 'effectiveDateNew') {
                        $convertDate1 = $empDetail.value
                        $convertDate2 = $emp2Detail.value
                        $dateArrNew1 = $convertDate1.split("-")
                        $dateArrNew2 = $convertDate2.split("-")
                        if ($dateArrNew2[0] -eq $dateArrNew1[0]) {
                            if ($dateArrNew2[1] -eq $dateArrNew1[1]) {
                                if ($dateArrNew2[2] -gt $dateArrNew1[2]) {
                                    $dateComp1 = 1
                                }
                            }
                        } elseif ($dateArrNew2[0] -eq $dateArrNew1[0]) {
                            if ($dateArrNew2[1] -gt $dateArrNew1[1]) {
                                $dateComp1 = 1
                            }
                        } elseif ($dateArrNew2[0] -gt $dateArrNew1[0]) {
                            $dateComp1 = 1
                        }
                        $dateArrNew1 = @($null, $null, $null, $null)
                        $dateArrNew2 = @($null, $null, $null, $null)
                    }
                    if ($empDetail.name -eq 'effectiveDateRenewal' -and $emp2Detail.name -eq 'effectiveDateRenewal') {
                        $convertDate1 = $empDetail.value
                        $convertDate2 = $emp2Detail.value
                        $dateArrNew1 = $convertDate1.split("-")
                        $dateArrNew2 = $convertDate2.split("-")
                        if ($dateArrNew2[0] -eq $dateArrNew1[0]) {
                            if ($dateArrNew2[1] -eq $dateArrNew1[1]) {
                                if ($dateArrNew2[2] -gt $dateArrNew1[2]) {
                                    $dateComp1 = 1
                                }
                            }
                        } elseif ($dateArrNew2[0] -eq $dateArrNew1[0]) {
                            if ($dateArrNew2[1] -gt $dateArrNew1[1]) {
                                $dateComp1 = 1
                            }
                        } elseif ($dateArrNew2[0] -gt $dateArrNew1[0]) {
                            $dateComp1 = 1
                        }
                        $dateArrRen1 = @($null, $null, $null, $null)
                        $dateArrRen2 = @($null, $null, $null, $null)
                    }
                    if (($empDetail.name -eq 'version') -and ($empDetail.name -eq $emp2Detail.name)) {
                        if ($empDetail.value -le $emp2Detail.value) {
                            $versionComp = 1
                        }
                    }
                    if (($empDetail.name -eq 'state') -and ($empDetail.name -eq $emp2Detail.name)) {
                        if ($empDetail.value -ne $emp2Detail.value) {
                            $nameComp = 1
                        }
                    }
                    if (($empDetail.name -eq 'lob') -and ($empDetail.name -eq $emp2Detail.name)) {
                        if ($empDetail.value -ne $emp2Detail.value) {
                            $lobComp = 1
                        }
                    }
                }
            }


            $newManuIDArr1 = @($null, $null, $null, $null)
            $newManuIDArr2 = @($null, $null, $null, $null)
            $doubleArr = @($newManuIDArr1, $newManuIDArr2)
            $manuID1 = $fXMLFile.ManuScript.properties.manuscriptID
            $manuID2 = $sXMLFile.ManuScript.properties.manuscriptID
            $manuIDArr1 = $manuID1.split("_")
            $manuIDArr2 = $manuID2.split("_")
            $specialCount = 0
            if ($stateName -eq "US-INH") {
                $specialCount = 1
            }
            if (($manuID1 -notmatch "Carrier") -and ($manuID2 -notmatch "Carrier")) {
                $count = 0
                for ($k = 3+$specialCount; $k -lt $manuIDArr1.length; $k++) {
                    $newManuIDArr1[$count] = $manuIDArr1[$k]
                    $newManuIDArr2[$count] = $manuIDArr2[$k]
                    if (($manuIDArr1[$k] -ne $maxVal[$count]) -and ($manuIDArr2[$k] -ne $recentVal[$count])) {
                        $manuCheck = 1
                    }
                    $count++
                }
            } elseif (($manuID1 -match "Carrier") -and ($manuID2 -match "Carrier")) {
                $count = 0
                for ($k = 4+$specialCount; $k -lt $manuIDArr1.length; $k++) {
                    $newManuIDArr1[$count] = $manuIDArr1[$k]
                    $newManuIDArr2[$count] = $manuIDArr2[$k]
                    if (($manuIDArr1[$k] -ne $maxVal[$count]) -and ($manuIDArr2[$k] -ne $recentVal[$count])) {
                        $manuCheck = 1
                    }
                    $count++
                }
            }
            $doubleArr[0] = $newManuIDArr1
            $doubleArr[1] = $newManuIDArr2
            $manuCompare = compareVer($doubleArr)
            if ($manuCompare -ne 1) {
                $manuCheck = 1
            }


            $versionID1 = $fXMLFile.ManuScript.properties.versionID
            $versionID2 = $sXMLFile.ManuScript.properties.versionID
            if ($versionID1 -ne $versionID2) {
                $versionIDCheck = 1
            }


            $versDateArr1 = @($null, $null, $null, $null)
            $versDateArr1 = @($null, $null, $null, $null)
            $versionDate1 = $fXMLFile.ManuScript.properties.versionDate
            $versionDate2 = $sXMLFile.ManuScript.properties.versionDate
            $splitVersDateArr1 = $versionDate1.split("-")
            $splitVersDateArr2 = $versionDate2.split("-")
            if ($splitVersDateArr2[0] -eq $splitVersDateArr1[0]) {
                if ($splitVersDateArr2[1] -eq $splitVersDateArr1[1]) {
                    if ($splitVersDateArr2[2] -gt $splitVersDateArr1[2]) {
                        $dateComp2 = 1
                    }
                }
            } elseif ($splitVersDateArr2[0] -eq $splitVersDateArr1[0]) {
                if ($splitVersDateArr2[1] -gt $splitVersDateArr1[1]) {
                    $dateComp2 = 1
                }
            } elseif ($splitVersDateArr2[0] -gt $splitVersDateArr1[0]) {
                $dateComp2 = 1
            }
            $splitVersDateArr1 = $null
            $splitVersDateArr2 = $null

            $notesSec1 = $fXMLFile.ManuScript.properties.notes
            $notesSec2 = $sXMLFile.ManuScript.properties.notes
            if ($notesSec1 -notmatch $notesSec2) {
                $notesCheck = 1
            }
        }

        $outString += "Old File:" + $fileName2 + "`n" + "New File:" + $fileName1 + "`n"
        $ifFlag++
        if ($ifFlag -ne 0 ) {
            Write-Host $outString
            #check of possible empty tags such as <data> followed by </data> meaning there was nothing inside the actual tags meaning the files are identical
            if ($emptyTagCheck -eq 1) {
                Write-Host "There are a set of empty tags which is not actually a difference" -ForegroundColor Green
            }
            #check for same number of lines 
            if (($numLineCheck -ne 1) -and ($emptyTagCheck -ne 1)) {
                Write-Host "There are not the same number of lines in each file" -ForegroundColor Red
            }
            #check version numbers in the keyinfo attributes
            if ($versionComp -eq 1 ) {
                Write-Host "The version number(s) are not correct in the keyinfo section" -ForegroundColor Red
            }
            #check version dates in the keyinfo attributes
            if ($dateComp1 -eq 1 ) {
                Write-Host "The date(s) are not correct in the keyinfo section" -ForegroundColor Red
            }
            #check state names in keyinfo attributes
            if ($nameComp -eq 1 ) {
                Write-Host "The state name(s) are not correct in the keyinfo section" -ForegroundColor Red
            }
            #check lob names in keyinfo attributes
            if ($lobComp -eq 1 ) {
                Write-Host "The lob name(s) are not correct in the keyinfo section" -ForegroundColor Red
            }
            #check manuscriptIDs in properties tag
            if ($manuCheck -eq 1 ) {
                Write-Host "The manuscriptID(s) are not correct in the properties tag" -ForegroundColor Red
            }
            #check versionIDs in properties tag
            if ($versionIDCheck -eq 1 ) {
                Write-Host "The versiontID(s) are not correct in the properties tag" -ForegroundColor Red
            }
            #check versionDates in properties tag
            if ($dateComp2 -eq 1 ) {
                Write-Host "The versionDate(s) are not correct in the properties tag" -ForegroundColor Red
            }
            #check if the new file's notes section contains the recent file's notes section
            if ($notesCheck -eq 1 ) {
                Write-Host "The note sections are not correct in the notes tag" -ForegroundColor Red
            }
            #check if the new file's model section is the same as the recent file's model section
            if ($modelCheck -eq 1 ) {
                Write-Host "The model section(s) are not the same under the model tag" -ForegroundColor Red
            }
        }
    } else {
        #no product file was found in folder
        Write-Host $outString
        Write-Host "Error: No product file(s) found" -ForegroundColor Red
        Write-Host ""
    }
}
