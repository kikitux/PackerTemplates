#if ((Get-WmiObject -Class Win32_OperatingSystem).Caption -like '*Windows 10*')
#{
#  Get-NetAdapter | Set-NetConnectionProfile -NetworkCategory Private
#  Enable-PSRemoting -Force -SkipNetworkProfileCheck
#}
#else
#{
#  Enable-PSRemoting -Force
#}
#winrm set winrm/config/client/auth '@{Basic="true"}'
#winrm set winrm/config/service/auth '@{Basic="true"}'
#winrm set winrm/config/service '@{AllowUnencrypted="true"}'
#Restart-Service -Name WinRM
#netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow


#alvaro

# Supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

# Set network to private
$ifaceinfo = Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex $ifaceinfo.InterfaceIndex -NetworkCategory Private 

# Set up WinRM and configure some things
winrm quickconfig -q
winrm s "winrm/config" '@{MaxTimeoutms="1800000"}'
winrm s "winrm/config/winrs" '@{MaxMemoryPerShellMB="2048"}'
winrm s "winrm/config/service" '@{AllowUnencrypted="true"}'
winrm s "winrm/config/service/auth" '@{Basic="true"}'
Restart-Service -Name WinRM
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
