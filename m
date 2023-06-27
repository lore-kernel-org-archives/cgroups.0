From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 3/9] cgroup/cpuset: Improve temporary cpumasks handling
Date: Tue, 27 Jun 2023 10:35:02 -0400
Message-ID: <20230627143508.1576882-4-longman@redhat.com>
References: <20230627143508.1576882-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687876587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPhp6M85RYtJ1OdHBAv4hPr3cT4UKKt6nbqDvx5A+ks=;
        b=eQF6Fq3q6cLfDHWoRJXng2nK5J7WiJbuKPMJ70Uhm4C9c49GmrBsuWpDNW88bsdgSEy5Da
        Enf+704XzGABNo2kRcz0FWUk4qk0AHLK292WLnGUx4gcP6LBF7rAlTf19U0eOrHLsVXAtu
        3TN4ovdC+GWUQrKAS41EvxOAyYcQqmQ=
In-Reply-To: <20230627143508.1576882-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>

The limitation that update_parent_subparts_cpumask() can only use
addmask & delmask in the given tmp cpumasks is fragile and may lead to
unexpected error.

Fix this problem by allocating/freeing a struct tmpmasks in
update_cpumask() to avoid reusing the cpumasks in trial_cs.

With this change, we can move the update_tasks_cpumask() for the
parent and update_sibling_cpumasks() for the sibling to inside
update_parent_subparts_cpumask().

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 42 +++++++++++++-----------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ade33e50ffe2..b8ccc1be7bde 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1277,6 +1277,8 @@ enum subparts_cmd {
 
 static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 		       int turning_on);
+static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
+				    struct tmpmasks *tmp);
 
 /*
  * Update partition exclusive flag
@@ -1447,7 +1449,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 		adding = cpumask_andnot(tmp->addmask, tmp->addmask,
 					parent->subparts_cpus);
 		/*
-		 * Empty cpumask is not allewed
+		 * Empty cpumask is not allowed
 		 */
 		if (cpumask_empty(newmask)) {
 			part_error = PERR_CPUSEMPTY;
@@ -1567,8 +1569,11 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 
 	spin_unlock_irq(&callback_lock);
 
-	if (adding || deleting)
+	if (adding || deleting) {
 		update_tasks_cpumask(parent, tmp->addmask);
+		if (parent->child_ecpus_count)
+			update_sibling_cpumasks(parent, cs, tmp);
+	}
 
 	/*
 	 * For partcmd_update without newmask, it is being called from
@@ -1842,18 +1847,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	/*
-	 * Use the cpumasks in trialcs for tmpmasks when they are pointers
-	 * to allocated cpumasks.
-	 *
-	 * Note that update_parent_subparts_cpumask() uses only addmask &
-	 * delmask, but not new_cpus.
-	 */
-	tmp.addmask  = trialcs->subparts_cpus;
-	tmp.delmask  = trialcs->effective_cpus;
-	tmp.new_cpus = NULL;
-#endif
+	if (alloc_cpumasks(NULL, &tmp))
+		return -ENOMEM;
 
 	retval = validate_change(cs, trialcs);
 
@@ -1882,7 +1877,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		retval = 0;
 	}
 	if (retval < 0)
-		return retval;
+		goto out_free;
 
 	if (cs->partition_root_state) {
 		if (invalidate)
@@ -1917,11 +1912,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	}
 	spin_unlock_irq(&callback_lock);
 
-#ifdef CONFIG_CPUMASK_OFFSTACK
-	/* Now trialcs->cpus_allowed is available */
-	tmp.new_cpus = trialcs->cpus_allowed;
-#endif
-
 	/* effective_cpus will be updated here */
 	update_cpumasks_hier(cs, &tmp, false);
 
@@ -1938,6 +1928,8 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		/* Update CS_SCHED_LOAD_BALANCE and/or sched_domains */
 		update_partition_sd_lb(cs, old_prs);
 	}
+out_free:
+	free_cpumasks(NULL, &tmp);
 	return 0;
 }
 
@@ -2346,13 +2338,11 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
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
@@ -2372,12 +2362,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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
-- 
2.31.1

