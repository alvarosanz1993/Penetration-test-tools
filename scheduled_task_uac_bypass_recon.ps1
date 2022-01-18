echo "Identificando tareas programadas debiles a una inyeccion de variables de entorno..."
$task = Get-ScheduledTask |
  Where-Object { $_.State -ne "Disabled" -and
                 $_.Principal.Runlevel -ne "Limited" -and
                 $_.Principal.LogonType -ne "ServiceAccount" -and
                 $_.Actions[0].CimClass.CimClassName -eq "MSFT_TaskExecAction" -and
                 $_.Actions[0].Execute -match '^%.+%.+?$' }

$task

echo "Identificando el nombre de las variables de entorno debiles..."
$pattern = '(?<=\%).+?(?=\%)'
$testText = $task | ForEach-Object {(Get-ScheduledTask $_.TaskName).Actions[0]} | ForEach-Object {[regex]::Matches($_.Execute, $pattern).Value}
$testText
