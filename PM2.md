That is incredibly frustrating. There’s nothing quite like a power flicker to remind us that SD cards and unsaved processes are fragile things.

The reason your processes didn't come back is that PM2 doesn't automatically "stick" to the reboot cycle unless you explicitly tell it to generate a startup script and then save the current list.

Here is how you can get everything back up and running—and make sure this is the last time you have to do it manually.

---

## Step 1: Restart your processes

First, you’ll need to manually start your applications one last time.

```bash
pm2 start app.js --name "my-app"
# Repeat for any other scripts you had running

```

## Step 2: Generate the Startup Script

PM2 has a built-in tool that detects your init system (likely `systemd` on a Raspberry Pi) and creates a configuration to run PM2 on boot.

```bash
pm2 startup

```

**Important:** After running that command, PM2 will output a specific line of code that starts with `sudo env PATH...`. You **must copy and paste** that entire line into your terminal and press Enter to execute it. This actually registers the service with your Pi.

## Step 3: "Freeze" the List

This is the step most people miss. Once your processes are running and look good (check with `pm2 status`), you need to tell PM2 to remember this exact configuration for the next reboot.

```bash
pm2 save

```

> **Note:** This command creates a dump file in `~/.pm2/dump.pm2`. Every time the Pi boots, PM2 looks at this file to decide what to launch.

---

### Pro-Tip: The "Resurrection"

If you ever find yourself in this situation again and you *know* you ran `pm2 save` in the past, you don't have to restart every app manually. Just run:

```bash
pm2 resurrect

```

This will instantly reload everything from your last saved dump file.

---

