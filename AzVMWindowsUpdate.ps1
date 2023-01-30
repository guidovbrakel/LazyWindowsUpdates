
<#
 # {First install the Az PowerShell Modules and then logon to Azure and then query all running VM's and update}
#>

Install-Module Az -Force

Login-AzAccount

Get-AzVM | `
Select-Object Name, @{Name="Status";
      Expression={(Get-AzVM -Name $_.Name -ResourceGroupName $_.ResourceGroupName -status).Statuses[1].displayStatus}} | `
Where-Object {$_.Status -eq "VM running"} | Invoke-AzVMRunCommand -Verbose -CommandId 'RunPowerShellScript' -ScriptString { Invoke-WebRequest -Uri https://github.com/guidovbrakel/LazyWindowsUpdates/raw/master/PSWindowsUpdate.zip -OutFile 'c:\temp\PSWindowsUpdate.zip' ; Expand-Archive -Force -LiteralPath 'c:\temp\PSWindowsUpdate.zip' -DestinationPath "C:\Windows\System32\WindowsPowerShell\v1.0\Modules" ; Set-ExecutionPolicy Unrestricted; Import-Module PSWindowsUpdate; Get-WUInstall -AcceptAll -Verbose -IgnoreReboot }
<#
 # {
#>


