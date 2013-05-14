From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] memcg: don't initialize kmem-cache destroying work for root caches
Date: Tue, 14 May 2013 16:38:38 +0400
Message-ID: <1368535118-27369-1-git-send-email-avagin@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

struct memcg_cache_params has a union. Different parts of this union are
used for root and non-root caches. A part with destroying work is used only
for non-root caches.

[  115.096202] BUG: unable to handle kernel paging request at 0000000fffffffe0
[  115.096785] IP: [<ffffffff8116b641>] kmem_cache_alloc+0x41/0x1f0
[  115.097024] PGD 7ace1067 PUD 0
[  115.097024] Oops: 0000 [#4] SMP
[  115.097024] Modules linked in: netlink_diag af_packet_diag udp_diag tcp_diag inet_diag unix_diag ip6table_filter ip6_tables i2c_piix4 virtio_net virtio_balloon microcode i2c_core pcspkr floppy
[  115.097024] CPU: 0 PID: 1929 Comm: lt-vzctl Tainted: G      D      3.10.0-rc1+ #2
[  115.097024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  115.097024] task: ffff88007b5aaee0 ti: ffff88007bf0c000 task.ti: ffff88007bf0c000
[  115.097024] RIP: 0010<ffffffff8116b641>]  [<ffffffff8116b641>] kmem_cache_alloc+0x41/0x1f0
[  115.097024] RSP: 0018:ffff88007bf0de68  EFLAGS: 00010202
[  115.097024] RAX: 0000000fffffffe0 RBX: 00007fff4014f200 RCX: 0000000000000300
[  115.097024] RDX: 0000000000000005 RSI: 00000000000000d0 RDI: ffff88007d001300
[  115.097024] RBP: ffff88007bf0dea8 R08: 00007f849c3141b7 R09: ffffffff8118e100
[  115.097024] R10: 0000000000000001 R11: 0000000000000246 R12: 00000000000000d0
[  115.097024] R13: 0000000fffffffe0 R14: ffff88007d001300 R15: 0000000000001000
[  115.097024] FS:  00007f849cbb8b40(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[  115.097024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  115.097024] CR2: 0000000fffffffe0 CR3: 000000007bc38000 CR4: 00000000000006f0
[  115.097024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  115.097024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  115.097024] Stack:
[  115.097024]  ffffffff8118e100 ffffffff81149ea1 0000000000000008 00007fff4014f200
[  115.097024]  00007fff4014f200 0000000000000000 0000000000000000 0000000000001000
[  115.097024]  ffff88007bf0dee8 ffffffff8118e100 ffff880037598e00 00007fff4014f200
[  115.097024] Call Trace:
[  115.097024]  [<ffffffff8118e100>] ? getname_flags.part.34+0x30/0x140
[  115.097024]  [<ffffffff81149ea1>] ? vma_rb_erase+0x121/0x210
[  115.097024]  [<ffffffff8118e100>] getname_flags.part.34+0x30/0x140
[  115.097024]  [<ffffffff8118e248>] getname+0x38/0x60
[  115.097024]  [<ffffffff81181d55>] do_sys_open+0xc5/0x1e0
[  115.097024]  [<ffffffff81181e92>] SyS_open+0x22/0x30
[  115.097024]  [<ffffffff8161cb82>] system_call_fastpath+0x16/0x1b
[  115.097024] Code: f4 53 48 83 ec 18 8b 05 8e 53 b7 00 4c 8b 4d 08 21 f0 a8 10 74 0d 4c 89 4d c0 e8 1b 76 4a 00 4c 8b 4d c0 e9 92 00 00 00 4d 89 f5 <4d> 8b 45 00 65 4c 03 04 25 48 cd 00 00 49 8b 50 08 4d 8b 38 49
[  115.097024] RIP  [<ffffffff8116b641>] kmem_cache_alloc+0x41/0x1f0
[  115.097024]  RSP <ffff88007bf0de68>
[  115.097024] CR2: 0000000fffffffe0
[  115.121352] ---[ end trace 16bb8e8408b97d0e ]---

Cc: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb1c9de..764b9e4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3141,8 +3141,6 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
 			return -ENOMEM;
 		}
 
-		INIT_WORK(&s->memcg_params->destroy,
-				kmem_cache_destroy_work_func);
 		s->memcg_params->is_root_cache = true;
 
 		/*
-- 
1.8.1.4
