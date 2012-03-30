From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [RFC 7/7] Global optimization
Date: Fri, 30 Mar 2012 10:04:45 +0200
Message-ID: <1333094685-5507-8-git-send-email-glommer@parallels.com>
References: <1333094685-5507-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333094685-5507-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

When we are close to the limit, doing percpu_counter_add and its
equivalent tests is a waste of time.

This patch introduce a "global" state flag to the res_counter.
When we are close to the limit, this flag is set and we skip directly
to the locked part. The flag is unset when we are far enough away from
the limit.

In this mode, we function very much like the original resource counter

The main difference right now is that we still scan all the cpus.
This should however be very easy to avoid, with a flusher function
that empties the per-cpu areas, and then updating usage_pcp directly.

This should be doable because once we get the global flag, we know
no one else would be adding to the percpu areas any longer.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 include/linux/res_counter.h |    1 +
 kernel/res_counter.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index 3527827..a8e4646 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -30,6 +30,7 @@ struct res_counter {
 	 * the limit that usage cannot exceed
 	 */
 	unsigned long long limit;
+	bool global;
 	/*
 	 * the limit that usage can be exceed
 	 */
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 7b05208..859a27d 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -29,6 +29,8 @@ int __res_counter_add(struct res_counter *c, long val, bool fail)
 	u64 usage;
 
 	rcu_read_lock();
+	if (c->global)
+		goto global;
 
 	if (val < 0) {
 		percpu_counter_add(&c->usage_pcp, val);
@@ -45,9 +47,25 @@ int __res_counter_add(struct res_counter *c, long val, bool fail)
 		return 0;
 	}
 
+global:
 	rcu_read_unlock();
 
 	raw_spin_lock(&c->usage_pcp.lock);
+	usage = __percpu_counter_sum_locked(&c->usage_pcp);
+
+	/* everyone that could update global is under lock
+	 * reader could miss a transition, but that is not a problem,
+	 * since we are always using percpu_counter_sum anyway
+	 */
+
+	if (!c->global && val > 0 && usage + val >
+	    (c->limit + num_online_cpus() * percpu_counter_batch))
+		c->global = true;
+
+	if (c->global && val < 0 && usage + val <
+	    (c->limit + num_online_cpus() * percpu_counter_batch))
+		c->global = false;
+
 
 	usage = __percpu_counter_sum_locked(&c->usage_pcp);
 
-- 
1.7.4.1
