             $outputswitch = Read-Host -Prompt 'Enter 1 for debugging info, 0 for basic output'
            
            #$LOB = Read-Host -Prompt 'Input LOB as state abbreviation'

            $LOBArray = Import-Csv C:\Users\colby.welch\Desktop\CSV.csv

            $LOB = Foreach ($loopvar in $LOBArray){
                
            

            $path = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$LOB"
            #$path = "C:\Users\maximillian.stoner\Desktop\Senior Project\$LOB"

            $fileForPath = gci $path | sort LastWriteTime | select -last 1
            $fileForPath2 = gci $path | sort LastWriteTime | select -skip 1 -last 1

            if($outputswitch -eq "1"){
            Write-Output $fileForPath
            Write-Output $fileForPath2
            }

            $temp = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$loopvar\$fileForPath"
            $temp2 = "C:\SaaS\TESTCLIENT\Policy\ManuScripts\DCTTemplates\Property\$loopvar\$fileForPath2"
            #$temp = "C:\Users\maximillian.stoner\Desktop\Senior Project\$LOB\$fileForPath"
            #$temp2 = "C:\Users\maximillian.stoner\Desktop\Senior Project\$LOB\$fileForPath2"

            if (Test-Path $temp){
                [xml]$File = Get-Content $temp 
                [xml]$File2 = Get-Content $temp2
            }
                
            else{
                Write-Error "Path Check Failed in file " $loopvar
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
                    
            else{
                Write-Error "Invalid File"
            }


            $File = $null
            $File2 = $null

            }