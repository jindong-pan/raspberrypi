`git clean` is your go-to tool for clearing out the "clutter" in your working directory—specifically, files that aren't being tracked by Git. It's powerful and permanent, so it’s worth knowing the specific flags to avoid accidentally nuking something important.

### The Safety Valve: Dry Run

Before you actually delete anything, you should **always** run a dry run. This tells you exactly what Git *would* delete without actually doing it.

```bash
git clean -n

```

---

### Common Commands

Depending on whether you want to remove just files, include directories, or ignore your `.gitignore` rules, use these variations:

* **Remove untracked files:**
`git clean -f`
(The `-f` stands for "force." Most Git configurations require this because deleting untracked files is irreversible.)
* **Remove untracked files AND directories:**
`git clean -fd`
(The `-d` tells Git to look into untracked directories as well.)
* **Remove ignored files too:**
`git clean -fx`
(This is useful if you want to clear out build artifacts, `.log` files, or compiled binaries that are usually hidden by your `.gitignore`.)
* **Interactive mode:**
`git clean -i`
(This launches a menu that lets you filter, choose, or skip files one by one. It’s the safest way to "hand-pick" the trash.)

---

### Key Flags Reference

| Flag | Description |
| --- | --- |
| **`-n`** | **Dry run.** Shows what will be deleted. |
| **`-f`** | **Force.** Required to actually execute the deletion. |
| **`-d`** | **Directory.** Includes untracked directories in the sweep. |
| **`-x`** | **Ignored.** Deletes files even if they are in your `.gitignore`. |
| **`-X`** | **Only Ignored.** *Only* deletes files that are ignored by Git. |

> **Warning:** Unlike `git rm`, which handles tracked files, `git clean` works on files Git doesn't know about. Once they are gone, you cannot `git checkout` or `git restore` them. They are deleted from your hard drive entirely.

Would you like me to show you how to configure a "safe" alias for this command so you don't accidentally delete important work in the future?
