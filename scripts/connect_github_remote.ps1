param(
    [Parameter(Mandatory=$true)]
    [string]$RepoUrl,

    [string]$Remote = "origin"
)

$ErrorActionPreference = "Stop"
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    throw "当前目录不是 Git 仓库，请先运行 git init。"
}

$oldErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$existing = & git remote get-url $Remote 2>$null
$remoteGetExitCode = $LASTEXITCODE
$ErrorActionPreference = $oldErrorActionPreference
$remoteExists = ($remoteGetExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($existing))

if ($remoteExists) {
    git remote set-url $Remote $RepoUrl
    Write-Host "已更新远程仓库 '$Remote' 为 $RepoUrl"
} else {
    git remote add $Remote $RepoUrl
    Write-Host "已添加远程仓库 '$Remote' = $RepoUrl"
}

$branch = (git branch --show-current).Trim()
if ([string]::IsNullOrWhiteSpace($branch)) {
    $branch = "main"
}

Write-Host "下一步可运行：git push -u $Remote $branch"
