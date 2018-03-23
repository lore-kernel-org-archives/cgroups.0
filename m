From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] cgroup: Reorganize kernel/cgroup/rstat.c
Date: Fri, 23 Mar 2018 16:13:09 -0700
Message-ID: <20180323231313.1254142-5-tj@kernel.org>
References: <20180323231313.1254142-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UU6/1zR6plP9O5Y5Afw9GytAguRcwTgpOIVhLMi5ag4=;
        b=V4zzLmtAWqE8VJis2QiDMF0iHo6AZPAisSH023MC6zta/sFa2qOT7sXdzaxozsyUNf
         HEUKr9DsdTH8+B366QW/Ywlc0U9tFGPPh4aI7KGS8VX8Lh/bsehxIqRtgiXZF25B4f0C
         5DHZ5GKFcfP1CldpCDiU0FlwG/eIWOKmhV/Gc/CH/d/i+vi8NQC3NKKGx5vX+PZXz1Y7
         x8H1TdFfUv5qQ3oPDMHt7eXQoonGwi2O7Peu4cV8+OLt6Uf3BdfWURrsbn25JnCYlE0o
         MMSCly7QJ+0s3h/40uZiBNEPDcmSdMBlF7FhDY2YFRLjDfkHtP0NkCLveprtfvUueX3N
         1ezw==
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, rstat.c has rstat and base stat implementations intermixed.
Collect base stat implementation at the end of the file.  Also,
reorder the prototypes.

This patch doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |   2 +-
 kernel/cgroup/rstat.c           | 182 +++++++++++++++++++++-------------------
 2 files changed, 95 insertions(+), 89 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index aab4d0a..2bf6fb4 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -206,8 +206,8 @@ int cgroup_task_count(const struct cgroup *cgrp);
 void cgroup_rstat_flush(struct cgroup *cgrp);
 int cgroup_rstat_init(struct cgroup *cgrp);
 void cgroup_rstat_exit(struct cgroup *cgrp);
-void cgroup_base_stat_cputime_show(struct seq_file *seq);
 void cgroup_rstat_boot(void);
+void cgroup_base_stat_cputime_show(struct seq_file *seq);
 
 /*
  * namespace.c
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 7670191..87d7252 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -5,6 +5,8 @@
 static DEFINE_MUTEX(cgroup_rstat_mutex);
 static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
 
+static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu);
+
 static struct cgroup_rstat_cpu *cgroup_rstat_cpu(struct cgroup *cgrp, int cpu)
 {
 	return per_cpu_ptr(cgrp->rstat_cpu, cpu);
@@ -128,6 +130,98 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	return pos;
 }
 
+/* see cgroup_rstat_flush() */
+static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
+{
+	int cpu;
+
+	lockdep_assert_held(&cgroup_rstat_mutex);
+
+	for_each_possible_cpu(cpu) {
+		raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock,
+						       cpu);
+		struct cgroup *pos = NULL;
+
+		raw_spin_lock_irq(cpu_lock);
+		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu)))
+			cgroup_base_stat_flush(pos, cpu);
+		raw_spin_unlock_irq(cpu_lock);
+	}
+}
+
+/**
+ * cgroup_rstat_flush - flush stats in @cgrp's subtree
+ * @cgrp: target cgroup
+ *
+ * Collect all per-cpu stats in @cgrp's subtree into the global counters
+ * and propagate them upwards.  After this function returns, all cgroups in
+ * the subtree have up-to-date ->stat.
+ *
+ * This also gets all cgroups in the subtree including @cgrp off the
+ * ->updated_children lists.
+ */
+void cgroup_rstat_flush(struct cgroup *cgrp)
+{
+	mutex_lock(&cgroup_rstat_mutex);
+	cgroup_rstat_flush_locked(cgrp);
+	mutex_unlock(&cgroup_rstat_mutex);
+}
+
+int cgroup_rstat_init(struct cgroup *cgrp)
+{
+	int cpu;
+
+	/* the root cgrp has rstat_cpu preallocated */
+	if (!cgrp->rstat_cpu) {
+		cgrp->rstat_cpu = alloc_percpu(struct cgroup_rstat_cpu);
+		if (!cgrp->rstat_cpu)
+			return -ENOMEM;
+	}
+
+	/* ->updated_children list is self terminated */
+	for_each_possible_cpu(cpu) {
+		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
+
+		rstatc->updated_children = cgrp;
+		u64_stats_init(&rstatc->bsync);
+	}
+
+	return 0;
+}
+
+void cgroup_rstat_exit(struct cgroup *cgrp)
+{
+	int cpu;
+
+	cgroup_rstat_flush(cgrp);
+
+	/* sanity check */
+	for_each_possible_cpu(cpu) {
+		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
+
+		if (WARN_ON_ONCE(rstatc->updated_children != cgrp) ||
+		    WARN_ON_ONCE(rstatc->updated_next))
+			return;
+	}
+
+	free_percpu(cgrp->rstat_cpu);
+	cgrp->rstat_cpu = NULL;
+}
+
+void __init cgroup_rstat_boot(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
+
+	BUG_ON(cgroup_rstat_init(&cgrp_dfl_root.cgrp));
+}
+
+/*
+ * Functions for cgroup basic resource statistics implemented on top of
+ * rstat.
+ */
 static void cgroup_base_stat_accumulate(struct cgroup_base_stat *dst_bstat,
 					struct cgroup_base_stat *src_bstat)
 {
@@ -170,43 +264,6 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 		cgroup_base_stat_accumulate(&parent->pending_bstat, &delta);
 }
 
-/* see cgroup_rstat_flush() */
-static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
-{
-	int cpu;
-
-	lockdep_assert_held(&cgroup_rstat_mutex);
-
-	for_each_possible_cpu(cpu) {
-		raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock,
-						       cpu);
-		struct cgroup *pos = NULL;
-
-		raw_spin_lock_irq(cpu_lock);
-		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu)))
-			cgroup_base_stat_flush(pos, cpu);
-		raw_spin_unlock_irq(cpu_lock);
-	}
-}
-
-/**
- * cgroup_rstat_flush - flush stats in @cgrp's subtree
- * @cgrp: target cgroup
- *
- * Collect all per-cpu stats in @cgrp's subtree into the global counters
- * and propagate them upwards.  After this function returns, all cgroups in
- * the subtree have up-to-date ->stat.
- *
- * This also gets all cgroups in the subtree including @cgrp off the
- * ->updated_children lists.
- */
-void cgroup_rstat_flush(struct cgroup *cgrp)
-{
-	mutex_lock(&cgroup_rstat_mutex);
-	cgroup_rstat_flush_locked(cgrp);
-	mutex_unlock(&cgroup_rstat_mutex);
-}
-
 static struct cgroup_rstat_cpu *
 cgroup_base_stat_cputime_account_begin(struct cgroup *cgrp)
 {
@@ -284,54 +341,3 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
 		   "system_usec %llu\n",
 		   usage, utime, stime);
 }
-
-int cgroup_rstat_init(struct cgroup *cgrp)
-{
-	int cpu;
-
-	/* the root cgrp has rstat_cpu preallocated */
-	if (!cgrp->rstat_cpu) {
-		cgrp->rstat_cpu = alloc_percpu(struct cgroup_rstat_cpu);
-		if (!cgrp->rstat_cpu)
-			return -ENOMEM;
-	}
-
-	/* ->updated_children list is self terminated */
-	for_each_possible_cpu(cpu) {
-		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
-
-		rstatc->updated_children = cgrp;
-		u64_stats_init(&rstatc->bsync);
-	}
-
-	return 0;
-}
-
-void cgroup_rstat_exit(struct cgroup *cgrp)
-{
-	int cpu;
-
-	cgroup_rstat_flush(cgrp);
-
-	/* sanity check */
-	for_each_possible_cpu(cpu) {
-		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
-
-		if (WARN_ON_ONCE(rstatc->updated_children != cgrp) ||
-		    WARN_ON_ONCE(rstatc->updated_next))
-			return;
-	}
-
-	free_percpu(cgrp->rstat_cpu);
-	cgrp->rstat_cpu = NULL;
-}
-
-void __init cgroup_rstat_boot(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
-
-	BUG_ON(cgroup_rstat_init(&cgrp_dfl_root.cgrp));
-}
-- 
2.9.5

