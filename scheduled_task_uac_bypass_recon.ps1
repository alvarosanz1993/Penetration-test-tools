$task = Get-ScheduledTask |
  Where-Object { $_.State -ne "Disabled" -and
                 $_.Principal.Runlevel -ne "Limited" -and
                 $_.Principal.LogonType -ne "ServiceAccount" -and
                 $_.Actions[0].CimClass.CimClassName -eq "MSFT_TaskExecAction" -and
                 $_.Actions[0].Execute -match '^%.+%.+$' }

$task
