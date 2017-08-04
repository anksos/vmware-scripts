
# Version 6
$target = "*"
$hostlist = Get-VMHost -location $target  | where {$_.ConnectionState -eq "Connected"}
$table = @()
foreach ($vmhost in $hostlist){
	$hostdetails = "" | Select-Object Cluster, Hostname, Version, Move, Init, Locking, ATS3, ATS5
	$hostdetails.Cluster = $vmhost.Parent
	$hostdetails.Hostname = $vmhost.Name
	$hostdetails.Version = $vmhost.Version
	$hostconfig = Get-AdvancedSetting -Entity $vmhost
	$hostdetails.Move = ($hostconfig | where {$_.name -eq "DataMover.HardwareAcceleratedMove"}).Value
	$hostdetails.Init = ($hostconfig | where {$_.name -eq "DataMover.HardwareAcceleratedInit"}).Value
	$hostdetails.Locking = ($hostconfig | where {$_.name -eq "VMFS3.HardwareAcceleratedLocking"}).Value
	$hostdetails.ATS3 = ($hostconfig | where {$_.name -eq "VMFS3.UseATSForHBOnVMFS3"}).Value
	$hostdetails.ATS5 = ($hostconfig | where {$_.name -eq "VMFS3.UseATSForHBOnVMFS5"}).Value
	$table += $hostdetails
}
$table | Sort Cluster, Hostname, Volume | ft -a -property * | Out-String -Width 200
