# Handoff Protocol

Use this file as the stable instruction block when asking Codex or another AI to continue from GitHub.

## What to push

- Source code and scripts needed to reproduce the change.
- Config files and command lines used for each run.
- Compact result files: CSV, JSON, JSONL, Markdown reports.
- Manuscript-ready figures: PDF, PNG, SVG.
- Short logs that explain failures or important diagnostics.

## What not to push

- Model checkpoints or weights.
- Raw datasets that are large, private, or license-restricted.
- API keys, tokens, .env files, cookies, or account credentials.
- Full generated caches unless they are essential and small.

## Branch naming

Use short purpose-specific branches:

- exp/anti-uap-inner-loss
- exp/radius-align-smoke
- fig/umap-diagnostics
- paper/verification-appendix

## Final handoff message

After pushing a branch, report:

    Repository: <GitHub URL>
    Branch: <branch name>
    Main changes:
    - <one-line summary>
    Key files:
    - <path/to/file>
    - <path/to/result.csv>
    Do not use ignored checkpoints or raw data from Git; they remain local.
