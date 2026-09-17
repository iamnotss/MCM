# GitHub 仓库使用说明

这份指南说明如何用同一个 GitHub 仓库共享代码、实验摘要、图表和论文内容，以及如何让多人在不同分支协作。命令和文件名保留原样，操作说明统一使用中文。

## 1. 当前仓库与基本概念

本地目录：

    C:\Users\yangyushi\Documents\Codex\2026-08-13\new-chat

远程仓库地址：

    https://github.com/iamnotss/MCM.git

- 工作区：你正在编辑的本地文件。
- 暂存区：已经通过 git add 选中、准备提交的修改。
- 提交：本地保存的一个版本，有唯一的提交编号。
- 分支：一条独立的工作线，例如 main 或 exp/yys-anti-uap-inner-loss。
- origin：远程仓库的常用别名。
- push：把本地提交上传到远程。
- pull：把远程更新取回并整合到本地。
- 合并请求（PR）：请协作者审阅某个分支，再合并到主分支。

提交成功不等于推送成功。网络中断后，本地提交仍然保留，可以在恢复连接后重新推送，不需要重复提交。

## 2. 哪些文件应该上传

适合上传：代码、配置、训练与评估脚本、小型 CSV/JSON/JSONL、Markdown 报告、图表和简短日志。

不适合直接上传：检查点、模型权重、大规模原始数据、凭据、环境变量文件、缓存和没有分发授权的论文 PDF。

.gitignore 已包含常见忽略规则，但不是全自动检查工具：
- 已被 Git 跟踪的文件不会因为新增忽略规则而自动移除。
- work/*.pdf 被忽略，不代表其他目录下的所有 PDF 都被忽略。
- 报告提到服务器上的检查点路径，不代表其他人能从 GitHub 获取它。
- 辅助发布脚本会加入所有未忽略的工作区修改，包括已有 outputs/ 和 work/ 中符合规则的文件。

## 3. 首次提交与连接远程

打开 PowerShell：

    cd C:\Users\yangyushi\Documents\Codex\2026-08-13\new-chat
    git status --short
    git log --oneline -5

如果还没有首次提交：

    git add .gitignore README.md docs scripts templates
    git diff --cached --stat
    git commit -m "建立仓库交接流程"

如果已经看到此前的提交，就不用重复创建首次提交。

连接远程：

    .\scripts\connect_github_remote.ps1 -RepoUrl https://github.com/iamnotss/MCM.git
    git remote -v

期望的地址为纯 URL：

    origin  https://github.com/iamnotss/MCM.git (fetch)
    origin  https://github.com/iamnotss/MCM.git (push)

若地址确实错误，直接修正：

    git remote set-url origin https://github.com/iamnotss/MCM.git

随后推送：

    git push -u origin main

这些首次推送步骤适用于空远程仓库或已有兼容提交历史的仓库。如果 GitHub 上已经有 README 或其他独立提交，不要强制覆盖，应先检查历史，参见故障排查。

命令参数中的 URL 不要写成 Markdown 链接。如果聊天界面自动把 URL 显示为链接，不代表 Git 配置一定错误，以本地实际输出为准。

## 4. 每次实验的操作流程

先确认工作区没有尚未处理的修改。需要保留的修改先提交，或明确暂存后再切分支。

    git status --short
    git switch main
    git pull --ff-only origin main
    .\scripts\new_experiment_branch.ps1 -Name yys-anti-uap-inner-loss

此时分支为 exp/yys-anti-uap-inner-loss。脚本从当前提交创建分支，不会替你自动同步 main；如果本地已有同名分支，会切换到该分支。

完成任务后，将结果整理为报告与摘要，再明确选取文件提交：

    git status --short
    git add results/anti_uap_smoke/report.md results/anti_uap_smoke/summary.csv
    git diff --cached --stat
    git diff --cached
    git commit -m "补充内层扰动约束实验结果"
    git push -u origin HEAD

以上结果路径是示例，必须先创建实际文件，或替换为已有路径。

## 5. 辅助脚本怎么用

### 创建实验分支

    .\scripts\new_experiment_branch.ps1 -Name yys-radius-align-smoke

创建论文分支：

    .\scripts\new_experiment_branch.ps1 -Prefix paper -Name yys-verification-appendix

名称使用英文、数字和连字符。脚本会整理名称，不适合传入纯中文分支名。

### 连接远程

    .\scripts\connect_github_remote.ps1 -RepoUrl https://github.com/iamnotss/MCM.git

如果 origin 已存在，该脚本会更新它的地址。先确认目标仓库属于这次任务。

### 提交并推送

    .\scripts\publish_handoff.ps1 -Message "补充实验报告"

只提交到本地：

    .\scripts\publish_handoff.ps1 -Message "补充实验报告" -NoPush

重要：发布脚本会执行 git add --all，包含未忽略的新增文件、修改和删除。想只提交指定文件时，请使用第 4 节的手动命令。

检查 Git 实际输出与退出状态，不要只依赖脚本最后显示的提示。推送后在 GitHub 核对分支和提交编号。

## 6. 分支命名

| 前缀 | 内容 | 示例 |
| --- | --- | --- |
| exp/ | 实验与诊断 | exp/yys-anti-uap-inner-loss |
| fig/ | 科研绘图 | fig/hy-umap-diagnostics |
| paper/ | 论文内容与排版 | paper/yys-verification-appendix |
| fix/ | 程序修复 | fix/hy-checkpoint-loading |

多人使用时，在任务名前加负责人缩写。避免多人直接编辑同一个分支。

完整规则见 [分支规范](BRANCHING.md)。

## 7. 实验目录建议

    results/anti_uap_smoke/
      report.md
      summary.csv
      config.json
      per_sample.csv
      notes.md

    figures/anti_uap_smoke/
      figure.pdf
      figure.png
      caption.tex

    scripts/
      run_anti_uap_smoke.py
      plot_anti_uap_smoke.py

每次独立运行可以在实验目录下面增加种子或运行时间子目录，避免覆盖旧结果。

检查点放在 saves/ 或 checkpoints/ 等已忽略目录。原始数据单独管理，报告注明数据版本、获取方式和访问限制。

## 8. 每份实验报告需要什么

使用 [实验报告模板](../templates/experiment_report.md)，至少填写：

- 要回答的实验问题。
- 代码提交编号、模型与初始化来源。
- 数据清单、划分、样本量、随机种子。
- 实际生效的配置与执行命令。
- 指标定义和生成参数。
- 结果、失败检查、不能推出的结论。
- 图表、摘要和原始本地材料的位置。

对于 StealthMark，应明确 WSR 与 FPR 的输入条件，以及编码器和扰动是否来自同一次训练、同一 epoch。不要只写“使用默认配置”。

## 9. 给其他 AI 的交接方式

先确认接手环境能够访问指定仓库和分支。私有仓库需要授权；只有链接并不自动具备读取、运行或推送权限。

### 网页版 GPT 与 Codex 如何通过 GitHub 协作

可以把 GitHub 当成一个共享笔记本和文件中转站。推荐分工是：Codex 负责改代码、跑实验、生成图表和提交结果；网页版 GPT 负责读取分支中的报告、表格和脚本，帮助分析结果、判断问题并生成下一轮给 Codex 的执行指令。

基本闭环如下：

    Codex 完成代码、实验或图表
    Codex 将结果 commit 到任务分支并 push 到 GitHub
    你把仓库、分支、提交编号和关键文件发给网页版 GPT
    网页版 GPT 基于这些文件分析结果并给出下一步指令
    你把下一步指令发回 Codex
    Codex 新建或更新任务分支继续执行

每次 Codex 完成任务后，建议输出如下交接信息：

    仓库：https://github.com/iamnotss/MCM
    分支：exp/yys-anti-uap-inner-loss
    提交编号：填写实际提交编号
    关键文件：
    - results/anti_uap_smoke/report.md
    - results/anti_uap_smoke/summary.csv
    - scripts/run_anti_uap_smoke.py
    下一步建议：请分析 FPR 是否下降，以及 WSR 和 CIDEr 是否崩塌。

把结果交给网页版 GPT 时，可以这样写：

    请读取这个 GitHub 仓库和分支，并基于实际文件帮我分析结果。

    仓库：https://github.com/iamnotss/MCM
    分支：exp/yys-anti-uap-inner-loss
    提交编号：填写实际提交编号

    请优先阅读：
    - results/anti_uap_smoke/report.md
    - results/anti_uap_smoke/summary.csv
    - scripts/run_anti_uap_smoke.py

    任务：判断 anti-UAP inner constraint 是否降低了 FPR，同时是否保持 WSR 和 CIDEr。

    要求：
    - 先说明实际读取了哪些文件。
    - 不要假设 GitHub 上没有的 checkpoint 或 raw data。
    - 区分已确认、推测和无法判断。
    - 最后生成一段可以直接喂给 Codex 的下一步执行指令。

把网页版 GPT 的建议交回 Codex 时，可以这样写：

    请从以下 GitHub 分支继续：

    仓库：https://github.com/iamnotss/MCM
    起点分支：exp/yys-anti-uap-inner-loss
    参考提交：填写实际提交编号

    任务：填写网页版 GPT 给出的执行指令。

    要求：
    - 新建自己的任务分支，不直接改 main。
    - 不覆盖已有结果。
    - 不提交 checkpoint、模型权重、raw data 或密钥。
    - 保存 report.md、summary.csv 和必要脚本。
    - 完成后 commit 并 push。
    - 最后报告新分支、提交编号和关键文件。

如果网页版 GPT 不能直接访问 GitHub，就把 report.md、summary.csv 或关键脚本作为文件上传，或粘贴经过检查的摘要。不要让它根据不存在的仓库内容推测结果。

可以发送：

    仓库：https://github.com/iamnotss/MCM
    分支：exp/yys-anti-uap-inner-loss
    提交编号：填写实际提交编号
    请先读 results/anti_uap_smoke/report.md 和 summary.csv。
    分析 FPR 是否下降，WSR 和 CIDEr 是否保持。
    本次只读分析，不修改代码，不启动训练。
    请说明实际读取的文件，无法访问的内容不要猜测。

需要修改时，另外明确新分支名、允许修改的范围和是否允许提交推送。完整模板见 [AI 交接提示词](WEB_CODEX_PROMPT.md)。

仓库交接减少手动粘贴，但读取文件仍会消耗上下文，不能保证一定节省使用额度。

## 10. 推送后的交接消息

    已推送到 exp/yys-anti-uap-inner-loss。
    提交编号：填写实际值
    主要修改：补充约束实现和小规模实验报告。
    关键文件：
    - src/align_loss.py
    - results/anti_uap_smoke/report.md
    - results/anti_uap_smoke/summary.csv
    检查点保留在服务器 saves/ 中，没有上传。
    下一步：检查实验可比性，不启动完整训练。

路径与实验内容均需按实际情况填写。更多要求见 [交接规范](HANDOFF.md)。

## 11. 多人共同使用一个仓库

### 仓库负责人配置

在 GitHub 仓库设置中添加协作者；界面中通常可在 Settings 下找到 Collaborators 或访问管理入口。每人用自己的账号接受邀请，不共享账号密码或令牌。

按需要分配读取或写入权限。组织仓库可通过团队分配权限。

在仓库支持的情况下，为 main 设置规则集或分支保护：
- 修改通过合并请求进入主分支。
- 至少一名其他成员审阅训练、评估和指标相关修改。
- 避免直接强制推送或删除主分支。
- 如果已有自动检查，将必要检查设为合并条件。

具体可用选项取决于仓库类型与 GitHub 套餐。

### 成员第一次加入

每个人在自己的电脑或服务器克隆：

    git clone https://github.com/iamnotss/MCM.git
    cd MCM

为当前仓库配置真实的提交身份，替换下面的示例：

    git config user.name "你的姓名"
    git config user.email "你的提交邮箱"

如果使用 GitHub 提供的隐私邮箱，可以在账户设置中查找对应地址。提交身份不等于登录认证，访问私有仓库仍需权限。

每个人使用自己的工作目录。同一服务器上同时运行多个任务时，使用独立克隆或工作树，不在同一个工作目录来回切分支。

### 每人独立开发

    git switch main
    git pull --ff-only origin main
    git switch -c exp/hy-radius-align-smoke

完成后：

    git add results/radius_smoke/report.md
    git commit -m "补充半径对齐诊断"
    git push -u origin exp/hy-radius-align-smoke

选择实际修改过的文件。不要提交他人的未完成内容。

### 发起合并请求

在 GitHub 选择自己的分支，创建合并请求：
- 目标分支选择 main。
- 来源分支选择自己的任务分支。
- 描述目标、修改内容、检查方式和结果。
- 说明未上传的模型、数据及无法复现的部分。
- 邀请负责相关模块的人审阅。

审阅通过并解决讨论后，由负责人合并。合并后其他成员同步 main；确认不再需要后再删除任务分支。

### 分工原则

尽量按文件或模块分工：
- 一人维护损失实现，另一人负责评估或绘图。
- 多人写论文时可按章节文件分工。
- 不同实验使用独立结果目录。
- 若必须修改同一文件，先约定合并顺序，再同步继续工作。

## 12. 同步与冲突处理

自己的分支需要吸收最新 main 时：

    git fetch origin
    git switch exp/hy-radius-align-smoke
    git merge origin/main

如果出现冲突：

1. 用 git status 找出冲突文件。
2. 阅读双方修改，确定预期的最终内容。
3. 删除冲突标记并保留正确内容。
4. 执行相应检查。
5. 只暂存已解决的文件，完成提交。

    git add 路径
    git commit -m "合并主分支并解决冲突"

“路径”需要替换成真实文件。若尚未解决、希望退出本次合并，可使用 git merge --abort；合并前应先处理自己的未提交工作。

不要手工拼接不同实验配置的 CSV。保留独立目录，说明差异。

熟悉 Git 的成员可以对未共享分支使用 rebase。共享分支优先 merge，不随意改写他人依赖的历史。

## 13. 常用查询与提交检查

查看当前分支、变更、提交和远程：

    git branch --show-current
    git status --short
    git log --oneline -5
    git rev-parse HEAD
    git remote -v

检查暂存内容：

    git diff --cached --stat
    git diff --cached

取消某个文件的暂存，不删除工作区文件：

    git restore --staged 路径

首次提交前尚无 HEAD 时，取消暂存可使用 git rm --cached -- 路径；不要添加删除工作区文件的选项。

确认一个文件为何被忽略：

    git check-ignore -v 路径

## 14. 常见问题

### 换行符提示

LF will be replaced by CRLF 是 Windows 常见的换行提示，不代表提交失败。团队可以另行用 .gitattributes 统一换行策略，不需要为了消除提示重做首次提交。

### 找不到 origin

先运行 git remote -v。确实未配置时：

    git remote add origin https://github.com/iamnotss/MCM.git

已有 origin 时使用 set-url，而不是重复 add。

### 无法连接 GitHub 或连接被重置

这是网络连接失败，不能仅凭该错误认定 URL、认证或代理中的哪一项有问题。先核实远程地址及浏览器连接情况。

如果确实使用本机 HTTP 代理，先在代理软件中确认监听端口，不要猜测端口。
例如已确认是 7897，可以检查：

    Test-NetConnection 127.0.0.1 -Port 7897

然后用一次性配置试推送，不修改全局 Git 设置：

    git -c http.proxy=http://127.0.0.1:7897 push -u origin main

确认有效且需要长期使用时，只给当前仓库配置：

    git config --local http.proxy http://127.0.0.1:7897

删除当前仓库的这项配置：

    git config --local --unset http.proxy

没有全局代理配置并不代表一定无法直连 GitHub。设置代理后连接仍失败，应检查代理是否支持 HTTP、是否正常运行及其网络可达性。

### 认证失败或没有仓库权限

确认账号有该仓库的访问权限。使用 Git Credential Manager、GitHub Desktop 或已配置的 SSH 密钥认证。不要把密码或令牌写入 remote URL、提交文件或聊天记录。

### 远程已有提交，推送被拒绝

先查看历史：

    git fetch origin
    git log --oneline --graph --all -15

如果历史相关，整合远程更新后重试。如果本地和远程各自独立初始化，优先另建目录克隆远程仓库，再复制本次需要的文件并提交。不要直接强制推送覆盖远程内容。

### 大文件被拒绝

检查是否误提交了检查点或数据。仅补充 .gitignore 或在下一次提交删除文件，不会移除旧提交里的大文件。先停止推送，根据是否已共享历史选择修复方式，不随意改写协作者正在使用的历史。

### PowerShell 中文显示异常

脚本使用 UTF-8 BOM 编码以兼容 Windows PowerShell 5.1 的中文源文件。用支持 UTF-8 的编辑器查看文档；Git 自身的输出语言由其安装与终端环境决定。

### 当前环境不能写 .git

文件编辑成功与 Git 提交成功是两回事。如果受环境权限限制，可以在有权限的本机终端执行明确范围的 git add、git commit 和 git push。不要把未提交状态说成已上传。

## 15. 项目约定

- main 保存经审阅的代码、文稿和结果。
- 每人每项任务使用独立分支。
- 每个实验保留报告、配置和摘要。
- 检查点和原始数据由独立存储管理。
- 推送前检查实际文件，确认没有凭据或无授权分发内容。
- 交接提供分支与提交编号，接手者核实实际文件。
- 当前目录中的辅助脚本用于 Windows PowerShell；Linux 服务器可使用等价 Git 命令。
