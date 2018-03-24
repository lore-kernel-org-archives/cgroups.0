From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 5/8] cgroup: Factor out and expose cgroup_rstat_*()
 interface functions
Date: Sat, 24 Mar 2018 13:44:35 -0700
Message-ID: <20180324204435.GG2149215@devbig577.frc2.facebook.com>
References: <20180323231313.1254142-1-tj@kernel.org>
 <20180323231313.1254142-6-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9QL+fDpA7/FLZ9oStkTp8p4oGO7i8CJwrbyPWLLJtMw=;
        b=DdBMksi8R06Hh8wMqRFP0sbTGOEWIrwzFympq18yokc+6KTfdnd+lIFpscZmyEmE1U
         x8TO76ZDKOrbv0HExY2Ql9kazLQr4c4wHklxB31d9JoI1FvEdgWqZZ/CjG8NS3KRu0Ae
         EkX4QXu9eCm0WGo2E03H9jARih2XGWH+W+P4hjRjnvGuUaqaERNqnqpiwCvBjYXzb/wW
         +Dhwd+3bMw5nZEA3FWjJgIy9Sex+OKU2Iejei3imEruQ8UKENDeRcvHa7Vt6hdi886o/
         XSYQO0jQN5UGdjCSR99XAgcE8CYrxjJ2Mnt7D3KTq6MVHb/hkRThrXEibSlYD5l5aMLi
         CcUQ==
Content-Disposition: inline
In-Reply-To: <20180323231313.1254142-6-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com

From 6139f87ac4a5650fed5c8be5611becbce96d7f1c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sat, 24 Mar 2018 13:39:36 -0700

cgroup_rstat is being generalized so that controllers can use it too.
This patch factors out and exposes the following interface functions.

* cgroup_rstat_updated(): Renamed from cgroup_rstat_cpu_updated() for
  consistency.

* cgroup_rstat_flush_hold/release(): Factored out from base stat
  implementation.

* cgroup_rstat_flush(): Verbatim expose.

While at it, drop assert on cgroup_rstat_mutex in
cgroup_base_stat_flush() as it crosses layers and make a minor comment
update.

v2: Added EXPORT_SYMBOL_GPL(cgroup_rstat_updated) to fix a build bug.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h          | 11 +++++++++--
 kernel/cgroup/cgroup-internal.h |  1 -
 kernel/cgroup/rstat.c           | 42 +++++++++++++++++++++++++++++------------
 3 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 473e0c0..5c6018f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -690,11 +690,18 @@ static inline void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
 	char *buf, size_t buflen) {}
 #endif /* !CONFIG_CGROUPS */
 
+#ifdef CONFIG_CGROUPS
 /*
- * Basic resource stats.
+ * cgroup scalable recursive statistics.
  */
-#ifdef CONFIG_CGROUPS
+void cgroup_rstat_updated(struct cgroup *cgrp, int cpu);
+void cgroup_rstat_flush(struct cgroup *cgrp);
+void cgroup_rstat_flush_hold(struct cgroup *cgrp);
+void cgroup_rstat_flush_release(void);
 
+/*
+ * Basic resource stats.
+ */
 #ifdef CONFIG_CGROUP_CPUACCT
 void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 void cpuacct_account_field(struct task_struct *tsk, int index, u64 val);
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 2bf6fb4..b68e1a7 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -203,7 +203,6 @@ int cgroup_task_count(const struct cgroup *cgrp);
 /*
  * rstat.c
  */
-void cgroup_rstat_flush(struct cgroup *cgrp);
 int cgroup_rstat_init(struct cgroup *cgrp);
 void cgroup_rstat_exit(struct cgroup *cgrp);
 void cgroup_rstat_boot(void);
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 87d7252..d49bf92 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -13,7 +13,7 @@ static struct cgroup_rstat_cpu *cgroup_rstat_cpu(struct cgroup *cgrp, int cpu)
 }
 
 /**
- * cgroup_rstat_cpu_updated - keep track of updated rstat_cpu
+ * cgroup_rstat_updated - keep track of updated rstat_cpu
  * @cgrp: target cgroup
  * @cpu: cpu on which rstat_cpu was updated
  *
@@ -21,7 +21,7 @@ static struct cgroup_rstat_cpu *cgroup_rstat_cpu(struct cgroup *cgrp, int cpu)
  * rstat_cpu->updated_children list.  See the comment on top of
  * cgroup_rstat_cpu definition for details.
  */
-static void cgroup_rstat_cpu_updated(struct cgroup *cgrp, int cpu)
+void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 {
 	raw_spinlock_t *cpu_lock = per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu);
 	struct cgroup *parent;
@@ -59,6 +59,7 @@ static void cgroup_rstat_cpu_updated(struct cgroup *cgrp, int cpu)
 
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
 }
+EXPORT_SYMBOL_GPL(cgroup_rstat_updated);
 
 /**
  * cgroup_rstat_cpu_pop_updated - iterate and dismantle rstat_cpu updated tree
@@ -167,6 +168,29 @@ void cgroup_rstat_flush(struct cgroup *cgrp)
 	mutex_unlock(&cgroup_rstat_mutex);
 }
 
+/**
+ * cgroup_rstat_flush_begin - flush stats in @cgrp's subtree and hold
+ * @cgrp: target cgroup
+ *
+ * Flush stats in @cgrp's subtree and prevent further flushes.  Must be
+ * paired with cgroup_rstat_flush_release().
+ */
+void cgroup_rstat_flush_hold(struct cgroup *cgrp)
+	__acquires(&cgroup_rstat_mutex)
+{
+	mutex_lock(&cgroup_rstat_mutex);
+	cgroup_rstat_flush_locked(cgrp);
+}
+
+/**
+ * cgroup_rstat_flush_release - release cgroup_rstat_flush_hold()
+ */
+void cgroup_rstat_flush_release(void)
+	__releases(&cgroup_rstat_mutex)
+{
+	mutex_unlock(&cgroup_rstat_mutex);
+}
+
 int cgroup_rstat_init(struct cgroup *cgrp)
 {
 	int cpu;
@@ -239,15 +263,13 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 	struct cgroup_base_stat delta;
 	unsigned seq;
 
-	lockdep_assert_held(&cgroup_rstat_mutex);
-
 	/* fetch the current per-cpu values */
 	do {
 		seq = __u64_stats_fetch_begin(&rstatc->bsync);
 		cputime = rstatc->bstat.cputime;
 	} while (__u64_stats_fetch_retry(&rstatc->bsync, seq));
 
-	/* accumulate the deltas to propgate */
+	/* calculate the delta to propgate */
 	delta.cputime.utime = cputime.utime - last_cputime->utime;
 	delta.cputime.stime = cputime.stime - last_cputime->stime;
 	delta.cputime.sum_exec_runtime = cputime.sum_exec_runtime -
@@ -278,7 +300,7 @@ static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
 						 struct cgroup_rstat_cpu *rstatc)
 {
 	u64_stats_update_end(&rstatc->bsync);
-	cgroup_rstat_cpu_updated(cgrp, smp_processor_id());
+	cgroup_rstat_updated(cgrp, smp_processor_id());
 	put_cpu_ptr(rstatc);
 }
 
@@ -323,14 +345,10 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
 	if (!cgroup_parent(cgrp))
 		return;
 
-	mutex_lock(&cgroup_rstat_mutex);
-
-	cgroup_rstat_flush_locked(cgrp);
-
+	cgroup_rstat_flush_hold(cgrp);
 	usage = cgrp->bstat.cputime.sum_exec_runtime;
 	cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime, &utime, &stime);
-
-	mutex_unlock(&cgroup_rstat_mutex);
+	cgroup_rstat_flush_release();
 
 	do_div(usage, NSEC_PER_USEC);
 	do_div(utime, NSEC_PER_USEC);
-- 
2.9.5

