<#
    Re-exports the Bad Duck logo PNGs from the SVG masters.

    Renders through headless Edge so the output matches exactly what a browser
    draws - including the clip-path on the shades, which some standalone SVG
    rasterisers handle differently.

    Usage:  pwsh brand/render-logo.ps1
#>
[CmdletBinding()]
param(
    [int[]] $Sizes = @(1024, 512, 288),
    [string] $Edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
)

$ErrorActionPreference = 'Stop'
$brand = $PSScriptRoot
if (-not (Test-Path $Edge)) { throw "Edge not found at $Edge" }

$work = Join-Path $env:TEMP "bd-render-$(Get-Random)"
New-Item -ItemType Directory -Path $work -Force | Out-Null

function Export-Logo {
    param([string] $SvgPath, [int] $Size, [string] $OutPng, [switch] $Transparent)

    $svg  = (Get-Content $SvgPath -Raw) -replace 'width="64" height="64"', "width=`"$Size`" height=`"$Size`""
    $html = "<!DOCTYPE html><html><head><meta charset='utf-8'>" +
            "<style>html,body{margin:0;padding:0;background:transparent}svg{display:block}</style>" +
            "</head><body>$svg</body></html>"

    Remove-Item $OutPng -Force -ErrorAction SilentlyContinue

    # Edge's headless screenshot occasionally never exits; retry rather than fail the run.
    foreach ($attempt in 1..3) {
        $stamp    = "$Size-$(Get-Random)"
        $htmlFile = Join-Path $work "render-$stamp.html"
        Set-Content -Path $htmlFile -Value $html -Encoding UTF8

        $userDataDir = Join-Path $work "profile-$stamp"
        $params = @(
            '--headless=new', '--disable-gpu', '--no-sandbox', '--hide-scrollbars'
            "--user-data-dir=$userDataDir", '--force-device-scale-factor=1'
            "--window-size=$Size,$Size", "--screenshot=$OutPng"
        )
        if ($Transparent) { $params += '--default-background-color=00000000' }
        $params += "file:///$($htmlFile -replace '\\','/')"

        $proc = Start-Process $Edge -PassThru -WindowStyle Hidden -ArgumentList $params
        $exited = $proc.WaitForExit(45000)
        if (-not $exited) { $proc.Kill() | Out-Null }
        Remove-Item $userDataDir -Recurse -Force -ErrorAction SilentlyContinue

        if (Test-Path $OutPng) { return }
        Write-Warning "render attempt $attempt failed for $(Split-Path $OutPng -Leaf); retrying"
    }

    throw "render failed after 3 attempts: $OutPng"
}

try {
    foreach ($size in $Sizes) {
        Export-Logo -SvgPath "$brand\bad-duck-logo-dark.svg" -Size $size -OutPng "$brand\bad-duck-logo-dark-$size.png"
        Export-Logo -SvgPath "$brand\bad-duck-logo.svg"      -Size $size -OutPng "$brand\bad-duck-logo-$size.png" -Transparent
        Write-Host "exported ${size}px"
    }
}
finally {
    Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue
}

Add-Type -AssemblyName System.Drawing
Get-ChildItem "$brand\*.png" | Sort-Object Name | ForEach-Object {
    $bmp = [System.Drawing.Bitmap]::FromFile($_.FullName)
    $corner = $bmp.GetPixel(2, 2)
    '{0,-32} {1}x{2}  corner-alpha={3}' -f $_.Name, $bmp.Width, $bmp.Height, $corner.A
    $bmp.Dispose()
}
