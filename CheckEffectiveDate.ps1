
        

            $LOB = Read-Host -Prompt 'Input LOB as state abbreviation'

            Write-Output $LOB

            $path = "C:\Users\colby.welch\Desktop\Test\DCTTemplate\$LOB\EXAMPLE1.0.xml"
            $path2 = "C:\Users\colby.welch\Desktop\Test\DCTTemplate\$LOB\EXAMPLE1.1.xml"

            if (Test-Path $path){
                [xml]$File = Get-Content $path 
                [xml]$File2 = Get-Content $path2
            }
                
            else{
                Write-Error "Path Check Failed in file " $LOB
            }
                
            if ( $File -ne $null -and $File2 -ne $null){
                $date = $File.SelectSingleNode('//effectiveDateNew').'#text' -as [datetime]
                $date2 = $File2.SelectSingleNode('//effectiveDateNew').'#text' -as [datetime]

                Write-Output $date
                Write-Output $date2

                if ($date -lt $date2){
                    Write-Host -ForegroundColor Green "Effective Date Valid in file $LOB" `n
                }

                else{
                    Write-Host -ForegroundColor Red "Invaild Effective Date in file $LOB" `n
                }

            }
                    
            else{
                Write-Error "Invalid File"
            }

            $File = $null
            $File2 = $null
        