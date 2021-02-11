Write-Output "First part"
#Validate encoding of file based on BOM (Byte Order Mark)
#Based on code from https://gist.github.com/jpoehls/2406504

#input from employee of state + version number. only wanting to run say 9/20 state folders
$clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
$clientLOBName = Read-Host -Prompt "Enter client's LOB folder (ex. property) "
$clientPath = 'C:\Users\ebpag\Desktop\DuckCreek\' + $clientName + '\'+ $clientLOBName

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

#function to check file for UTF-8 encoding
function getEncoding($fileName){
    $ret = ""
     [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $fileName
    # EF BB BF (UTF8)
     if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf ) {
        $ret =  'UTF-8 with BOM'
    } else { 
        $ret = 'Wrong encoding or no BOM'
    }
    return $ret
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
            #store output variable names
            $fileInfo = Get-ChildItem -Path $_.FullName
            $fileName = $fileInfo.Name
    
            #store file encoding result in variable
            $encodingCheck = getEncoding($_.FullName)

            #check for incorrect encoding
            if ($encodingCheck -ne "UTF-8 with BOM") {
                #check for previous errors
                if($flag -eq 0){
                    Write-Host "The following files have incorrect encoding:" -ForegroundColor Red
                    $flag++
                }
                $outString += $fileName + "`n"
                $ifFlag++
            }
        }
    }
    if($ifFlag -ne 0){
        Write-Host $outString
    }
}
#check to see if there were no errors
if($flag -eq 0){
        Write-Host "All files have UTF-8 with BOM" -ForegroundColor Green
}
