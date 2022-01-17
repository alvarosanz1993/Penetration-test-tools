echo "Este script recoge distinta informacion sobre la maquina que puede ayudarle al pentester en su proceso de postexplotacion. Esta informacion sera almacenada en un objeto, y sera mostrada por pantalla al finalizar la ejecucion del script"
$MewTestObject = New-Object -TypeName psobject

echo "Almacenando la version del sistema operativo..."
$MewTestObject | Add-Member -MemberType NoteProperty -Name OS -Value $(Get-WmiObject win32_operatingsystem).name
echo "Almacenando la informacion del nombre del equipo..."
$MewTestObject | Add-Member -MemberType NoteProperty -Name SystemInfo -Value $(Get-WmiObject win32_operatingsystem).CSName
echo "Almacenando las revisiones de seguridad instaladas (parches). Nos referimos a las KB de Windows..."
$MewTestObject | Add-Member -MemberType NoteProperty -Name Revisiones -Value $(GetWmiObject -Class win32_quickfixengineering).HotFixID
echo "Almacenando el listado de usuarios del grupo administradores..."
$MewTestObject | Add-Member -MemberType NoteProperty -Name UsersAdmin -Value $(Get-LocalGroupMember -Group "Administrators").Name
echo "Almacenando el nombre de los procesos que se encuentran en ejecucion en la maquina..."
$MewTestObject | Add-Member -MemberType NoteProperty -Name Procesos -Value $((Get-Process).ProcessName | select -Unique)

$MewTestObject
