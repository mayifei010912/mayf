$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
$p=[System.IO.Ports.SerialPort]::new('COM13',115200,[System.IO.Ports.Parity]::None,8,[System.IO.Ports.StopBits]::One)
$p.DtrEnable=$false;$p.RtsEnable=$false;$p.NewLine="`r"
try {
    $p.Open();$p.Write("`r");Start-Sleep -Milliseconds 200;$s=$p.ReadExisting()
    $cmd=@'
printf '\nHYBRID_KERNEL_FINGERPRINT_BEGIN\n'; cat /proc/version; strings /lib/modules/5.4.0/extra/dmaproxy/dmaproxy.ko | grep -E '^vermagic=|^srcversion='; if test -r /proc/config.gz; then printf '\nCONFIG_BASE64_BEGIN\n'; python3 -c 'import base64;print(base64.b64encode(open("/proc/config.gz","rb").read()).decode())'; printf '\nCONFIG_BASE64_END\n'; fi; ls -l /boot 2>/dev/null; printf '\nHYBRID_KERNEL_FINGERPRINT_END\n'
'@
    $p.WriteLine($cmd);$end=[DateTime]::UtcNow.AddSeconds(20)
    while([DateTime]::UtcNow -lt $end){Start-Sleep -Milliseconds 200;$s+=$p.ReadExisting();if($s -match "HYBRID_KERNEL_FINGERPRINT_END\r?\n"){break}}
    if($s -notmatch "HYBRID_KERNEL_FINGERPRINT_END\r?\n"){throw 'Incomplete serial response; no fingerprint saved'}
    [IO.File]::WriteAllText((Join-Path $root 'reports\board_kernel_fingerprint.txt'),$s,[Text.UTF8Encoding]::new($false))
    if($s -match '(?s)\r?\nCONFIG_BASE64_BEGIN\r?\n([A-Za-z0-9+/=\r\n]+)\r?\nCONFIG_BASE64_END'){
        $bytes=[Convert]::FromBase64String($Matches[1])
        [IO.File]::WriteAllBytes((Join-Path $root 'reports\board_kernel_config.gz'),$bytes)
    }
    $s -split "`r?`n" | Where-Object {$_ -match '^Linux version|^vermagic=|^srcversion=|^HYBRID_KERNEL|^total |^-|^d'}
} finally {if($p.IsOpen){$p.Close()};$p.Dispose()}
