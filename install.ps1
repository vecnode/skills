# install.ps1 — symlink all skills into %USERPROFILE%\.claude\skills\
# Run in an elevated (Administrator) PowerShell session for symlink creation.

$repoRoot  = $PSScriptRoot
$skillsSrc = Join-Path $repoRoot "skills"
$skillsDst = Join-Path $env:USERPROFILE ".claude\skills"

New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null

Get-ChildItem -Path $skillsSrc -Directory | ForEach-Object {
    $name   = $_.Name
    $source = $_.FullName
    $target = Join-Path $skillsDst $name

    if (Test-Path $target) {
        $item = Get-Item $target -Force
        if ($item.LinkType -eq "SymbolicLink" -or $item.LinkType -eq "Junction") {
            Write-Host "up-to-date  $name"
        } else {
            Write-Host "skip        $name  (exists as real file/dir, remove it manually)"
        }
        return
    }

    try {
        New-Item -ItemType SymbolicLink -Path $target -Target $source -ErrorAction Stop | Out-Null
        Write-Host "linked      $name  (symlink)"
    } catch {
        # Symlinks require Administrator or Developer Mode. Junctions don't.
        try {
            New-Item -ItemType Junction -Path $target -Target $source -ErrorAction Stop | Out-Null
            Write-Host "linked      $name  (junction)"
        } catch {
            Write-Host "FAILED      $name  ($($_.Exception.Message))"
        }
    }
}

Write-Host ""
Write-Host "Done. Skills available at: $skillsDst"
