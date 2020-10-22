#Validate encoding of file based on BOM (Byte Order Mark)
#Based on code from https://gist.github.com/jpoehls/2406504
Write-Output "First part"
function Get-FileEncoding {
  [CmdletBinding()] 
  Param (
    [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $True)] 
    [string]$Path
  )
  #Write-Host Bytes: $byte[0] $byte[1] $byte[2] $byte[3]
  [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $Path
  # EF BB BF (UTF8)
  if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf ) {
    Write-Output 'UTF-8 with BOM'
  } else { 
    Write-Output 'Wrong encoding or no BOM' 
  }
}
$clientName = Read-Host -Prompt "Enter client name (ex. Five) "
$clientPath = 'C:\Users\Family\Desktop\TempDCT\' +$clientName
Write-Host $clientPath
try {
$max = ""
Get-ChildItem -Path $clientPath | ForEach-Object {
    if ($max -lt $_.Name) {
        $max = $_.Name
    }
}
$clientPath = $clientPath + "\" + $max
Get-ChildItem -Path $clientPath -ErrorAction stop | Select Name, @{n='Encoding';e={Get-FileEncoding $_.FullName}}
} catch [System.Exception] {
Write-Host "An error occured "
Write-Host $_
}
#Get-ChildItem  -Path C:\Users\Family\Desktop\TempDCT\*.xml | Select Name, @{n='Encoding';e={Get-FileEncoding $_.FullName}}


#Get-ChildItem -Path $clientPath
#for ($i = 1; $i -lt $filePath.Count; $i++) {
#    $temp1 = Get-Content $filePath[$i].Name
#    $temp2 = Get-Content $filePath[$i+1].Name
#    Compare-Object -ReferenceObject ( $temp1) -DifferenceObject ($temp2)
#}
