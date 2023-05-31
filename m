From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/6] cgroup/cpuset: Improve temporary cpumasks handling
Date: Wed, 31 May 2023 12:34:01 -0400
Message-ID: <20230531163405.2200292-3-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685550854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dnclgW5iNRTHpshzwEto29UyjPb2x7GdQxiRrKMztLM=;
        b=e+Jqq6eMr0NKwoCIs7+YCBx0TRRRiDTAO/hH2z03BYsYPZoTAJGDJ98bGM2BNG73ed0XQ9
        XTf2rgUQ80Gm+bBxyj7ys29FLPOGCW8UHJQfSRCxJxUi5Ec1DKOKVwsrg9ml2109jAz/BO
        rOp2rbPY94HnLjLOH3az0Fl0zg7eOSc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>

The limitation that update_parent_subparts_cpumask() can only use
addmask & delmask in the given tmp cpumasks is fragile and may lead to
unexpected error. Add a new statically allocated cs_tmp_cpus cpumask
(protected by cpuset_mutex) for internal use so that all the three
temporary cpumasks can be freely used.

With this change, we can move the update_tasks_cpumask() for the
parent and update_sibling_cpumasks() for the sibling to inside
update_parent_subparts_cpumask().

Also add a init_tmpmasks() helper to handle initialization of the tmpmasks
structure when cpumasks are too big to be statically allocated on stack.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 66 ++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 12a0b583aca4..8604c919e1e4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -208,6 +208,8 @@ struct cpuset {
 	struct cgroup_file partition_file;
 };
 
+static cpumask_var_t	cs_tmp_cpus;	/* Temp cpumask for partition */
+
 /*
  * Partition root states:
  *
@@ -668,6 +670,24 @@ static inline void free_cpumasks(struct cpuset *cs, struct tmpmasks *tmp)
 	}
 }
 
+/*
+ * init_tmpmasks - Initialize the cpumasks in tmpmasks with the given ones
+ */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+static inline void
+init_tmpmasks(struct tmpmasks *tmp, struct cpumask *new_cpus,
+	      struct cpumask *addmask, struct cpumask *delmask)
+{
+	tmp->new_cpus = new_cpus;
+	tmp->addmask  = addmask;
+	tmp->delmask  = delmask;
+}
+#else
+static inline void
+init_tmpmasks(struct tmpmasks *tmp, struct cpumask *new_cpus,
+	      struct cpumask *addmask, struct cpumask *delmask) { }
+#endif
+
 /**
  * alloc_trial_cpuset - allocate a trial cpuset
  * @cs: the cpuset that the trial cpuset duplicates
@@ -1300,6 +1320,8 @@ enum subparts_cmd {
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on);
+static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
+				    struct tmpmasks *tmp);
 
 /*
  * Update partition exclusive flag
@@ -1463,7 +1485,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
 					parent->subparts_cpus);
 		/*
-		 * Empty cpumask is not allewed
+		 * Empty cpumask is not allowed
 		 */
 		if (cpumask_empty(newmask)) {
 			part_error = PERR_CPUSEMPTY;
@@ -1583,8 +1605,11 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 
 	spin_unlock_irq(&callback_lock);
 
-	if (adding || deleting)
+	if (adding || deleting) {
 		update_tasks_cpumask(parent, tmp->addmask);
+		if (parent->child_ecpus_count)
+			update_sibling_cpumasks(parent, cs, tmp);
+	}
 
 	/*
 	 * For partcmd_update without newmask, it is being called from
@@ -1839,18 +1864,13 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
 	/*
 	 * Use the cpumasks in trialcs for tmpmasks when they are pointers
-	 * to allocated cpumasks.
-	 *
-	 * Note that update_parent_subparts_cpumask() uses only addmask &
-	 * delmask, but not new_cpus.
+	 * to allocated cpumasks & save the newmask into cs_tmp_cpus.
 	 */
-	tmp.addmask  = trialcs->subparts_cpus;
-	tmp.delmask  = trialcs->effective_cpus;
-	tmp.new_cpus = NULL;
-#endif
+	cpumask_copy(cs_tmp_cpus, trialcs->cpus_allowed);
+	init_tmpmasks(&tmp, trialcs->cpus_allowed, trialcs->subparts_cpus,
+		      trialcs->effective_cpus);
 
 	retval = validate_change(cs, trialcs);
 
@@ -1870,7 +1890,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		parent = parent_cs(cs);
 		cpuset_for_each_child(cp, css, parent)
 			if (is_partition_valid(cp) &&
-			    cpumask_intersects(trialcs->cpus_allowed, cp->cpus_allowed)) {
+			    cpumask_intersects(cs_tmp_cpus, cp->cpus_allowed)) {
 				rcu_read_unlock();
 				update_parent_subparts_cpumask(cp, partcmd_invalidate, NULL, &tmp);
 				rcu_read_lock();
@@ -1887,13 +1907,15 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 						       NULL, &tmp);
 		else
 			update_parent_subparts_cpumask(cs, partcmd_update,
-						trialcs->cpus_allowed, &tmp);
+						cs_tmp_cpus, &tmp);
 	}
 
+	/* Restore trialcs->cpus_allowed */
+	cpumask_copy(trialcs->cpus_allowed, cs_tmp_cpus);
 	compute_effective_cpumask(trialcs->effective_cpus, trialcs,
 				  parent_cs(cs));
 	spin_lock_irq(&callback_lock);
-	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	cpumask_copy(cs->cpus_allowed, cs_tmp_cpus);
 
 	/*
 	 * Make sure that subparts_cpus, if not empty, is a subset of
@@ -1914,11 +1936,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	}
 	spin_unlock_irq(&callback_lock);
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	/* Now trialcs->cpus_allowed is available */
-	tmp.new_cpus = trialcs->cpus_allowed;
-#endif
-
 	/* effective_cpus will be updated here */
 	update_cpumasks_hier(cs, &tmp, false);
 
@@ -2343,13 +2360,11 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 		err = update_parent_subparts_cpumask(cs, partcmd_enable,
 						     NULL, &tmpmask);
-		if (err)
-			goto out;
 	} else if (old_prs && new_prs) {
 		/*
 		 * A change in load balance state only, no change in cpumasks.
 		 */
-		goto out;
+		;
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
@@ -2369,12 +2384,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			spin_unlock_irq(&callback_lock);
 		}
 	}
-
-	update_tasks_cpumask(parent, tmpmask.new_cpus);
-
-	if (parent->child_ecpus_count)
-		update_sibling_cpumasks(parent, cs, &tmpmask);
-
 out:
 	/*
 	 * Make partition invalid & disable CS_CPU_EXCLUSIVE if an error
@@ -3500,6 +3509,7 @@ int __init cpuset_init(void)
 	BUG_ON(!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL));
 	BUG_ON(!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&top_cpuset.subparts_cpus, GFP_KERNEL));
+	BUG_ON(!zalloc_cpumask_var(&cs_tmp_cpus, GFP_KERNEL));
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
-- 
2.31.1

