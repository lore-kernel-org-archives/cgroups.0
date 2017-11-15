From: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v3 1/2] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 15 Nov 2017 19:50:14 +0530
Message-ID: <1510755615-25906-2-git-send-email-prsood@codeaurora.org>
References: <20171115103742.xt7muaq2dfrs2cyd@hirez.programming.kicks-ass.net>
 <1510755615-25906-1-git-send-email-prsood@codeaurora.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510755658;
        bh=5gCB3TVY3LZFHDZrRIw/QT+4yrnnTyN8Fk+BEzm3nTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVnNT/HehJXp964lpNUOjz4uMzoKxuzGpo8ZapmJVEMkv4jst6kq8s2+CeRabK4CH
         uAfdF1cRbasv+k3iA27gZLwLM2AQ34v6bJq6ASaKzDnlII0pQDwZfUKs6IC4r5KBr1
         Cfx90RzsP8dD5vUbzSxu60m9NKGVCQxPWQMnxRwA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1510755658;
        bh=5gCB3TVY3LZFHDZrRIw/QT+4yrnnTyN8Fk+BEzm3nTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVnNT/HehJXp964lpNUOjz4uMzoKxuzGpo8ZapmJVEMkv4jst6kq8s2+CeRabK4CH
         uAfdF1cRbasv+k3iA27gZLwLM2AQ34v6bJq6ASaKzDnlII0pQDwZfUKs6IC4r5KBr1
         Cfx90RzsP8dD5vUbzSxu60m9NKGVCQxPWQMnxRwA=
In-Reply-To: <1510755615-25906-1-git-send-email-prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clingutla-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

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
            queue_work_on(); // unbind_work on system_highpri_wq
               __queue_work();
                 insert_work();
                    wake_up_worker();
            flush_work();
               wait_for_completion();

worker_thread();
   manage_workers();
      create_worker();
	     kthread_create_on_node();
		    wake_up_process(kthreadd_task);

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
 kernel/cgroup/cpuset.c | 53 ++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f7efa7b..cab5fd1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -812,6 +812,18 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	return ndoms;
 }
 
+static void cpuset_sched_change_begin(void)
+{
+	cpus_read_lock();
+	mutex_lock(&cpuset_mutex);
+}
+
+static void cpuset_sched_change_end(void)
+{
+	mutex_unlock(&cpuset_mutex);
+	cpus_read_unlock();
+}
+
 /*
  * Rebuild scheduler domains.
  *
@@ -821,16 +833,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
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
@@ -838,27 +848,25 @@ static void rebuild_sched_domains_locked(void)
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
-	mutex_lock(&cpuset_mutex);
-	rebuild_sched_domains_locked();
-	mutex_unlock(&cpuset_mutex);
+	cpuset_sched_change_begin();
+	rebuild_sched_domains_cpuslocked();
+	cpuset_sched_change_end();
 }
 
 /**
@@ -944,7 +952,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 	rcu_read_unlock();
 
 	if (need_rebuild_sched_domains)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 }
 
 /**
@@ -1276,7 +1284,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 		cs->relax_domain_level = val;
 		if (!cpumask_empty(cs->cpus_allowed) &&
 		    is_sched_load_balance(cs))
-			rebuild_sched_domains_locked();
+			rebuild_sched_domains_cpuslocked();
 	}
 
 	return 0;
@@ -1309,7 +1317,6 @@ static void update_tasks_flags(struct cpuset *cs)
  *
  * Call with cpuset_mutex held.
  */
-
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
@@ -1342,7 +1349,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 
 	if (spread_flag_changed)
 		update_tasks_flags(cs);
@@ -1610,7 +1617,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
-	mutex_lock(&cpuset_mutex);
+	cpuset_sched_change_begin();
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
 		goto out_unlock;
@@ -1646,7 +1653,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 		break;
 	}
 out_unlock:
-	mutex_unlock(&cpuset_mutex);
+	cpuset_sched_change_end();
 	return retval;
 }
 
@@ -1657,7 +1664,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
-	mutex_lock(&cpuset_mutex);
+	cpuset_sched_change_begin();
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
 
@@ -1670,7 +1677,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 		break;
 	}
 out_unlock:
-	mutex_unlock(&cpuset_mutex);
+	cpuset_sched_change_end();
 	return retval;
 }
 
@@ -1709,7 +1716,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
-	mutex_lock(&cpuset_mutex);
+	cpuset_sched_change_begin();
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
 
@@ -1733,7 +1740,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 
 	free_trial_cpuset(trialcs);
 out_unlock:
-	mutex_unlock(&cpuset_mutex);
+	cpuset_sched_change_end();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -2034,14 +2041,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
+ * will call rebuild_sched_domains_cpuslocked().
  */
 
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
-	mutex_lock(&cpuset_mutex);
+	cpuset_sched_change_begin();
 
 	if (is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
@@ -2049,7 +2056,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	cpuset_dec();
 	clear_bit(CS_ONLINE, &cs->flags);
 
-	mutex_unlock(&cpuset_mutex);
+	cpuset_sched_change_end();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
