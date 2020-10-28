Write-Output "Second part:"
#for the first part we are working under the assumption the master script always puts the first line there, and our encoding check is based off of that
#$clientName = Read-Host -Prompt "Enter client name (ex. Five) "
#$clientPath = 'C:\Users\Family\Desktop\TempDCT\' +$clientName
#Write-Host $clientPath
#try {
#    $max = ""
#    Get-ChildItem -Path $clientPath | ForEach-Object {
#        if ($max -lt $_.Name) {
#            $max = $_.Name
#        }
#    }
#    $clientPath = $clientPath + "\" + $max
#    Write-Host $clientPath
#    #$noEncodingLine = Get-ChildItem -Path $clientPath -ErrorAction stop | Where-Object {!($_ | Select-String 'encoding="utf-8' -Quiet) }
#    $encodingLine = Get-ChildItem -Path $clientPath -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'
#} catch [System.Exception] {
#    Write-Host "An error occured "
#    Write-Host $_
#}
#$allInstances = Get-ChildItem $clientPath -Recurse -Directory
#$allInstances | ForEach-Object {
#    Write-Host $allInstances
#    try {
#        $max = ""
#        Get-ChildItem -Path ($clientPath + '\' + $_) | ForEach-Object {
#            if ($max -lt $_.Name) {
#                $max = $_.Name
#            }
#        }
#        $maxPath = $clientPath + "\" + $max
#        Write-Host $maxPath
#         $encodingLine = Get-ChildItem -Path $maxPath -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'
#    } catch [System.Exception] {
#        Write-Host "An error occured "
#        Write-Host $_
#    }
    $clientName = Read-Host -Prompt "Enter client name (ex. Five) "
    $clientPath = 'C:\Users\Family\Desktop\TempDCT\' + $clientName + '\*'
    Write-Host $clientPath
    try {
        $max = ""
        $maxPath = ""
        Get-ChildItem -Path ($clientPath) | ForEach-Object {
            $stateName = $_.Name
            Get-ChildItem -Path $_.FullName | ForEach-Object {
                if ($max -lt $_.Name) {
                    $maxPath = $_.FullName
                }
            }
            $encodingLine = Get-ChildItem -Path $maxPath -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'
            $noEncodingLine = Get-ChildItem -Path $maxPath -ErrorAction stop | Where-Object {!($_ | Select-String 'encoding="utf-8' -Quiet) }
            #$noEncodingLine = Get-ChildItem -Path $maxPath -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'
            if ($encodingLine -eq $null) {
                Write-Host "No utf-8 encoding lines found in "
                $noEncodingLine | foreach {$stateName}
            } else {
                Write-Host "Utf-8 encoding line found in the following files "
                $encodingLine | foreach {$stateName}
                $encodingLine | foreach {$maxPath}
        #Write-Output " "
        #"No encoding line found in the following files: "
        #$noEncodingLine | foreach {$_.Name}
            }
        }
        #$maxPath = $clientPath + $max
        #Write-Host $maxPath
        #Get-ChildItem -Path $maxPath -ErrorAction stop | Select Name, @{n='Encoding';e={Get-FileEncoding $_.FullName}}, @{n='State';e={$_.FullName}}
    } catch [System.Exception] {
        Write-Host "An error occured "
        Write-Host $_
    }
#    if ($encodingLine -eq $null) {
#    "No utf-8 encoding lines found in " + $stateName
#    } else {
#        "Utf-8 encoding line found in the following files "
#        $encodingLine | foreach {$_.FileName}
        #Write-Output " "
        #"No encoding line found in the following files: "
        #$noEncodingLine | foreach {$_.Name}
#    }
#}
#if ($encodingLine -eq $null) {
#    "No utf-8 encoding lines found"
#} else {
#    "Utf-8 encoding line found in the following files: "
#    $encodingLine | foreach {$_.FileName}
    #Write-Output " "
    #"No encoding line found in the following files: "
    #$noEncodingLine | foreach {$_.Name}
#}



#$clientName = Read-Host -Prompt "Enter client name: "
#$clientPath = 'C:\Users\Family\Desktop\TempDCT\' +$clientName+ '\*.xml'
#Write-Host $clientPath
#try {
#$noEncodingLine = Get-ChildItem -Path $clientPath -ErrorAction stop | Where-Object {!($_ | Select-String 'encoding="utf-8' -Quiet) }
#$encodingLine = Get-ChildItem -Path $clientPath -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'
#} catch [System.Exception] {
#Write-Host "An error occured: "
#Write-Host $_
#}
#$noEncodingLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\*.xml | Where-Object {!($_ | Select-String 'encoding="utf-8' -Quiet) }
#$encodingLine = Get-ChildItem -Path C:\Users\Family\Desktop\TempDCT\*.xml | Select-String -Pattern 'encoding="utf-8"'
