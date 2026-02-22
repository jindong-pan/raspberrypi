To create the `@` and `@home` subvolumes for **Timeshift**, you use the `btrfs subvolume create` command.

Since you are converting an existing "flat" system, you must do this from a **Live USB** to move your files safely. Here is exactly how to do it:

### 1. Mount your 2TB Drive

First, you need to mount the "root" of your Btrfs filesystem (the top-level, often called ID 5) to a temporary folder so you can work on it.

```bash
# Create a folder to mount your drive
sudo mkdir -p /mnt/btrfs

# Mount your partition (replace /dev/sda2 with your actual drive name)
sudo mount -o subvolid=5 /dev/sda2 /mnt/btrfs

```

### 2. Run the Creation Commands

Now that you are "inside" the top level of your 2TB SSD, run these two commands to create the subvolumes:

```bash
sudo btrfs subvolume create /mnt/btrfs/@
sudo btrfs subvolume create /mnt/btrfs/@home

```

### 3. Verify the Creation

To make sure they exist and have the correct names for Timeshift, run:

```bash
sudo btrfs subvolume list /mnt/btrfs

```

**You should see:**

* `ID [number] gen [number] top level 5 path @`
* `ID [number] gen [number] top level 5 path @home`

---

### What's happening behind the scenes?

Even though these look like empty folders right now, Btrfs treats them as **independent root trees**. This is why Timeshift requires them—it can "freeze" the state of `@` (your OS) into a backup without touching `@home` (your personal files), allowing you to restore your system without losing your work.

### The Next Critical Step

After creating these, they are empty. You must move your existing system files into `@` and your user files into `@home`.

**Would you like the `mv` commands to move your current files into these new subvolumes without breaking your permissions?**
