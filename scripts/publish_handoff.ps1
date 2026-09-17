param(
    [Parameter(Mandatory=$true)]
    [string]$Message,

    [string]$Remote = "origin",

    [switch]$NoPush
)

$ErrorActionPreference = "Stop"
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    throw "This directory is not a Git repository."
}

$branch = (git branch --show-current).Trim()
if ([string]::IsNullOrWhiteSpace($branch)) {
    throw "Could not determine current branch."
}

git add --all

$status = git status --porcelain
if (-not $status) {
    Write-Host "No changes to commit on $branch."
} else {
    git commit -m $Message
}

if ($NoPush) {
    Write-Host "Committed locally. Push skipped by -NoPush."
    exit 0
}

$remoteUrl = git remote get-url $Remote 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($remoteUrl)) {
    Write-Host "No remote named '$Remote' is configured. Add one with:"
    Write-Host "git remote add $Remote <YOUR_GITHUB_REPO_URL>"
    Write-Host "Then run: git push -u $Remote $branch"
    exit 0
}

git push -u $Remote $branch
Write-Host "Pushed branch: $branch"
