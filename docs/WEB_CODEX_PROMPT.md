# Prompt For Web ChatGPT Or Another AI

Use this prompt when asking another AI to continue from a GitHub branch.

    Please inspect the GitHub repository and branch below, then continue the task from the committed files.

    Repository: <GitHub URL>
    Branch: <branch name>

    Task:
    <Describe the concrete next step.>

    Important rules:
    - Treat files in the repository as the source of truth.
    - Do not assume ignored checkpoints, raw data, or private credentials are available in Git.
    - Read the branch-specific report or README first if present.
    - Summarize which files you used before drawing conclusions.
    - If you make changes, commit them to a new branch and report the branch name.

## Example

    Repository: https://github.com/<user>/<repo>
    Branch: exp/anti-uap-inner-loss

    Task:
    Analyze results/anti_uap_smoke/summary.csv and tell me whether the anti-UAP inner constraint reduces FPR without collapsing WSR or CIDEr.
