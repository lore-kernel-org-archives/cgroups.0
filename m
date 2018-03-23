From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] cgroup: Rename stat to rstat
Date: Fri, 23 Mar 2018 16:13:07 -0700
Message-ID: <20180323231313.1254142-3-tj@kernel.org>
References: <20180323231313.1254142-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s4nFXcHb76c4i/aiWeBXac58xEhzCV4lfS6Ocnoc0L8=;
        b=OOVweSBp9HtIKc5P+BAWFT7sefp4rHwWLODSk6hExUe0RsnStpDQy6h7hv31Gow/og
         wS8LfectLfR7qF97obqFXNP4huxUVQrq6QUBPR/oDeLetcCyDyc82X7HPqrFTacn/0zc
         EVHCqw3CNfrUcVvTlQPScj/33THO9uobziYXTKL5QbT1eTMuu959VLsGVxYmwXSEZRJp
         4I2txVOAMcVuANYVlWuqPJ1/JkWMNiL8ZdNPfOg+8JmxI3E4a0EKpGVKdZCSVltdOlTt
         bEmkaYytLURLe6GkE/3VjR0wI9XQSsf5PZgKWtRnm7RJ8dG6xOjKBRKeiICwKYhY5DQX
         1UPQ==
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

stat is too generic a name and ends up causing subtle confusions.
It'll be made generic so that controllers can plug into it, which will
make the problem worse.  Let's rename it to something more specific -
cgroup_rstat for cgroup recursive stat.

This patch does the following renames.  No other changes.

* cpu_stat	-> rstat_cpu
* stat		-> rstat
* ?cstat	-> ?rstatc

Note that the renames are selective.  The unrenamed are the ones which
implement basic resource statistics on top of rstat.  This will be
further cleaned up in the following patches.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h     |  16 ++--
 kernel/cgroup/cgroup-internal.h |  10 +--
 kernel/cgroup/cgroup.c          |  14 ++--
 kernel/cgroup/rstat.c           | 180 ++++++++++++++++++++--------------------
 4 files changed, 112 insertions(+), 108 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 90ede40..02625cf 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -259,11 +259,11 @@ struct css_set {
 };
 
 /*
- * cgroup basic resource usage statistics.  Accounting is done per-cpu in
- * cgroup_cpu_stat which is then lazily propagated up the hierarchy on
- * reads.
+ * rstat - cgroup scalable recursive statistics.  Accounting is done
+ * per-cpu in cgroup_rstat_cpu which is then lazily propagated up the
+ * hierarchy on reads.
  *
- * When a stat gets updated, the cgroup_cpu_stat and its ancestors are
+ * When a stat gets updated, the cgroup_rstat_cpu and its ancestors are
  * linked into the updated tree.  On the following read, propagation only
  * considers and consumes the updated tree.  This makes reading O(the
  * number of descendants which have been active since last read) instead of
@@ -274,7 +274,7 @@ struct css_set {
  * become very expensive.  By propagating selectively, increasing reading
  * frequency decreases the cost of each read.
  */
-struct cgroup_cpu_stat {
+struct cgroup_rstat_cpu {
 	/*
 	 * ->sync protects all the current counters.  These are the only
 	 * fields which get updated in the hot path.
@@ -297,7 +297,7 @@ struct cgroup_cpu_stat {
 	 * to the cgroup makes it unnecessary for each per-cpu struct to
 	 * point back to the associated cgroup.
 	 *
-	 * Protected by per-cpu cgroup_cpu_stat_lock.
+	 * Protected by per-cpu cgroup_rstat_cpu_lock.
 	 */
 	struct cgroup *updated_children;	/* terminated by self cgroup */
 	struct cgroup *updated_next;		/* NULL iff not on the list */
@@ -408,8 +408,10 @@ struct cgroup {
 	 */
 	struct cgroup *dom_cgrp;
 
+	/* per-cpu recursive resource statistics */
+	struct cgroup_rstat_cpu __percpu *rstat_cpu;
+
 	/* cgroup basic resource statistics */
-	struct cgroup_cpu_stat __percpu *cpu_stat;
 	struct cgroup_stat pending_stat;	/* pending from children */
 	struct cgroup_stat stat;
 
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index b928b27..0927111 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -201,13 +201,13 @@ int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 int cgroup_task_count(const struct cgroup *cgrp);
 
 /*
- * stat.c
+ * rstat.c
  */
-void cgroup_stat_flush(struct cgroup *cgrp);
-int cgroup_stat_init(struct cgroup *cgrp);
-void cgroup_stat_exit(struct cgroup *cgrp);
+void cgroup_rstat_flush(struct cgroup *cgrp);
+int cgroup_rstat_init(struct cgroup *cgrp);
+void cgroup_rstat_exit(struct cgroup *cgrp);
 void cgroup_stat_show_cputime(struct seq_file *seq);
-void cgroup_stat_boot(void);
+void cgroup_rstat_boot(void);
 
 /*
  * namespace.c
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ea31ec5..5549a7c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -144,14 +144,14 @@ static struct static_key_true *cgroup_subsys_on_dfl_key[] = {
 };
 #undef SUBSYS
 
-static DEFINE_PER_CPU(struct cgroup_cpu_stat, cgrp_dfl_root_cpu_stat);
+static DEFINE_PER_CPU(struct cgroup_rstat_cpu, cgrp_dfl_root_rstat_cpu);
 
 /*
  * The default hierarchy, reserved for the subsystems that are otherwise
  * unattached - it never has more than a single cgroup, and all tasks are
  * part of that cgroup.
  */
-struct cgroup_root cgrp_dfl_root = { .cgrp.cpu_stat = &cgrp_dfl_root_cpu_stat };
+struct cgroup_root cgrp_dfl_root = { .cgrp.rstat_cpu = &cgrp_dfl_root_rstat_cpu };
 EXPORT_SYMBOL_GPL(cgrp_dfl_root);
 
 /*
@@ -4592,7 +4592,7 @@ static void css_free_work_fn(struct work_struct *work)
 			cgroup_put(cgroup_parent(cgrp));
 			kernfs_put(cgrp->kn);
 			if (cgroup_on_dfl(cgrp))
-				cgroup_stat_exit(cgrp);
+				cgroup_rstat_exit(cgrp);
 			kfree(cgrp);
 		} else {
 			/*
@@ -4638,7 +4638,7 @@ static void css_release_work_fn(struct work_struct *work)
 		trace_cgroup_release(cgrp);
 
 		if (cgroup_on_dfl(cgrp))
-			cgroup_stat_flush(cgrp);
+			cgroup_rstat_flush(cgrp);
 
 		for (tcgrp = cgroup_parent(cgrp); tcgrp;
 		     tcgrp = cgroup_parent(tcgrp))
@@ -4824,7 +4824,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 		goto out_free_cgrp;
 
 	if (cgroup_on_dfl(parent)) {
-		ret = cgroup_stat_init(cgrp);
+		ret = cgroup_rstat_init(cgrp);
 		if (ret)
 			goto out_cancel_ref;
 	}
@@ -4889,7 +4889,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	cgroup_idr_remove(&root->cgroup_idr, cgrp->id);
 out_stat_exit:
 	if (cgroup_on_dfl(parent))
-		cgroup_stat_exit(cgrp);
+		cgroup_rstat_exit(cgrp);
 out_cancel_ref:
 	percpu_ref_exit(&cgrp->self.refcnt);
 out_free_cgrp:
@@ -5282,7 +5282,7 @@ int __init cgroup_init(void)
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
 	BUG_ON(cgroup_init_cftypes(NULL, cgroup1_base_files));
 
-	cgroup_stat_boot();
+	cgroup_rstat_boot();
 
 	/*
 	 * The latency of the synchronize_sched() is too high for cgroups,
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 1e111dd..6824047 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -2,26 +2,26 @@
 
 #include <linux/sched/cputime.h>
 
-static DEFINE_MUTEX(cgroup_stat_mutex);
-static DEFINE_PER_CPU(raw_spinlock_t, cgroup_cpu_stat_lock);
+static DEFINE_MUTEX(cgroup_rstat_mutex);
+static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
 
-static struct cgroup_cpu_stat *cgroup_cpu_stat(struct cgroup *cgrp, int cpu)
+static struct cgroup_rstat_cpu *cgroup_rstat_cpu(struct cgroup *cgrp, int cpu)
 {
-	return per_cpu_ptr(cgrp->cpu_stat, cpu);
+	return per_cpu_ptr(cgrp->rstat_cpu, cpu);
 }
 
 /**
- * cgroup_cpu_stat_updated - keep track of updated cpu_stat
+ * cgroup_rstat_cpu_updated - keep track of updated rstat_cpu
  * @cgrp: target cgroup
- * @cpu: cpu on which cpu_stat was updated
+ * @cpu: cpu on which rstat_cpu was updated
  *
- * @cgrp's cpu_stat on @cpu was updated.  Put it on the parent's matching
- * cpu_stat->updated_children list.  See the comment on top of
- * cgroup_cpu_stat definition for details.
+ * @cgrp's rstat_cpu on @cpu was updated.  Put it on the parent's matching
+ * rstat_cpu->updated_children list.  See the comment on top of
+ * cgroup_rstat_cpu definition for details.
  */
-static void cgroup_cpu_stat_updated(struct cgroup *cgrp, int cpu)
+static void cgroup_rstat_cpu_updated(struct cgroup *cgrp, int cpu)
 {
-	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_cpu_stat_lock, cpu);
+	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
 	struct cgroup *parent;
 	unsigned long flags;
 
@@ -33,7 +33,7 @@ static void cgroup_cpu_stat_updated(struct cgroup *cgrp, int cpu)
 	 * instead of NULL, we can tell whether @cgrp is on the list by
 	 * testing the next pointer for NULL.
 	 */
-	if (cgroup_cpu_stat(cgrp, cpu)->updated_next)
+	if (cgroup_rstat_cpu(cgrp, cpu)->updated_next)
 		return;
 
 	raw_spin_lock_irqsave(cpu_lock, flags);
@@ -41,42 +41,42 @@ static void cgroup_cpu_stat_updated(struct cgroup *cgrp, int cpu)
 	/* put @cgrp and all ancestors on the corresponding updated lists */
 	for (parent = cgroup_parent(cgrp); parent;
 	     cgrp = parent, parent = cgroup_parent(cgrp)) {
-		struct cgroup_cpu_stat *cstat = cgroup_cpu_stat(cgrp, cpu);
-		struct cgroup_cpu_stat *pcstat = cgroup_cpu_stat(parent, cpu);
+		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
+		struct cgroup_rstat_cpu *prstatc = cgroup_rstat_cpu(parent, cpu);
 
 		/*
 		 * Both additions and removals are bottom-up.  If a cgroup
 		 * is already in the tree, all ancestors are.
 		 */
-		if (cstat->updated_next)
+		if (rstatc->updated_next)
 			break;
 
-		cstat->updated_next = pcstat->updated_children;
-		pcstat->updated_children = cgrp;
+		rstatc->updated_next = prstatc->updated_children;
+		prstatc->updated_children = cgrp;
 	}
 
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
 }
 
 /**
- * cgroup_cpu_stat_pop_updated - iterate and dismantle cpu_stat updated tree
+ * cgroup_rstat_cpu_pop_updated - iterate and dismantle rstat_cpu updated tree
  * @pos: current position
  * @root: root of the tree to traversal
  * @cpu: target cpu
  *
- * Walks the udpated cpu_stat tree on @cpu from @root.  %NULL @pos starts
+ * Walks the udpated rstat_cpu tree on @cpu from @root.  %NULL @pos starts
  * the traversal and %NULL return indicates the end.  During traversal,
  * each returned cgroup is unlinked from the tree.  Must be called with the
- * matching cgroup_cpu_stat_lock held.
+ * matching cgroup_rstat_cpu_lock held.
  *
  * The only ordering guarantee is that, for a parent and a child pair
  * covered by a given traversal, if a child is visited, its parent is
  * guaranteed to be visited afterwards.
  */
-static struct cgroup *cgroup_cpu_stat_pop_updated(struct cgroup *pos,
-						  struct cgroup *root, int cpu)
+static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
+						   struct cgroup *root, int cpu)
 {
-	struct cgroup_cpu_stat *cstat;
+	struct cgroup_rstat_cpu *rstatc;
 	struct cgroup *parent;
 
 	if (pos == root)
@@ -93,10 +93,10 @@ static struct cgroup *cgroup_cpu_stat_pop_updated(struct cgroup *pos,
 
 	/* walk down to the first leaf */
 	while (true) {
-		cstat = cgroup_cpu_stat(pos, cpu);
-		if (cstat->updated_children == pos)
+		rstatc = cgroup_rstat_cpu(pos, cpu);
+		if (rstatc->updated_children == pos)
 			break;
-		pos = cstat->updated_children;
+		pos = rstatc->updated_children;
 	}
 
 	/*
@@ -106,23 +106,23 @@ static struct cgroup *cgroup_cpu_stat_pop_updated(struct cgroup *pos,
 	 * child in most cases. The only exception is @root.
 	 */
 	parent = cgroup_parent(pos);
-	if (parent && cstat->updated_next) {
-		struct cgroup_cpu_stat *pcstat = cgroup_cpu_stat(parent, cpu);
-		struct cgroup_cpu_stat *ncstat;
+	if (parent && rstatc->updated_next) {
+		struct cgroup_rstat_cpu *prstatc = cgroup_rstat_cpu(parent, cpu);
+		struct cgroup_rstat_cpu *nrstatc;
 		struct cgroup **nextp;
 
-		nextp = &pcstat->updated_children;
+		nextp = &prstatc->updated_children;
 		while (true) {
-			ncstat = cgroup_cpu_stat(*nextp, cpu);
+			nrstatc = cgroup_rstat_cpu(*nextp, cpu);
 			if (*nextp == pos)
 				break;
 
 			WARN_ON_ONCE(*nextp == parent);
-			nextp = &ncstat->updated_next;
+			nextp = &nrstatc->updated_next;
 		}
 
-		*nextp = cstat->updated_next;
-		cstat->updated_next = NULL;
+		*nextp = rstatc->updated_next;
+		rstatc->updated_next = NULL;
 	}
 
 	return pos;
@@ -139,19 +139,19 @@ static void cgroup_stat_accumulate(struct cgroup_stat *dst_stat,
 static void cgroup_cpu_stat_flush_one(struct cgroup *cgrp, int cpu)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-	struct cgroup_cpu_stat *cstat = cgroup_cpu_stat(cgrp, cpu);
-	struct task_cputime *last_cputime = &cstat->last_cputime;
+	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
+	struct task_cputime *last_cputime = &rstatc->last_cputime;
 	struct task_cputime cputime;
 	struct cgroup_stat delta;
 	unsigned seq;
 
-	lockdep_assert_held(&cgroup_stat_mutex);
+	lockdep_assert_held(&cgroup_rstat_mutex);
 
 	/* fetch the current per-cpu values */
 	do {
-		seq = __u64_stats_fetch_begin(&cstat->sync);
-		cputime = cstat->cputime;
-	} while (__u64_stats_fetch_retry(&cstat->sync, seq));
+		seq = __u64_stats_fetch_begin(&rstatc->sync);
+		cputime = rstatc->cputime;
+	} while (__u64_stats_fetch_retry(&rstatc->sync, seq));
 
 	/* accumulate the deltas to propgate */
 	delta.cputime.utime = cputime.utime - last_cputime->utime;
@@ -170,26 +170,27 @@ static void cgroup_cpu_stat_flush_one(struct cgroup *cgrp, int cpu)
 		cgroup_stat_accumulate(&parent->pending_stat, &delta);
 }
 
-/* see cgroup_stat_flush() */
-static void cgroup_stat_flush_locked(struct cgroup *cgrp)
+/* see cgroup_rstat_flush() */
+static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
 {
 	int cpu;
 
-	lockdep_assert_held(&cgroup_stat_mutex);
+	lockdep_assert_held(&cgroup_rstat_mutex);
 
 	for_each_possible_cpu(cpu) {
-		raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_cpu_stat_lock, cpu);
+		raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock,
+						       cpu);
 		struct cgroup *pos = NULL;
 
 		raw_spin_lock_irq(cpu_lock);
-		while ((pos = cgroup_cpu_stat_pop_updated(pos, cgrp, cpu)))
+		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu)))
 			cgroup_cpu_stat_flush_one(pos, cpu);
 		raw_spin_unlock_irq(cpu_lock);
 	}
 }
 
 /**
- * cgroup_stat_flush - flush stats in @cgrp's subtree
+ * cgroup_rstat_flush - flush stats in @cgrp's subtree
  * @cgrp: target cgroup
  *
  * Collect all per-cpu stats in @cgrp's subtree into the global counters
@@ -199,61 +200,62 @@ static void cgroup_stat_flush_locked(struct cgroup *cgrp)
  * This also gets all cgroups in the subtree including @cgrp off the
  * ->updated_children lists.
  */
-void cgroup_stat_flush(struct cgroup *cgrp)
+void cgroup_rstat_flush(struct cgroup *cgrp)
 {
-	mutex_lock(&cgroup_stat_mutex);
-	cgroup_stat_flush_locked(cgrp);
-	mutex_unlock(&cgroup_stat_mutex);
+	mutex_lock(&cgroup_rstat_mutex);
+	cgroup_rstat_flush_locked(cgrp);
+	mutex_unlock(&cgroup_rstat_mutex);
 }
 
-static struct cgroup_cpu_stat *cgroup_cpu_stat_account_begin(struct cgroup *cgrp)
+static struct cgroup_rstat_cpu *
+cgroup_cpu_stat_account_begin(struct cgroup *cgrp)
 {
-	struct cgroup_cpu_stat *cstat;
+	struct cgroup_rstat_cpu *rstatc;
 
-	cstat = get_cpu_ptr(cgrp->cpu_stat);
-	u64_stats_update_begin(&cstat->sync);
-	return cstat;
+	rstatc = get_cpu_ptr(cgrp->rstat_cpu);
+	u64_stats_update_begin(&rstatc->sync);
+	return rstatc;
 }
 
 static void cgroup_cpu_stat_account_end(struct cgroup *cgrp,
-					struct cgroup_cpu_stat *cstat)
+					struct cgroup_rstat_cpu *rstatc)
 {
-	u64_stats_update_end(&cstat->sync);
-	cgroup_cpu_stat_updated(cgrp, smp_processor_id());
-	put_cpu_ptr(cstat);
+	u64_stats_update_end(&rstatc->sync);
+	cgroup_rstat_cpu_updated(cgrp, smp_processor_id());
+	put_cpu_ptr(rstatc);
 }
 
 void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec)
 {
-	struct cgroup_cpu_stat *cstat;
+	struct cgroup_rstat_cpu *rstatc;
 
-	cstat = cgroup_cpu_stat_account_begin(cgrp);
-	cstat->cputime.sum_exec_runtime += delta_exec;
-	cgroup_cpu_stat_account_end(cgrp, cstat);
+	rstatc = cgroup_cpu_stat_account_begin(cgrp);
+	rstatc->cputime.sum_exec_runtime += delta_exec;
+	cgroup_cpu_stat_account_end(cgrp, rstatc);
 }
 
 void __cgroup_account_cputime_field(struct cgroup *cgrp,
 				    enum cpu_usage_stat index, u64 delta_exec)
 {
-	struct cgroup_cpu_stat *cstat;
+	struct cgroup_rstat_cpu *rstatc;
 
-	cstat = cgroup_cpu_stat_account_begin(cgrp);
+	rstatc = cgroup_cpu_stat_account_begin(cgrp);
 
 	switch (index) {
 	case CPUTIME_USER:
 	case CPUTIME_NICE:
-		cstat->cputime.utime += delta_exec;
+		rstatc->cputime.utime += delta_exec;
 		break;
 	case CPUTIME_SYSTEM:
 	case CPUTIME_IRQ:
 	case CPUTIME_SOFTIRQ:
-		cstat->cputime.stime += delta_exec;
+		rstatc->cputime.stime += delta_exec;
 		break;
 	default:
 		break;
 	}
 
-	cgroup_cpu_stat_account_end(cgrp, cstat);
+	cgroup_cpu_stat_account_end(cgrp, rstatc);
 }
 
 void cgroup_stat_show_cputime(struct seq_file *seq)
@@ -264,15 +266,15 @@ void cgroup_stat_show_cputime(struct seq_file *seq)
 	if (!cgroup_parent(cgrp))
 		return;
 
-	mutex_lock(&cgroup_stat_mutex);
+	mutex_lock(&cgroup_rstat_mutex);
 
-	cgroup_stat_flush_locked(cgrp);
+	cgroup_rstat_flush_locked(cgrp);
 
 	usage = cgrp->stat.cputime.sum_exec_runtime;
 	cputime_adjust(&cgrp->stat.cputime, &cgrp->stat.prev_cputime,
 		       &utime, &stime);
 
-	mutex_unlock(&cgroup_stat_mutex);
+	mutex_unlock(&cgroup_rstat_mutex);
 
 	do_div(usage, NSEC_PER_USEC);
 	do_div(utime, NSEC_PER_USEC);
@@ -284,23 +286,23 @@ void cgroup_stat_show_cputime(struct seq_file *seq)
 		   usage, utime, stime);
 }
 
-int cgroup_stat_init(struct cgroup *cgrp)
+int cgroup_rstat_init(struct cgroup *cgrp)
 {
 	int cpu;
 
-	/* the root cgrp has cpu_stat preallocated */
-	if (!cgrp->cpu_stat) {
-		cgrp->cpu_stat = alloc_percpu(struct cgroup_cpu_stat);
-		if (!cgrp->cpu_stat)
+	/* the root cgrp has rstat_cpu preallocated */
+	if (!cgrp->rstat_cpu) {
+		cgrp->rstat_cpu = alloc_percpu(struct cgroup_rstat_cpu);
+		if (!cgrp->rstat_cpu)
 			return -ENOMEM;
 	}
 
 	/* ->updated_children list is self terminated */
 	for_each_possible_cpu(cpu) {
-		struct cgroup_cpu_stat *cstat = cgroup_cpu_stat(cgrp, cpu);
+		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
 
-		cstat->updated_children = cgrp;
-		u64_stats_init(&cstat->sync);
+		rstatc->updated_children = cgrp;
+		u64_stats_init(&rstatc->sync);
 	}
 
 	prev_cputime_init(&cgrp->stat.prev_cputime);
@@ -308,31 +310,31 @@ int cgroup_stat_init(struct cgroup *cgrp)
 	return 0;
 }
 
-void cgroup_stat_exit(struct cgroup *cgrp)
+void cgroup_rstat_exit(struct cgroup *cgrp)
 {
 	int cpu;
 
-	cgroup_stat_flush(cgrp);
+	cgroup_rstat_flush(cgrp);
 
 	/* sanity check */
 	for_each_possible_cpu(cpu) {
-		struct cgroup_cpu_stat *cstat = cgroup_cpu_stat(cgrp, cpu);
+		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
 
-		if (WARN_ON_ONCE(cstat->updated_children != cgrp) ||
-		    WARN_ON_ONCE(cstat->updated_next))
+		if (WARN_ON_ONCE(rstatc->updated_children != cgrp) ||
+		    WARN_ON_ONCE(rstatc->updated_next))
 			return;
 	}
 
-	free_percpu(cgrp->cpu_stat);
-	cgrp->cpu_stat = NULL;
+	free_percpu(cgrp->rstat_cpu);
+	cgrp->rstat_cpu = NULL;
 }
 
-void __init cgroup_stat_boot(void)
+void __init cgroup_rstat_boot(void)
 {
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		raw_spin_lock_init(per_cpu_ptr(&cgroup_cpu_stat_lock, cpu));
+		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
 
-	BUG_ON(cgroup_stat_init(&cgrp_dfl_root.cgrp));
+	BUG_ON(cgroup_rstat_init(&cgrp_dfl_root.cgrp));
 }
-- 
2.9.5

