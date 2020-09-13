Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Invoke-WebRequest `
    https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe `
    -OutFile $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Start-Process `
    -FilePath $env:USERPROFILE\Desktop\SSMAgent_latest.exe `
    -ArgumentList "/S"
Remove-Item -Force $env:USERPROFILE\Desktop\SSMAgent_latest.exe
Restart-Service AmazonSSMAgent