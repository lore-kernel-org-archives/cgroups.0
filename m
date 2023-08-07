From: Hao Jia <jiahao.os@bytedance.com>
Subject: [PATCH v2] cgroup/rstat: Record the cumulative per-cpu time of cgroup and its descendants
Date: Mon,  7 Aug 2023 11:29:30 +0800
Message-ID: <20230807032930.87785-1-jiahao.os@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691379002; x=1691983802;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VSleIMqg0obClaPZQhg7+Ks6xrxwU85bZ75FMLlTO7c=;
        b=EnSVSnHsPlsW89xzfLkP3wUxd8KSZca7gDZUxHD2RVP7s44GVLnjzcbWmFVtLJnCV8
         CzDZNRwl2mo+D5XvQH1+JytoDuc4qdfSgKWq3EyWXSmbTMvnOB5fyBYbl9KaltxT6h2c
         FLSDhmaOfPYzWAd7bYGacMNsodAJgWHCZOjWe5ig6QevjgkdBPvKaFQbfpDcV/HTXQuX
         JrFxQb61l1zOUWWtucIgRCWnV3ogBWY3QhZilZ30hMLXiYYn4m3jDHi5ASFDduPgb5vK
         lvZGlTKYsprzbg0kqS+VVw9LK0m6HbbH1yYT8Pv9F4h4U2QhqCNHVFyRIzJzmnkp72nl
         1zbg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mkoutny@suse.com, songmuchun@bytedance.com, muchun.song@linux.dev, wuyun.abel@bytedance.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hao Jia <jiahao.os@bytedance.com>

The member variable bstat of the structure cgroup_rstat_cpu
records the per-cpu time of the cgroup itself, but does not
include the per-cpu time of its descendants. The per-cpu time
including descendants is very useful for calculating the
per-cpu usage of cgroups.

Although we can indirectly obtain the total per-cpu time
of the cgroup and its descendants by accumulating the per-cpu
bstat of each descendant of the cgroup. But after a child cgroup
is removed, we will lose its bstat information. This will cause
the cumulative value to be non-monotonic, thus affecting
the accuracy of cgroup per-cpu usage.

So we add the subtree_bstat variable to record the total
per-cpu time of this cgroup and its descendants, which is
similar to "cpuacct.usage*" in cgroup v1. And this is
also helpful for the migration from cgroup v1 to cgroup v2.
After adding this variable, we can obtain the per-cpu time of
cgroup and its descendants in user mode through eBPF/drgn, etc.
And we are still trying to determine how to expose it in the
cgroupfs interface.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hao Jia <jiahao.os@bytedance.com>
---
 include/linux/cgroup-defs.h | 14 ++++++++++++++
 kernel/cgroup/rstat.c       | 12 ++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 8a0d5466c7be..7a2862172f51 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -341,6 +341,20 @@ struct cgroup_rstat_cpu {
 	 */
 	struct cgroup_base_stat last_bstat;
 
+	/*
+	 * This field is used to record the cumulative per-cpu time of
+	 * the cgroup and its descendants. Currently it can be read via
+	 * eBPF/drgn etc, and we are still trying to determine how to
+	 * expose it in the cgroupfs interface.
+	 */
+	struct cgroup_base_stat subtree_bstat;
+
+	/*
+	 * Snapshots at the last reading. These are used to calculate the
+	 * deltas to propagate to the per-cpu subtree_bstat.
+	 */
+	struct cgroup_base_stat last_subtree_bstat;
+
 	/*
 	 * Child cgroups with stat updates on this cpu since the last read
 	 * are linked on the parent's ->updated_children through
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 2542c21b6b6d..d80d7a608141 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -344,6 +344,7 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 {
 	struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
 	struct cgroup *parent = cgroup_parent(cgrp);
+	struct cgroup_rstat_cpu *prstatc;
 	struct cgroup_base_stat delta;
 	unsigned seq;
 
@@ -357,17 +358,24 @@ static void cgroup_base_stat_flush(struct cgroup *cgrp, int cpu)
 		delta = rstatc->bstat;
 	} while (__u64_stats_fetch_retry(&rstatc->bsync, seq));
 
-	/* propagate percpu delta to global */
+	/* propagate per-cpu delta to cgroup and per-cpu global statistics */
 	cgroup_base_stat_sub(&delta, &rstatc->last_bstat);
 	cgroup_base_stat_add(&cgrp->bstat, &delta);
 	cgroup_base_stat_add(&rstatc->last_bstat, &delta);
+	cgroup_base_stat_add(&rstatc->subtree_bstat, &delta);
 
-	/* propagate global delta to parent (unless that's root) */
+	/* propagate cgroup and per-cpu global delta to parent (unless that's root) */
 	if (cgroup_parent(parent)) {
 		delta = cgrp->bstat;
 		cgroup_base_stat_sub(&delta, &cgrp->last_bstat);
 		cgroup_base_stat_add(&parent->bstat, &delta);
 		cgroup_base_stat_add(&cgrp->last_bstat, &delta);
+
+		delta = rstatc->subtree_bstat;
+		prstatc = cgroup_rstat_cpu(parent, cpu);
+		cgroup_base_stat_sub(&delta, &rstatc->last_subtree_bstat);
+		cgroup_base_stat_add(&prstatc->subtree_bstat, &delta);
+		cgroup_base_stat_add(&rstatc->last_subtree_bstat, &delta);
 	}
 }
 
-- 
2.37.0

