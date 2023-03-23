From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the percpu lock
Date: Thu, 23 Mar 2023 04:00:31 +0000
Message-ID: <20230323040037.2389095-2-yosryahmed@google.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zlRHMwQCwPxTz7URsIPFYEiZ1y/NkKG6JVNDPEffcgo=;
        b=q0IiHI38SIToezuWJ5YCNMq/43EaxUo3i4AMEPHcC9bZCfWe3qfaYbxabY9EbcCoqm
         LUESQ/1v1D2aalE9SO+twkVNP5hnW+UNiSPbsUMxGnfaQG+8mDUTyeXBv18fXpGW3SWD
         GCVDR2eWTWBw72p7FFHYiZQYGqUWBUdEyjEquw53iNIuEWGhIQhSBNfbqBw3sfwQmtJy
         zq0COAvO1AYz/HqEKQJev5lhSkkjfsk/GYKhQDhBPMJgp6hmFHeDaNzuC/4om1icb3Uk
         IS34ZPkCnh/Dxdz7tz/xvLp+bFG8mdt7D5IhxCaGQj3LQws3RSkaD2yIkaXnXsqGxGWA
         GdAQ==
In-Reply-To: <20230323040037.2389095-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently, when sleeping is not allowed during rstat flushing, we hold
the global rstat lock with interrupts disabled throughout the entire
flush operation. Flushing in an O(# cgroups * # cpus) operation, and
having interrupts disabled throughout is dangerous.

For some contexts, we may not want to sleep, but can be interrupted
(e.g. while holding a spinlock or RCU read lock). As such, do not
disable interrupts throughout rstat flushing, only when holding the
percpu lock. This breaks down the O(# cgroups * # cpus) duration with
interrupts disabled to a series of O(# cgroups) durations.

Furthermore, if a cpu spinning waiting for the global rstat lock, it
doesn't need to spin with interrupts disabled anymore.

If the caller of rstat flushing needs interrupts to be disabled, it's up
to them to decide that, and it should be fine to hold the global rstat
lock with interrupts disabled. There is currently a single context that
may invoke rstat flushing with interrupts disabled, the
mem_cgroup_flush_stats() call in mem_cgroup_usage(), if called from
mem_cgroup_threshold().

To make it safe to hold the global rstat lock with interrupts enabled,
make sure we only flush from in_task() contexts. The side effect of that
we read stale stats in interrupt context, but this should be okay, as
flushing in interrupt context is dangerous anyway as it is an expensive
operation, so reading stale stats is safer.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/rstat.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 831f1f472bb8..af11e28bd055 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -7,6 +7,7 @@
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
 
+/* This lock should only be held from task context */
 static DEFINE_SPINLOCK(cgroup_rstat_lock);
 static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
 
@@ -210,14 +211,24 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 		/* if @may_sleep, play nice and yield if necessary */
 		if (may_sleep && (need_resched() ||
 				  spin_needbreak(&cgroup_rstat_lock))) {
-			spin_unlock_irq(&cgroup_rstat_lock);
+			spin_unlock(&cgroup_rstat_lock);
 			if (!cond_resched())
 				cpu_relax();
-			spin_lock_irq(&cgroup_rstat_lock);
+			spin_lock(&cgroup_rstat_lock);
 		}
 	}
 }
 
+static bool should_skip_flush(void)
+{
+	/*
+	 * We acquire cgroup_rstat_lock without disabling interrupts, so we
+	 * should not try to acquire from interrupt contexts to avoid deadlocks.
+	 * It can be expensive to flush stats in interrupt context anyway.
+	 */
+	return !in_task();
+}
+
 /**
  * cgroup_rstat_flush - flush stats in @cgrp's subtree
  * @cgrp: target cgroup
@@ -229,15 +240,18 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
  * This also gets all cgroups in the subtree including @cgrp off the
  * ->updated_children lists.
  *
- * This function may block.
+ * This function is safe to call from contexts that disable interrupts, but
+ * @may_sleep must be set to false, otherwise the function may block.
  */
 __bpf_kfunc void cgroup_rstat_flush(struct cgroup *cgrp)
 {
-	might_sleep();
+	if (should_skip_flush())
+		return;
 
-	spin_lock_irq(&cgroup_rstat_lock);
+	might_sleep();
+	spin_lock(&cgroup_rstat_lock);
 	cgroup_rstat_flush_locked(cgrp, true);
-	spin_unlock_irq(&cgroup_rstat_lock);
+	spin_unlock(&cgroup_rstat_lock);
 }
 
 /**
@@ -248,11 +262,12 @@ __bpf_kfunc void cgroup_rstat_flush(struct cgroup *cgrp)
  */
 void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp)
 {
-	unsigned long flags;
+	if (should_skip_flush())
+		return;
 
-	spin_lock_irqsave(&cgroup_rstat_lock, flags);
+	spin_lock(&cgroup_rstat_lock);
 	cgroup_rstat_flush_locked(cgrp, false);
-	spin_unlock_irqrestore(&cgroup_rstat_lock, flags);
+	spin_unlock(&cgroup_rstat_lock);
 }
 
 /**
@@ -267,8 +282,11 @@ void cgroup_rstat_flush_irqsafe(struct cgroup *cgrp)
 void cgroup_rstat_flush_hold(struct cgroup *cgrp)
 	__acquires(&cgroup_rstat_lock)
 {
+	if (should_skip_flush())
+		return;
+
 	might_sleep();
-	spin_lock_irq(&cgroup_rstat_lock);
+	spin_lock(&cgroup_rstat_lock);
 	cgroup_rstat_flush_locked(cgrp, true);
 }
 
@@ -278,7 +296,7 @@ void cgroup_rstat_flush_hold(struct cgroup *cgrp)
 void cgroup_rstat_flush_release(void)
 	__releases(&cgroup_rstat_lock)
 {
-	spin_unlock_irq(&cgroup_rstat_lock);
+	spin_unlock(&cgroup_rstat_lock);
 }
 
 int cgroup_rstat_init(struct cgroup *cgrp)
-- 
2.40.0.rc1.284.g88254d51c5-goog

