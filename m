From: Sasha Levin <sasha.levin@oracle.com>
Subject: cgroup: kernel BUG at kernel/cgroup.c:1038!
Date: Tue, 25 Jun 2013 13:20:59 -0400
Message-ID: <51C9D17B.5090208@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <trinity-owner@vger.kernel.org>
Sender: trinity-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: lizefan@huawei.com, tj@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, trinity@vger.kernel.org

Hi all,

While fuzzing with trinity on a KVM tools guest running latest -next kernel, I've
stumbled on the following spew:

[   88.247018] kernel BUG at kernel/cgroup.c:1038!
[   88.250738] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   88.251169] Dumping ftrace buffer:
[   88.251169]    (ftrace buffer empty)
[   88.251169] CPU: 1 PID: 7973 Comm: mount Tainted: G        W    3.10.0-rc7-next-2013
0625-sasha-00011-g1c1dc0e #1105
[   88.251169] task: ffff880fc0ae8000 ti: ffff880fc0b9a000 task.ti: ffff880fc0b9a000
[   88.251437] RIP: 0010:[<ffffffff81249b29>]  [<ffffffff81249b29>] rebind_subsystems+0
x409/0x5f0
[   88.252442] RSP: 0018:ffff880fc0b9bba8  EFLAGS: 00010202
[   88.252994] RAX: 0000000000000001 RBX: ffff880fc0b8a148 RCX: 0000000000000001
[   88.253839] RDX: 0000000000000003 RSI: 0000000000000001 RDI: ffffffff8860eec0
[   88.254695] RBP: ffff880fc0b9bc28 R08: ffff880fc0b8a170 R09: ffffffff889e64f8
[   88.255325] R10: ffffffff889e64d0 R11: ffffffff8a28b600 R12: 0000000000000001
[   88.255325] R13: 0000000000000000 R14: ffff880fc0b8a170 R15: ffffffff87a6f060
[   88.255325] FS:  00007f1289eba7e0(0000) GS:ffff880fe5800000(0000) knlGS:000000000000
0000
[   88.255325] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   88.255325] CR2: 00007f12894382f0 CR3: 0000000fc01e0000 CR4: 00000000000006e0
[   88.255325] Stack:
[   88.255325]  ffffffff87a6e4d8 ffffffff87a6e468 2222222222222222 2222222222222222
[   88.255325]  2222222222222222 2222222200000001 0000000000000000 0000000187a6e460
[   88.255325]  ffff880fc0b8a160 0000000000000000 ffff880fcc2f8b88 ffff880fc0b8a148
[   88.255325] Call Trace:
[   88.255325]  [<ffffffff8124bd4f>] cgroup_kill_sb+0xff/0x210
[   88.255325]  [<ffffffff813d21af>] deactivate_locked_super+0x4f/0x90
[   88.255325]  [<ffffffff8124f3b3>] cgroup_mount+0x673/0x6e0
[   88.255325]  [<ffffffff81401a6d>] ? get_fs_type+0x7d/0xd0
[   88.255325]  [<ffffffff854e95ec>] ? _raw_read_unlock+0x5c/0x80
[   88.255325]  [<ffffffff81257169>] cpuset_mount+0xd9/0x110
[   88.255325]  [<ffffffff81337908>] ? pcpu_alloc+0x4e8/0x5f0
[   88.255325]  [<ffffffff813d2580>] mount_fs+0xb0/0x2d0
[   88.255325]  [<ffffffff81404afd>] vfs_kern_mount+0xbd/0x180
[   88.255325]  [<ffffffff814070b5>] do_new_mount+0x145/0x2c0
[   88.255325]  [<ffffffff81de79b8>] ? security_capable+0x18/0x20
[   88.255325]  [<ffffffff814085d6>] do_mount+0x356/0x3c0
[   88.255325]  [<ffffffff8140873d>] SyS_mount+0xfd/0x140
[   88.255325]  [<ffffffff854eb600>] tracesys+0xdd/0xe2
[   88.255325] Code: 89 c6 89 45 a8 e8 28 b7 07 00 8b 45 a8 48 63 d0 48 83 c2 02 48 8b 0c d5 48 63 
9e 88 48 ff c1 85 c0 48 89 0c d5 48 63 9e 88 74 04 <0f> 0b eb fe 4a 8b 84 2b 88 00 00 00 48 c7 c7 98 
ee 60 88 4c 39
[   88.255325] RIP  [<ffffffff81249b29>] rebind_subsystems+0x409/0x5f0
[   88.255325]  RSP <ffff880fc0b9bba8>


Thanks,
Sasha
