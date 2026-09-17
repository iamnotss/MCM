# GitHub Handoff Usage Guide

This guide explains how to use this workspace as a GitHub handoff bridge between local Codex, web ChatGPT, VSCode, and other experiment environments.

The goal is simple: keep code, compact results, figures, and reports in GitHub branches, so another AI or collaborator can continue from a branch instead of reading long pasted logs in chat.

## 1. What This Workflow Solves

Use this workflow when you want to:

- Let Codex modify code locally and push the result to GitHub.
- Ask web ChatGPT to inspect a specific branch and analyze results.
- Keep experiment results traceable by branch and commit.
- Avoid pasting long logs, scripts, CSV files, and figure paths into chat.
- Separate different experiments, figures, and manuscript edits cleanly.

The repository should contain reproducible materials, not large private artifacts.

## 2. What Should Be Committed

Commit these files:

- Source code changes.
- Training and evaluation scripts.
- Config files.
- Compact experiment outputs such as .csv, .json, .jsonl, and .md reports.
- Manuscript-ready figures such as .pdf, .png, and .svg.
- Short diagnostic logs that explain what happened.

Do not commit these files:

- Model checkpoints or weights, such as .bin, .pt, .pth, .ckpt, .safetensors.
- Raw datasets or large downloaded data.
- API keys, tokens, cookies, credentials, or .env files.
- Full cache folders or temporary training outputs.
- Private papers or licensed PDFs unless you are sure they can be shared.

The .gitignore file already excludes common checkpoint, dataset, cache, and secret patterns.

## 3. First-Time Setup

Open PowerShell in this workspace:

    cd C:\Users\yangyushi\Documents\Codex\2026-08-13\new-chat

Check the current files:

    git status --short

Create the first commit:

    git add .gitignore README.md docs scripts templates
    git commit -m "Set up Codex GitHub handoff workflow"

Create an empty GitHub repository in your GitHub account. Then connect this local repository to it:

    .\scripts\connect_github_remote.ps1 -RepoUrl <YOUR_GITHUB_REPO_URL>

Push the first branch:

    git push -u origin main

Example GitHub URL formats:

    https://github.com/<user>/<repo>.git
    git@github.com:<user>/<repo>.git

Use HTTPS if your GitHub Desktop or credential manager is already logged in. Use SSH only if your SSH key is configured.

## 4. Daily Experiment Workflow

For every new experiment, create a separate branch.

Example: anti-UAP inner-loss experiment

    .\scripts\new_experiment_branch.ps1 -Name anti-uap-inner-loss

This creates or switches to:

    exp/anti-uap-inner-loss

Run the experiment or ask Codex to edit the relevant code. When the work is ready, prepare a compact report using:

    templates/experiment_report.md

Recommended report location:

    results/<experiment_name>/report.md

Recommended summary table location:

    results/<experiment_name>/summary.csv

Then commit and push:

    .\scripts\publish_handoff.ps1 -Message "Add anti-UAP inner loss smoke test"

If you only want to commit locally without pushing:

    .\scripts\publish_handoff.ps1 -Message "Add anti-UAP inner loss smoke test" -NoPush

## 5. Branch Naming Rules

Use short branches that describe the task.

Recommended prefixes:

- exp/ for experiments and diagnostics.
- fig/ for figure creation or restyling.
- paper/ for manuscript text and LaTeX edits.
- fix/ for focused code fixes.

Examples:

    exp/anti-uap-inner-loss
    exp/radius-align-smoke
    exp/epoch-ablation
    fig/umap-diagnostics
    paper/blackbox-verification-appendix

Avoid vague names such as test, new, final, or fix2.

## 6. How To Hand Off To Web ChatGPT Or Another AI

After pushing a branch, send the next AI a short message like this:

    Repository: https://github.com/<user>/<repo>
    Branch: exp/anti-uap-inner-loss

    Task:
    Please inspect the branch and analyze results/anti_uap_smoke/summary.csv.
    Tell me whether the anti-UAP inner constraint reduces FPR without collapsing WSR or CIDEr.

    Important rules:
    - Treat committed files as the source of truth.
    - Do not assume checkpoints or raw data are available in Git.
    - Read the experiment report first if present.
    - Summarize which files you used before drawing conclusions.

You can also copy the template from:

    docs/WEB_CODEX_PROMPT.md

## 7. How To Ask Codex To Continue From A Branch

When asking Codex or another local agent to continue work, provide:

- Repository URL.
- Branch name.
- Exact task.
- Files or folders that matter.
- What must not be changed.

Example:

    Please continue from branch exp/radius-align-smoke.
    Inspect src/align_loss.py and results/radius_smoke/summary.csv.
    Do not start long training. Only check whether beta=0 reproduces the old L_align and whether the radius term has gradients to delta and Fw.

Good handoffs are specific. Avoid asking only: Continue the experiment.

## 8. Recommended Experiment Folder Layout

For each experiment, use a compact structure like this:

    results/<experiment_name>/
      report.md
      summary.csv
      config.json
      per_sample.csv
      notes.md

    figures/<experiment_name>/
      figure.pdf
      figure.png
      caption.tex

    scripts/
      run_<experiment_name>.py
      plot_<experiment_name>.py

If checkpoints are produced, keep them outside Git or under ignored paths such as:

    saves/
    checkpoints/
    models/

In the report, mention checkpoint paths as local paths only if needed, but do not commit the files.

## 9. Minimal Experiment Report Template

Every experiment branch should include a short report with:

- Goal: what question the run answers.
- Setup: model, data split, seed, checkpoint, and key config.
- Metrics: WSR, FPR, clean-input hit, CIDEr or ACC_uti.
- Findings: what changed and what did not.
- Limitations: what cannot be concluded yet.
- Files: where the CSV, JSON, figure, and logs are stored.

Use this template:

    templates/experiment_report.md

## 10. Common Commands

Check current branch:

    git branch --show-current

Check changed files:

    git status --short

Show recent commits:

    git log --oneline -5

Create a new experiment branch:

    .\scripts\new_experiment_branch.ps1 -Name radius-align-smoke

Create a paper branch:

    .\scripts\new_experiment_branch.ps1 -Prefix paper -Name blackbox-verification-appendix

Commit and push:

    .\scripts\publish_handoff.ps1 -Message "Update black-box verification appendix"

Update the GitHub remote URL:

    .\scripts\connect_github_remote.ps1 -RepoUrl <YOUR_GITHUB_REPO_URL>

## 11. Before Pushing

Always check what will be committed:

    git status --short

If you see checkpoint files, raw data, or secrets, stop and update .gitignore before committing.

Useful checks:

    git diff --stat
    git diff --cached --stat

If a file is already staged by mistake, unstage it:

    git restore --staged <path>

If a large file was committed accidentally, do not keep pushing. Remove it from Git history before sharing the repository.

## 12. Suggested Handoff Message After Each Push

After pushing, report something like:

    Done. Pushed to branch exp/anti-uap-inner-loss.
    Main changes:
    - Added anti-UAP inner loss implementation.
    - Added 5-epoch smoke test report.
    Key files:
    - src/align_loss.py
    - results/anti_uap_smoke/summary.csv
    - results/anti_uap_smoke/report.md
    Notes:
    - Checkpoints remain local under saves/ and were not pushed.

This gives web ChatGPT or another AI enough context to continue without a long chat transcript.

## 13. Troubleshooting

### No remote named origin

Run:

    .\scripts\connect_github_remote.ps1 -RepoUrl <YOUR_GITHUB_REPO_URL>

Then push again:

    git push -u origin <branch-name>

### Authentication failed

Use GitHub Desktop, Git Credential Manager, or SSH keys to sign in. After authentication works once, the scripts should reuse it.

### Large file rejected by GitHub

The file is probably a checkpoint, model weight, raw dataset, or cache. Remove it from the commit and keep only summaries, figures, configs, and scripts.

### Branch already exists

The branch script switches to the existing branch automatically. Check your current branch with:

    git branch --show-current

### Codex cannot commit in this environment

In some sandboxed Codex environments, writing to .git metadata may be restricted. If that happens, Codex can still edit files, and you can run the final git add, git commit, and git push commands manually in PowerShell.

## 14. Privacy And Safety Checklist

Before making a repository public, confirm that it does not contain:

- Private model weights.
- Dataset files with license restrictions.
- API keys or service credentials.
- Unpublished paper PDFs that should not be redistributed.
- Reviewer comments or confidential submission material.
- Full logs containing usernames, tokens, paths, or account information.

For the StealthMark project, the safest default is to push:

- Code patches.
- Experiment configs.
- Small CSV/JSON summaries.
- Figure PDFs/PNGs/SVGs.
- Manuscript snippets and captions.

Keep checkpoints and raw datasets local unless you deliberately prepare a separate release package.

## 15. Multi-Person Collaboration

When several people or AI agents use the same GitHub repository, keep the main branch stable and let each person work on their own branch. Do not let multiple people push directly to main during active experiments.

### Recommended permission setup

- Give trusted collaborators write access to the GitHub repository.
- Keep main protected if the repository is shared by several people.
- Require pull requests before merging into main.
- Require at least one review for code that changes training, evaluation, or plotting logic.
- Do not give broad access to repositories that contain unpublished manuscripts, private logs, or paths to restricted data unless every collaborator is allowed to see them.

### Branch ownership

Each collaborator should create a branch for their own task:

    exp/<owner>-<experiment-name>
    fig/<owner>-<figure-name>
    paper/<owner>-<section-name>

Examples:

    exp/yys-anti-uap-inner-loss
    exp/hy-radius-align-smoke
    fig/yys-umap-diagnostics
    paper/hy-verification-appendix

This avoids two people editing the same branch at the same time.

### Daily collaboration workflow

Before starting work:

    git switch main
    git pull origin main
    .\scripts\new_experiment_branch.ps1 -Name yys-anti-uap-inner-loss

During work:

    git status --short
    git add <changed files>
    git commit -m "Add anti-UAP smoke test"
    git push -u origin exp/yys-anti-uap-inner-loss

When asking another person or AI to inspect the branch, provide:

    Repository: <GitHub URL>
    Branch: exp/yys-anti-uap-inner-loss
    Main task: <what to check or continue>
    Key files: <report, CSV, script, figure>
    Do not change: <protected files or experiment results>

### Pull request workflow

Use pull requests when a branch is ready to merge.

The pull request description should include:

- Purpose of the branch.
- Main code or manuscript changes.
- Exact commands or configs used.
- Result files and figures.
- Whether checkpoints or raw data remain local.
- Known limitations and failed checks.

For experiment branches, merge only compact reports, scripts, configs, and figures. Do not merge ignored checkpoint paths or local-only data references as if they were reproducible from GitHub.

### Avoiding conflicts

Try to avoid multiple people editing the same files at once. In this project, common conflict-prone files include:

- Shared training scripts.
- Shared loss implementation files.
- Paper LaTeX files.
- Figure scripts reused by several experiments.
- README and documentation files.

If two people need to modify the same file, agree on ownership first. One person should merge their branch before the other rebases or updates from main.

### Updating your branch from main

If main changed while you were working, update your branch before continuing:

    git fetch origin
    git switch exp/<your-branch>
    git merge origin/main

If you prefer a cleaner history and know how to resolve conflicts, you can rebase instead:

    git fetch origin
    git switch exp/<your-branch>
    git rebase origin/main

Use merge if you are unsure. It is easier to recover from.

### Handling merge conflicts

When Git reports a conflict:

1. Open each conflicted file.
2. Keep the lines that match the intended final behavior.
3. Remove conflict markers such as <<<<<<<, =======, and >>>>>>>.
4. Run the smallest relevant check or test.
5. Commit the conflict resolution.

If the conflict is in experiment outputs, do not manually blend incompatible CSVs or reports. Keep both result folders with distinct names and explain the difference in the pull request.

### Collaborating with AI agents

When assigning work to another AI, keep the prompt narrow:

- Name the branch to read.
- Name the files to inspect first.
- State whether code changes are allowed.
- State whether training is allowed.
- State what outputs are expected.
- State what files must not be touched.

Example:

    Please inspect branch exp/yys-anti-uap-inner-loss.
    Read results/anti_uap_smoke/report.md and src/align_loss.py first.
    Do not start long training and do not edit checkpoint paths.
    Tell me whether FPR decreases without WSR or CIDEr collapse.

If the AI makes changes, ask it to commit to a new branch rather than pushing directly to the branch owned by another person.

### Shared result discipline

For every experiment, include enough information for another person to understand the run without the original chat:

- Branch name.
- Commit hash.
- Model and checkpoint source.
- Dataset split and sample count.
- Random seed.
- Exact command or config.
- Summary metrics.
- Location of raw local-only artifacts if needed.
- Clear statement of what cannot be reproduced from GitHub alone.

### Recommended repository policy

For this project, a practical policy is:

- main contains stable scripts, manuscript text, reusable figures, and compact verified results.
- exp/* branches contain active experiments and diagnostics.
- fig/* branches contain figure restyling or visualization work.
- paper/* branches contain manuscript edits.
- No checkpoint, model weight, raw dataset, credential, or private PDF is merged into main.
- Every merged experiment has a report.md and summary.csv.
