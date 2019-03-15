From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: fs_context-related oops in mainline
Date: Fri, 15 Mar 2019 08:43:07 +0100
Message-ID: <20190315074307.GA31430@light.dominikbrodowski.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, linux-kernel@vger.kernel.org

David, Al,

commit 23bf1b6be9c2 ("kernfs, sysfs, cgroup, intel_rdt: Support fs_context")
seems to have introduced a bug; at least that's the commit I bisected the
following oops down to:

[    0.827317] BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
[    0.829771] #PF error: [normal kernel read fault]
[    0.831141] PGD 800000007f927067 P4D 800000007f927067 PUD 7f928067 PMD 0 
[    0.833116] Oops: 0000 [#1] PREEMPT SMP PTI
[    0.834330] CPU: 1 PID: 46 Comm: mount Tainted: G                T 5.0.0-rc2+ #38
[    0.836478] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.12.0-20181126_142135-anatol 04/01/2014
[    0.839322] RIP: 0010:sysfs_init_fs_context+0x82/0xd0
[    0.840777] Code: 15 fb ef af 01 48 89 45 08 48 c7 45 10 72 65 65 62 48 c7 03 60 66 22 8f 48 85 ff 48 89 55 00 74 09 f0 ff 8f 5
[    0.846170] RSP: 0018:ffffa55e8041bdb8 EFLAGS: 00010202
[    0.847693] RAX: 0000000000000000 RBX: ffff949bbc0fee00 RCX: 0000000000000000
[    0.850013] RDX: ffff949bbc878d00 RSI: 0000000000000000 RDI: ffffffff8f645c40
[    0.852134] RBP: ffff949bbc0ff400 R08: 0000000000000001 R09: 00000000001ef140
[    0.854211] R10: 0000000136a1068e R11: 0000000000000001 R12: 0000000000000000
[    0.856225] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000008000
[    0.858350] FS:  000000000050b558(0000) GS:ffff949bbce00000(0000) knlGS:0000000000000000
[    0.860738] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.862391] CR2: 0000000000000220 CR3: 000000007c1f0004 CR4: 00000000003606e0
[    0.864463] Call Trace:
[    0.865200]  alloc_fs_context+0xfa/0x170
[    0.866349]  do_mount+0x8fa/0xf50
[    0.867310]  ? memdup_user+0x4b/0x70
[    0.868350]  ksys_mount+0xba/0xd0
[    0.869291]  __x64_sys_mount+0x21/0x30
[    0.870390]  do_syscall_64+0x6a/0x3f4
[    0.871465]  ? lockdep_hardirqs_off+0x79/0xd0
[    0.872744]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[    0.874106]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[    0.875584] RIP: 0033:0x4bf02f
[    0.876496] Code: e8 06 21 f4 ff 5a c3 48 63 ff 50 48 63 d2 b8 67 00 00 00 0f 05 48 89 c7 e8 ee 20 f4 ff 5a c3 49 89 ca 50 b8 8
[    0.882329] RSP: 002b:00007ffc1befbd80 EFLAGS: 00000212 ORIG_RAX: 00000000000000a5
[    0.884110] RAX: ffffffffffffffda RBX: 00007ffc1befc058 RCX: 00000000004bf02f
[    0.885871] RDX: 00007ffc1befdf84 RSI: 00007ffc1befdf90 RDI: 00007ffc1befdf8a
[    0.888102] RBP: 00007ffc1befdf8a R08: 0000000000000000 R09: 8080808080808080
[    0.890154] R10: 0000000000008000 R11: 0000000000000212 R12: 00007ffc1befdf90
[    0.892107] R13: 00007ffc1befdf84 R14: 0000000000008000 R15: 0000000000000000
[    0.893537] CR2: 0000000000000220
[    0.894467] ---[ end trace 0a9affd2a96301a9 ]---
[    0.896230] RIP: 0010:sysfs_init_fs_context+0x82/0xd0
[    0.897494] Code: 15 fb ef af 01 48 89 45 08 48 c7 45 10 72 65 65 62 48 c7 03 60 66 22 8f 48 85 ff 48 89 55 00 74 09 f0 ff 8f 5
[    0.903017] RSP: 0018:ffffa55e8041bdb8 EFLAGS: 00010202
[    0.904315] RAX: 0000000000000000 RBX: ffff949bbc0fee00 RCX: 0000000000000000
[    0.905857] RDX: ffff949bbc878d00 RSI: 0000000000000000 RDI: ffffffff8f645c40
[    0.907444] RBP: ffff949bbc0ff400 R08: 0000000000000001 R09: 00000000001ef140
[    0.909973] R10: 0000000136a1068e R11: 0000000000000001 R12: 0000000000000000
[    0.911415] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000008000
[    0.913726] FS:  000000000050b558(0000) GS:ffff949bbce00000(0000) knlGS:0000000000000000
[    0.916710] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.918129] CR2: 0000000000000220 CR3: 000000007c1f0004 CR4: 00000000003606e0

This occurs while trying to mount sysfs in initramfs

	mount -n -t sysfs sysfs /sys

All this obviously runs in qemu; config and further information are available upon request.

Thanks,
	Dominik
