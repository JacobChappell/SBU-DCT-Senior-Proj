Write-Output "Second part:"
#This script will iterate through a file strucutre and verify that 
#the encoding line was removed from the top of the xml file 

$clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
$clientLOBName = Read-Host -Prompt "Enter client's LOB folder (ex. property) "
#$clientPath = 'C:\SaaS\' + $clientName + '\Policy\ManuScripts\DCTTemplates\' + $clientLOBName
$clientPath ='C:\Users\ebpag\Desktop\DuckCreek\' + $clientName + '\'+ $clientLOBName 

#Determine the newest version number
#function newestPath($clPath){
#    $newestPath = ""
#    Get-ChildItem -Path $clPath | ForEach{
#        if($_.Name -gt $newestPath){
#            $newestPath = $_.FullName
#        }
#    }
#    return $newestPath
#}

#Determine the newest version number
function newestVersion($clPath){
    $newestVer = ""
    #Iterate through child folder
    Get-ChildItem -Path $clPath | ForEach{
        #separate version number from title
        $splitArr = ""
        $splitArr = $_.BaseName.Split("_") 
        $version = ""
        for(($i = 0); ($i -lt $splitArr.Length);$i++){
            if($splitArr[$i] -match "^\d+$"){
                $version += "_" + $splitArr[$i]
            }
        }
        #Find largest file version 
        if($newestVer -lt $version){
            $newestVer = $version
        }
    }
    return $newestVer
}

$flag = 0
#Iterate through folders in LOB    
Get-ChildItem -Path $clientPath | ForEach{
    $LobPath = $_.FullName
    $stateName = $_.Name
    $outString = "Folder: " + $stateName + "`n"
    $versionNum = newestVersion($LobPath)
    $ifFlag = 0
    Get-ChildItem -Path $LobPath | ForEach{ 
        if($_.Name -Match $versionNum){
            #determine if encoding line exists
            $encodingLine = Get-ChildItem -Path $_.FullName -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'

            #display results to user
            if ($encodingLine -ne $null) {

                #check for previous errors
                if($flag -eq 0){
                    Write-Host "Utf-8 encoding line found in the following files:" -ForegroundColor Red
                    $flag++
                }
                $fileName = $_.Name
                $outString += $fileName + "`n"
                $ifFlag++
            }
        }#end if
    }
    if($ifFlag -ne 0){
        Write-Host $outString
    }
}
#check to see if there were no errors
if($flag -eq 0){
        Write-Host "No Utf-8 encoding lines were found" -ForegroundColor Green
}
