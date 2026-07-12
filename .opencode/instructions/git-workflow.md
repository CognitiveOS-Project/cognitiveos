---
description: Git workflow — topic branches; no rebase; SemVer tags; how to sync
alwaysApply: true
---

# Git workflow

## Branching and PRs (default)

- **Do not** commit new work **directly** on **`main`** or **`development`**. Use a **topic branch** from **`development`**:
  `git fetch origin` then `git checkout -b feature/<topic> development` (or `fix/<topic>` / `bugfix/<topic>`).
- **Push** the topic branch and open a PR into **`development`** via the GitHub UI or `gh pr create`.
- Merge to **`development`** via **PR** after review.
- Promotion **`development` → `main`** uses a release PR.

**Exception:** If the user **explicitly** asks to commit or push **directly** to **`development`** or **`main`** (e.g. maintainer emergency), follow their instruction and remind them it bypasses the usual topic-branch flow.

## Never use `git rebase`

Prefer plain **`git pull`** (merge) when updating from remote, unless the user specifies otherwise. Do not use **`git pull --rebase`** or **`git rebase`** for this repo's workflow.

## When the user says "sync git"

Meaning: **save local work and push the current branch** to the remote — **not** "skip branching."

1. If the current branch is **`main`** or **`development`** and there are **new** changes, **prefer** moving work to a topic branch first (unless the user explicitly wants a direct push — see Exception above):
   e.g. `git fetch origin && git checkout -b feature/<short-description> development`, then bring commits across if needed.
2. Stage, commit with a **clear message**, push:
   ```bash
   git add .
   git commit -m "<concise message describing the changes>"
   git push -u origin HEAD
   ```
   Use `-u origin HEAD` when the branch has no upstream yet; otherwise `git push`. If there is **nothing to commit**, run **`git push`** if there are unpushed commits.
3. **Untracked files:** Use **`git add .**` (or add paths explicitly); do not rely on **`git commit -a`** alone if new files exist.

Do not substitute stash/rebase flows for "sync git" unless the user asks for a pull-only or merge-from-remote step.

## Opening a PR

Use the GitHub UI, **`gh pr create`**, or a configured auto-PR workflow (see `.github/workflows/`). Provide a clear title and description of the changes.

## SSH config workaround (Linux container, macOS host)

If `git push` fails with `Bad configuration option: usekeychain`, the host's `~/.ssh/config` contains macOS-only `UseKeychain` directives that OpenSSH on Linux doesn't understand.

This is handled automatically by `~/.profile` (see `AGENTS.md`), which sets `GIT_SSH_COMMAND` to filter out the offending lines.

## Auth — SSH only, never HTTPS

**This instance is pre-configured with SSH keys for `gh` and `git`. Never use HTTPS.**

- Remote URLs must use `git@github.com:` (SSH), never `https://github.com/`.
- `GH_TOKEN` must not be set or relied upon. If it contains stale credentials, unset it before running `gh` commands.
- Do not set `GH_TOKEN` from `~/.config/gh/hosts.yml` or any other source.
- If re-auth is needed, use the device flow with `--git-protocol ssh`:
  ```bash
  unset GH_TOKEN && gh auth login --git-protocol ssh --web
  ```
- `~/.ssh/` is on a read-only filesystem, so `UserKnownHostsFile` must point to `/tmp/`:
  ```bash
  export GIT_SSH_COMMAND="$GIT_SSH_COMMAND -o UserKnownHostsFile=/tmp/known_hosts"
  ```

## Releases and tags

- **Feature releases:** Open a PR from **`development`** to **`main`**, merge, then tag on **`main`** with an **annotated** SemVer tag: `git tag -a vMAJOR.MINOR.PATCH -m "<description>"`. Push the tag: `git push origin vMAJOR.MINOR.PATCH`.
- **Integration tags:** After a feature/fix/bugfix PR merges into **`development`**, optionally tag with `vMAJOR.MINOR.PATCH-dev.N` on **`development``.

## Release pipeline (CognitiveOS multi-repo)

CognitiveOS spans 11 repos under `CognitiveOS-Project`. A coordinated release follows this process:

### 1. Merge changes to `development`

For each repo with changes:
```bash
git fetch origin
git checkout -b <topic> origin/development
# make changes, commit
git push -u origin HEAD
gh pr create --base development --head <topic>
gh pr merge <number> --squash --delete-branch=false
```

### 2. Promote `development` → `main`

After squash-merge history, a direct `development→main` PR may fail with "merge commit cannot be cleanly created" due to divergent commit history. **Always use a topic branch from `main` with a cherry-pick:**

```bash
# 1. Get the commit hash from development
git fetch origin development
hash=$(git log --oneline origin/development -- <path> | head -1 | awk '{print $1}')

# 2. Create topic branch from main and cherry-pick
git checkout -b <topic>-main origin/main
git cherry-pick $hash
git push -u origin <topic>-main

# 3. PR and merge to main
gh pr create --base main --head <topic>-main
gh pr merge <number> --squash --delete-branch=false
```

### 3. Cross-repo coordination

When the same change type (e.g. docs, gitignore, attribution) applies to multiple repos, batch the work:

1. **Create topic branches** for all repos in parallel
2. **Push all branches**
3. **Create and merge PRs to `development`** for all repos
4. **Update local `development`** branches (`git pull`)
5. **Cherry-pick to `main`** for each repo (step 2 above)
6. **Clean up** local and remote topic branches

### 4. Tagging

Tag all repos at the same version after all merges are complete:

```bash
version="vMAJOR.MINOR.PATCH"
for repo in cognitiveos product-specs sdlc cpm core-mcp-bridges inference cognitiveosd cli cognitiveos-alpine-distro registry-server cgp-template cognitive-os.org; do
  gh -R CognitiveOS-Project/$repo api repos/CognitiveOS-Project/$repo/git/refs -X POST \
    -f ref="refs/tags/$version" \
    -f sha="$(gh -R CognitiveOS-Project/$repo api repos/CognitiveOS-Project/$repo/branches/main --jq '.commit.sha')"
done
```

### 5. GitHub Pages deployment

The website repo (`cognitive-os.org`) auto-deploys via `.github/workflows/pages.yml` on push to `main`. Verify deployment:

```bash
gh api repos/CognitiveOS-Project/cognitive-os.org/pages --jq '{status, html_url}'
```
