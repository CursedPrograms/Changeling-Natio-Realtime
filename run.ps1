# Changeling Natio Realtime runs in Changeling Natio's environment: it needs Changeling Natio and Changeling
# Imago Realtime next to this folder (as in Changeling Studio). Missing ones are fetched here.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
$Studio = Split-Path $PSScriptRoot -Parent
foreach ($a in @("Natio", "Imago-Realtime")) {
    $dir = Join-Path $Studio "Changeling-$a"
    if (-not (Test-Path $dir)) {
        Write-Host "Getting Changeling $a ..."
        git clone "https://github.com/CursedPrograms/Changeling-$a" $dir
    }
}

# The environment: Changeling Natio's, or a sibling's (Tiresias, Chronos and Natio need the same things).
$Py = $null
foreach ($a in @("Natio", "Tiresias", "Chronos", "Natio")) {
    $p = Join-Path $Studio "Changeling-$a\psdenv\Scripts\python.exe"
    $torch = Join-Path $Studio "Changeling-$a\psdenv\Lib\site-packages	orch"
    if (-not $Py -and (Test-Path $torch)) { $Py = $p }
}
if (-not $Py) {
    Write-Host "Setting up Changeling Natio first, once: its environment and its models."
    & (Join-Path $Studio "Changeling-Natio\run.ps1") --download-models
    $Py = Join-Path $Studio "Changeling-Natio\psdenv\Scripts\python.exe"
}
if (-not (Test-Path (Join-Path $Studio "Changeling-Imago-Realtime\venv\Scripts\python.exe"))) {
    Write-Host "Changeling Imago Realtime isn't set up yet: start its run.ps1 once, then come back."
}

& $Py live.py @args
