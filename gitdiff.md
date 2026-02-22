Comparing your current work to what came before is the bread and butter of version control. Depending on whether you want to see changes in your **unsaved workspace** or between **recorded commits**, here is how you handle it.

---

## 1. Diff Your Uncommitted Changes

If you’ve been typing away and want to see what you’ve changed since your last commit (but haven't "staged" or "added" the files yet):

```bash
git diff

```

If you have already run `git add` and want to see what is staged and ready to be committed:

```bash
git diff --staged

```

---

## 2. Diff Current vs. One Version Ago

To compare your current state (HEAD) against the immediate previous commit, use the **tilde (~)** or **caret (^)** symbols:

```bash
git diff HEAD~1 HEAD

```

* **HEAD:** Represents your current position (the most recent commit).
* **HEAD~1:** Represents the commit right before that.

---

## 3. Diff Between Two Specific Commits

If you want to look further back in time, you can use the commit hashes (the long strings of letters and numbers found in `git log`):

```bash
git diff <old-commit-hash> <new-commit-hash>

```

*Note: You only need the first 7 characters of the hash for this to work.*

---

## 4. Useful View Options

Standard `git diff` output can be a bit "wall-of-text." Here are two ways to make it more readable:

| Command | What it does |
| --- | --- |
| `git diff --stat` | Shows a summary of which files changed and how many lines were added/deleted. |
| `git diff --word-diff` | Shows changes at the word level rather than highlighting the entire line. |

---

> **Pro Tip:** If you have a visual tool installed (like VS Code, Meld, or Beyond Compare), you can run `git difftool` to see the changes side-by-side in a graphical interface instead of the terminal.

Would you like me to show you how to compare a specific file across different branches?
You can absolutely use **vimdiff**, and for many, it’s the preferred way to see changes side-by-side rather than the standard "top-down" unified diff format.

There are two main ways to use it: as a one-off command or as your permanent Git tool.

---

## 1. The Quick Way (One-Off)

If you just want to jump into a Vim diff right now without changing any settings, you can use the `git difftool` command. Git will ask if you want to launch the tool for each modified file.

To compare your current workspace to the last commit:

```bash
git difftool --tool=vimdiff

```

To compare two specific commits:

```bash
git difftool --tool=vimdiff <commit1> <commit2>

```

---

## 2. The Efficient Way (Permanent Config)

If you plan on using this often, you should tell Git that `vimdiff` is your default tool. Run these commands in your terminal:

```bash
git config --global diff.tool vimdiff
git config --global difftool.prompt false

```

Now, whenever you want to see your changes in Vim, you just type:
**`git difftool`**

---

## 3. Essential Vimdiff Navigation

Once you are inside the Vim interface, these shortcuts will save you a lot of headache:

* **`Ctrl + w` then `w**`: Switch your cursor between the left and right windows.
* **`[c`**: Jump to the **previous** change.
* **`]c`**: Jump to the **next** change.
* **`do`**: (Diff Obtain) Pull the change from the *other* window into yours.
* **`dp`**: (Diff Put) Push the change from *your* window into the other.
* **`:qa`**: Quit all windows (handy if you have multiple files to diff).

---

> **Note:** If you are working on your **HP laptop** (running WSL or Linux Mint), `vimdiff` should already be pre-installed with the base `vim` package.

Would you like to learn how to use `vimdiff` to resolve merge conflicts?
