From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: [BUG] NULL ptr deref in css_free_rwork_fn
Date: Wed, 16 Sep 2020 08:58:49 +0200
Message-ID: <dd06bf27-b0d0-d956-abfc-d2a209f0a225@i2se.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi,

i noticed a regular crash (NULL pointer dereference) on my ARM i.MX28
board using the current mainline kernel (last tested version Linux
5.9-rc5). I also tested Linux 5.8, but i wasn't able to reproduce with
this version, so i assume this is a regression. The crash happens mostly
short after boot or during shutdown. Unfortunately i don't have a
specific scenario to trigger this issue. The issue was reproducable with
arm/mxs_defconfig.

Here is the crash output:

[   58.670665] 8<--- cut here ---
[   58.673844] Unable to handle kernel NULL pointer dereference at
virtual address 000002c0
[   58.682130] pgd = aa9080fa
[   58.684863] [000002c0] *pgd=00000000
[   58.688467] Internal error: Oops: 5 [#1] ARM
[   58.692743] Modules linked in:
[   58.695826] CPU: 0 PID: 41 Comm: kworker/0:2 Not tainted
5.9.0-rc5-00009-g9d3c35e #15
[   58.703660] Hardware name: Freescale MXS (Device Tree)
[   58.708830] Workqueue: cgroup_destroy css_free_rwork_fn
[   58.714089] PC is at kernfs_put+0xb8/0x1c4
[   58.718195] LR is at 0xc6f4c7c0
[   58.721342] pc : [<c01b3cb4>]    lr : [<c6f4c7c0>]    psr: 00000013
[   58.727614] sp : c7787ed0  ip : 60000013  fp : c6f47a10
[   58.732843] r10: c6f4c9c0  r9 : c0ae95fc  r8 : c0ae95f8
[   58.738072] r7 : c74249c8  r6 : c6f486e0  r5 : c670b898  r4 : 000002c0
[   58.744603] r3 : 00000000  r2 : 00000001  r1 : 00000001  r0 : c7ee4030
[   58.751138] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
Segment none
[   58.758280] Control: 0005317f  Table: 44d18000  DAC: 00000053
[   58.764043] Process kworker/0:2 (pid: 41, stack limit = 0x6fb11f96)
[   58.770322] Stack: (0xc7787ed0 to 0xc7788000)
[   58.774697] 7ec0:                                     60000013
c0ae2664 c7ee4d00 00000000
[   58.782896] 7ee0: c653b800 c74249c0 c0ab2df4 c653b864 00000000
c653b800 c7ee4d00 00000000
[   58.791096] 7f00: 00000000 c653b868 c0ab2df4 c0083574 c653b864
c773d720 00000000 c7ee4d00
[   58.799295] 7f20: 00000000 c00309e8 c0a21370 c7786000 c0a28fa0
c773d720 c0a2135c c773d734
[   58.807493] 7f40: c0a21370 c7786000 c0a28fa0 00000008 c0a2135c
c0031158 c773d720 c7497eb8
[   58.815693] 7f60: c7787f7c c778c100 c7781200 00000000 c7786000
c0031108 c773d720 c7497eb8
[   58.823890] 7f80: c778c120 c00371d4 60000013 c7781200 c00370dc
00000000 00000000 00000000
[   58.832087] 7fa0: 00000000 00000000 00000000 c0008540 00000000
00000000 00000000 00000000
[   58.840282] 7fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.848478] 7fe0: 00000000 00000000 00000000 00000000 00000013
00000000 00000000 00000000
[   58.856698] [<c01b3cb4>] (kernfs_put) from [<c0083574>]
(css_free_rwork_fn+0x19c/0x3ac)
[   58.864739] [<c0083574>] (css_free_rwork_fn) from [<c00309e8>]
(process_one_work+0x14c/0x4d4)
[   58.873293] [<c00309e8>] (process_one_work) from [<c0031158>]
(worker_thread+0x50/0x590)
[   58.881421] [<c0031158>] (worker_thread) from [<c00371d4>]
(kthread+0xf8/0x134)
[   58.888764] [<c00371d4>] (kthread) from [<c0008540>]
(ret_from_fork+0x14/0x34)
[   58.895996] Exception stack(0xc7787fb0 to 0xc7787ff8)
[   58.901062] 7fa0:                                     00000000
00000000 00000000 00000000
[   58.909259] 7fc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[   58.917452] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
[   58.924088] Code: ebfdce1f e1a0000a ebfce9aa e154000b (e5943000)
[   58.930410] ---[ end trace 73455566ad3e0105 ]---


