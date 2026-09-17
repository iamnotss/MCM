param(
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [string]$Prefix = "exp"
)

$ErrorActionPreference = "Stop"

function Sanitize-BranchPart([string]$value) {
    $safe = $value.Trim().ToLowerInvariant()
    $safe = $safe -replace "[^a-z0-9._-]+", "-"
    $safe = $safe -replace "-+", "-"
    $safe = $safe.Trim("-", ".", "_")
    if ([string]::IsNullOrWhiteSpace($safe)) {
        throw "Branch name became empty after sanitization."
    }
    return $safe
}

$branchName = "$(Sanitize-BranchPart $Prefix)/$(Sanitize-BranchPart $Name)"

git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    throw "This directory is not a Git repository. Run git init first."
}

$existing = git branch --list $branchName
if ($existing) {
    git switch $branchName
} else {
    git switch -c $branchName
}

Write-Host "Current branch: $branchName"
