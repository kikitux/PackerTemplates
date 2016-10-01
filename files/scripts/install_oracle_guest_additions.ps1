Write-Host "Installing Guest Additions"
certutil -addstore -f "TrustedPublisher" D:\cert\oracle-vbox.cer
Start-Process -FilePath "D:\VBoxWindowsAdditions.exe" -ArgumentList "/S" -WorkingDirectory "C:\Windows\Temp\virtualbox" -Wait
Remove-Item "C:\Windows\Temp\virtualbox"
