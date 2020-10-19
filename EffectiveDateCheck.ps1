Get-ChildItem -Path C:\Users\colby.welch\Desktop\Test\DCTTemplate -Directory -Recurse | ForEach-Object {
    

    
        $path = 'C:\Users\colby.welch\Desktop\Test\DCTTemplate\AL\EXAMPLE1.0.xml'
        #Write-Host $path
        $path2 = 'C:\Users\colby.welch\Desktop\Test\DCTTemplate\AL\EXAMPLE1.1.xml'
        #Write-Host $path2

    [xml]$XML = Get-Content $path
    Write-Host $XML
    [xml]$XML2 = Get-Content $path2
    Write-Host $XML2
   
    $temp = $XML.SelectSingleNode('//effectiveDateNew').'#text' -as [datetime]
    $temp2 = $XML2.SelectSingleNode('//effectiveDateNew').'#text' -as [datetime]

    #Write-Output $XML

        if ($temp -lt $temp2) {
            Write-Output "Made Comparison"
            }
    }


    <#Pseudocode
    if(currentdate < previousdtae)
        throw flag 
        #>
        
        
    #$XML = Select-Xml -Path C:\Users\colby.welch\Desktop\Test\DCTTemplate\AL\EXAMPLE1.0.xml -XPath "//effectiveDateNew" | Select-Object -ExpandProperty node
    #$XML2 = Select-Xml -Path C:\Users\colby.welch\Desktop\Test\DCTTemplate\AL\EXAMPLE1.1.xml -XPath "//effectiveDateNew" | Select-Object -ExpandProperty node