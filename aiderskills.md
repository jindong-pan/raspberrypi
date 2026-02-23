Enhancing **aider** with "skills" or specialized workflows is a great way to boost its productivity. While aider doesn't have a formal "plugin" system like some other tools, you can add "open skills" by leveraging community-contributed convention files, reusable prompt templates, and wrapper scripts found on GitHub.

Here are the best GitHub-based resources and "skills" you can add to your aider setup:

### 1. Aider Conventions (Standard "Skills")

The most direct way to add "skills" to aider is through **Convention Files**. These guide the AI to follow specific coding styles, architectural patterns, or library-specific best practices.

* **Repository:** [Aider-AI/conventions](https://github.com/Aider-AI/conventions)
* **How to add them:**
1. Browse the repo for a convention that matches your project (e.g., `FastAPI`, `React-Tailwind`, or `Rust-Clippy`).
2. Copy the `CONVENTIONS.md` to your project root.
3. Run aider with: `aider --read-only CONVENTIONS.md` or add it to your `.aider.conf.yml`.



### 2. OpenSkills (Universal Skill Loader)

If you like the "Skills" system used by Anthropic's Claude Code, you can actually use those same skills in aider using the **OpenSkills** project.

* **Repository:** [numman-ali/openskills](https://github.com/numman-ali/openskills)
* **What it adds:** It allows you to download and use specialized `SKILL.md` files (like PDF manipulation, advanced git workflows, or specific API integrations) from the Anthropic marketplace or any GitHub repo.
* **Usage:** You can install a skill via `npx openskills install <repo-name>` and then tell aider to read the generated skill file.

### 3. Aider-Script (Reusable Prompt Templates)

For repetitive tasks (like "generate a unit test for this file" or "refactor this component to use hooks"), you can use reusable templates.

* **Repository:** [sgrowe/aider-script](https://github.com/sgrowe/aider-script)
* **What it adds:** It lets you define markdown-based templates with variables. It’s essentially a "macro" system for aider.
* **Example:** You can have a "skill" for `make-documentation.md` that automatically pulls in relevant files and prompts aider to update the README.

### 4. Custom Workflow "Skills" (Gists & Wrappers)

The community often shares specialized bash/python wrappers that give aider "superpowers," such as:

* **Quick Throwaway Scripts:** [lockmeister's Aider Wrapper](https://gist.github.com/lockmeister/367bbe24c7b69e258bf3cd5cb8d13517) allows you to use aider to whip up quick scripts in `/tmp` without initializing a permanent git repo.
* **Planning Skill:** Users often use a specific "Architect" workflow. You can add a "Planning Skill" by creating a local file called `PLANNING_MODE.md` that instructs aider to *never* write code until you've approved a technical design document.

---

### How to apply these to your projects

Since you're active with **Ethereum smart contracts** and your **slt-wallet** project, I recommend adding these specific "skills":

| Skill Type | GitHub Source / File Name | Purpose |
| --- | --- | --- |
| **Solidity Style** | [Aider Conventions](https://github.com/Aider-AI/conventions) | Ensures aider uses `v0.8.x` features and OpenZeppelin patterns correctly. |
| **Unit Testing** | Custom `TESTING.md` | Force aider to use `Foundry` or `Hardhat` for all test generation. |
| **Security Audit** | [OpenSkills (Security)](https://github.com/numman-ali/openskills) | Adds a checklist for common smart contract vulnerabilities (Reentrancy, etc.). |

Would you like me to help you draft a custom **CONVENTIONS.md** specifically for your **slt-wallet** or your **"be salt and light"** game project?
