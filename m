From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Subject: Lockdep warning at cset_cgroup_from_root()
Date: Fri, 1 Jan 2016 12:10:08 +0900
Message-ID: <201601011210.BEB82753.OFtOMLJHFOSQVF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

I booted a CONFIG_PREEMPT_NONE=y && CONFIG_SMP=n kernel, and got flood of
below warning.
The location is lockdep_assert_held(&css_set_lock) in cset_cgroup_from_root()
in kernel/cgroup.c. linux.git as of 9c982e86dbdb does not hit this warning.

[    2.355852] ------------[ cut here ]------------
[    2.357417] WARNING: CPU: 0 PID: 59 at kernel/cgroup.c:1159 cset_cgroup_from_root+0x98/0xc0()
[    2.360329] Modules linked in:
[    2.361574] CPU: 0 PID: 59 Comm: kworker/0:2 Not tainted 4.4.0-rc7-next-20151231 #268
[    2.364241] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[    2.367500] Workqueue: events cgroup_release_agent
[    2.369399]  0000000000000000 0000000006fe97c4 ffff880035adbc90 ffffffff8135125d
[    2.372378]  ffff880035adbcc8 ffffffff8105fde6 ffff88007bec4000 ffffffff81c4aae0
[    2.375042]  0000000000001000 0000000000000000 ffffffff81c3fb40 ffff880035adbcd8
[    2.377731] Call Trace:
[    2.378775]  [<ffffffff8135125d>] dump_stack+0x19/0x1c
[    2.380289]  [<ffffffff8105fde6>] warn_slowpath_common+0x76/0xb0
[    2.382044]  [<ffffffff8105ff25>] warn_slowpath_null+0x15/0x20
[    2.383765]  [<ffffffff810d12a8>] cset_cgroup_from_root+0x98/0xc0
[    2.386169]  [<ffffffff810d436a>] cgroup_path+0x4a/0x80
[    2.388037]  [<ffffffff810d4530>] cgroup_release_agent+0xb0/0x110
[    2.389813]  [<ffffffff81078623>] ? process_one_work+0x133/0x400
[    2.391487]  [<ffffffff81078687>] process_one_work+0x197/0x400
[    2.393163]  [<ffffffff81078623>] ? process_one_work+0x133/0x400
[    2.394942]  [<ffffffff81078a14>] worker_thread+0x124/0x490
[    2.396565]  [<ffffffff816a5a82>] ? __schedule+0x2b2/0x880
[    2.398183]  [<ffffffff810788f0>] ? process_one_work+0x400/0x400
[    2.399942]  [<ffffffff8107e308>] kthread+0xf8/0x110
[    2.401394]  [<ffffffff8107e210>] ? kthread_create_on_node+0x220/0x220
[    2.415321]  [<ffffffff816ab2df>] ret_from_fork+0x3f/0x70
[    2.416921]  [<ffffffff8107e210>] ? kthread_create_on_node+0x220/0x220
[    2.419011] ---[ end trace 4bbece452f458d9b ]---
