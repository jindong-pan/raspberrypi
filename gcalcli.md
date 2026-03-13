It looks like you're setting up **gcalcli** on your Inspiron 1545. Since you are at the prompt for the `Client ID`, you'll need to generate these credentials from the Google Cloud Console to give the application permission to access your calendar.

Here is the step-by-step process to get your credentials:

### 1. Create a Project in Google Cloud Console

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Click the project dropdown at the top and select **New Project**. Name it something like "MyGcalcli".
3. Search for **"Google Calendar API"** in the search bar and click **Enable**.

### 2. Configure the OAuth Consent Screen

Before getting the ID, Google needs to know what kind of "app" this is:

1. Go to **APIs & Services > OAuth consent screen**.
2. Select **External** (if you don't have a Google Workspace org) and click **Create**.
3. Fill in the required app name and your email.
4. For **Scopes**, you can skip or add `.../auth/calendar` if you want to be specific, but gcalcli usually requests what it needs during the first login.
5. **Crucial:** Add your own email address under **Test Users**; otherwise, the login will fail later.

### 3. Generate Credentials

1. Go to **APIs & Services > Credentials**.
2. Click **+ Create Credentials** and select **OAuth client ID**.
3. Select **Desktop App** as the Application type.
4. Give it a name (e.g., "Laptop-CLI") and click **Create**.

### 4. Authenticate in your Terminal

Once you click create, a window will pop up with your **Client ID** and **Client Secret**.

1. Copy the **Client ID** and paste it into your terminal prompt.
2. It will then ask for the **Client Secret**; paste that in as well.
3. Your browser should open (or provide a URL) for you to log in with your Google account.
4. Because the app is "Unverified" (since you just made it), you may need to click **Advanced > Go to [App Name] (unsafe)** to proceed.

---

**Quick Tip for Btrfs Users:** Since you’re working in `~/picoclaw`, if you plan on making frequent changes to this tool's configuration, you might want to ensure this directory is part of a subvolume that you’re snapshotting. It saves a lot of headache if a config file gets corrupted during setup.

Would you like me to help you draft a shell script to automate the backup of your `~/.gcalclirc` and other hidden config files to your secure storage?
This "Error 400: redirect_uri_mismatch" is a classic hurdle when setting up `gcalcli`. It happens because Google’s modern security policies are very strict about where the "Success" code gets sent back to.

For a command-line tool like `gcalcli`, the solution depends on which version you are running, but usually comes down to one of these two fixes:

### Fix 1: The "Localhost" Trick (Most Common)

If `gcalcli` is trying to open a browser on your Inspiron, it’s likely using a local web server to catch the login.

1. Go back to your **Google Cloud Console**.
2. Edit your **OAuth 2.0 Client ID**.
3. Under **Authorized redirect URIs**, add these two exactly:
* `http://localhost`
* `http://127.0.0.1`


4. **Save** and wait about 2–5 minutes for Google to update their servers.
5. Try the `gcalcli list` command again.

### Fix 2: Change to "Desktop App" Type

If you accidentally created a **"Web Application"** credential instead of a **"Desktop App"** credential, it will almost always fail with this error.

1. In the Cloud Console, look at the **Type** column in your Credentials list.
2. If it says **Web Application**, delete it.
3. Click **+ Create Credentials** > **OAuth client ID**.
4. Select **Desktop App** from the dropdown.
5. This type is specifically designed for CLI tools and handles the redirect flow differently (often using a special URI like `urn:ietf:wg:oauth:2.0:oob`, which Google handles automatically).

---

### Important Note for Remote/SSH Users

If you are SSHing into your Inspiron from another machine, the browser won't be able to open "localhost" correctly. If that's the case, try running the command with the "no auth local webserver" flag:

```bash
gcalcli list --noauth_local_webserver

```

This will give you a URL to copy/paste into your browser manually. After you "Allow" access, Google will give you a code to paste back into the terminal.

**Which of these matches your setup?** If you're still stuck, click the **"Error details"** link in that "Access blocked" window—it will list the exact `redirect_uri` it's complaining about (e.g., `http://localhost:8080`), and we can add that specific one to your console.
