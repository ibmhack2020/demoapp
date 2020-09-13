$appPool = "AngularAppPool"
$webSiteName = "AngularSite"
$webAppName = "AngularApp"
#$virtualDirectory = "DemoAngularApp"
#$managedRuntimeVersion = "No Managed Code"
$managedRuntimeVersion = "v4.0"
$managedPipelineMode = "0";
$sitePath = "$env:systemdrive\inetpub\$webAppName"
Import-Module -Name ServerManager
Import-Module -Name WebAdministration
if(Test-Path ($sitePath)) {
    Write-Host "The folder $fullIISPath already exists" -ForegroundColor Yellow
}
Write-Host "Creating directory $sitePath" -ForegroundColor Green
New-Item -Path $sitePath -ItemType "directory" -Force
Write-Host "Creating directory $sitePath completed" -ForegroundColor Green
if(Test-Path ("IIS:\AppPools\" + $appPool)) {
    Write-Host "The App Pool $appPool already exists" -ForegroundColor Yellow
}
Write-Host "Creating App Pool $appPool" -ForegroundColor Green
New-WebAppPool -Name $appPool -Force
Write-Host "Creating App Pool $appPool completed" -ForegroundColor Green
if (Test-Path ("IIS:\Sites\$WebSiteName")){
    Write-Host "Web Site $webSiteName already exists" -ForegroundColor Yellow
}
Write-Host "Creating Web site $webSiteName" -ForegroundColor Green
New-WebSite -Name $webSiteName -Port 80 -HostHeader $webAppName -PhysicalPath $sitePath -ApplicationPool $appPool -Force
Write-Host "Creating Web site $webSiteName completed" -ForegroundColor Green
#New-WebVirtualDirectory -Site $webSiteName -Name $virtualDirectory -PhysicalPath $sitePath -Force
#$pool = Get-Item "IIS:\AppPools\$appPool"
#$pool.processmodel.identityType = 3
#$pool.processmodel.username  = "username"
#$pool.processmodel.password = "password"
#$pool.managedRuntimeVersion = "v4.0"
#$pool | Set-Item
if ($managedRuntimeVersion){
    Set-ItemProperty -Path "IIS:\AppPools\$appPool" managedRuntimeVersion $managedRuntimeVersion -Force
}
if ($managedPipelineMode){
    Set-ItemProperty -Path "IIS:\AppPools\$appPool" managedPipelineMode $managedPipelineMode -Force
}
Write-Host "Stop IIS"
& iisreset /Stop
#New-WebBinding -Name $newSiteName -IPAddress "*" -Port 80 -HostHeader $webAppName -Force