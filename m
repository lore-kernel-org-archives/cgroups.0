From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 1/6] cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling
Date: Wed, 31 May 2023 12:34:00 -0400
Message-ID: <20230531163405.2200292-2-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685550858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hNwDItSa7gah8NTUpgcKB6a8T7nVlWQpfJD91nGKxdk=;
        b=SZs+jZ5G/JjI3aY5ViOhwjvAVKn6CpJLJm2zN6APHAv3vbjBiulLDyOtDH2NFnN0+9J0uj
        n3NQ9lNykR2JuPyUdAzyya02lfUb7FBKZlhTEUwvnRslanm2n1Ly3Bq2T9vqlVwZDeThiH
        bCgiqPUsTIC0Bq6Ib8pjfVspj6dUctk=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>

Extract out the setting of CS_CPU_EXCLUSIVE and CS_SCHED_LOAD_BALANCE
flags as well as the rebuilding of scheduling domains into the new
update_partition_exclusive() and update_partition_sd_lb() helper
functions to simplify the logic. The update_partition_exclusive()
helper is called mainly at the beginning of the caller, but it may be
called at the end too. The update_partition_sd_lb() helper is called
at the end of the caller.

This patch should reduce the chance that cpuset partition will end up
in an incorrect state.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 134 ++++++++++++++++++++++++-----------------
 1 file changed, 79 insertions(+), 55 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2c76fcd9f0bc..12a0b583aca4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1278,7 +1278,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 static void compute_effective_cpumask(struct cpumask *new_cpus,
 				      struct cpuset *cs, struct cpuset *parent)
 {
-	if (parent->nr_subparts_cpus) {
+	if (parent->nr_subparts_cpus && is_partition_valid(cs)) {
 		cpumask_or(new_cpus, parent->effective_cpus,
 			   parent->subparts_cpus);
 		cpumask_and(new_cpus, new_cpus, cs->cpus_allowed);
@@ -1300,6 +1300,43 @@ enum subparts_cmd {
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on);
+
+/*
+ * Update partition exclusive flag
+ *
+ * Return: 0 if successful, an error code otherwise
+ */
+static int update_partition_exclusive(struct cpuset *cs, int new_prs)
+{
+	bool exclusive = (new_prs > 0);
+
+	if (exclusive && !is_cpu_exclusive(cs)) {
+		if (update_flag(CS_CPU_EXCLUSIVE, cs, 1))
+			return PERR_NOTEXCL;
+	} else if (!exclusive && is_cpu_exclusive(cs)) {
+		/* Turning off CS_CPU_EXCLUSIVE will not return error */
+		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
+	}
+	return 0;
+}
+
+/*
+ * Update partition load balance flag and/or rebuild sched domain
+ *
+ * Changing load balance flag will automatically call
+ * rebuild_sched_domains_locked().
+ */
+static void update_partition_sd_lb(struct cpuset *cs, int old_prs)
+{
+	int new_prs = cs->partition_root_state;
+	bool new_lb = (new_prs != PRS_ISOLATED);
+
+	if (new_lb != !!is_sched_load_balance(cs))
+		update_flag(CS_SCHED_LOAD_BALANCE, cs, new_lb);
+	else if ((new_prs > 0) || (old_prs > 0))
+		rebuild_sched_domains_locked();
+}
+
 /**
  * update_parent_subparts_cpumask - update subparts_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
@@ -1359,8 +1396,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		return is_partition_invalid(parent)
 		       ? PERR_INVPARENT : PERR_NOTPART;
 	}
-	if ((newmask && cpumask_empty(newmask)) ||
-	   (!newmask && cpumask_empty(cs->cpus_allowed)))
+	if (!newmask && cpumask_empty(cs->cpus_allowed))
 		return PERR_CPUSEMPTY;
 
 	/*
@@ -1426,11 +1462,16 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		cpumask_and(tmp->addmask, newmask, parent->cpus_allowed);
 		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
 					parent->subparts_cpus);
+		/*
+		 * Empty cpumask is not allewed
+		 */
+		if (cpumask_empty(newmask)) {
+			part_error = PERR_CPUSEMPTY;
 		/*
 		 * Make partition invalid if parent's effective_cpus could
 		 * become empty and there are tasks in the parent.
 		 */
-		if (adding &&
+		} else if (adding &&
 		    cpumask_subset(parent->effective_cpus, tmp->addmask) &&
 		    !cpumask_intersects(tmp->delmask, cpu_active_mask) &&
 		    partition_is_populated(parent, cs)) {
@@ -1503,14 +1544,13 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 
 	/*
 	 * Transitioning between invalid to valid or vice versa may require
-	 * changing CS_CPU_EXCLUSIVE and CS_SCHED_LOAD_BALANCE.
+	 * changing CS_CPU_EXCLUSIVE.
 	 */
 	if (old_prs != new_prs) {
-		if (is_prs_invalid(old_prs) && !is_cpu_exclusive(cs) &&
-		    (update_flag(CS_CPU_EXCLUSIVE, cs, 1) < 0))
-			return PERR_NOTEXCL;
-		if (is_prs_invalid(new_prs) && is_cpu_exclusive(cs))
-			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
+		int err = update_partition_exclusive(cs, new_prs);
+
+		if (err)
+			return err;
 	}
 
 	/*
@@ -1547,15 +1587,16 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		update_tasks_cpumask(parent, tmp->addmask);
 
 	/*
-	 * Set or clear CS_SCHED_LOAD_BALANCE when partcmd_update, if necessary.
-	 * rebuild_sched_domains_locked() may be called.
+	 * For partcmd_update without newmask, it is being called from
+	 * cpuset_hotplug_workfn() where cpus_read_lock() wasn't taken.
+	 * Update the load balance flag and scheduling domain if
+	 * cpus_read_trylock() is successful.
 	 */
-	if (old_prs != new_prs) {
-		if (old_prs == PRS_ISOLATED)
-			update_flag(CS_SCHED_LOAD_BALANCE, cs, 1);
-		else if (new_prs == PRS_ISOLATED)
-			update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
+	if ((cmd == partcmd_update) && !newmask && cpus_read_trylock()) {
+		update_partition_sd_lb(cs, old_prs);
+		cpus_read_unlock();
 	}
+
 	notify_partition_change(cs, old_prs);
 	return 0;
 }
@@ -1770,6 +1811,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	int retval;
 	struct tmpmasks tmp;
 	bool invalidate = false;
+	int old_prs = cs->partition_root_state;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
 	if (cs == &top_cpuset)
@@ -1889,6 +1931,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		 */
 		if (parent->child_ecpus_count)
 			update_sibling_cpumasks(parent, cs, &tmp);
+
+		/* Update CS_SCHED_LOAD_BALANCE and/or sched_domains */
+		update_partition_sd_lb(cs, old_prs);
 	}
 	return 0;
 }
@@ -2265,7 +2310,6 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 static int update_prstate(struct cpuset *cs, int new_prs)
 {
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
-	bool sched_domain_rebuilt = false;
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 
@@ -2284,45 +2328,28 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (alloc_cpumasks(NULL, &tmpmask))
 		return -ENOMEM;
 
+	err = update_partition_exclusive(cs, new_prs);
+	if (err)
+		goto out;
+
 	if (!old_prs) {
 		/*
-		 * Turning on partition root requires setting the
-		 * CS_CPU_EXCLUSIVE bit implicitly as well and cpus_allowed
-		 * cannot be empty.
+		 * cpus_allowed cannot be empty.
 		 */
 		if (cpumask_empty(cs->cpus_allowed)) {
 			err = PERR_CPUSEMPTY;
 			goto out;
 		}
 
-		err = update_flag(CS_CPU_EXCLUSIVE, cs, 1);
-		if (err) {
-			err = PERR_NOTEXCL;
-			goto out;
-		}
-
 		err = update_parent_subparts_cpumask(cs, partcmd_enable,
 						     NULL, &tmpmask);
-		if (err) {
-			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
+		if (err)
 			goto out;
-		}
-
-		if (new_prs == PRS_ISOLATED) {
-			/*
-			 * Disable the load balance flag should not return an
-			 * error unless the system is running out of memory.
-			 */
-			update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
-			sched_domain_rebuilt = true;
-		}
 	} else if (old_prs && new_prs) {
 		/*
 		 * A change in load balance state only, no change in cpumasks.
 		 */
-		update_flag(CS_SCHED_LOAD_BALANCE, cs, (new_prs != PRS_ISOLATED));
-		sched_domain_rebuilt = true;
-		goto out;	/* Sched domain is rebuilt in update_flag() */
+		goto out;
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
@@ -2341,15 +2368,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			compute_effective_cpumask(cs->effective_cpus, cs, parent);
 			spin_unlock_irq(&callback_lock);
 		}
-
-		/* Turning off CS_CPU_EXCLUSIVE will not return error */
-		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
-
-		if (!is_sched_load_balance(cs)) {
-			/* Make sure load balance is on */
-			update_flag(CS_SCHED_LOAD_BALANCE, cs, 1);
-			sched_domain_rebuilt = true;
-		}
 	}
 
 	update_tasks_cpumask(parent, tmpmask.new_cpus);
@@ -2357,18 +2375,24 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (parent->child_ecpus_count)
 		update_sibling_cpumasks(parent, cs, &tmpmask);
 
-	if (!sched_domain_rebuilt)
-		rebuild_sched_domains_locked();
 out:
 	/*
-	 * Make partition invalid if an error happen
+	 * Make partition invalid & disable CS_CPU_EXCLUSIVE if an error
+	 * happens.
 	 */
-	if (err)
+	if (err) {
 		new_prs = -new_prs;
+		update_partition_exclusive(cs, new_prs);
+	}
+
 	spin_lock_irq(&callback_lock);
 	cs->partition_root_state = new_prs;
 	WRITE_ONCE(cs->prs_err, err);
 	spin_unlock_irq(&callback_lock);
+
+	/* Update sched domains and load balance flag */
+	update_partition_sd_lb(cs, old_prs);
+
 	/*
 	 * Update child cpusets, if present.
 	 * Force update if switching back to member.
-- 
2.31.1

