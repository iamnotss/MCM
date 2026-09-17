param(
    [Parameter(Mandatory=$true)]
    [string]$Message,

    [string]$Remote = "origin",

    [switch]$NoPush
)

$ErrorActionPreference = "Stop"
git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    throw "当前目录不是 Git 仓库。"
}

$branch = (git branch --show-current).Trim()
if ([string]::IsNullOrWhiteSpace($branch)) {
    throw "无法确定当前分支。"
}

git add --all

$status = git status --porcelain
if (-not $status) {
    Write-Host "当前分支 $branch 没有需要提交的变更。"
} else {
    git commit -m $Message
}

if ($NoPush) {
    Write-Host "已完成本地提交；由于使用 -NoPush，已跳过推送。"
    exit 0
}

$remoteUrl = git remote get-url $Remote 2>$null
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($remoteUrl)) {
    Write-Host "尚未配置名为 '$Remote' 的远程仓库。可先运行："
    Write-Host "git remote add $Remote <YOUR_GITHUB_REPO_URL>"
    Write-Host "然后运行：git push -u $Remote $branch"
    exit 0
}

git push -u $Remote $branch
Write-Host "已推送分支：$branch"
