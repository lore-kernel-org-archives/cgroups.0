From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu, 26 Oct 2017 17:22:02 +0530
Message-ID: <1509018722-30359-1-git-send-email-prsood@codeaurora.org>
References: <20171025093041.GO3165@worktop.lehotels.local>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1509018742;
        bh=84E0gQD8jLWem2VToU2SGP7q/ZrZTnLVJCANgIb+Oxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+6TP0UPsxyxCD/VR7ki+Dvu5aMNqr2c2PdIepwVoMbmeu3xiLY5mnEihUq4MwGlK
         b36sMvd4oCh5nFneyw3Q2uflLHIJ5XWBs/gLZxlHE1OxBMbuu3/5KmsexxD23Fs5BD
         tDDt4UgcZKm+eCfbry56cxSqCyI2KZnBaZxn/Y0E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1509018741;
        bh=84E0gQD8jLWem2VToU2SGP7q/ZrZTnLVJCANgIb+Oxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejttPojDtInM+/EAKDXct4vZ9/rvEJ0P8RwSULsQuI93BOZ/XqCVmYC3f9PLGjjv+
         U4okhik8tHFbB/COLMAoEH08HrzJOXnn9ZmNGkqboYx5kybsrGMqYceYFZxBCsdYaL
         ssWsrdf9AjhdHoByImXQRb/SIYOxLon3JtHW6n5k=
In-Reply-To: <20171025093041.GO3165-IIpfhp3q70x9+YH6RuovlLjjLBE8jN/0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Remove circular dependency deadlock in a scenario where hotplug of CPU is
being done while there is updation in cgroup and cpuset triggered from
userspace.

Process A => kthreadd => Process B => Process C => Process A

Process A
cpu_subsys_offline();
  cpu_down();
    _cpu_down();
      percpu_down_write(&cpu_hotplug_lock); //held
      cpuhp_invoke_callback();
        workqueue_offline_cpu();
          wq_update_unbound_numa();
            kthread_create_on_node();
              wake_up_process();  //wakeup kthreadd
          flush_work();
          wait_for_completion();

kthreadd
kthreadd();
  kernel_thread();
    do_fork();
      copy_process();
        percpu_down_read(&cgroup_threadgroup_rwsem);
          __rwsem_down_read_failed_common(); //waiting

Process B
kernfs_fop_write();
  cgroup_file_write();
    cgroup_procs_write();
      percpu_down_write(&cgroup_threadgroup_rwsem); //held
      cgroup_attach_task();
        cgroup_migrate();
          cgroup_migrate_execute();
            cpuset_can_attach();
              mutex_lock(&cpuset_mutex); //waiting

Process C
kernfs_fop_write();
  cgroup_file_write();
    cpuset_write_resmask();
      mutex_lock(&cpuset_mutex); //held
      update_cpumask();
        update_cpumasks_hier();
          rebuild_sched_domains_locked();
            get_online_cpus();
              percpu_down_read(&cpu_hotplug_lock); //waiting

Eliminating deadlock by reversing the locking order for cpuset_mutex and
cpu_hotplug_lock.

Signed-off-by: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 include/linux/cpuset.h |  6 -----
 kernel/cgroup/cpuset.c | 70 ++++++++++++++++++++++++++------------------------
 kernel/power/process.c |  2 --
 kernel/sched/core.c    |  1 -
 4 files changed, 36 insertions(+), 43 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a1e6a33..e74655d 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -51,9 +51,7 @@ static inline void cpuset_dec(void)
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
-extern void cpuset_wait_for_hotplug(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -166,15 +164,11 @@ static inline void set_mems_allowed(nodemask_t nodemask)
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
index 4657e29..a8213c2 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -826,16 +826,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
  * 'cpus' is removed, then call this routine to rebuild the
  * scheduler's dynamic sched domains.
  *
- * Call with cpuset_mutex held.  Takes get_online_cpus().
  */
-static void rebuild_sched_domains_locked(void)
+static void rebuild_sched_domains_cpuslocked(void)
 {
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
 	int ndoms;
 
 	lockdep_assert_held(&cpuset_mutex);
-	get_online_cpus();
 
 	/*
 	 * We have raced with CPU hotplug. Don't do anything to avoid
@@ -843,27 +841,27 @@ static void rebuild_sched_domains_locked(void)
 	 * Anyways, hotplug work item will rebuild sched domains.
 	 */
 	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
-		goto out;
+		return;
 
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-out:
-	put_online_cpus();
 }
 #else /* !CONFIG_SMP */
-static void rebuild_sched_domains_locked(void)
+static void rebuild_sched_domains_cpuslocked(void)
 {
 }
 #endif /* CONFIG_SMP */
 
 void rebuild_sched_domains(void)
 {
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
-	rebuild_sched_domains_locked();
+	rebuild_sched_domains_cpuslocked();
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 }
 
 /**
@@ -949,7 +947,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 	rcu_read_unlock();
 
 	if (need_rebuild_sched_domains)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 }
 
 /**
@@ -1281,7 +1279,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 		cs->relax_domain_level = val;
 		if (!cpumask_empty(cs->cpus_allowed) &&
 		    is_sched_load_balance(cs))
-			rebuild_sched_domains_locked();
+			rebuild_sched_domains_cpuslocked();
 	}
 
 	return 0;
@@ -1314,7 +1312,6 @@ static void update_tasks_flags(struct cpuset *cs)
  *
  * Call with cpuset_mutex held.
  */
-
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
@@ -1347,7 +1344,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 
 	if (spread_flag_changed)
 		update_tasks_flags(cs);
@@ -1615,6 +1612,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
@@ -1652,6 +1650,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 	return retval;
 }
 
@@ -1662,6 +1661,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1676,6 +1676,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 	return retval;
 }
 
@@ -1714,6 +1715,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1739,6 +1741,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -2039,13 +2042,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
+ * will call rebuild_sched_domains_cpuslocked().
  */
 
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 
 	if (is_sched_load_balance(cs))
@@ -2055,6 +2059,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)
@@ -2275,15 +2280,8 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs)
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
@@ -2298,7 +2296,7 @@ void cpuset_force_rebuild(void)
  * Note that CPU offlining during suspend is ignored.  We don't modify
  * cpusets across suspend/resume cycles at all.
  */
-static void cpuset_hotplug_workfn(struct work_struct *work)
+static void cpuset_hotplug(bool use_cpu_hp_lock)
 {
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
@@ -2356,25 +2354,29 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	}
 
 	/* rebuild sched domains if cpus_allowed has changed */
-	if (cpus_updated || force_rebuild) {
-		force_rebuild = false;
-		rebuild_sched_domains();
+	if (cpus_updated) {
+		if (use_cpu_hp_lock)
+			rebuild_sched_domains();
+		else {
+			/* When called during cpu hotplug cpu_hotplug_lock
+			 * is held by the calling thread, not
+			 * not cpuhp_thread_fun
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
index 50f25cb..28772b405 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -203,8 +203,6 @@ void thaw_processes(void)
 	__usermodehelper_set_disable_depth(UMH_FREEZING);
 	thaw_workqueues();
 
-	cpuset_wait_for_hotplug();
-
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, p) {
 		/* No other threads should have PF_SUSPEND_TASK set */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d17c5da..25b8717 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5590,7 +5590,6 @@ static void cpuset_cpu_active(void)
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
