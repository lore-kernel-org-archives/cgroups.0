From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v3 2/2] cpuset: Make cpuset hotplug synchronous
Date: Wed, 15 Nov 2017 19:50:15 +0530
Message-ID: <1510755615-25906-3-git-send-email-prsood@codeaurora.org>
References: <20171115103742.xt7muaq2dfrs2cyd@hirez.programming.kicks-ass.net>
 <1510755615-25906-1-git-send-email-prsood@codeaurora.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510755670;
        bh=JTsQHW4GItGPTjRYNBoXVyw/ExLMauAGSz8z1vFga3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9OrNxDuODcbC23DTTpPP9qKfohs0np8Mu3l0x7tG9N4I2+4xi9x3cH4q4u2STzy+
         nZrSP6J6y16LToKsjxgDn4Sv9tI3x/rRzJs0VQsLjQ0xS3TRSblYuhSP83v01W92Sn
         LXehhKcnb+7VRgQcjajnM6McLEJAV3A9zEIF05Aw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510755670;
        bh=JTsQHW4GItGPTjRYNBoXVyw/ExLMauAGSz8z1vFga3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q9OrNxDuODcbC23DTTpPP9qKfohs0np8Mu3l0x7tG9N4I2+4xi9x3cH4q4u2STzy+
         nZrSP6J6y16LToKsjxgDn4Sv9tI3x/rRzJs0VQsLjQ0xS3TRSblYuhSP83v01W92Sn
         LXehhKcnb+7VRgQcjajnM6McLEJAV3A9zEIF05Aw=
In-Reply-To: <1510755615-25906-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clingutla-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

Convert cpuset_hotplug_workfn() into synchronous call for cpu hotplug
path. For memory hotplug path it still gets queued as a work item.

Since cpuset_hotplug_workfn() can be made synchronous for cpu hotplug
path, it is not required to wait for cpuset hotplug while thawing
processes.

Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 include/linux/cpuset.h |  6 ------
 kernel/cgroup/cpuset.c | 41 ++++++++++++++++++++---------------------
 kernel/power/process.c |  2 --
 kernel/sched/core.c    |  1 -
 4 files changed, 20 insertions(+), 30 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 1b8e415..2ab910f 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -52,9 +52,7 @@ static inline void cpuset_dec(void)
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
-extern void cpuset_wait_for_hotplug(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -167,15 +165,11 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline void cpuset_force_rebuild(void) { }
-
 static inline void cpuset_update_active_cpus(void)
 {
 	partition_sched_domains(1, NULL, NULL);
 }
 
-static inline void cpuset_wait_for_hotplug(void) { }
-
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index cab5fd1..227bc25 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2277,15 +2277,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs)
 	mutex_unlock(&cpuset_mutex);
 }
 
-static bool force_rebuild;
-
-void cpuset_force_rebuild(void)
-{
-	force_rebuild = true;
-}
-
 /**
- * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
+ * cpuset_hotplug - handle CPU/memory hotunplug for a cpuset
  *
  * This function is called after either CPU or memory configuration has
  * changed and updates cpuset accordingly.  The top_cpuset is always
@@ -2300,7 +2293,7 @@ void cpuset_force_rebuild(void)
  * Note that CPU offlining during suspend is ignored.  We don't modify
  * cpusets across suspend/resume cycles at all.
  */
-static void cpuset_hotplug_workfn(struct work_struct *work)
+static void cpuset_hotplug(bool use_cpu_hp_lock)
 {
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
@@ -2358,25 +2351,31 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	}
 
 	/* rebuild sched domains if cpus_allowed has changed */
-	if (cpus_updated || force_rebuild) {
-		force_rebuild = false;
-		rebuild_sched_domains();
+	if (cpus_updated) {
+		if (use_cpu_hp_lock)
+			rebuild_sched_domains();
+		else {
+			/* Acquiring cpu_hotplug_lock is not required.
+			 * When cpuset_hotplug() is called in hotplug path,
+			 * cpu_hotplug_lock is held by the hotplug context
+			 * which is waiting for cpuhp_thread_fun to indicate
+			 * completion of callback.
+			 */
+			mutex_lock(&cpuset_mutex);
+			rebuild_sched_domains_cpuslocked();
+			mutex_unlock(&cpuset_mutex);
+		}
 	}
 }
 
-void cpuset_update_active_cpus(void)
+static void cpuset_hotplug_workfn(struct work_struct *work)
 {
-	/*
-	 * We're inside cpu hotplug critical region which usually nests
-	 * inside cgroup synchronization.  Bounce actual hotplug processing
-	 * to a work item to avoid reverse locking order.
-	 */
-	schedule_work(&cpuset_hotplug_work);
+	cpuset_hotplug(true);
 }
 
-void cpuset_wait_for_hotplug(void)
+void cpuset_update_active_cpus(void)
 {
-	flush_work(&cpuset_hotplug_work);
+	cpuset_hotplug(false);
 }
 
 /*
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 7381d49..c326d72 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -204,8 +204,6 @@ void thaw_processes(void)
 	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
 
-	cpuset_wait_for_hotplug();
-
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, p) {
 		/* No other threads should have PF_SUSPEND_TASK set */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5b82a00..efcf753 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5600,7 +5600,6 @@ static void cpuset_cpu_active(void)
 		 * restore the original sched domains by considering the
 		 * cpuset configurations.
 		 */
-		cpuset_force_rebuild();
 	}
 	cpuset_update_active_cpus();
 }
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
