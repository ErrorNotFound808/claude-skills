<#
.SYNOPSIS
  Import the exported skills into a Claude Code installation.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File install.ps1
  powershell -ExecutionPolicy Bypass -File install.ps1 -Project C:\path\to\repo
  powershell -ExecutionPolicy Bypass -File install.ps1 -WithGstack -WithLearnings -Force
#>
param(
  [string]$Project,
  [switch]$WithGstack,
  [switch]$WithLearnings,
  [switch]$Force
)

$ErrorActionPreference = "Stop"
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($Project) { $TargetRoot = Join-Path $Project ".claude" }
else          { $TargetRoot = Join-Path $HOME ".claude" }

$Dest = Join-Path $TargetRoot "skills"
if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Force -Path $Dest | Out-Null }

Write-Host "Installing into: $Dest"
Write-Host ""

$script:installed = 0
$script:skipped   = 0

function Copy-Skill([string]$SrcDir) {
  $name = Split-Path $SrcDir -Leaf
  $out  = Join-Path $Dest $name
  if ((Test-Path $out) -and (-not $Force)) {
    Write-Host "  skip (exists): $name"
    $script:skipped++
    return
  }
  if (Test-Path $out) { Remove-Item -Recurse -Force $out }
  Copy-Item -Recurse -Force $SrcDir $out
  Write-Host "  installed: $name"
  $script:installed++
}

Write-Host "Core skills:"
Get-ChildItem -Directory (Join-Path $Here "skills") | ForEach-Object { Copy-Skill $_.FullName }

if ($WithGstack) {
  Write-Host ""
  Write-Host "gstack wrapper skills (require the gstack repo at ~/.claude/skills/gstack):"
  Get-ChildItem -Directory (Join-Path $Here "optional\gstack-skills") | ForEach-Object { Copy-Skill $_.FullName }
}

if ($WithLearnings) {
  Write-Host ""
  Write-Host "Raw memory files:"
  $src = Join-Path $Here "learnings\raw-memory"
  Get-ChildItem -Directory $src | ForEach-Object {
    $out = Join-Path $TargetRoot ("imported-memory\" + $_.Name)
    New-Item -ItemType Directory -Force -Path $out | Out-Null
    Copy-Item -Recurse -Force (Join-Path $_.FullName "*") $out
    Write-Host ("  copied: " + $_.Name + " -> " + $out)
  }
  Write-Host ""
  Write-Host "  NOTE: memory lives per project under ~/.claude/projects/<slug>/memory/."
  Write-Host "  Move each folder into the matching project slug on this machine."
}

Write-Host ""
Write-Host ("Done. installed=" + $script:installed + " skipped=" + $script:skipped)
Write-Host "Restart Claude Code (or start a new session) to pick up the new skills."
