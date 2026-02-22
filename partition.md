For your ThinkPad with a **2TB SSD** and **32GB of RAM**, the absolute best setup is a **Full Btrfs Migration with a dedicated Swap Partition**. This gives you the speed of an SSD, the "undo" power of snapshots, and the stability of traditional swap for hibernation.

## The Best Plan: Btrfs + Swap Partition

| Component | Recommended Size | Role |
| --- | --- | --- |
| **EFI Partition** | 512 MB - 1 GB | Bootloader storage. |
| **Swap Partition** | **38 GB** | Dedicated space for 32GB RAM + 6GB buffer for hibernation. |
| **Btrfs Partition** | Remaining (~1.8 TB) | Single pool for OS, home, and AI models. |

---

## Final Installation Guide (Path B)

### Step 1: Live USB & Partitioning

Boot from your Linux Live USB and open **GParted**.

1. **Wipe the Drive:** Delete your existing `ext4` partition (`/dev/sda2`). Keep the EFI partition (`/dev/sda1`).
2. **Create Swap:** Create a **38 GB** partition at the beginning or end of the unallocated space. Format as `linux-swap`.
3. **Create Btrfs:** Use all remaining space to create one large **Btrfs** partition.

### Step 2: The Installation

Run the Linux installer and choose **Manual Partitioning** or **"Something Else"**:

* **Mount `/dev/sda1**` as `/boot/efi`.
* **Mount the Btrfs partition** as `/`. The installer will typically create two subvolumes automatically: `@` for the system and `@home` for your files.
* **Assign the Swap partition** as your swap space.

### Step 3: Post-Install "Power User" Tweaks

Once installed, open your terminal to optimize for your ThinkPad’s SSD and CPU.

1. **Enable Compression:** Open your fstab file (`sudo nano /etc/fstab`) and add `compress=zstd:1` to your Btrfs mount options. This saves space with minimal CPU load.
2. **Set up Snapshots (The "Undo" Button):**
* Install Timeshift: `sudo apt install timeshift` (or your distro's equivalent).
* Open Timeshift, select **Btrfs mode**, and finish the wizard.
* **Tip:** It will now automatically create a system snapshot before every major update.



---

## Why this is better than Dual Booting

* **Efficiency:** Instead of splitting your drive in half, both your "Main OS" and any future "Test OS" can share the same 2TB pool of space.
* **Instant Recovery:** If a system update crashes your ThinkPad, you don't need to "switch" to a second OS. You can boot directly into a **Btrfs snapshot** from the GRUB menu and be back in your working environment in seconds.
* **Reliability:** A dedicated swap partition is much more reliable for **hibernation** than a swap file, which can be tricky to configure on Btrfs.

**Would you like the specific terminal commands to verify your Btrfs compression savings once you've finished the install?**
