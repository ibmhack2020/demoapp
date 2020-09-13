Import-Module -Name ServerManager
Import-Module -Name WebAdministration
#$appPool = "AngularAppPool"

#Write-Host "Starting $appPool"
#Start-WebAppPool -Name $appPool

Write-Host "Resetting IIS"
& iisreset /start