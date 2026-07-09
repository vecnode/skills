---
name: create-pr-and-merge
description: Use when the user runs /create-pr-and-merge. Pushes the current branch, opens a PR, and merges it into the repo's default branch immediately — no confirmation prompt. This skill's entire purpose is to skip the usual "ask before merging" pause, so only invoke it when the user explicitly triggers it.
---

# Create PR and merge

This skill always ends with the branch merged into the default branch (usually
`main`). Do not stop to ask "should I merge?" — invoking this skill IS the
user's confirmation.

## Steps

1. **Check state.** Run `git status` and `git branch --show-current`.
   - If there are no committed changes ahead of the default branch, stop and
     tell the user there's nothing to merge.
   - If currently on the default branch itself, stop and tell the user to
     switch to a feature branch first — this skill never merges a branch into
     itself.
2. **Push the branch.** `git push -u origin <branch>` (only if not already
   pushed / up to date with remote).
3. **Open the PR.** Use `gh pr create` with a title and body summarizing the
   changes (derive from `git log` / `git diff` against the default branch,
   same as normal commit-message drafting — focus on the *why*).
4. **Merge immediately.** `gh pr merge --squash --delete-branch` (or
   `--merge`/`--rebase` if the user has stated a preference for this repo).
   Do not wait for CI, review, or further confirmation unless the user has
   told you this repo requires green checks first — if so, poll
   `gh pr checks` until it resolves before merging, and if checks fail, stop
   and report instead of merging.
5. **Report** the PR URL and the merge commit SHA back to the user.

## Guardrails

- Never force-push, never skip hooks (no `--no-verify`), never delete
  anything outside the merged branch.
- If `gh pr create` reports the PR already exists, reuse it instead of
  creating a duplicate.
- If the merge fails (conflicts, branch protection, failing required checks),
  stop and report the exact error — do not retry with `--admin` or force
  overrides.
