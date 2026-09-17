# GitHub 实验与文档交接仓库

本仓库用于在本地、远程实验服务器和协作者之间共享代码、配置、实验摘要与论文图表。每次交接提供仓库地址、分支、提交编号和关键文件，减少重复粘贴长日志。

仓库地址：https://github.com/iamnotss/MCM

## 文档入口

- [完整使用说明](docs/USAGE.md)：首次配置、日常使用、多人协作和常见问题。
- [交接规范](docs/HANDOFF.md)：每次交接需要提供的材料。
- [分支规范](docs/BRANCHING.md)：命名、同步和合并规则。
- [AI 交接提示词](docs/WEB_CODEX_PROMPT.md)：可直接填写的中文模板。
- [实验报告模板](templates/experiment_report.md)：设置、指标、结论和局限。

## 基本流程

1. 从同步后的主分支创建自己的任务分支。
2. 完成修改或实验，整理配置、结果摘要和报告。
3. 检查待提交文件，提交并推送自己的分支。
4. 通过合并请求让协作者审阅，再合并到 main。
5. 交接时提供分支、提交编号和关键文件。

## 常用操作

连接远程仓库：

    .\scripts\connect_github_remote.ps1 -RepoUrl https://github.com/iamnotss/MCM.git

创建实验分支：

    .\scripts\new_experiment_branch.ps1 -Name yys-anti-uap-inner-loss

推荐明确选择文件再提交：

    git status --short
    git add README.md docs scripts templates .gitignore
    git diff --cached --stat
    git commit -m "更新中文说明与交接模板"
    git push -u origin HEAD

辅助发布脚本会执行 git add --all，将整个工作区内未被忽略的变更加入提交。确认所有变更都属于本次任务后再使用：

    .\scripts\publish_handoff.ps1 -Message "补充实验结果报告"

## 文件与访问边界

提交代码、配置、小型 CSV/JSON、图表和报告。模型权重、原始数据、凭据及缓存保留在受控存储中。

提供 GitHub 链接并不自动授予另一个 AI 读取或写入权限。私有仓库需要相应授权；无法访问时提供经过检查的报告和摘要文件。
