From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] cgroup: Distinguish base resource stat implementation from rstat
Date: Fri, 23 Mar 2018 16:13:08 -0700
Message-ID: <20180323231313.1254142-4-tj@kernel.org>
References: <20180323231313.1254142-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cpaTysrW3sXkiHy/WixNh4ieV7j51EUSYr1/xvpzIKY=;
        b=QtE9N7DAPxBVgNptqkYp2BD+dJJMPcewS+dylxH/U/1tBSHdv1vuReV/hH9j+jT41D
         x0wDKR/AqAvDDccnnOaNbnMls7T+q6amGznjG9dig54EnYpOAHwNbS+b/Naejm1I7W7n
         luGQS324z96XbPeBUjmXoG0RF3qebylP4MIrmtwEfPlt+lQCTkcEY3h7egXEvuub0PIa
         3FmQRUNRqCID8MluzH92dYWeIqdb1ljyX4p3giwY4g7f6UhTVhE9wk8KRLe4VKcmTu35
         ULFGRg6RD+wWzLHdMd6jusLbOcSbMLJ0JiEuLTFE+NbY896UT2+bKuhxfp/Zhi0wM8qo
         mWww==
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Base resource stat accounts universial (not specific to any
controller) resource consumptions on top of rstat.  Currently, its
implementation is intermixed with rstat implementation making the code
confusing to follow.

This patch clarifies the distintion by doing the followings.

* Encapsulate base resource stat counters, currently only cputime, in
  struct cgroup_base_stat.

* Move prev_cputime into struct cgroup and initialize it with cgroup.

* Rename the related functions so that they start with cgroup_base_stat.

* Prefix the related variables and field names with b.

This patch doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h     | 29 ++++++++++--------
 kernel/cgroup/cgroup-internal.h |  2 +-
 kernel/cgroup/cgroup.c          |  4 ++-
 kernel/cgroup/rstat.c           | 67 ++++++++++++++++++++---------------------
 4 files changed, 52 insertions(+), 50 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 02625cf..cf9db7b 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -258,6 +258,10 @@ struct css_set {
 	struct rcu_head rcu_head;
 };
 
+struct cgroup_base_stat {
+	struct task_cputime cputime;
+};
+
 /*
  * rstat - cgroup scalable recursive statistics.  Accounting is done
  * per-cpu in cgroup_rstat_cpu which is then lazily propagated up the
@@ -273,20 +277,24 @@ struct css_set {
  * aren't active and stat may be read frequently.  The combination can
  * become very expensive.  By propagating selectively, increasing reading
  * frequency decreases the cost of each read.
+ *
+ * This struct hosts both the fields which implement the above -
+ * updated_children and updated_next - and the fields which track basic
+ * resource statistics on top of it - bsync, bstat and last_bstat.
  */
 struct cgroup_rstat_cpu {
 	/*
-	 * ->sync protects all the current counters.  These are the only
-	 * fields which get updated in the hot path.
+	 * ->bsync protects ->bstat.  These are the only fields which get
+	 * updated in the hot path.
 	 */
-	struct u64_stats_sync sync;
-	struct task_cputime cputime;
+	struct u64_stats_sync bsync;
+	struct cgroup_base_stat bstat;
 
 	/*
 	 * Snapshots at the last reading.  These are used to calculate the
 	 * deltas to propagate to the global counters.
 	 */
-	struct task_cputime last_cputime;
+	struct cgroup_base_stat last_bstat;
 
 	/*
 	 * Child cgroups with stat updates on this cpu since the last read
@@ -303,12 +311,6 @@ struct cgroup_rstat_cpu {
 	struct cgroup *updated_next;		/* NULL iff not on the list */
 };
 
-struct cgroup_stat {
-	/* per-cpu statistics are collected into the folowing global counters */
-	struct task_cputime cputime;
-	struct prev_cputime prev_cputime;
-};
-
 struct cgroup {
 	/* self css with NULL ->ss, points back to this cgroup */
 	struct cgroup_subsys_state self;
@@ -412,8 +414,9 @@ struct cgroup {
 	struct cgroup_rstat_cpu __percpu *rstat_cpu;
 
 	/* cgroup basic resource statistics */
-	struct cgroup_stat pending_stat;	/* pending from children */
-	struct cgroup_stat stat;
+	struct cgroup_base_stat pending_bstat;	/* pending from children */
+	struct cgroup_base_stat bstat;
+	struct prev_cputime prev_cputime;	/* for printing out cputime */
 
 	/*
 	 * list of pidlists, up to two for each namespace (one for procs, one
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 0927111..aab4d0a 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -206,7 +206,7 @@ int cgroup_task_count(const struct cgroup *cgrp);
 void cgroup_rstat_flush(struct cgroup *cgrp);
 int cgroup_rstat_init(struct cgroup *cgrp);
 void cgroup_rstat_exit(struct cgroup *cgrp);
-void cgroup_stat_show_cputime(struct seq_file *seq);
+void cgroup_base_stat_cputime_show(struct seq_file *seq);
 void cgroup_rstat_boot(void);
 
 /*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5549a7c..0d3d093 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -54,6 +54,7 @@
 #include <linux/proc_ns.h>
 #include <linux/nsproxy.h>
 #include <linux/file.h>
+#include <linux/sched/cputime.h>
 #include <net/sock.h>
 
 #define CREATE_TRACE_POINTS
@@ -1859,6 +1860,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	cgrp->dom_cgrp = cgrp;
 	cgrp->max_descendants = INT_MAX;
 	cgrp->max_depth = INT_MAX;
+	prev_cputime_init(&cgrp->prev_cputime);
 
 	for_each_subsys(ss, ssid)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
@@ -3396,7 +3398,7 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 	struct cgroup __maybe_unused *cgrp = seq_css(seq)->cgroup;
 	int ret = 0;
 
-	cgroup_stat_show_cputime(seq);
+	cgroup_base_stat_cputime_show(seq);
 #ifdef CONFIG_CGROUP_SCHED
 	ret = cgroup_extra_stat_show(seq, cgrp, cpu_cgrp_id);
 #endif
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 6824047..7670191 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -128,30 +128,30 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	return pos;
 }
 
-static void cgroup_stat_accumulate(struct cgroup_stat *dst_stat,
-				   struct cgroup_stat *src_stat)
+static void cgroup_base_stat_accumulate(struct cgroup_base_stat *dst_bstat,
+					struct cgroup_base_stat *src_bstat)
 {
-	dst_stat->cputime.utime += src_stat->cputime.utime;
-	dst_stat->cputime.stime += src_stat->cputime.stime;
-	dst_stat->cputime.sum_exec_runtime += src_stat->cputime.sum_exec_runtime;
+	dst_bstat->cputime.utime += src_bstat->cputime.utime;
+	dst_bstat->cputime.stime += src_bstat->cputime.stime;
+	dst_bstat->cputime.sum_exec_runtime += src_bstat->cputime.sum_exec_runtime;
 }
 
-static void cgroup_cpu_stat_flush_one(struct cgroup *cgrp, int cpu)
+static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
-	struct task_cputime *last_cputime = &rstatc->last_cputime;
+	struct task_cputime *last_cputime = &rstatc->last_bstat.cputime;
 	struct task_cputime cputime;
-	struct cgroup_stat delta;
+	struct cgroup_base_stat delta;
 	unsigned seq;
 
 	lockdep_assert_held(&cgroup_rstat_mutex);
 
 	/* fetch the current per-cpu values */
 	do {
-		seq = __u64_stats_fetch_begin(&rstatc->sync);
-		cputime = rstatc->cputime;
-	} while (__u64_stats_fetch_retry(&rstatc->sync, seq));
+		seq = __u64_stats_fetch_begin(&rstatc->bsync);
+		cputime = rstatc->bstat.cputime;
+	} while (__u64_stats_fetch_retry(&rstatc->bsync, seq));
 
 	/* accumulate the deltas to propgate */
 	delta.cputime.utime = cputime.utime - last_cputime->utime;
@@ -161,13 +161,13 @@ static void cgroup_cpu_stat_flush_one(struct cgroup *cgrp, int cpu)
 	*last_cputime = cputime;
 
 	/* transfer the pending stat into delta */
-	cgroup_stat_accumulate(&delta, &cgrp->pending_stat);
-	memset(&cgrp->pending_stat, 0, sizeof(cgrp->pending_stat));
+	cgroup_base_stat_accumulate(&delta, &cgrp->pending_bstat);
+	memset(&cgrp->pending_bstat, 0, sizeof(cgrp->pending_bstat));
 
 	/* propagate delta into the global stat and the parent's pending */
-	cgroup_stat_accumulate(&cgrp->stat, &delta);
+	cgroup_base_stat_accumulate(&cgrp->bstat, &delta);
 	if (parent)
-		cgroup_stat_accumulate(&parent->pending_stat, &delta);
+		cgroup_base_stat_accumulate(&parent->pending_bstat, &delta);
 }
 
 /* see cgroup_rstat_flush() */
@@ -184,7 +184,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp)
 
 		raw_spin_lock_irq(cpu_lock);
 		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu)))
-			cgroup_cpu_stat_flush_one(pos, cpu);
+			cgroup_base_stat_flush(pos, cpu);
 		raw_spin_unlock_irq(cpu_lock);
 	}
 }
@@ -208,19 +208,19 @@ void cgroup_rstat_flush(struct cgroup *cgrp)
 }
 
 static struct cgroup_rstat_cpu *
-cgroup_cpu_stat_account_begin(struct cgroup *cgrp)
+cgroup_base_stat_cputime_account_begin(struct cgroup *cgrp)
 {
 	struct cgroup_rstat_cpu *rstatc;
 
 	rstatc = get_cpu_ptr(cgrp->rstat_cpu);
-	u64_stats_update_begin(&rstatc->sync);
+	u64_stats_update_begin(&rstatc->bsync);
 	return rstatc;
 }
 
-static void cgroup_cpu_stat_account_end(struct cgroup *cgrp,
-					struct cgroup_rstat_cpu *rstatc)
+static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
+						 struct cgroup_rstat_cpu *rstatc)
 {
-	u64_stats_update_end(&rstatc->sync);
+	u64_stats_update_end(&rstatc->bsync);
 	cgroup_rstat_cpu_updated(cgrp, smp_processor_id());
 	put_cpu_ptr(rstatc);
 }
@@ -229,9 +229,9 @@ void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec)
 {
 	struct cgroup_rstat_cpu *rstatc;
 
-	rstatc = cgroup_cpu_stat_account_begin(cgrp);
-	rstatc->cputime.sum_exec_runtime += delta_exec;
-	cgroup_cpu_stat_account_end(cgrp, rstatc);
+	rstatc = cgroup_base_stat_cputime_account_begin(cgrp);
+	rstatc->bstat.cputime.sum_exec_runtime += delta_exec;
+	cgroup_base_stat_cputime_account_end(cgrp, rstatc);
 }
 
 void __cgroup_account_cputime_field(struct cgroup *cgrp,
@@ -239,26 +239,26 @@ void __cgroup_account_cputime_field(struct cgroup *cgrp,
 {
 	struct cgroup_rstat_cpu *rstatc;
 
-	rstatc = cgroup_cpu_stat_account_begin(cgrp);
+	rstatc = cgroup_base_stat_cputime_account_begin(cgrp);
 
 	switch (index) {
 	case CPUTIME_USER:
 	case CPUTIME_NICE:
-		rstatc->cputime.utime += delta_exec;
+		rstatc->bstat.cputime.utime += delta_exec;
 		break;
 	case CPUTIME_SYSTEM:
 	case CPUTIME_IRQ:
 	case CPUTIME_SOFTIRQ:
-		rstatc->cputime.stime += delta_exec;
+		rstatc->bstat.cputime.stime += delta_exec;
 		break;
 	default:
 		break;
 	}
 
-	cgroup_cpu_stat_account_end(cgrp, rstatc);
+	cgroup_base_stat_cputime_account_end(cgrp, rstatc);
 }
 
-void cgroup_stat_show_cputime(struct seq_file *seq)
+void cgroup_base_stat_cputime_show(struct seq_file *seq)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 	u64 usage, utime, stime;
@@ -270,9 +270,8 @@ void cgroup_stat_show_cputime(struct seq_file *seq)
 
 	cgroup_rstat_flush_locked(cgrp);
 
-	usage = cgrp->stat.cputime.sum_exec_runtime;
-	cputime_adjust(&cgrp->stat.cputime, &cgrp->stat.prev_cputime,
-		       &utime, &stime);
+	usage = cgrp->bstat.cputime.sum_exec_runtime;
+	cputime_adjust(&cgrp->bstat.cputime, &cgrp->prev_cputime, &utime, &stime);
 
 	mutex_unlock(&cgroup_rstat_mutex);
 
@@ -302,11 +301,9 @@ int cgroup_rstat_init(struct cgroup *cgrp)
 		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
 
 		rstatc->updated_children = cgrp;
-		u64_stats_init(&rstatc->sync);
+		u64_stats_init(&rstatc->bsync);
 	}
 
-	prev_cputime_init(&cgrp->stat.prev_cputime);
-
 	return 0;
 }
 
-- 
2.9.5

