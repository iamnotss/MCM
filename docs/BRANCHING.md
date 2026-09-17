# 分支与提交规范

## 分支类型

| 前缀 | 用途 | 示例 |
| --- | --- | --- |
| exp/ | 实验与诊断 | exp/yys-anti-uap-inner-loss |
| fig/ | 绘图与样式修改 | fig/hy-umap-diagnostics |
| paper/ | 论文正文与排版 | paper/yys-verification-appendix |
| fix/ | 代码修复 | fix/hy-checkpoint-loading |

分支名使用简短英文、数字和连字符；说明与提交消息使用中文。避免使用 test、final、fix2 等无法表达目的的名称。

## 创建与同步

先提交自己的工作或妥善暂存，确认工作区状态，再执行：

    git switch main
    git pull --ff-only origin main
    .\scripts\new_experiment_branch.ps1 -Name yys-anti-uap-inner-loss

脚本从当前分支创建新分支，不会自动切回 main；遇到同名本地分支会切换过去。使用前确认自己的起点。

主分支更新后，在自己的分支执行：

    git fetch origin
    git merge origin/main

已经共享的分支优先采用 merge，不随意变基或强制推送他人的提交。

## 提交消息

使用简短、可核对的中文描述，例如：

- 增加内层扰动约束的梯度检查
- 补充黑盒水印验证附录
- 统一消融图字体与配色

## 合并要求

main 保存经审阅的内容。每个人在独立分支工作，通过合并请求汇入 main。实验分支应包含目标、实际配置、执行命令、摘要指标、输出路径和局限；检查点与原始数据不随分支上传。
