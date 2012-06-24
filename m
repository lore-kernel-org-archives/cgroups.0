From: shyju pv <shyju.pv-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Date: Sun, 24 Jun 2012 19:04:50 +0000
Message-ID: <E061084CB90FCE4F89232A6CF839683B32B5227C@SZXEML507-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sanil kumar <sanil.kumar-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, 
Observed a crash with cgroup tests from LTP(Stable April,2012 release)on Dell Inspiron 1526[Intel(R) Core2Duo T7250, MEM 4GB] and also on another x86 quad core target(4GB RAM). 
LTP test case: cgroup_regression_test.sh(test 4,7 and 9 crashes randomly when the test cases are executed in order) 
Shyju 

[  532.805905] BUG: Dentry ffff8801164db490{i=491b,n=/} still in use (1) [unmount of cgroup cgroup] 
[  532.805961] ------------[ cut here ]------------ 
[  532.805996] kernel BUG at fs/dcache.c:965! 
[  532.806035] invalid opcode: 0000 [#1] SMP 
[  532.806067] CPU 1 
[  532.806505] Modules linked in: raw binfmt_misc ipv6 af_packet mperf fuse loop dm_mod coretemp kvm_intel kvm microcode tpm_tis tpm tpm_bios pcspkr serio_raw i2c_i801 i2c_core lpc_ich mfd_core hid_generic sg mptctl i5k_amb i5000_edac tg3 edac_core shpchp e1000e pci_hotplug button usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor ide_pci_generic ide_core ata_generic ata_piix libata mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon 
[  532.806625] 
[  532.806650] Pid: 930, comm: kworker/1:2 Not tainted 3.5.0-rc3-0.7-default #2 HUAWEI TECHNOLOGIES CO.,LTD. Tecal/CN21WBSA 
[  532.806721] RIP: 0010:[<ffffffff811ec127>]  [<ffffffff811ec127>] shrink_dcache_for_umount_subtree+0x267/0x290 
[  532.806765] RSP: 0018:ffff880111eafbf0  EFLAGS: 00010202 
[  532.806788] RAX: 0000000000000054 RBX: ffff8801164db490 RCX: 0000000000000006 
[  532.806811] RDX: ffffffff82a7d630 RSI: ffff88011318dfa8 RDI: 0000000000000246 
[  532.806832] RBP: ffff880111eafc10 R08: 0000000000000002 R09: 0000000000000000 
[  532.806855] R10: 000000000000000a R11: 0000000000000006 R12: ffff8801164db490 
[  532.806877] R13: ffffffff8181ca80 R14: ffff880116d43000 R15: ffff88011a9d5000 
[  532.806904] FS:  0000000000000000(0000) GS:ffff88011a800000(0000) knlGS:0000000000000000 
[  532.806931] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[  532.806951] CR2: 00007fcf7b4843e0 CR3: 0000000001c0c000 CR4: 00000000000007e0 
[  532.806984] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  532.807011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  532.807034] Process kworker/1:2 (pid: 930, threadinfo ffff880111eae000, task ffff88011318d680) 
[  532.807060] Stack: 
[  532.807084]  ffff880116d43580 ffff8801164db4f0 ffff880116d43000 ffff880116d431b8 
[  532.807113]  ffff880111eafc30 ffffffff811ec19a ffff880111eafc80 ffff880116d43000 
[  532.807143]  ffff880111eafc60 ffffffff811cc3c7 ffff8801164db490 0000000000000013 
[  532.807164] Call Trace: 
[  532.807186]  [<ffffffff811ec19a>] shrink_dcache_for_umount+0x4a/0x90 
[  532.807217]  [<ffffffff811cc3c7>] generic_shutdown_super+0x37/0x160 
[  532.807247]  [<ffffffff811cc5d9>] kill_anon_super+0x19/0x40 
[  532.807273]  [<ffffffff811cc63a>] kill_litter_super+0x3a/0x50 
[  532.807300]  [<ffffffff810fb65a>] cgroup_kill_sb+0x20a/0x280 
[  532.807330]  [<ffffffff811ccdc5>] deactivate_locked_super+0x65/0xb0 
[  532.807353]  [<ffffffff811ce339>] deactivate_super+0x89/0xe0 
[  532.807379]  [<ffffffff810f7734>] cgroup_d_release+0x34/0x40 
[  532.807405]  [<ffffffff811eb258>] d_free+0x58/0xc0 
[  532.807433]  [<ffffffff811ee5f0>] dput+0x220/0x350 
[  532.807455]  [<ffffffff810f7429>] css_dput_fn+0x19/0x30 
[  532.807483]  [<ffffffff8107b4d9>] process_one_work+0x239/0x800 
[  532.807509]  [<ffffffff8107b450>] ? process_one_work+0x1b0/0x800 
[  532.807527]  [<ffffffff810f7410>] ? cgroup_rename+0x70/0x70 
[  532.807547]  [<ffffffff8107eba3>] worker_thread+0x2e3/0x710 
[  532.807575]  [<ffffffff8107e8c0>] ? manage_workers+0x370/0x370 
[  532.807595]  [<ffffffff81087e46>] kthread+0xd6/0xf0 
[  532.807636]  [<ffffffff81630474>] kernel_thread_helper+0x4/0x10 
[  532.807658]  [<ffffffff816256f0>] ? retint_restore_args+0x13/0x13 
[  532.807672]  [<ffffffff81087d70>] ? __init_kthread_worker+0x80/0x80 
[  532.807683]  [<ffffffff81630470>] ? gs_change+0x13/0x13 
[  532.807811] Code: 83 05 6d a5 f1 01 01 48 8d 86 80 05 00 00 48 c7 c7 f0 68 9b 81 48 89 de 48 89 04 24 31 c0 e8 dd 30 43 00 48 83 05 59 a5 f1 01 01 <0f> 0b eb fe 48 83 05 45 a5 f1 01 01 31 d2 eb cc 48 83 05 11 a5 
[  532.807843] RIP  [<ffffffff811ec127>] shrink_dcache_for_umount_subtree+0x267/0x290 
[  532.807856]  RSP <ffff880111eafbf0> 
[  532.807876] ---[ end trace 1e5c705163c24a85 ]--- 
[  532.808176] BUG: unable to handle kernel paging request at fffffffffffffff8 
[  532.808188] IP: [<ffffffff81087573>] kthread_data+0x13/0x20 
[  532.808198] PGD 1c0e067 PUD 1c0f067 PMD 0 
[  532.808206] Oops: 0000 [#2] SMP 
[  532.808212] CPU 1 
[  532.808326] Modules linked in: raw binfmt_misc ipv6 af_packet mperf fuse loop dm_mod coretemp kvm_intel kvm microcode tpm_tis tpm tpm_bios pcspkr serio_raw i2c_i801 i2c_core lpc_ich mfd_core hid_generic sg mptctl i5k_amb i5000_edac tg3 edac_core shpchp e1000e pci_hotplug button usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor ide_pci_generic ide_core ata_generic ata_piix libata mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon 
[  532.808360] 
[  532.808368] Pid: 930, comm: kworker/1:2 Tainted: G      D      3.5.0-rc3-0.7-default #2 HUAWEI TECHNOLOGIES CO.,LTD. Tecal/CN21WBSA 
[  532.808382] RIP: 0010:[<ffffffff81087573>]  [<ffffffff81087573>] kthread_data+0x13/0x20 
[  532.808390] RSP: 0018:ffff880111eaf7e8  EFLAGS: 00010006 
[  532.808397] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88011318d6c8 
[  532.808404] RDX: ffff88011318d680 RSI: 0000000000000001 RDI: ffff88011318d680 
[  532.808412] RBP: ffff880111eaf7e8 R08: 0000000000000000 R09: 0000000000000001 
[  532.808422] R10: 0000000000000800 R11: 0000000000000000 R12: ffff88011318dc10 
[  532.808432] R13: 0000000000000001 R14: ffff88011a9d1b00 R15: 0000000000000000 
[  532.808442] FS:  0000000000000000(0000) GS:ffff88011a800000(0000) knlGS:0000000000000000 
[  532.808455] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[  532.808468] CR2: fffffffffffffff8 CR3: 0000000001c0c000 CR4: 00000000000007e0 
[  532.808487] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[  532.808504] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[  532.808516] Process kworker/1:2 (pid: 930, threadinfo ffff880111eae000, task ffff88011318d680) 
[  532.808531] Stack: 
[  532.808549]  ffff880111eaf808 ffffffff8107d428 ffff880111eaf808 ffff880111eae010 
[  532.808570]  ffff880111eaf948 ffffffff8162231d ffff880111eae010 00000000001d1b00 
[  532.808596]  00000000001d1b00 ffff88011318d680 00000000001d1b00 ffff880111eaffd8 
[  532.808608] Call Trace: 
[  532.808618]  [<ffffffff8107d428>] wq_worker_sleeping+0x18/0x130 
[  532.808639]  [<ffffffff8162231d>] __schedule+0x92d/0xe00 
[  532.808651]  [<ffffffff810d976d>] ? trace_hardirqs_on+0x1d/0x30 
[  532.808667]  [<ffffffff812f43c0>] ? put_io_context+0xc0/0x110 
[  532.808682]  [<ffffffff812f453b>] ? put_io_context_active+0x12b/0x1a0 
[  532.808705]  [<ffffffff81622984>] schedule+0x34/0xc0 
[  532.808717]  [<ffffffff8105f306>] do_exit+0x9a6/0xe60 
[  532.808732]  [<ffffffff81057c38>] ? kmsg_dump+0x98/0x1e0 
[  532.808759]  [<ffffffff8162698c>] oops_end+0x15c/0x160 
[  532.808775]  [<ffffffff81008889>] die+0x79/0xd0 
[  532.808794]  [<ffffffff81625fe8>] do_trap+0x1b8/0x1f0 
[  532.808813]  [<ffffffff81005988>] do_invalid_op+0xb8/0x100 
[  532.808830]  [<ffffffff811ec127>] ? shrink_dcache_for_umount_subtree+0x267/0x290 
[  532.808844]  [<ffffffff81058d0e>] ? vprintk_emit+0x23e/0x820 
[  532.808856]  [<ffffffff81326c0d>] ? trace_hardirqs_off_thunk+0x3a/0x3c 
[  532.808872]  [<ffffffff81625720>] ? restore_args+0x30/0x30 
[  532.808886]  [<ffffffff816302eb>] invalid_op+0x1b/0x20 
[  532.808916]  [<ffffffff811ec127>] ? shrink_dcache_for_umount_subtree+0x267/0x290 
[  532.808933]  [<ffffffff811ec19a>] shrink_dcache_for_umount+0x4a/0x90 
[  532.808952]  [<ffffffff811cc3c7>] generic_shutdown_super+0x37/0x160 
[  532.808972]  [<ffffffff811cc5d9>] kill_anon_super+0x19/0x40 
[  532.808986]  [<ffffffff811cc63a>] kill_litter_super+0x3a/0x50 
[  532.809011]  [<ffffffff810fb65a>] cgroup_kill_sb+0x20a/0x280 
[  532.809026]  [<ffffffff811ccdc5>] deactivate_locked_super+0x65/0xb0 
[  532.809040]  [<ffffffff811ce339>] deactivate_super+0x89/0xe0 
[  532.809056]  [<ffffffff810f7734>] cgroup_d_release+0x34/0x40 
[  532.809070]  [<ffffffff811eb258>] d_free+0x58/0xc0 
[  532.809083]  [<ffffffff811ee5f0>] dput+0x220/0x350 
[  532.809095]  [<ffffffff810f7429>] css_dput_fn+0x19/0x30 
[  532.809112]  [<ffffffff8107b4d9>] process_one_work+0x239/0x800 
[  532.809128]  [<ffffffff8107b450>] ? process_one_work+0x1b0/0x800 
[  532.809142]  [<ffffffff810f7410>] ? cgroup_rename+0x70/0x70 
[  532.809170]  [<ffffffff8107eba3>] worker_thread+0x2e3/0x710 
[  532.809190]  [<ffffffff8107e8c0>] ? manage_workers+0x370/0x370 
[  532.809207]  [<ffffffff81087e46>] kthread+0xd6/0xf0 
[  532.809234]  [<ffffffff81630474>] kernel_thread_helper+0x4/0x10 
[  532.809254]  [<ffffffff816256f0>] ? retint_restore_args+0x13/0x13 
[  532.809279]  [<ffffffff81087d70>] ? __init_kthread_worker+0x80/0x80 
[  532.809291]  [<ffffffff81630470>] ? gs_change+0x13/0x13 
[  532.809352] Code: 00 48 89 e5 8b 40 f0 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 05 e0 46 71 01 01 55 48 8b 87 38 05 00 00 48 89 e5 <48> 8b 40 f8 c9 c3 0f 1f 80 00 00 00 00 55 48 3b 3d 78 46 71 01 
[  532.809369] RIP  [<ffffffff81087573>] kthread_data+0x13/0x20 
[  532.809376]  RSP <ffff880111eaf7e8> 
[  532.809381] CR2: fffffffffffffff8 
[  532.809390] ---[ end trace 1e5c705163c24a86 ]--- 
[  532.809401] Fixing recursive fault but reboot is needed! 
[  592.820384] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0, t=15002 jiffies) 
[  592.820402] INFO: Stall ended before state dump start 
[  609.100148] INFO: rcu_bh detected stalls on CPUs/tasks: { 1} (detected by 0, t=15002 jiffies) 
[  609.100168] INFO: Stall ended before state dump start --
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
