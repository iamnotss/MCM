param(
    [Parameter(Mandatory=$true)]
    [string]$RepoUrl,

    [string]$Remote = "origin"
)

$ErrorActionPreference = "Stop"
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    throw "This directory is not a Git repository. Run git init first."
}

$oldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$existing = & git remote get-url $Remote 2>$null
$remoteGetExitCode = $LASTEXITCODE
$ErrorActionPreference = $oldErrorActionPreference
$remoteExists = ($remoteGetExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($existing))

if ($remoteExists) {
    git remote set-url $Remote $RepoUrl
    Write-Host "Updated remote '$Remote' to $RepoUrl"
} else {
    git remote add $Remote $RepoUrl
    Write-Host "Added remote '$Remote' = $RepoUrl"
}

$branch = (git branch --show-current).Trim()
if ([string]::IsNullOrWhiteSpace($branch)) {
    $branch = "main"
}

Write-Host "Next command: git push -u $Remote $branch"
