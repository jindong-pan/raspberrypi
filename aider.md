Building a virtual environment for Aider is a great idea—it keeps your system clean and prevents dependency conflicts, which is especially important on a low-resource system like yours.

Since you're likely on **Python 3.12 or 3.13** (common on recent Linux distros), here is the most efficient way to set it up manually.

---

### 1. Create the Aider Environment

Run these commands in your terminal to create a dedicated folder and virtual environment.

```bash
# Create a hidden folder for your AI tools or just a directory for the venv
mkdir -p ~/ai_tools
cd ~/ai_tools

# Create the virtual environment named 'aider'
python3 -m venv aider

# Activate it
source aider/bin/activate

```

### 2. Install Aider

Once the environment is active (you should see `(aider)` in your prompt), install the package:

```bash
pip install -U pip
pip install aider-chat

```

### 3. Get Your Free Gemini API Key

To use Gemini with Aider, you'll need a key from Google AI Studio:

1. Go to **[Google AI Studio](https://aistudio.google.com/)**.
2. Click **"Get API key"** on the left sidebar.
3. Click **"Create API key in new project."**
4. **Copy the key** and keep it safe.

### 4. Launch Aider with Gemini

To start coding, navigate to your project folder (e.g., your "humanitarian care" game project) and run:

```bash
# Export your key (you can also add this to your ~/.bashrc or a .env file)
export GEMINI_API_KEY="your-api-key-here"

# Start aider using the Gemini 2.0 Flash model (fast & free tier)
aider --model gemini/gemini-2.0-flash

```

---

## Pro Tip for 3GB RAM Users: `uv`

If you find that `pip` is a bit slow or heavy when installing, I highly recommend a tool called **`uv`**. It is a modern Python package manager written in Rust. It's incredibly fast and uses much less memory during the installation process than standard `pip`.

You can install it with one command:
`curl -LsSf https://astral.sh/uv/install.sh | sh`

Then, you can install Aider as a global "tool" that manages its own virtual environment automatically:
`uv tool install aider-chat`
```bash
python -m pip install aider-install
aider-install

# Change directory into your codebase
cd /to/your/project

# DeepSeek
aider --model deepseek --api-key deepseek=<key>

# Claude 3.7 Sonnet
aider --model sonnet --api-key anthropic=<key>

# o3-mini
aider --model o3-mini --api-key openai=<key>
```
# Testing
```bash
mkdir ~/aider_test
cd ~/aider_test
# Initialize git (Aider works best with git)
git init
```
### set .env
```bash
# Navigate to your project or home
cd ~/aider_test

# Create the file and add your key
nano .env
```

### ignor .env
```bash
echo ".env" >> .gitignore
```

### define keys in .env
```text
# Google Gemini
GEMINI_API_KEY=your_gemini_key_here

# Anthropic (Claude 3.7 Sonnet)
ANTHROPIC_API_KEY=your_anthropic_key_here

# OpenAI (o3-mini)
OPENAI_API_KEY=your_openai_key_here

# DeepSeek
DEEPSEEK_API_KEY=your_deepseek_key_here
```
### How to run:
Model,Command
```bash
# Gemini,
aider --model gemini/gemini-2.0-flash
# Claude 3.7,
aider --model sonnet
# o3-mini,
aider --model o3-mini
# DeepSeek,
aider --model deepseek
# Grok:
aider --model xai/grok-beta
```

# Token budget
In early 2026, the free tier landscape is divided into three main "islands": **Google AI Studio** (generous daily limits), **GitHub Models** (best for diverse coding models), and **OpenRouter** (great for multi-model failover).

Here are the specific limits for the models in your script.

---

### 1. Google AI Studio (Your Primary Key)

Google offers the highest daily limits, but they are strict about **Requests Per Minute (RPM)**. If you type too fast, you'll hit a 1-minute "timeout."

| Model | Requests Per Day (RPD) | Requests Per Minute (RPM) | Best For |
| --- | --- | --- | --- |
| **Gemini 2.5 Flash-Lite** | **1,000** | 15 | Quick refactors, cleanup |
| **Gemini 2.5 Flash** | **250** | 10 | Standard "Code" mode |
| **Gemini 3 Pro (Preview)** | **100** | 5-10 | "Architect" planning |
| **Nano Banana (Image)** | **2-3** | 1 | Game art prototyping |

---

### 2. GitHub Models (Your Secondary Key)

GitHub uses a "Tier" system. Most models you use for coding fall into the **High** or **Low** categories.

| Model | Requests Per Day (RPD) | Requests Per Minute (RPM) |
| --- | --- | --- |
| **GPT-4o-mini** | **150** | 15 |
| **Llama 3.3 70B** | **150** | 15 |
| **GPT-4o (Full)** | **50** | 10 |
| **Claude 3.5 Sonnet** | **50** | 10 |
| **DeepSeek R1** | **8** | 1 |

---

### 3. OpenRouter (The "Emergency" Backup)

If you hit your limits on both Google and GitHub, OpenRouter provides a small daily "allowance" of roughly **200 requests per day** across a rotating list of free models (including Llama and Mistral).

---

### Comparison of Limits

### How to read your "429" errors

When your `a-code.sh` script removes a model, it’s usually because you hit one of these:

* **RPD (Requests Per Day):** You are done for the next 24 hours. (Wait until Midnight Pacific Time).
* **RPM (Requests Per Minute):** You just need to wait **60 seconds** and try again.

### Pro-Tip 

Because your RAM is limited, **TPM (Tokens Per Minute)** is actually your biggest hidden limit. If you add 20 files to Aider at once, you might hit the 250,000 token limit in a single request.

> **Solution:** Use `/drop` to remove files you aren't currently editing to keep your "token spend" low.

### aider history stored in
* .aider.chat.history.md
