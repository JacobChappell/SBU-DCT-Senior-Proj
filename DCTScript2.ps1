Write-Output "Second part:"
    $clientName = Read-Host -Prompt "Enter client name (ex. TESTCLIENT) "
    $clientLOBName = Read-Host -Prompt "Enter client's LOB folder (ex. property) "
    $clientPath = 'C:\SaaS\' + $clientName + '\Policy\ManuScripts\DCTTemplates\' + $clientLOBName
    try {
        $max = ""
        $maxPath = ""
        Get-ChildItem -Path ($clientPath) | ForEach-Object {
            $stateName = $_.Name
            Get-ChildItem -Path $_.FullName | ForEach-Object {
                if ($max -lt $_.Name) {
                    $maxPath = $_.FullName
                    $fName = $_.Name
                }
            }
            $encodingLine = Get-ChildItem -Path $maxPath -ErrorAction stop | Select-String -Pattern 'encoding="utf-8"'
            $noEncodingLine = Get-ChildItem -Path $maxPath -ErrorAction stop | Where-Object {!($_ | Select-String 'encoding="utf-8' -Quiet) }
            if ($encodingLine -eq $null) {
                Write-Host "No utf-8 encoding lines found in " ($noEncodingLine | foreach {$stateName, $fName})
            } else {
                Write-Host "**********************"
                Write-Host "Utf-8 encoding line found in the following files " ($encodingLine | foreach {$stateName, $fName})
                Write-Host "**********************"
            }
        }
    } catch [System.Exception] {
        Write-Host "An error occured "
        Write-Host $_
    }
