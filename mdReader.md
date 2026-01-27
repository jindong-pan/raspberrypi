Installing **Glow** (the terminal-based Markdown reader) is a great choice for your Raspberry Pi because it is extremely lightweight and fast compared to VS Code.

Since you are running Raspberry Pi OS (Debian-based), here are the two best ways to install it:

### Option 1: The Fastest Way (Official Repo)

This adds the "Charm" repository to your system so you can install and update Glow using `apt`, just like any other Linux package.

1. **Add the GPG key:**
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg

```


2. **Add the repository:**
```bash
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

```


3. **Install Glow:**
```bash
sudo apt update && sudo apt install glow

```



---

### Option 2: Using Homebrew (If you already have it)

If you already use Homebrew on your Pi for other development tools, it's just one command:

```bash
brew install glow

```

---

### How to use Glow

Once installed, Glow is very intuitive:

* **Read a file:** `glow README.md`
* **Open the TUI (Full Menu):** Just type `glow`. This opens a beautiful interface where you can browse all Markdown files in your current directory.
* **Stash a file:** Press `s` while viewing a file to "stash" it (bookmark it) so you can find it quickly later even if you move the file.

### Why this is better for your Pi

* **Disk Space:** Glow is only a few megabytes, unlike the 500MB+ for VS Code.
* **CPU:** It uses almost zero idle CPU, whereas VS Code uses a lot of background resources.
* **Aesthetics:** Since you care about "humanistic care" and beauty in your projects, you'll love how Glow renders Markdown—it uses "Glamour" to make terminal text look professional and clean.

**Would you like me to show you how to customize the "style" of Glow (like using a light or dark theme) to match your preferences?**
