---
name: git-commit-and-pr
description: >-
  Commit local changes, push a feature branch, and open a GitHub PR using the
  project's established flow (branch from master, gh + credential token, PR
  body template). Use when the user asks to commit and push, 提交并提 PR,
  提交到远程, create a pull request, or similar.
---

# Git commit, push, and PR

Follow this workflow when the user asks to commit current work and/or open a PR.
Do **not** commit or push unless the user explicitly asked.

## Safety (always)

- Never update git config
- Never force-push; never `git push --force` to main/master
- Never skip hooks (`--no-verify`, etc.) unless user explicitly asks
- Never amend unless user rules for amend are fully met
- Do not commit secrets (`.env`, credentials, etc.)
- Prefer not committing local-only noise (e.g. personal `analysis_options.yaml`) unless the user asks

## 1. Inspect state (parallel)

Run together:

```bash
git status
git diff
git log -5 --oneline
git branch -vv
```

Also note: current branch, whether it tracks a remote, and whether `master`/`main` is the default base.

## 2. Branch

| Situation | Action |
|-----------|--------|
| On `master`/`main` with changes to ship | Create and switch to a new branch: `git checkout -b <type>/<short-kebab-name>` |
| Already on a feature/fix branch | Stay on it; commit there |
| Dirty unrelated files | Stage only files that belong to this change |

Branch naming: `feature/...`, `fix/...`, matching recent repo style.

If creating/switching a feature branch in this Cursor workspace, call `SetActiveBranch` with the new branch name.

Track whether **this run created a new branch** (needed for step 7).

## 3. Before commit: drop unused imports

For every source file that will be part of this commit, remove unused imports **before** staging.

- Prefer the analyzer / IDE fix; do not leave `unused_import` / unused import warnings in committed files.
- Dart/Flutter (this repo): run on the paths being committed, e.g.

```bash
dart fix --apply --code=unused_import lib/path/to/changed_file.dart
```

  Or apply to a containing directory if multiple files changed. Re-check the diff after fixing so only import cleanup + intended changes remain.
- Do not “fix” unrelated files just to clear imports project-wide unless the user asked.

## 4. Commit

1. Stage relevant files only (`git add <paths>`).
2. Draft a concise commit message focused on **why** (1–2 short sentences / subject + body).
3. Commit with a HEREDOC (or PowerShell here-string). On Windows PowerShell:

```powershell
git commit -m @"
Subject line here.

Optional body explaining why.
"@
```

If commit fails due to a hook, fix and create a **new** commit (do not amend unless amend rules allow).

## 5. Push

Push the current branch and set upstream if needed:

```powershell
$env:GH_TOKEN = (git credential fill 2>&1 | Where-Object { $_ -match '^password=' }) -replace '^password=',''
git push -u origin HEAD
```

Reuse `GH_TOKEN` for `gh` in the same shell session. Do not print or log the token.

If `gh` is already authenticated, plain `git push -u origin HEAD` is enough; still set `GH_TOKEN` when `gh` fails with auth errors.

## 6. Create PR

Only when the user asked for a PR (or “提交并提 pr” / equivalent).

```powershell
gh pr create --title "<title>" --body @"
## Summary
- <1-3 bullets of what / why>

## Test plan
- [ ] <concrete checks>
"@
```

- Base: default (`master`/`main`) unless user specifies otherwise
- Title: imperative, matches the change
- Return the PR URL when done

If a PR for this branch already exists, do not open a duplicate; report the existing URL (`gh pr view --web` / `gh pr list --head`).

## 7. After a newly created branch: switch local back to master

**If this run created a new branch** (step 2), after a successful push (and PR create if requested):

```bash
git checkout master
```

(Use `main` if that is the default branch.)

Then call `SetActiveBranch` with `master` (or `main`) so the Cursor UI matches.

**If the work was committed on an existing feature branch**, stay on that branch; do not auto-switch.

## 8. Verify

```bash
git status
```

Report briefly: branch used, commit subject, PR URL (if any), and that local checkout is back on `master`/`main` when step 7 applied.

## Quick checklist

```
- [ ] Inspect status/diff/log/branch
- [ ] New branch from master if needed (remember flag)
- [ ] Remove unused imports on files to commit (dart fix --code=unused_import)
- [ ] Stage only relevant files; commit
- [ ] Push -u origin HEAD (GH_TOKEN via credential if needed)
- [ ] gh pr create with Summary + Test plan
- [ ] If new branch this run → checkout master + SetActiveBranch
- [ ] Reply with PR URL
```
