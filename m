From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2] cgroup/cpuset: Don't filter offline CPUs in cpuset_cpus_allowed() for top cpuset tasks
Date: Sun,  5 Feb 2023 22:48:53 -0500
Message-ID: <20230206034853.330463-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675655362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IpJlMbJRGMZmMDrtHPjj3U2BT9EG2aPl3b1EE2nsKis=;
        b=eGu8yv2kdrBsHFNWsAOQPaQtRcHD41phRAFBZ/y3CB5kGVCzH24l5dXkWmpPXlZ1+B+Xvv
        pCRrTU/etI3bAXeWHYyewH3FB3kmF91kJ5V3Dch0B4Lb0Gqx1wkGz+wcJ7zMNiJ0sd8dFq
        RjXqQLc3n0vreJV0QwgarK/8bkY/Uog=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@android.com, Waiman Long <longman@redhat.com>

Since commit 8f9ea86fdf99 ("sched: Always preserve the user
requested cpumask"), relax_compatible_cpus_allowed_ptr() is calling
__sched_setaffinity() unconditionally. This helps to expose a bug in
the current cpuset hotplug code where the cpumasks of the tasks in
the top cpuset are not updated at all when some CPUs become online or
offline. It is likely caused by the fact that some of the tasks in the
top cpuset, like percpu kthreads, cannot have their cpu affinity changed.

One way to reproduce this as suggested by Peter is:
 - boot machine
 - offline all CPUs except one
 - taskset -p ffffffff $$
 - online all CPUs

Fix this by allowing cpuset_cpus_allowed() to return a wider mask that
includes offline CPUs for those tasks that are in the top cpuset. For
tasks not in the top cpuset, the old rule applies and only online CPUs
will be returned in the mask since hotplug events will update their
cpumasks accordingly.

Fixes: 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
Reported-by: Will Deacon <will@kernel.org>
Originally-from: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Will Deacon <will@kernel.org>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

 [v2] Remove "TODO".

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 207bafdb05e8..6630f74967ea 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3707,15 +3707,38 @@ void __init cpuset_init_smp(void)
  * Description: Returns the cpumask_var_t cpus_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
  * subset of cpu_online_mask, even if this means going outside the
- * tasks cpuset.
+ * tasks cpuset, except when the task is in the top cpuset.
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
+	if (cs != &top_cpuset)
+		guarantee_online_cpus(tsk, pmask);
+	/*
+	 * Tasks in the top cpuset won't get update to their cpumasks
+	 * when a hotplug online/offline event happens. So we include all
+	 * offline cpus in the allowed cpu list.
+	 */
+	if ((cs == &top_cpuset) || cpumask_empty(pmask)) {
+		const struct cpumask *possible_mask = task_cpu_possible_mask(tsk);
+
+		/*
+		 * We first exclude cpus allocated to partitions. If there is no
+		 * allowable online cpu left, we fall back to all possible cpus.
+		 */
+		cpumask_andnot(pmask, possible_mask, top_cpuset.subparts_cpus);
+		if (!cpumask_intersects(pmask, cpu_online_mask))
+			cpumask_copy(pmask, possible_mask);
+	}
+
+	rcu_read_unlock();
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
-- 
2.31.1

