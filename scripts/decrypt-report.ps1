# Run with Windows PowerShell. No key-store import or third-party dependencies.
param(
    [Parameter(Mandatory = $true)][string]$Report,
    [Parameter(Mandatory = $true)][string]$Output,
    [string]$Key,
    [string]$PasswordFile
)
$ErrorActionPreference = 'Stop'
Import-Module "$PSHOME\Modules\Microsoft.PowerShell.Security\Microsoft.PowerShell.Security.psd1"
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (-not $Key) { $Key = Join-Path $PSScriptRoot '..\.local-report-keys\report-private.pfx' }
if (Test-Path -LiteralPath $Output) { throw 'Refusing to overwrite the output file.' }
$password = if ($PasswordFile) {
    ConvertTo-SecureString ([IO.File]::ReadAllText((Resolve-Path -LiteralPath $PasswordFile)).TrimEnd("`r", "`n")) -AsPlainText -Force
} else { Read-Host 'Private-key password' -AsSecureString }
$cert = $null; $zip = $null; $reader = $null; $file = $null
try {
    $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new(
        (Resolve-Path -LiteralPath $Key).Path, $password,
        [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::EphemeralKeySet)
    $zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $Report).Path)
    $entry = $zip.GetEntry('report.cms')
    if ($zip.Entries.Count -ne 1 -or -not $entry -or $entry.Length -gt 256MB) {
        throw 'Not a supported encrypted report (expected report.cms, at most 256 MiB).'
    }
    $reader = [IO.StreamReader]::new($entry.Open())
    $bytes = [Convert]::FromBase64String((Unprotect-CmsMessage -To $cert -Content $reader.ReadToEnd()))
    # Write a ZIP only; never extract or execute a submitted report.
    $file = [IO.File]::Open($Output, [IO.FileMode]::CreateNew)
    $file.Write($bytes, 0, $bytes.Length)
} finally {
    foreach ($item in @($file, $reader, $zip, $cert, $password)) {
        if ($null -ne $item) { $item.Dispose() }
    }
}
Write-Output "Decrypted ZIP saved to $Output"
