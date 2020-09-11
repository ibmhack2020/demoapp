<powershell>
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Import-Module AWSPowerShell
$REGION = (ConvertFrom-Json (Invoke-WebRequest -Uri http://169.254.169.254/latest/dynamic/instance-identity/document -UseBasicParsing).Content).region
New-Item -Path "c:\temp" -ItemType "directory" -Force
powershell.exe -Command Read-S3Object -BucketName aws-codedeploy-$REGION -Key latest/codedeploy-agent.msi -File c:\temp\codedeploy-agent.msi
powershell.exe -Command Add-MpPreference -ExclusionPath "C:\ProgramData\Amazon\CodeDeploy"
powershell.exe -Command Add-MpPreference -ExclusionPath "c:\temp"
c:\temp\codedeploy-agent.msi /quiet /l c:\temp\host-agent-install-log.txt
Start-Sleep -Seconds 60
powershell.exe -Command Remove-MpPreference -ExclusionPath "C:\ProgramData\Amazon\CodeDeploy"
powershell.exe -Command Remove-MpPreference -ExclusionPath "C:\temp"
$CODE_DEPLOY_AGENT =  (Get-Service 'codedeployagent')
if($CODE_DEPLOY_AGENT.StartType -eq 'Disabled'){
powershell.exe -Command Set-Service -Name 'codedeployagent' -StartupType 'manual' -Status 'stopped'
powershell.exe -Command Set-Service -Name 'codedeployagent' -StartupType 'automatic' -Status 'running'
}
Write-Output  "Install Internet Information Server (IIS) Started."
powershell.exe -Command Import-Module -Name ServerManager
powershell.exe -Command Install-WindowsFeature Web-Server
Write-Output  "Install Internet Information Server (IIS) Completed"
</powershell>