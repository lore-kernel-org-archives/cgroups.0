From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-5.14-fixes] cgroup: rstat: fix A-A deadlock on
 32bit around u64_stats_sync
Date: Tue, 27 Jul 2021 13:04:49 -1000
Message-ID: <YQCREXMBq1EPoQWu@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=+zPcJpoAXidsAZrfmunhWmzWmAmlPVvmu9gYFGmOupg=;
        b=coS26sfi4q47AesZECMQbJnXpLJ7/LBavvccUdZakqOPGCA1I6W1t7XMnnOtrm0Et9
         odHOTcXdUEyDQlPinWYi7S/H+tr1CI1xhbvqBmgWuGwjOD4DY+UcFZFqcfIEtc/jy8Pr
         32sYeLMHHs8xNDiGlI0k05xmJss0esdtcOj1Jc505JLSG9sRoM8FjuueGMBC9EI6Oi+a
         uM+WsGI30f65296dIL2R9f+K8Pz4E58lT2azagUvpqK8SWYitxu9grLqRJUk6FQMEOck
         kMLNy43EAHxMBsNnfou5gXygu4N7XcdF3Nw6t82Y196CL8FS3rnftPgUS5LFYky/H6z9
         3xTQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>

0fa294fb1985 ("cgroup: Replace cgroup_rstat_mutex with a spinlock") added
cgroup_rstat_flush_irqsafe() allowing flushing to happen from the irq
context. However, rstat paths use u64_stats_sync to synchronize access to
64bit stat counters on 32bit machines. u64_stats_sync is implemented using
seq_lock and trying to read from an irq context can lead to A-A deadlock if
the irq happens to interrupt the stat update.

Fix it by using the irqsafe variants - u64_stats_update_begin_irqsave() and
u64_stats_update_end_irqrestore() - in the update paths. Note that none of
this matters on 64bit machines. All these are just for 32bit SMP setups.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>
---
 block/blk-cgroup.c    |   14 ++++++++------
 kernel/cgroup/rstat.c |   19 +++++++++++--------
 2 files changed, 19 insertions(+), 14 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -790,6 +790,7 @@ static void blkcg_rstat_flush(struct cgr
 		struct blkcg_gq *parent = blkg->parent;
 		struct blkg_iostat_set *bisc = per_cpu_ptr(blkg->iostat_cpu, cpu);
 		struct blkg_iostat cur, delta;
+		unsigned long flags;
 		unsigned int seq;
 
 		/* fetch the current per-cpu values */
@@ -799,21 +800,21 @@ static void blkcg_rstat_flush(struct cgr
 		} while (u64_stats_fetch_retry(&bisc->sync, seq));
 
 		/* propagate percpu delta to global */
-		u64_stats_update_begin(&blkg->iostat.sync);
+		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
 		blkg_iostat_set(&delta, &cur);
 		blkg_iostat_sub(&delta, &bisc->last);
 		blkg_iostat_add(&blkg->iostat.cur, &delta);
 		blkg_iostat_add(&bisc->last, &delta);
-		u64_stats_update_end(&blkg->iostat.sync);
+		u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 
 		/* propagate global delta to parent (unless that's root) */
 		if (parent && parent->parent) {
-			u64_stats_update_begin(&parent->iostat.sync);
+			flags = u64_stats_update_begin_irqsave(&parent->iostat.sync);
 			blkg_iostat_set(&delta, &blkg->iostat.cur);
 			blkg_iostat_sub(&delta, &blkg->iostat.last);
 			blkg_iostat_add(&parent->iostat.cur, &delta);
 			blkg_iostat_add(&blkg->iostat.last, &delta);
-			u64_stats_update_end(&parent->iostat.sync);
+			u64_stats_update_end_irqrestore(&parent->iostat.sync, flags);
 		}
 	}
 
@@ -848,6 +849,7 @@ static void blkcg_fill_root_iostats(void
 		memset(&tmp, 0, sizeof(tmp));
 		for_each_possible_cpu(cpu) {
 			struct disk_stats *cpu_dkstats;
+			unsigned long flags;
 
 			cpu_dkstats = per_cpu_ptr(bdev->bd_stats, cpu);
 			tmp.ios[BLKG_IOSTAT_READ] +=
@@ -864,9 +866,9 @@ static void blkcg_fill_root_iostats(void
 			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
 				cpu_dkstats->sectors[STAT_DISCARD] << 9;
 
-			u64_stats_update_begin(&blkg->iostat.sync);
+			flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
 			blkg_iostat_set(&blkg->iostat.cur, &tmp);
-			u64_stats_update_end(&blkg->iostat.sync);
+			u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 		}
 	}
 }
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -347,19 +347,20 @@ static void cgroup_base_stat_flush(struc
 }
 
 static struct cgroup_rstat_cpu *
-cgroup_base_stat_cputime_account_begin(struct cgroup *cgrp)
+cgroup_base_stat_cputime_account_begin(struct cgroup *cgrp, unsigned long *flags)
 {
 	struct cgroup_rstat_cpu *rstatc;
 
 	rstatc = get_cpu_ptr(cgrp->rstat_cpu);
-	u64_stats_update_begin(&rstatc->bsync);
+	*flags = u64_stats_update_begin_irqsave(&rstatc->bsync);
 	return rstatc;
 }
 
 static void cgroup_base_stat_cputime_account_end(struct cgroup *cgrp,
-						 struct cgroup_rstat_cpu *rstatc)
+						 struct cgroup_rstat_cpu *rstatc,
+						 unsigned long flags)
 {
-	u64_stats_update_end(&rstatc->bsync);
+	u64_stats_update_end_irqrestore(&rstatc->bsync, flags);
 	cgroup_rstat_updated(cgrp, smp_processor_id());
 	put_cpu_ptr(rstatc);
 }
@@ -367,18 +368,20 @@ static void cgroup_base_stat_cputime_acc
 void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec)
 {
 	struct cgroup_rstat_cpu *rstatc;
+	unsigned long flags;
 
-	rstatc = cgroup_base_stat_cputime_account_begin(cgrp);
+	rstatc = cgroup_base_stat_cputime_account_begin(cgrp, &flags);
 	rstatc->bstat.cputime.sum_exec_runtime += delta_exec;
-	cgroup_base_stat_cputime_account_end(cgrp, rstatc);
+	cgroup_base_stat_cputime_account_end(cgrp, rstatc, flags);
 }
 
 void __cgroup_account_cputime_field(struct cgroup *cgrp,
 				    enum cpu_usage_stat index, u64 delta_exec)
 {
 	struct cgroup_rstat_cpu *rstatc;
+	unsigned long flags;
 
-	rstatc = cgroup_base_stat_cputime_account_begin(cgrp);
+	rstatc = cgroup_base_stat_cputime_account_begin(cgrp, &flags);
 
 	switch (index) {
 	case CPUTIME_USER:
@@ -394,7 +397,7 @@ void __cgroup_account_cputime_field(stru
 		break;
 	}
 
-	cgroup_base_stat_cputime_account_end(cgrp, rstatc);
+	cgroup_base_stat_cputime_account_end(cgrp, rstatc, flags);
 }
 
 /*
