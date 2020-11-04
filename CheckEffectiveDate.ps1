 $ErrorActionPreference = 'SilentlyContinue'
        $stateArray = @('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS',
                        'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY',
                        'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY')

        for ($i = 0; $i -lt $stateArray.length - 1; $i++){ 

            $arrayPosition = $stateArray[$i]

            $path = "C:\Users\colby.welch\Desktop\Test\DCTTemplate\$arrayPosition\EXAMPLE1.0.xml"
            $path2 = "C:\Users\colby.welch\Desktop\Test\DCTTemplate\$arrayPosition\EXAMPLE1.1.xml"

            if (Test-Path $path){
                [xml]$File = Get-Content $path 
                [xml]$File2 = Get-Content $path2
            }
                
            else{
                Write-Error "Path Check Failed in file " $arrayPosition
            }
                
            if ( $File -ne $null -and $File2 -ne $null){
                $date = $File.SelectSingleNode('//effectiveDateNew').'#text' -as [datetime]
                $date2 = $File2.SelectSingleNode('//effectiveDateNew').'#text' -as [datetime]

                Write-Output $date
                Write-Output $date2

                if ($date -lt $date2){
                    Write-Host -ForegroundColor Green "Effective Date Valid in file $arrayPosition" `n
                }

                else{
                    Write-Host -ForegroundColor Red "Invaild Effective Date in file $arrayPosition" `n
                }

            }
                    
            else{
                Write-Error "Invalid File"
            }

            $File = $null
            $File2 = $null
        }