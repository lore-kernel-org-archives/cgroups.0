From: Waiman Long <longman@redhat.com>
Subject: [PATCH v3 4/9] cgroup/cpuset: Allow suppression of sched domain rebuild in update_cpumasks_hier()
Date: Mon, 26 Jun 2023 20:55:24 -0400
Message-ID: <20230627005529.1564984-5-longman@redhat.com>
References: <20230627005529.1564984-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687827366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1/GI0DN/l36YNRdQUEP56Qh0Q1HrifFn5e4yBEgTec=;
        b=BqLVSeroPj1F6Mxsm1k635tqlvYiCX8yabq+4+kTTQ2nBEIHikmWW7cc1uGU+O7YGtijid
        EbIEK1fbeClrjYlq89mFp9cdxkJgt+IvFs8pPAR3rQFq7nH1J/YgTSwllfWysILh5ts20d
        +9Y8bQD8FrhOZMiLs1QYaMPhv5QZlGA=
In-Reply-To: <20230627005529.1564984-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>

A single partition setup and tear-down operation can lead to
multiple rebuild_sched_domains_locked() calls which is a waste of
effort. This can partly be mitigated by adding a flag to suppress the
rebuild_sched_domains_locked() call in update_cpumasks_hier(). Since
a Boolean flag has already been passed as the 3rd argument to
update_cpumasks_hier(), we can extend that to a full flag word.

The sched domain rebuild suppression is now enabled in
update_sibling_cpumasks() as all it callers will do the sched domain
rebuild after its return later on anyway.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b8ccc1be7bde..64f9e305b3ab 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1590,6 +1590,12 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 	return 0;
 }
 
+/*
+ * update_cpumasks_hier() flags
+ */
+#define HIER_CHECKALL		0x01	/* Check all cpusets with no skipping */
+#define HIER_NO_SD_REBUILD	0x02	/* Don't rebuild sched domains */
+
 /*
  * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
  * @cs:  the cpuset to consider
@@ -1604,7 +1610,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
  * Called with cpuset_mutex held
  */
 static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
-				 bool force)
+				 int flags)
 {
 	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
@@ -1644,10 +1650,10 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 * Skip the whole subtree if
 		 * 1) the cpumask remains the same,
 		 * 2) has no partition root state,
-		 * 3) force flag not set, and
+		 * 3) HIER_CHECKALL flag not set, and
 		 * 4) for v2 load balance state same as its parent.
 		 */
-		if (!cp->partition_root_state && !force &&
+		if (!cp->partition_root_state && !(flags & HIER_CHECKALL) &&
 		    cpumask_equal(tmp->new_cpus, cp->effective_cpus) &&
 		    (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
 		    (is_sched_load_balance(parent) == is_sched_load_balance(cp)))) {
@@ -1764,7 +1770,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 	}
 	rcu_read_unlock();
 
-	if (need_rebuild_sched_domains)
+	if (need_rebuild_sched_domains && !(flags & HIER_NO_SD_REBUILD))
 		rebuild_sched_domains_locked();
 }
 
@@ -1788,7 +1794,9 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 	 * to use the right effective_cpus value.
 	 *
 	 * The update_cpumasks_hier() function may sleep. So we have to
-	 * release the RCU read lock before calling it.
+	 * release the RCU read lock before calling it. HIER_NO_SD_REBUILD
+	 * flag is used to suppress rebuild of sched domains as the callers
+	 * will take care of that.
 	 */
 	rcu_read_lock();
 	cpuset_for_each_child(sibling, pos_css, parent) {
@@ -1800,7 +1808,7 @@ static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 			continue;
 
 		rcu_read_unlock();
-		update_cpumasks_hier(sibling, tmp, false);
+		update_cpumasks_hier(sibling, tmp, HIER_NO_SD_REBUILD);
 		rcu_read_lock();
 		css_put(&sibling->css);
 	}
@@ -1913,7 +1921,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_unlock_irq(&callback_lock);
 
 	/* effective_cpus will be updated here */
-	update_cpumasks_hier(cs, &tmp, false);
+	update_cpumasks_hier(cs, &tmp, 0);
 
 	if (cs->partition_root_state) {
 		struct cpuset *parent = parent_cs(cs);
@@ -2382,7 +2390,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	 * Force update if switching back to member.
 	 */
 	if (!list_empty(&cs->css.children))
-		update_cpumasks_hier(cs, &tmpmask, !new_prs);
+		update_cpumasks_hier(cs, &tmpmask, !new_prs ? HIER_CHECKALL : 0);
 
 	/* Update sched domains and load balance flag */
 	update_partition_sd_lb(cs, old_prs);
-- 
2.31.1

