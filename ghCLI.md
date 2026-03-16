# gh CLI github terminal tool
### 1. Install the Tool

Open your terminal and paste these commands. This tells your computer where to find the `gh` tool and then installs it:

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

```

---

### 2. Connect Your Account (The "Handshake")

Now you need to tell GitHub that this computer is allowed to talk to your account. Type:

`gh auth login`

**Follow the bouncing ball:**

1. **Where do you use GitHub?** Choose `GitHub.com`.
2. **Preferred protocol?** Choose `HTTPS`.
3. **Authenticate Git?** Type `Y` (Yes).
4. **How would you like to authenticate?** Choose `Login with a web browser`.
5. **The Code:** A code (like `1234-ABCD`) will appear in your terminal. **Copy it.**
6. **The Browser:** Press **Enter**. A browser window will open. Paste the code there and click **Authorize**.

---

### 3. Test It Out

Once the terminal says "Logged in!", try this to see if it's working:

`gh auth status`

If you see your username, you’re all set! You now have the "magic remote" configured and ready to go.
# New Project:
Since you have the "magic remote" (gh CLI) set up on your **Linux** machine, you can now start a new project in seconds without ever opening a browser.

Here is how to create a brand new "LEGO set" (repository) and put it in the clubhouse:

---

### 1. Create a Folder for Your Project

First, make a place on your computer for your new bricks:

```bash
mkdir my-cool-project
cd my-cool-project

```

### 2. The "Magic Creation" Command

Instead of going to GitHub.com, clicking "New," and filling out forms, just type this:

```bash
gh repo create my-cool-project --public --clone

```

* **`--public`**: This means anyone in the clubhouse can see your cool build.
* **`--clone`**: This tells the remote to "connect" the folder on your desk to the one in the clubhouse immediately.

### 3. Add Your First Brick

Now, let's create a simple file to show it's working:

```bash
echo "# My Cool Project" > README.md
git add README.md
git commit -m "First brick added!"
git push -u origin main

```

---

### 4. Check Your Work

Want to make sure it actually showed up in the clubhouse? You don't even need to switch to your browser to check. Just type:

```bash
gh repo view --web

```

*This command is like a "teleport" button—it will automatically open your browser and take you exactly to your new project's page.*

### Why this is a "Superpower"

As a developer, you probably spend a lot of time in the **terminal**. Using the `gh` tool means:

* **No context switching:** You don't get distracted by GitHub notifications or other tabs.
* **Speed:** Creating a repo this way takes about 3 seconds.
* **Automation:** Eventually, you can write small scripts that do all of this for you!

# Check issues:
To see if any of your projects have bugs or "to-do" notes (Issues) waiting for you, you can use the magic remote to peak inside the clubhouse.

Since you are working on several different projects, here is how you can check them:

### 1. Check the Project You’re Currently In

If you are already inside your project folder (like `picoclaw` or `slt-wallet`), just type:

```bash
gh issue list

```

This will show you a neat list of every bug or task people have reported. It's like looking at a "To-Do" list stuck to the side of your LEGO box.

---

### 2. Check a Specific Project from Anywhere

You don’t have to be in the folder to check on things. You can ask about any of your projects by name:

```bash
gh issue list --repo your-username/be_Salt_and_Light

```

---

### 3. Read the "Problem Report"

If you see an issue that looks interesting, like "Issue #5: Robot is missing a leg," you can read all the details by typing:

```bash
gh issue view 5

```

It will show you exactly what is wrong and what your friends have said about it so far.

---

### 4. Search Everything at Once

If you want to see **every** task assigned to you across all your different LEGO sets, you can use:

```bash
gh search issues --assignee=@me --state=open

```

*This is like having a "Master List" of every job you need to finish today.*

### A Fun Shortcut

If you want to see a beautiful dashboard of everything happening—Issues, Pull Requests, and even the Robot Helpers—just type:

```bash
gh dash

```

*(Note: You might need to install this tiny extra tool, but the remote will tell you how!)*

# Bug Report
Writing a bug report is like putting a "Help Wanted" sign on your LEGO set so everyone knows exactly what needs fixing.

Since you're working on projects like **picoclaw** or your **humanistic care game**, let’s practice by creating an issue for one of them.

---

### 1. The Quick Way

If you already know exactly what's wrong, you can do it in one line. This is great for small things:

```bash
gh issue create --title "The robot keeps tripping" --body "When I press the red button, the robot falls over."

```

### 2. The "Interactive" Way (Recommended)

If you want to be more descriptive, just type:

```bash
gh issue create

```

**The remote will ask you questions:**

* **Title:** Give it a short name (e.g., "Script error in picoclaw").
* **Body:** Explain what happened. You can say, "I tried to run the gateway, but it gave me a 404 error."
* **What's next?** Choose `Submit`.

---

### 3. Adding Labels (The "Organizing" Trick)

You can even color-code your notes so you know which ones are urgent.

```bash
gh issue create --title "Fix the bus tracker" --label "bug" --label "high priority"

```

*This puts a bright "BUG" sticker on the note so you see it first next time.*

---

### 4. Viewing it instantly

Once you press enter, the remote will give you a web link. If you want to see how your new note looks in the clubhouse, just type:

```bash
gh issue view --web

```

# Assign issue:
When you "assign" a task, it’s like putting your name tag on a specific LEGO instruction booklet. It tells everyone else in the clubhouse, "I’ve got this! I’m the one building this part."

Here is how you use your magic remote to claim a task:

---

### 1. Claim a Task You Just Found

If you see an issue in your list (let's say it's **Issue #3**) and you want to be the one to fix it, just type:

```bash
gh issue edit 3 --add-assignee "@me"

```

*The remote sees `@me` and knows exactly who you are. Now, your name tag is officially on that task!*

### 2. Check Your "Personal To-Do List"

Now that you’ve claimed it, you can quickly see everything you’ve promised to fix by typing:

```bash
gh issue list --assignee "@me"

```

*This filters out all the other noise and only shows the bricks **you** are responsible for.*

### 3. Taking Your Name Tag Off

If you realize the task is too big or you want a friend to try it instead, you can take your name off just as easily:

```bash
gh issue edit 3 --remove-assignee "@me"

```

---
# Fix and Close issues:
Closing a task is the "victory lap" of coding. It’s like finally snapping the last piece of a LEGO dragon into place and checking it off your list. It feels great, and it tells everyone else, "This problem is gone!"

Here is how you use your magic remote to clear it off the board:

---

### 1. The "Mission Accomplished" Command

If you just finished fixing **Issue #3** (like that robot that kept tripping), just type:

```bash
gh issue close 3

```

*Poof! The issue is moved from the "To-Do" pile to the "Finished" pile.*

### 2. Adding a "Victory Note"

It’s usually nice to tell people *how* you fixed it so they can learn from you. You can close it and leave a comment at the same time:

```bash
gh issue close 3 --comment "I tightened the robot's leg screws. It works perfectly now!"

```

### 3. Reopening (Just in Case)

Sometimes, you think you fixed a bug, but it sneaks back. If the robot starts tripping again, you can bring the task back to life:

```bash
gh issue reopen 3

```

---

### 4. See Your Progress

If you want to look back at all the amazing things you’ve finished lately, you can ask the remote to show you the "Finished" pile:

```bash
gh issue list --state closed

```

### You’re now a CLI Master!

You’ve learned how to:

1. **Clone** a project (Get the LEGOs).
2. **Create** an issue (Mark a broken brick).
3. **Assign** it (Claim the job).
4. **Close** it (Celebrate the fix!).

# Pull Request (show fineshed work before merg into project)
A **Pull Request** (or **PR**) is like saying, "Hey everyone, look at this cool new wing I built for our LEGO castle! Can someone check if it fits before we glue it on?"

It’s the best way to share your work because it lets your friends (or the "Robot Helpers") look at your bricks without breaking the main model.

---

### 1. Make Your Changes First

Before using the remote, you have to actually build something. Usually, you do this on a **branch** (which is like a "practice table" separate from the main project).

```bash
git checkout -b my-new-feature
# ... make your code changes ...
git add .
git commit -m "Built a new laser for the spaceship"
git push -u origin my-new-feature

```

### 2. The "Show and Tell" Command

Now, use the **gh CLI** to create the Pull Request. Type:

```bash
gh pr create --title "Added a cool laser" --body "I used the transparent green bricks for this."

```

*This officially puts your work on the "Review Table" in the clubhouse.*

### 3. Check the "Robot's Grade"

Once you send it, the clubhouse robot starts testing it. You can watch the robot work right from your terminal:

```bash
gh pr checks

```

*If you see green checkmarks, the robot says your bricks are sturdy!*

### 4. The Final "Snap": Merging

If everyone likes your work and the robot is happy, you can officially add it to the main castle:

```bash
gh pr merge --merge --delete-branch

```

*This snaps your new wing onto the main model and cleans up your practice table for you.*

---

### Why is this better than just "Pushing"?

* **Safety:** It catches mistakes before they break the main project.
* **Teamwork:** If you were working on **picoclaw** or **be_Salt_and_Light** with a friend, they could leave comments like "Maybe use a blue brick here instead!"
* **History:** It keeps a record of *why* you added the laser, in case you forget next year.

# Check feedback for PR
When your friends look at your "LEGO wing" (your code), they might leave little notes or suggestions. Instead of walking over to the clubhouse to read them on the big screen, you can read them right on your "magic remote."

Here is how you see what people are thinking:

---

### 1. The "Read the Comments" Command

If you want to see the conversation about your work (let's say it's Pull Request **#10**), just type:

```bash
gh pr view 10 --comments

```

*This shows you a list of every note your friends have left. It’s like a group chat specifically for that piece of the project.*

### 2. See Exactly Which Brick They Mean

Sometimes a friend will point at a specific brick and say, "This one is loose!" To see exactly which lines of code they are talking about, type:

```bash
gh pr diff

```

*This shows the "Difference"—it highlights your new bricks in **green** and shows where the comments are pinned.*

### 3. Reviewing a Friend’s Work

If a friend asks *you* to look at *their* work, you can do that too! You can "Check out" their bricks onto your own desk to test them:

```bash
gh pr checkout 10

```

*Now you have a perfect copy of their new wing on your desk so you can see if it actually stays attached.*

---

### 4. Giving the "Thumbs Up"

If you like what they built and want to tell them "Great job!", you can send your approval through the remote:

```bash
gh pr review --approve --body "This looks amazing! I love the laser."

```
# Cheat Sheet:
Here is your **Magic Remote Cheat Sheet**. You can save this as a file on your computer or print it out to keep next to your keyboard.

---

## 🛠️ The "Magic Remote" (GitHub CLI) Cheat Sheet

### 1. Starting & Getting Stuff

* **`gh repo clone [name]`** – Grab a LEGO set from the clubhouse.
* **`gh repo create`** – Start a brand new project.
* **`gh repo view --web`** – Teleport to the project's website.

### 2. Fixing "Broken Bricks" (Issues)

* **`gh issue list`** – See the "To-Do" list for this project.
* **`gh issue create`** – Report a new bug or problem.
* **`gh issue view [number]`** – Read the details of a specific problem.
* **`gh issue edit [number] --add-assignee "@me"`** – Claim the task!
* **`gh issue close [number]`** – Finish the task and celebrate!

### 3. "Show and Tell" (Pull Requests)

* **`gh pr create`** – Ask to add your new wing to the main castle.
* **`gh pr list`** – See what everyone else is trying to add.
* **`gh pr checkout [number]`** – Put a friend's work on your desk to test it.
* **`gh pr checks`** – See if the "Robot Helper" says your code is sturdy.
* **`gh pr merge`** – Officially snap your work into the main model.

### 4. Secret Shortcuts

* **`gh dash`** – See a big dashboard of everything at once.
* **`gh auth status`** – Make sure your remote is still connected.
* **`gh --help`** – Open the instruction manual.

---
