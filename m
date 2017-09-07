From: Prateek Sood <prsood@codeaurora.org>
Subject: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Thu,  7 Sep 2017 19:26:23 +0530
Message-ID: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504792599;
        bh=4Dazj0ZqmJZm3Mant58JhyUR0T7nHXbfl52cLk2lf/8=;
        h=From:To:Cc:Subject:Date:From;
        b=bLs/2pn+L6rnBi8X8tagOWWhLuz7GROd0RaZ7qbPpIGdt3v6xGE28fYYZvXK/irXh
         6hHCwJ+pl+7UCu1OmEb1SQQ0AJxDz2weQEYNldPClwAzl5RdvURygLMtaEH6yr00OF
         2eFU8MjbkNx3k5WcMJFa07p7MBqVjcZArx9f8Vzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1504792598;
        bh=4Dazj0ZqmJZm3Mant58JhyUR0T7nHXbfl52cLk2lf/8=;
        h=From:To:Cc:Subject:Date:From;
        b=gG/dfn4GDqf42hdYDWafqSGg9eVoltdSBdpWHSOAWFvBuTiQ8n1EMa4pS8D4GowQG
         R4ggTWYVKqL9bwjZcUy6pcdjT++466fu/0Gt4mRSvgScOURGJC/EIqUYUDhMfOyoD2
         RXR4P9BWe4i/G7LSEPsFC9qG4KsqlVGk3DWJJRis=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, peterz@infradead.org, boqun.feng@gmail.com, tglx@linutronix.de
Cc: Prateek Sood <prsood@codeaurora.org>, linux-kernel@vger.kernel.org, sramana@codeaurora.org

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

Signed-off-by: Prateek Sood <prsood@codeaurora.org>
---
 kernel/cgroup/cpuset.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2f4039b..60dc0ac 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -816,16 +816,15 @@ static int generate_sched_domains(cpumask_var_t **domains,
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
@@ -833,27 +832,27 @@ static void rebuild_sched_domains_locked(void)
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
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
-	rebuild_sched_domains_locked();
+	rebuild_sched_domains_cpuslocked();
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 /**
@@ -940,7 +939,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 	rcu_read_unlock();
 
 	if (need_rebuild_sched_domains)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 }
 
 /**
@@ -1273,7 +1272,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 		cs->relax_domain_level = val;
 		if (!cpumask_empty(cs->cpus_allowed) &&
 		    is_sched_load_balance(cs))
-			rebuild_sched_domains_locked();
+			rebuild_sched_domains_cpuslocked();
 	}
 
 	return 0;
@@ -1306,7 +1305,6 @@ static void update_tasks_flags(struct cpuset *cs)
  *
  * Call with cpuset_mutex held.
  */
-
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on)
 {
@@ -1339,7 +1337,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	spin_unlock_irq(&callback_lock);
 
 	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
-		rebuild_sched_domains_locked();
+		rebuild_sched_domains_cpuslocked();
 
 	if (spread_flag_changed)
 		update_tasks_flags(cs);
@@ -1607,6 +1605,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
@@ -1644,6 +1643,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1654,6 +1654,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1668,6 +1669,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1706,6 +1708,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1731,6 +1734,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -2031,13 +2035,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
+ * will call rebuild_sched_domains_cpuslocked().
  */
 
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	if (is_sched_load_balance(cs))
@@ -2047,6 +2052,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., 
is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

