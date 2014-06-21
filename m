From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Date: Fri, 20 Jun 2014 17:56:48 -0700
Message-ID: <20140620175648.666cae72.akpm@linux-foundation.org>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
	<1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
	<53A4D323.5080808@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53A4D323.5080808-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 20 Jun 2014 20:34:43 -0400 Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> I'm seeing the following when booting a VM, bisection pointed me to this
> patch.
> 
> [   32.830823] BUG: using __this_cpu_add() in preemptible [00000000] code: mkdir/8677

Thanks.  This one was fixed earlier today.

From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: memcg: mem_cgroup_charge_statistics needs preempt_disable

preempt_disable was previously disabled by lock_page_cgroup which has been
removed by "mm: memcontrol: rewrite uncharge API".

This fixes the a flood of splats like this:
[    3.149371] BUG: using __this_cpu_add() in preemptible [00000000] code: udevd/1271
[    3.151458] caller is __this_cpu_preempt_check+0x13/0x15
[    3.152927] CPU: 0 PID: 1271 Comm: udevd Not tainted 3.15.0-test1 #366
[    3.154637] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[    3.156788]  0000000000000000 ffff88000005fba8 ffffffff814efe3f 0000000000000000
[    3.158810]  ffff88000005fbd8 ffffffff8125b969 ffff880007413448 0000000000000001
[    3.160836]  ffffea00001e8c00 0000000000000001 ffff88000005fbe8 ffffffff8125b9a8
[    3.162950] Call Trace:
[    3.163598]  [<ffffffff814efe3f>] dump_stack+0x4e/0x7a
[    3.164942]  [<ffffffff8125b969>] check_preemption_disabled+0xd2/0xe5
[    3.166618]  [<ffffffff8125b9a8>] __this_cpu_preempt_check+0x13/0x15
[    3.168267]  [<ffffffff8112b630>] mem_cgroup_charge_statistics.isra.36+0xb5/0xc6
[    3.170169]  [<ffffffff8112d2c5>] commit_charge+0x23c/0x256
[    3.171823]  [<ffffffff8113101b>] mem_cgroup_commit_charge+0xb8/0xd7
[    3.173838]  [<ffffffff810f5dab>] shmem_getpage_gfp+0x399/0x605
[    3.175363]  [<ffffffff810f7456>] shmem_write_begin+0x3d/0x58
[    3.176854]  [<ffffffff810e1361>] generic_perform_write+0xbc/0x192
[    3.178445]  [<ffffffff8114a086>] ? file_update_time+0x34/0xac
[    3.179952]  [<ffffffff810e2ae4>] __generic_file_aio_write+0x2c0/0x300
[    3.181655]  [<ffffffff810e2b76>] generic_file_aio_write+0x52/0xbd
[    3.183234]  [<ffffffff81133944>] do_sync_write+0x59/0x78
[    3.184630]  [<ffffffff81133ea8>] vfs_write+0xc4/0x181
[    3.185957]  [<ffffffff81134801>] SyS_write+0x4a/0x91
[    3.187258]  [<ffffffff814fd30e>] tracesys+0xd0/0xd5

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---

 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-4 mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-4
+++ a/mm/memcontrol.c
@@ -904,6 +904,8 @@ static void mem_cgroup_charge_statistics
 					 struct page *page,
 					 int nr_pages)
 {
+	preempt_disable();
+
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
 	 * counted as CACHE even if it's on ANON LRU.
@@ -928,6 +930,7 @@ static void mem_cgroup_charge_statistics
 	}
 
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
+	preempt_enable();
 }
 
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
_
