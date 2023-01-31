From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] cpuset: Fix cpuset_cpus_allowed() to not filter offline CPUs
Date: Tue, 31 Jan 2023 22:17:18 +0000
Message-ID: <20230131221719.3176-2-will@kernel.org>
References: <20230131221719.3176-1-will@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675203446;
        bh=ELfyS2nEQLpVpTwQYA/Y76BnsftBMsvCjEcLwiHp7V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfTuawChPCNl9Geuhr0xvy93l5JDQisVlKYHhjH/PfAaEzwpic+WNs3QMvLjz93I0
         WOrnIvHvp81Y3wCqXP4jLx48EN45G9jZxuM2l7EofC6G0X9VeoszRHJ+QCSEZYJaZ5
         ra4tk+7dO/u7a8vCq0Aw9iOCSq3lipvtj+wcDtJweZVxO1w//nQtG/59RA6sHZPvKt
         XY3PVrGHBw+yA5zPqPCNG/eao/QPJ6RxpN+yCjaYrPN4dtH+WZE1VMGKzPpPhJBAJQ
         gpArYGeEzyBb8EIQ7ehvR5aklzi7yKQ2yVjAXW3JTXY+08g8MRfQHiozQ+0jYuQWaq
         e0ddTf9L2Vrcg==
In-Reply-To: <20230131221719.3176-1-will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

There is a difference in behaviour between CPUSET={y,n} that is now
wrecking havoc with {relax,force}_compatible_cpus_allowed_ptr().

Specifically, since commit 8f9ea86fdf99 ("sched: Always preserve the
user requested cpumask")  relax_compatible_cpus_allowed_ptr() is
calling __sched_setaffinity() unconditionally.

But the underlying problem goes back a lot further, possibly to
commit: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}") which
switched cpuset_cpus_allowed() from cs->cpus_allowed to
cs->effective_cpus.

The problem is that for CPUSET=y cpuset_cpus_allowed() will filter out
all offline CPUs. For tasks that are part of a (!root) cpuset this is
then later fixed up by the cpuset hotplug notifiers that re-evaluate
and re-apply cs->effective_cpus, but for (normal) tasks in the root
cpuset this does not happen and they will forever after be excluded
from CPUs onlined later.

As such, rewrite cpuset_cpus_allowed() to return a wider mask,
including the offline CPUs.

Fixes: 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
Reported-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Link: https://lkml.kernel.org/r/20230117160825.GA17756@willie-the-truck
Signed-off-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a29c0b13706b..8552cc2c586a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3683,23 +3683,52 @@ void __init cpuset_init_smp(void)
 	BUG_ON(!cpuset_migrate_mm_wq);
 }
 
+static const struct cpumask *__cs_cpus_allowed(struct cpuset *cs)
+{
+	const struct cpumask *cs_mask = cs->cpus_allowed;
+	if (!parent_cs(cs))
+		cs_mask = cpu_possible_mask;
+	return cs_mask;
+}
+
+static void cs_cpus_allowed(struct cpuset *cs, struct cpumask *pmask)
+{
+	do {
+		cpumask_and(pmask, pmask, __cs_cpus_allowed(cs));
+		cs = parent_cs(cs);
+	} while (cs);
+}
+
 /**
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
  * @pmask: pointer to struct cpumask variable to receive cpus_allowed set.
  *
- * Description: Returns the cpumask_var_t cpus_allowed of the cpuset
- * attached to the specified @tsk.  Guaranteed to return some non-empty
- * subset of cpu_online_mask, even if this means going outside the
- * tasks cpuset.
+ * Description: Returns the cpumask_var_t cpus_allowed of the cpuset attached
+ * to the specified @tsk.  Guaranteed to return some non-empty intersection
+ * with cpu_online_mask, even if this means going outside the tasks cpuset.
  **/
 
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
 	unsigned long flags;
+	struct cpuset *cs;
 
 	spin_lock_irqsave(&callback_lock, flags);
-	guarantee_online_cpus(tsk, pmask);
+	rcu_read_lock();
+
+	cs = task_cs(tsk);
+	do {
+		cpumask_copy(pmask, task_cpu_possible_mask(tsk));
+		cs_cpus_allowed(cs, pmask);
+
+		if (cpumask_intersects(pmask, cpu_online_mask))
+			break;
+
+		cs = parent_cs(cs);
+	} while (cs);
+
+	rcu_read_unlock();
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
-- 
2.39.1.456.gfc5497dd1b-goog

