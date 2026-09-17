# Branching Guide

## Recommended branch types

- exp/<name> for experiments and diagnostics.
- fig/<name> for figure generation or styling.
- paper/<name> for manuscript text and LaTeX edits.
- fix/<name> for focused code fixes.

## Commit style

Use concise, factual commit messages:

- Add anti-UAP inner loss smoke test
- Update verification appendix wording
- Restyle checkpoint ablation figure

## Result discipline

Each experiment branch should include one compact report with:

- Goal and setup.
- Exact config or command used.
- Summary metrics.
- Key output paths.
- Known limitations or failed checks.
