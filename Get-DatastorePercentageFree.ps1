# Find percentage free of Datastores
# Name: Get-DatastorePercentageFree.ps1

function CalcPercent {
    param(
    [parameter(Mandatory = $true)]
    [int]$InputNum1,
    [parameter(Mandatory = $true)]
    [int]$InputNum2)
    $InputNum1 / $InputNum2*100
}
 
$datastores = Get-Datastore | Sort Name
ForEach ($ds in $datastores)
{
    if (($ds.Name -match "Shared") -or ($ds.Name -match ""))
    {
        $PercentFree = CalcPercent $ds.FreeSpaceMB $ds.CapacityMB
        $PercentFree = "{0:N2}" -f $PercentFree
        $ds | Add-Member -type NoteProperty -name PercentFree -value $PercentFree
    }
}
$datastores | Select Name,FreeSpaceMB,CapacityMB,PercentFree | Export-Csv c:\DatastorePercentage.csv
