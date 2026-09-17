# Codex GitHub Handoff Workspace

This repository is a lightweight handoff point between Codex, web ChatGPT, and any remote experiment environment.

## Intended workflow

1. Create a branch for each experiment or writing task.
2. Commit only code, configs, figures, tables, compact logs, and reports.
3. Keep model weights, checkpoints, raw datasets, credentials, and private large artifacts out of Git.
4. Push the branch to GitHub.
5. Tell the next AI or collaborator the repository, branch name, and key files to inspect.

## Quick commands

Create a branch:

    ./scripts/new_experiment_branch.ps1 -Name anti-uap-inner-loss

Commit and push current work:

    ./scripts/publish_handoff.ps1 -Message "Add anti-UAP smoke test report"

If no GitHub remote has been configured yet, add one first:

    git remote add origin <YOUR_GITHUB_REPO_URL>
    git push -u origin main

Or use the helper script:

    ./scripts/connect_github_remote.ps1 -RepoUrl <YOUR_GITHUB_REPO_URL>
    ./scripts/publish_handoff.ps1 -Message "Initial handoff setup"

## Handoff summary template

Use templates/experiment_report.md for experiment results, docs/HANDOFF.md for branch handoff notes, and docs/WEB_CODEX_PROMPT.md when handing a branch to web ChatGPT or another AI.

For the full step-by-step workflow, see docs/USAGE.md.
