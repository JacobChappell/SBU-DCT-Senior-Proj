            #Effective Date Checker
            #Updated by Max Stoner 4/1/21
            #This code imports two effective dates and compares them:
            #If the first date is later than the second date, the code will succeed!
            
            
            
            #Asks for LOB input
            $LOB = Read-Host -Prompt 'Input LOB as state abbreviation'

            #Writes LOB (REMOVE AFTER DEBUGGING)
            Write-Output $LOB

            #Path creation
            $path = "C:\Program Files\Duck Creek Technologies_MO_Base_1905\ManuScripts\DCTTemplates\$LOB\*\BaseProduct.xml"
            $path2 = "C:\Program Files\Duck Creek Technologies_MO_Base_1905\ManuScripts\DCTTemplates\$LOB\*\BillingBaseProduct.xml"
            
            #Import the xml information as a File
            if (Test-Path $path){
                [xml]$File = Get-Content $path
                [xml]$File2 = Get-Content $path2
            }
            #Error: Unless there is no file at path 
            else{
                Write-Error "Path Check Failed in file " $LOB
            }
            
            #If the files aren't blank, pull out EffectiveDateNew and cast it as a date
            if ( $File -ne $null -and $File2 -ne $null){
                $date = $File.SelectSingleNode('//@effectiveDateNew').'#text' -as [datetime]
                $date2 = $File2.SelectSingleNode('//@effectiveDateNew').'#text' -as [datetime]

                #Output dates (REMOVE AFTER DEBUGGING)
                Write-Output $date
                Write-Output $date2

                #if the first file's date is less than file 2's it's valid
                if ($date -lt $date2){
                    Write-Host -ForegroundColor Green "Effective Date Valid in file $LOB" `n
                }

                #if date is empty (REMOVE AFTER DEBUGGING)
                if($date -eq $null -or $date2 -eq $null){
                    Write-Host -ForegroundColor Red "Big Fart time" `n
                }

                #else invalid
                else{
                    Write-Host -ForegroundColor Red "Invaild Effective Date in file $LOB" `n
                }

            }
            
            #else the files are blank    
            else{
                Write-Error "Invalid File"
            }

            #cleaning variables
            $File = $null
            $File2 = $null 
