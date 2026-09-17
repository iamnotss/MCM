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
        throw "分支名清理后为空，请使用英文、数字或连字符命名。"
    }
    return $safe
}

$branchName = "$(Sanitize-BranchPart $Prefix)/$(Sanitize-BranchPart $Name)"

git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    throw "当前目录不是 Git 仓库，请先运行 git init。"
}

$existing = git branch --list $branchName
if ($existing) {
    git switch $branchName
} else {
    git switch -c $branchName
}

Write-Host "当前分支：$branchName"
