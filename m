From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Mon,  9 Oct 2017 19:02:51 +0530
Message-ID: <1507555971-7231-1-git-send-email-prsood@codeaurora.org>
References: <4668d1ec-dc43-8a9c-4f94-a421683d3c17@codeaurora.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1507555987;
        bh=zyN5lOMu3/bFB2LgdeB6WPHaYt5LhtWzVckia55bv8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM4sq6xLkgC5JD3aoZ4SvBxr/LxOlKb1Gxw3qkyEuvAjjSKOjBvH01Jw0cTaqFWs1
         s6WqC0/xy+Wkt89kywhkzfmJu/a2YYY4eD64OR+s5cXVMVv5+8zXXjXUmZnlWmB4XY
         jrce6DjBGZoXYbYxFztTYZezcF6SGMw9TTC1tU2M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1507555986;
        bh=zyN5lOMu3/bFB2LgdeB6WPHaYt5LhtWzVckia55bv8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKBgPc0qUEm8pHJcVQTvGBF27VZ8Xcq4f4+we8XV9OIQEX5I8H8e/oh7w8uqsndcZ
         ruxeLd4ew7x7a8mmJPJHnvzF1rqXg/ckzRYW80K0VLWzeAkqsidO0VaPHtZGpW9nwh
         FOw8JFJu3jR5eh0DGfucrKcwikhg2TRazkxLRb7Y=
In-Reply-To: <4668d1ec-dc43-8a9c-4f94-a421683d3c17-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

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
 kernel/cgroup/cpuset.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4657e29..c493cdb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -826,16 +826,15 @@ static int generate_sched_domains(cpumask_var_t **domains,
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
 
+	lockdep_assert_cpus_held();
 	lockdep_assert_held(&cpuset_mutex);
-	get_online_cpus();
 
 	/*
 	 * We have raced with CPU hotplug. Don't do anything to avoid
@@ -843,27 +842,27 @@ static void rebuild_sched_domains_locked(void)
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
@@ -949,7 +948,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 	rcu_read_unlock();
 
 	if (need_rebuild_sched_domains)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 }
 
 /**
@@ -1281,7 +1280,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 		cs->relax_domain_level = val;
 		if (!cpumask_empty(cs->cpus_allowed) &&
 		    is_sched_load_balance(cs))
-			rebuild_sched_domains_locked();
+			rebuild_sched_domains_cpuslocked();
 	}
 
 	return 0;
@@ -1314,7 +1313,6 @@ static void update_tasks_flags(struct cpuset *cs)
  *
  * Call with cpuset_mutex held.
  */
-
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
@@ -1347,7 +1345,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 
 	if (spread_flag_changed)
 		update_tasks_flags(cs);
@@ -1615,6 +1613,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
@@ -1652,6 +1651,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 	return retval;
 }
 
@@ -1662,6 +1662,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1676,6 +1677,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 	return retval;
 }
 
@@ -1714,6 +1716,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
+	cpus_read_lock();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1739,6 +1742,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -2039,13 +2043,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
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
@@ -2055,6 +2060,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
