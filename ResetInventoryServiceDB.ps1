# *** USE IT AT YOUR OWN RISK ***
# Reset Inventory Service Database
# This applies only to VMware vCenter 5.1.x and 5.5.x
# Change the directories if it doesn't fit to your installation. This is based on the default installation.
# This cannot be applied to nuclear missiles or reactors.

$ISservice = "vimQueryService"
# Stop the Inventory Service service
Write-Host "Stopping the Inventory Service service!" -Foregroundcolor orange
Stop-Service $ISservice
Write-Host "Inventory Service stopped!" -Foregroundcolor green
Write-Host " "

# Backup xdb.bootstrap
Write-Host "Backing up xdb.bootstrap!" -Foregroundcolor orange
Get-Content 'C:\Program Files\VMware\Infrastructure\Inventory Service\data\xdb.bootstrap' | Select-String -Pattern "<server" | ForEach-Object { $_.line } | Out-File 'C:\Program Files\VMware\Infrastructure\Inventory Service\datahash1234321.txt'
Write-Host "xdb.boostrap backup Completed!" -Foregroundcolor green
Write-Host " "

# Removing the contents! 
Write-Host "Moving the contents from directory!" -Foregroundcolor orange
Move-Item "C:\Program Files\VMware\Infrastructure\Inventory Service\data" "C:\Program Files\VMware\Infrastructure\Inventory Service\data_old"
Write-Host "Items moved!" -Foregroundcolor green
Write-Host " "

# Re-create the Database
Write-Host "Database is re-creating!" -Foregroundcolor orange
Start-Process "C:\Program Files\VMware\Infrastructure\Inventory Service\scripts\createDB.bat"
Write-Host "Database re-created!" -Foregroundcolor green
Write-Host " "

# Restore the xdb.bootstrap to the new Database
Write-Host "Restoring xdb.bootstrap!" -Foreground orange
$oldcontent = [IO.FILE]::ReadAllText("C:\Program Files\VMware\Infrastructure\Inventory Service\datahash1234321.txt"); $newcontent = [IO.FILE]::ReadAllText("C:\Program Files\VMware\Infrastructure\Inventory Service\data\xdb.bootstrap"); $newcontent -Replace "<server.+" , "$oldcontent" | Out-File "C:\Program Files\VMware\Infrastructure\Inventory Service\data\xdb.bootstrap"; Remove-Item "C:\Program Files\VMware\Infrastructure\Inventory Service\datahash1234321.txt"
Write-Host "Restore completed!" -Foregroundcolor green
Write-Host " "
Write-Host "Starting the Inventory Service service" -Foregroundcolor orange
Start-Service $ISservice
Write-Host "Inventory Service started!" -Foregroundcolor green

Write-Host "*** Please Re-register your Inventory Service Database. Check KB here -> https://kb.vmware.com/kb/2042200 ***" -Foregroundcolor red

