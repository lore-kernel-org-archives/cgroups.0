From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: __blkg_lookup oops with 4.2-rcX
Date: Sun, 30 Aug 2015 08:30:41 -0400
Message-ID: <CA+5PVA5rzQ0s4723n5rHBcxQa9t0cW8BPPBekr_9aMRoWt2aYg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:date:message-id:subject:from:to:cc:content-type;
        bh=3leEkQcZrPrhf4SVojxtTZsOsfzXEgf7Et778NCFeNk=;
        b=n5YQruCo3iVCcEWgZ/YaEeq4X09vlIkKXs//Tr/FWyXT//0vsvOb6/Nn4dVVhu9k/h
         st5Ztpsy5KliQEEGNF87+JIweuSs8iokDLxDOBPle/6jbgtWOPgRJKB6BJzf3H9OTkxb
         PhYoEcuQ/QkVp4kluZGRPUq14UXhCOGRPVMOGB3HW6a/G5TNbvVyC3owYrCmRaX274k7
         Pv/sGlDDzzuVip3qjwp9FaaKU7NR87/RX2rH4FISx/WJrYgEobTEpKX1HlaPV3l2tMJz
         cmUw8Ne5BBjpeJvM4IBL+uzAkj6hewT+vvuZyi9rk7LqkfRohwWy1/iQFd9+ff+TAlwq
         NB/A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Tejun,

Mike and Jeff suggested you be informed of the oops one of our
community members is hitting in Fedora with 4.2-rcX.  I thought they
had already sent this upstream to you, but apparently they didn't.

The latest oops is below.  That is with 4.2-rc8.  I believe the first
report was against a merge window 4.2 kernel.  The full bug report is
here: https://bugzilla.redhat.com/show_bug.cgi?id=1237136

I believe Mike and Jeff suspected the cgroup writeback patches.

josh

lvm vgchange -a n
  /run/lvm/lvmetad.socket: connect failed: No such file or directory
  WARNING: Failed to connect to lvmetad. Falling back to internal scanning.
[   36.157672] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000558
[   36.157672] IP: [<ffffffff81389746>] __blkg_lookup+0x26/0x70
[   36.157672] PGD 0
[   36.157672] Oops: 0000 [#1] SMP
[   36.157672] Modules linked in: kvm_amd kvm snd_pcsp snd_pcm
snd_timer snd soundcore serio_raw ata_generic pata_acpi libcrc32c crc8
crc_itu_t crc_ccitt virtio_pci virtio_mmio virtio_input virtio_balloon
virtio_scsi sym53c8xx scsi_transport_spi megaraid_sas megaraid_mbox
megaraid_mm megaraid ideapad_laptop rfkill sparse_keymap video
virtio_net virtio_gpu ttm drm_kms_helper drm virtio_console virtio_rng
virtio_blk virtio_ring virtio crc32
[   36.157672] CPU: 0 PID: 248 Comm: lvm Not tainted
4.2.0-0.rc8.git0.1.fc23.x86_64 #1
[   36.157672] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.8.2-20150714_191134- 04/01/2014
[   36.157672] task: ffff88001b4e2580 ti: ffff88001ac0c000 task.ti:
ffff88001ac0c000
[   36.157672] RIP: 0010:[<ffffffff81389746>]  [<ffffffff81389746>]
__blkg_lookup+0x26/0x70
[   36.157672] RSP: 0018:ffff88001ac0fa58  EFLAGS: 00000046
[   36.157672] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   36.157672] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff820176a0
[   36.157672] RBP: ffff88001ac0fa78 R08: ffff88001ac0c000 R09: ffff88001ce6e800
[   36.157672] R10: 0000000000000002 R11: 000000000001eaa5 R12: ffff88001cc57000
[   36.157672] R13: ffff88001ccf99c8 R14: ffff88001ccf9f38 R15: ffff88001ccba8d8
[   36.157672] FS:  00007f9a21711880(0000) GS:ffff88001f000000(0000)
knlGS:0000000000000000
[   36.157672] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   36.157672] CR2: 0000000000000558 CR3: 000000001b41d000 CR4: 00000000000006f0
[   36.157672] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   36.157672] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[   36.157672] Stack:
[   36.157672]  ffffffff82017700 ffffffff820176a0 ffff88001cc57000
ffff88001ccf99c8
[   36.157672]  ffff88001ac0faa8 ffffffff8138d14a ffff88001cc570b8
ffff88001ccf99c8
[   36.157672]  ffffffff81cb1c20 0000000000000000 ffff88001ac0fab8
ffffffff8138a108
[   36.157672] Call Trace:
[   36.157672]  [<ffffffff8138d14a>] blk_throtl_drain+0x5a/0x110
[   36.157672]  [<ffffffff8138a108>] blkcg_drain_queue+0x18/0x20
[   36.157672]  [<ffffffff81369a70>] __blk_drain_queue+0xc0/0x170
[   36.157672]  [<ffffffff8136a101>] blk_queue_bypass_start+0x61/0x80
[   36.157672]  [<ffffffff81388c59>] blkcg_deactivate_policy+0x39/0x100
[   36.157672]  [<ffffffff8138d328>] blk_throtl_exit+0x38/0x50
[   36.157672]  [<ffffffff8138a14e>] blkcg_exit_queue+0x3e/0x50
[   36.157672]  [<ffffffff8137016e>] blk_release_queue+0x1e/0xc0
[   36.157672]  [<ffffffff8139bcba>] kobject_release+0x7a/0x190
[   36.157672]  [<ffffffff8139bb6f>] kobject_put+0x2f/0x60
[   36.157672]  [<ffffffff8136a2b1>] blk_cleanup_queue+0x111/0x140
[   36.157672]  [<ffffffff815f13fc>] cleanup_mapped_device+0xdc/0x100
[   36.157672]  [<ffffffff815f2311>] __dm_destroy+0x161/0x260
[   36.157672]  [<ffffffff815f45d3>] dm_destroy+0x13/0x20
[   36.157672]  [<ffffffff815f9ebd>] dev_remove+0x10d/0x170
[   36.157672]  [<ffffffff815f9db0>] ? dev_suspend+0x280/0x280
[   36.157672]  [<ffffffff815fa572>] ctl_ioctl+0x232/0x4d0
[   36.157672]  [<ffffffff8130cd80>] ? SYSC_semtimedop+0x2b0/0xeb0
[   36.157672]  [<ffffffff810136f1>] ? __switch_to+0x261/0x4b0
[   36.157672]  [<ffffffff815fa823>] dm_ctl_ioctl+0x13/0x20
[   36.157672]  [<ffffffff8122ebd5>] do_vfs_ioctl+0x295/0x470
[   36.157672]  [<ffffffff8130b259>] ? sem_security+0x9/0x10
[   36.157672]  [<ffffffff8122ee29>] SyS_ioctl+0x79/0x90
[   36.157672]  [<ffffffff817750ae>] entry_SYSCALL_64_fastpath+0x12/0x71
[   36.157672] Code: eb bf 0f 1f 00 66 66 66 66 90 55 48 89 e5 41 55
41 54 53 48 83 ec 08 48 8b 87 c8 00 00 00 48 85 c0 74 05 48 39 30 74
45 48 89 f3 <48> 63 b6 58 05 00 00 49 89 fd 48 8d bf b8 00 00 00 41 89
d4 e8
[   36.157672] RIP  [<ffffffff81389746>] __blkg_lookup+0x26/0x70
[   36.157672]  RSP <ffff88001ac0fa58>
[   36.157672] CR2: 0000000000000558
[   36.157672] ---[ end trace a6310b2924d6c01e ]---
