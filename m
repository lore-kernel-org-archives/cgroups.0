From: "Alex Ng (LIS)" <alexng-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [OOPS] BUG_ON in cgroups on 4.4.0-rc5-next
Date: Fri, 18 Dec 2015 20:08:03 +0000
Message-ID: <BLUPR0301MB200140C023EB8C2B414F6B13D8E10@BLUPR0301MB2001.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wJ1KAo3of+QFp/mRNLxOEAqvqiwVYhw+H7uxLV0C9EY=;
 b=IuTCQWixBO9DkDXuCfxN0B+hPt3Uudao+0mXHBbf2yOWvUSmYwc8wRLNgMzyZbQAfuRh4cZAoRKAiBXrKdhiHYRuJKif/GmpmCCKnsjvwNNDQH5pJZ6vjwfznundu0ucSB2mbEkxShVTkyeRM1PM5KGrlv8tXeaaAZyQnmHai18=
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

I was running a "git clone" of the linux-next source tree and hit the following BUG_ON condition. My box is running kernel 4.4.0-rc5-next-20151217-52.27. Any ideas on how to pin down the cause?

The trace indicates that the following condition in compare_css_sets() triggered the oops:

	BUG_ON(cgrp1->root != cgrp2->root);

[ 1859.800805] ------------[ cut here ]------------
[ 1859.804082] kernel BUG at kernel/cgroup.c:834!
[ 1859.804082] invalid opcode: 0000 [#1] SMP
[ 1859.804082] Modules linked in: iscsi_ibft iscsi_boot_sysfs af_packet crct10dif_pclmul crc32_pclmul ghash_clmulni_intel drbg ansi_cprng aesni_intel i2c_piix4 hv_netvsc serio_raw pcspkr hyperv_keyboard aes_x86_64 lrw hyperv_fb joydev gf128mul glue_helper ablk_helper hv_utils acpi_cpufreq cryptd processor button dm_mod xfs libcrc32c sd_mod hid_generic sr_mod cdrom ata_generic ata_piix hid_hyperv hv_storvsc ahci libahci crc32c_intel hv_vmbus libata floppy sg scsi_mod autofs4
[ 1859.804082] CPU: 2 PID: 1 Comm: systemd Not tainted 4.4.0-rc5-next-20151217-52.27-default+ #2
[ 1859.804082] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[ 1859.804082] task: ffff880101c54040 ti: ffff880101c58000 task.ti: ffff880101c58000
[ 1859.804082] RIP: 0010:[<ffffffff810f108d>]  [<ffffffff810f108d>] find_css_set+0x3ad/0x3e0
[ 1859.804082] RSP: 0018:ffff880101c5bc38  EFLAGS: 00010207
[ 1859.804082] RAX: ffff88003694b238 RBX: ffff8800f10d0638 RCX: ffff8800eefa8220
[ 1859.804082] RDX: ffff8800f14b5a20 RSI: ffff88003694b250 RDI: ffff880101c5bc48
[ 1859.804082] RBP: ffff880101c5bcc0 R08: 0000000000000000 R09: ffff8800f12efc00
[ 1859.804082] R10: ffff8800f18e3800 R11: 0000000000000000 R12: ffff8800f3938400
[ 1859.804082] R13: ffff880101c5bc48 R14: ffff8800f10d0600 R15: ffff88003694b200
[ 1859.804082] FS:  00007f994345a880(0000) GS:ffff880102e40000(0000) knlGS:0000000000000000
[ 1859.804082] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1859.804082] CR2: 00007fc829d19000 CR3: 0000000036e46000 CR4: 00000000000006e0
[ 1859.804082] Stack:
[ 1859.804082]  ffff880101c5bc88 ffffffff810c3970 ffffffff81a74b00 ffffffff81dcc380
[ 1859.804082]  ffffffff81a4d100 ffffffff81f5c660 ffff8801023df800 ffff8801023db500
[ 1859.804082]  ffff8801023d7400 ffff8801023d7340 ffff8801023d7280 ffff8801023db400
[ 1859.804082] Call Trace:
[ 1859.804082]  [<ffffffff810c3970>] ? __wait_rcu_gp+0xd0/0xf0
[ 1859.804082]  [<ffffffff810f115a>] cgroup_migrate_prepare_dst+0x9a/0x200
[ 1859.804082]  [<ffffffff810f2065>] cgroup_attach_task+0x65/0xd0
[ 1859.804082]  [<ffffffff810abf1d>] ? percpu_down_write+0x5d/0xd0
[ 1859.804082]  [<ffffffff810f2348>] __cgroup_procs_write.isra.22+0x1b8/0x2d0
[ 1859.804082]  [<ffffffff810f2493>] cgroup_procs_write+0x13/0x20
[ 1859.804082]  [<ffffffff810edb28>] cgroup_file_write+0x38/0xf0
[ 1859.804082]  [<ffffffff81250380>] kernfs_fop_write+0x120/0x170
[ 1859.804082]  [<ffffffff811daf08>] __vfs_write+0x28/0xe0
[ 1859.804082]  [<ffffffff8129a618>] ? apparmor_file_permission+0x18/0x20
[ 1859.804082]  [<ffffffff81273dbd>] ? security_file_permission+0x3d/0xc0
[ 1859.804082]  [<ffffffff810abe47>] ? percpu_down_read+0x17/0x50
[ 1859.804082]  [<ffffffff811db7c2>] vfs_write+0xa2/0x1a0
[ 1859.804082]  [<ffffffff81051310>] ? __do_page_fault+0x1a0/0x3f0
[ 1859.804082]  [<ffffffff811dc726>] SyS_write+0x46/0xa0
[ 1859.804082]  [<ffffffff815aafee>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 1859.804082] Code: 03 10 48 8b 72 08 48 89 4a 08 48 89 11 48 89 71 08 48 89 0e f6 40 74 01 75 c3 48 8b 50 18 f6 c2 03 75 22 65 48 ff 02 eb b4 0f 0b <0f> 0b 31 c0 e9 b0 fd ff ff 4c 89 ff e8 72 92 0c 00 31 c0 e9 a1
[ 1860.196107] RIP  [<ffffffff810f108d>] find_css_set+0x3ad/0x3e0
[ 1860.196107]  RSP <ffff880101c5bc38>
[ 1860.199742] ---[ end trace 3a415fee224c72a3 ]---
[ 1860.199744] Kernel panic - not syncing: Fatal exception in interrupt
[ 1860.203733] Kernel Offset: disabled
[ 1860.203733] ---[ end Kernel panic - not syncing: Fatal exception in interrupt

--
Alex Ng
