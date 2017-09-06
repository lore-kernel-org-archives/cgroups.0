From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Wed,  6 Sep 2017 17:18:55 +0530
Message-ID: <1504698535-8187-1-git-send-email-prsood@codeaurora.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504698563;
        bh=aRvFVTYdzyB/mK+a4/DRtOOr+MVYV5ScOMij5AI1rcc=;
        h=From:To:Cc:Subject:Date:From;
        b=Ea9LXHkL69+Jx0ZEvkHLoTKb/RkNM6rb8jnhcNjo+xVTu9h9tIRWtVLdnajLyRF9S
         tY6tt9s9bm56gnSbI/GDIWNdjzTNwVHUg7NlXUTIZlOG5/1/SlyIaNL8bfyiuCqw3x
         U6+1DLfZ2FAGZohJZ1O0AUleQdMwJTYzMFHLvbiE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504698561;
        bh=aRvFVTYdzyB/mK+a4/DRtOOr+MVYV5ScOMij5AI1rcc=;
        h=From:To:Cc:Subject:Date:From;
        b=NdXqNZVRW2fOMw97ZNtzBiz4zHdCzE8Q+dLgTpF+M92JE4qGSVAePkS4l2jLWMiEG
         6bZGLxAbu28jm+L5VkxgR/oHuzfwRPmzVe8lWs5XQn4CMRILcPiui/nLpcqwmCW+wD
         NYVzynAf0bYL5bH8NGq5HGBYBV0PbV8ZtrmuAIDU=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

Remove circular dependency deadlock in a scenario where hotplug of CPU is
being done while there is updation in cgroup and cpuset triggered from
userspace.

Example scenario:
kworker/0:0 => kthreadd => init:729 => init:1 => kworker/0:0

kworker/0:0 - lock(cpuhotplug.mutex)  [held]
              flush(work)   [no high prio workqueue available on CPU]
              wait_for_completion()

kthreadd    - percpu_down_read(cgroup_threadgroup_rwsem)  [waiting]

init:729    - percpu_down_write(cgroup_threadgroup_rwsem)   [held]
              lock(cpuset_mutex)   [waiting]

init:1      - lock(cpuset_mutex)   [held]
              lock(cpuhotplug.mutex)   [waiting]

Eliminate this dependecy by reordering locking of cpuset_mutex
and cpuhotplug.mutex in following order
1. Acquire cpuhotplug.mutex
2. Acquire cpuset_mutex

Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 70 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2f4039b..c7a3901 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -843,10 +843,41 @@ static void rebuild_sched_domains_locked(void)
 out:
 	put_online_cpus();
 }
+
+/*
+ * Rebuild scheduler domains.
+ * Call with following mutex held in the order
+ * 1. cpuhotplug.mutex
+ * 2. cpuset_mutex
+ */
+static void rebuild_sched_domains_unlocked(void)
+{
+        struct sched_domain_attr *attr;
+        cpumask_var_t *doms;
+        int ndoms;
+
+        /*
+         * We have raced with CPU hotplug. Don't do anything to avoid
+         * passing doms with offlined cpu to partition_sched_domains().
+         * Anyways, hotplug work item will rebuild sched domains.
+         */
+        if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
+                return;
+
+        /* Generate domain masks and attrs */
+        ndoms = generate_sched_domains(&doms, &attr);
+
+        /* Have scheduler rebuild the domains */
+        partition_sched_domains(ndoms, doms, attr);
+}
 #else /* !CONFIG_SMP */
 static void rebuild_sched_domains_locked(void)
 {
 }
+
+static void rebuild_sched_domains_unlocked(void)
+{
+}
 #endif /* CONFIG_SMP */
 
 void rebuild_sched_domains(void)
@@ -885,7 +916,9 @@ static void update_tasks_cpumask(struct cpuset *cs)
  *
  * On legacy hierachy, effective_cpus will be the same with cpu_allowed.
  *
- * Called with cpuset_mutex held
+ * Called with following mutex held in order
+ * 1. cpuhotplug.mutex
+ * 2. cpuset_mutex
  */
 static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 {
@@ -940,7 +973,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 	rcu_read_unlock();
 
 	if (need_rebuild_sched_domains)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_unlocked();
 }
 
 /**
@@ -1262,6 +1295,11 @@ int current_cpuset_is_being_rebound(void)
 	return ret;
 }
 
+/*
+ * Call with following mutex held in order
+ * 1. cpuhotplug.mutex
+ * 2. cpuset_mutex
+ */
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
@@ -1273,7 +1311,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 		cs->relax_domain_level = val;
 		if (!cpumask_empty(cs->cpus_allowed) &&
 		    is_sched_load_balance(cs))
-			rebuild_sched_domains_locked();
+			rebuild_sched_domains_unlocked();
 	}
 
 	return 0;
@@ -1304,9 +1342,10 @@ static void update_tasks_flags(struct cpuset *cs)
  * cs:		the cpuset to update
  * turning_on: 	whether the flag is being set or cleared
  *
- * Call with cpuset_mutex held.
+ * Call with following mutex held in order
+ * 1. cpuhotplug.mutex
+ * 2. cpuset_mutex
  */
-
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
@@ -1339,7 +1378,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_unlocked();
 
 	if (spread_flag_changed)
 		update_tasks_flags(cs);
@@ -1607,6 +1646,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
@@ -1644,6 +1684,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1654,6 +1695,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1668,6 +1710,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1706,6 +1749,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1731,6 +1775,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -2031,13 +2076,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
+ * will call rebuild_sched_domains_unlocked().
  */
 
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	if (is_sched_load_balance(cs))
@@ -2047,6 +2093,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)
@@ -2341,8 +2388,13 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	}
 
 	/* rebuild sched domains if cpus_allowed has changed */
-	if (cpus_updated)
-		rebuild_sched_domains();
+	if (cpus_updated) {
+		get_online_cpus();
+		mutex_lock(&cpuset_mutex);
+		rebuild_sched_domains_unlocked();
+		mutex_unlock(&cpuset_mutex);
+		put_online_cpus();
+	}
 }
 
 void cpuset_update_active_cpus(void)
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
