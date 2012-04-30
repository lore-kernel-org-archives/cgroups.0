From: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] slab: Fix imbalanced rcu locking
Date: Mon, 30 Apr 2012 03:01:39 -0700
Message-ID: <20120430100138.GB28569@lizard>
References: <20120430095918.GA13824@lizard>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120430095918.GA13824@lizard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org

Not sure why the code tries to unlock the rcu. The
only case where slab grabs the lock is around
mem_cgroup_get_kmem_cache() call, which won't result
into calling cache_grow() (that tries to unlock the rcu).

=====================================
[ BUG: bad unlock balance detected! ]
3.4.0-rc4+ #33 Not tainted
-------------------------------------
swapper/0/0 is trying to release lock (rcu_read_lock) at:
[<ffffffff8134f0b4>] cache_grow.constprop.63+0xe8/0x371
but there are no more locks to release!

other info that might help us debug this:
no locks held by swapper/0/0.

stack backtrace:
Pid: 0, comm: swapper/0 Not tainted 3.4.0-rc4+ #33
Call Trace:
 [<ffffffff8134f0b4>] ? cache_grow.constprop.63+0xe8/0x371
 [<ffffffff8134cf09>] print_unlock_inbalance_bug.part.26+0xd1/0xd9
 [<ffffffff8134f0b4>] ? cache_grow.constprop.63+0xe8/0x371
 [<ffffffff8106865e>] print_unlock_inbalance_bug+0x4e/0x50
 [<ffffffff8134f0b4>] ? cache_grow.constprop.63+0xe8/0x371
 [<ffffffff8106cb26>] __lock_release+0xd6/0xe0
 [<ffffffff8106cb8c>] lock_release+0x5c/0x80
 [<ffffffff8134f0cc>] cache_grow.constprop.63+0x100/0x371
 [<ffffffff8134f5c6>] cache_alloc_refill+0x289/0x2dc
 [<ffffffff810bf682>] ? kmem_cache_alloc+0x92/0x260
 [<ffffffff81676a0f>] ? pidmap_init+0x79/0xb2
 [<ffffffff810bf842>] kmem_cache_alloc+0x252/0x260
 [<ffffffff810bf5f0>] ? kmem_freepages+0x180/0x180
 [<ffffffff81676a0f>] pidmap_init+0x79/0xb2
 [<ffffffff81667aa3>] start_kernel+0x297/0x2f8
 [<ffffffff8166769e>] ? repair_env_string+0x5a/0x5a
 [<ffffffff816672fd>] x86_64_start_reservations+0x101/0x105
 [<ffffffff816673f1>] x86_64_start_kernel+0xf0/0xf7

Signed-off-by: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/slab_def.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index c4f7e45..2d371ae 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -245,13 +245,11 @@ mem_cgroup_kmem_cache_prepare_sleep(struct kmem_cache *cachep)
 	 * enabled.
 	 */
 	kmem_cache_get_ref(cachep);
-	rcu_read_unlock();
 }
 
 static inline void
 mem_cgroup_kmem_cache_finish_sleep(struct kmem_cache *cachep)
 {
-	rcu_read_lock();
 	kmem_cache_drop_ref(cachep);
 }
 
-- 
1.7.9.2
