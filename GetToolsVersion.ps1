# GetToolsVersion.ps1
# Get the version of the VMware tools
# based on the .txt file

$vCname = Read-Host “Enter the vCenter or ESXi host name to connect”
if (-not (Get-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue)) {
    Add-PSSnapin VMware.VimAutomation.Core
}
# We create a new VIProperty in order to take also the Guest VM tools version
New-VIProperty -Name ToolsVersion -ObjectType VirtualMachine `
    -ValueFromExtensionProperty 'Config.tools.ToolsVersion' `
    -Force
    
# We create a new VIProperty in order to take also the Guest VM tools status
New-VIProperty -Name ToolsVersionStatus -ObjectType VirtualMachine `
    -ValueFromExtensionProperty 'Guest.ToolsVersionStatus' `
    -Force
# Connect to vCenter Server
Connect-viserver $vcname
# Import the VMList.txt please make sure if you have to specify path as well like "C:\VMList.txt"
$VirtualMachines = Get-Content "VMList.txt"
foreach ($vm in (Get-VM -Name $VirtualMachines)) {
	Get-VM -Name $vm | Select Name, Version, ToolsVersion, ToolsVersionStatus
}
