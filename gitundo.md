Discarding changes can feel a bit like performing surgery—you want to be precise so you don't accidentally cut the wrong thing. Depending on whether your changes are just **sitting in your folder** or have already been **committed**, here is how you handle it.

---

## 1. Discard Uncommitted Changes (The "Undo" Button)

If you’ve been editing files and realize you've made a mess, but you haven't run `git commit` yet, use this:

### To discard changes in a specific file:

```bash
git checkout -- <file_name>

```

### To discard ALL changes in the current directory:

```bash
git reset --hard HEAD

```

> **⚠️ Warning:** This is destructive. Any code you haven't committed will be deleted forever.

---

## 2. Revert the Last Commit (The "Safe" Way)

If you already committed your changes and want to undo them *without* erasing the history of what you did, use `revert`. This creates a **new commit** that does the exact opposite of the previous one.

```bash
git revert HEAD

```

This is the best practice if you are working on a team or have already pushed your code to GitHub, as it doesn't "rewrite" history.

---

## 3. Hard Reset to a Previous Version (The "Time Machine" Way)

If you want to completely delete the last commit and act like it never happened, you can move your branch pointer back.

### To go back exactly one version:

```bash
git reset --hard HEAD~1

```

### To go back to a specific point in time:

1. Find the hash of the "good" version: `git log --oneline`
2. Reset to it: `git reset --hard <commit-hash>`

---

## Summary of "Undo" Commands

| Situation | Command | Result |
| --- | --- | --- |
| **Unsaved mess** | `git checkout -- <file>` | Replaces file with the last committed version. |
| **Staged a file by mistake** | `git restore --staged <file>` | Un-stages the file but keeps your code changes. |
| **Undo last commit (Keep code)** | `git reset --soft HEAD~1` | Deletes the commit but keeps your work as "staged." |
| **Undo last commit (Delete code)** | `git reset --hard HEAD~1` | Wipes the last commit and all work associated with it. |
# You need following to ignore the wrong version already in github
---
```bash
 git push origin main --force
```
