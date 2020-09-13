$currUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Import-Module -Name ServerManager
Import-Module WebAdministration
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Add-LocalGroupMember -Group "IIS_IUSRS" -Member $currUser
$currentRetry = 0;
$success = $false;
$defaultSite = "Default Web Site"
$appPool = "DefaultAppPool"

Write-Host "Stopping $appPool"
Stop-WebAppPool -Name $appPool

do{

    $status = (Get-WebAppPoolState -name $appPool).Value
    if ($status -eq "Stopped"){
            $success = $true;
            Write-Host "$appPool is $status."
        }
    else{
        Write-Host "Let's wait a few seconds. $appPool is $status"
        Start-Sleep -s 10
        $currentRetry = $currentRetry + 1;
        }
    }
while (!$success -and $currentRetry -le 4)

Write-Host "Stopping $defaultSite"
Stop-WebSite -Name $defaultSite

$currentRetry = 0;
$success = $false;

do{

    $status = (Get-WebsiteState -Name $defaultSite).Value
    if ($status -eq "Stopped"){
            $success = $true;
            Write-Host "$defaultSite is $status."
        }
    else{
        Write-Host "Let's wait a few seconds. $defaultSite is $status"
        Start-Sleep -s 10
        $currentRetry = $currentRetry + 1;
        }
    }
while (!$success -and $currentRetry -le 4)

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
powershell.exe -Command Add-MpPreference -ExclusionPath "c:\temp"
Invoke-WebRequest -Uri "https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi" -OutFile c:\temp\rewrite_amd64_en-US.msi
c:\temp\rewrite_amd64_en-US.msi /quiet /l c:\temp\rewrite-module-install-log.txt