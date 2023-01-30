Install-Module Az -Force

Login-AzAccount

et-AzVM | `
Select-Object Name, @{Name="Status";
      Expression={(Get-AzVM -Name $_.Name -ResourceGroupName $_.ResourceGroupName -status).Statuses[1].displayStatus}} | `
Where-Object {$_.Status -eq "VM running"} | Invoke-AzVMRunCommand -CommandId 'RunPowerShellScript' -ScriptString { Invoke-WebRequest -Uri https://github.com/guidovbrakel/LazyWindowsUpdates/raw/master/PSWindowsUpdate.zip -OutFile 'c:\temp\PSWindowsUpdate.zip' ; Expand-Archive -Force -LiteralPath 'c:\temp\PSWindowsUpdate.zip' -DestinationPath "C:\Windows\System32\WindowsPowerShell\v1.0\Modules" ; Set-ExecutionPolicy Unrestricted; Import-Module PSWindowsUpdate; Get-WUInstall -AcceptAll -Verbose -IgnoreReboot ; time = "20:00:00" ; $date = "02/4/2019" ; schtasks /create /tn “Scheduled Reboot” /tr “shutdown /r /t 0” /sc once /st $time /sd $date /ru “System” }
