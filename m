From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] blkcg: make blkg_[rw]stat_recursive_sum() to be able to index into blkcg_gq
Date: Thu, 25 Jun 2015 17:38:55 -0400
Message-ID: <1435268337-1738-5-git-send-email-tj@kernel.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WuUpV18wc930H8L2xoEE6I4YfzyniSYqoT/xruWcU7Y=;
        b=HczdDxdGddv4Pz2NeV9veReojDoBc3HTJ8hdITiERA5CC+XVMZvV8+7F2bi5UdNXhs
         j9SWxNpkP9X+qoXqP/BWfdrzxVhcAmjkvIEZ6WvhWg1AQvjg2mm9Ik11IDdpOrD2/uFn
         SVDMWnl6iodPOXGmgc0v+XNsxPGc6u+qpkd5gaFp4DbPwwy9A0a2QNlzGrREmRrPEnub
         SNmaGi7KwpRjaKYOE+T5HPnGPqzdxY/i/bxYviZ0WC95l2hWCtET1YIIkp3S6BWO40Ja
         uaTurcp9yVryPzb5P871DeEmaXB4wer0DRZvh0Ej8o1x+HiSQg2h8MUPUgESAzM6PlQZ
         O7Kg==
In-Reply-To: <1435268337-1738-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, blkg_[rw]stat_recursive_sum() assume that the target
counter is located in pd (blkg_policy_data); however, some counters
are planned to be moved to blkg (blkcg_gq).

This patch updates blkg_[rw]stat_recursive_sum() to take blkg and
blkg_policy pointers instead of pd.  If policy is NULL, it indexes
into blkg.  If non-NULL, into the blkg's pd of the policy.

The existing usages are updated to maintain the current behaviors.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c         | 69 ++++++++++++++++++++++++++++------------------
 block/cfq-iosched.c        |  8 +++---
 include/linux/blk-cgroup.h |  7 +++--
 3 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bc90b5b..899232e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -615,30 +615,39 @@ EXPORT_SYMBOL_GPL(blkg_prfill_rwstat);
 
 /**
  * blkg_stat_recursive_sum - collect hierarchical blkg_stat
- * @pd: policy private data of interest
- * @off: offset to the blkg_stat in @pd
+ * @blkg: blkg of interest
+ * @pol: blkcg_policy which contains the blkg_stat
+ * @off: offset to the blkg_stat in blkg_policy_data or @blkg
  *
- * Collect the blkg_stat specified by @off from @pd and all its online
- * descendants and their aux counts.  The caller must be holding the queue
- * lock for online tests.
+ * Collect the blkg_stat specified by @blkg, @pol and @off and all its
+ * online descendants and their aux counts.  The caller must be holding the
+ * queue lock for online tests.
+ *
+ * If @pol is NULL, blkg_stat is at @off bytes into @blkg; otherwise, it is
+ * at @off bytes into @blkg's blkg_policy_data of the policy.
  */
-u64 blkg_stat_recursive_sum(struct blkg_policy_data *pd, int off)
+u64 blkg_stat_recursive_sum(struct blkcg_gq *blkg,
+			    struct blkcg_policy *pol, int off)
 {
-	struct blkcg_policy *pol = blkcg_policy[pd->plid];
 	struct blkcg_gq *pos_blkg;
 	struct cgroup_subsys_state *pos_css;
 	u64 sum = 0;
 
-	lockdep_assert_held(pd->blkg->q->queue_lock);
+	lockdep_assert_held(blkg->q->queue_lock);
 
 	rcu_read_lock();
-	blkg_for_each_descendant_pre(pos_blkg, pos_css, pd_to_blkg(pd)) {
-		struct blkg_policy_data *pos_pd = blkg_to_pd(pos_blkg, pol);
-		struct blkg_stat *stat = (void *)pos_pd + off;
+	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
+		struct blkg_stat *stat;
+
+		if (!pos_blkg->online)
+			continue;
 
-		if (pos_blkg->online)
-			sum += blkg_stat_read(stat) +
-				atomic64_read(&stat->aux_cnt);
+		if (pol)
+			stat = (void *)blkg_to_pd(pos_blkg, pol) + off;
+		else
+			stat = (void *)blkg + off;
+
+		sum += blkg_stat_read(stat) + atomic64_read(&stat->aux_cnt);
 	}
 	rcu_read_unlock();
 
@@ -648,33 +657,39 @@ EXPORT_SYMBOL_GPL(blkg_stat_recursive_sum);
 
 /**
  * blkg_rwstat_recursive_sum - collect hierarchical blkg_rwstat
- * @pd: policy private data of interest
- * @off: offset to the blkg_stat in @pd
+ * @blkg: blkg of interest
+ * @pol: blkcg_policy which contains the blkg_rwstat
+ * @off: offset to the blkg_rwstat in blkg_policy_data or @blkg
  *
- * Collect the blkg_rwstat specified by @off from @pd and all its online
- * descendants and their aux counts.  The caller must be holding the queue
- * lock for online tests.
+ * Collect the blkg_rwstat specified by @blkg, @pol and @off and all its
+ * online descendants and their aux counts.  The caller must be holding the
+ * queue lock for online tests.
+ *
+ * If @pol is NULL, blkg_rwstat is at @off bytes into @blkg; otherwise, it
+ * is at @off bytes into @blkg's blkg_policy_data of the policy.
  */
-struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkg_policy_data *pd,
-					     int off)
+struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkcg_gq *blkg,
+					     struct blkcg_policy *pol, int off)
 {
-	struct blkcg_policy *pol = blkcg_policy[pd->plid];
 	struct blkcg_gq *pos_blkg;
 	struct cgroup_subsys_state *pos_css;
 	struct blkg_rwstat sum = { };
 	int i;
 
-	lockdep_assert_held(pd->blkg->q->queue_lock);
+	lockdep_assert_held(blkg->q->queue_lock);
 
 	rcu_read_lock();
-	blkg_for_each_descendant_pre(pos_blkg, pos_css, pd_to_blkg(pd)) {
-		struct blkg_policy_data *pos_pd = blkg_to_pd(pos_blkg, pol);
-		struct blkg_rwstat *rwstat = (void *)pos_pd + off;
-		struct blkg_rwstat tmp;
+	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
+		struct blkg_rwstat *rwstat, tmp;
 
 		if (!pos_blkg->online)
 			continue;
 
+		if (pol)
+			rwstat = (void *)blkg_to_pd(pos_blkg, pol) + off;
+		else
+			rwstat = (void *)pos_blkg + off;
+
 		tmp = blkg_rwstat_read(rwstat);
 
 		for (i = 0; i < BLKG_RWSTAT_NR; i++)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3bdef38..86ae2ea 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1818,16 +1818,16 @@ static int cfqg_print_rwstat(struct seq_file *sf, void *v)
 static u64 cfqg_prfill_stat_recursive(struct seq_file *sf,
 				      struct blkg_policy_data *pd, int off)
 {
-	u64 sum = blkg_stat_recursive_sum(pd, off);
-
+	u64 sum = blkg_stat_recursive_sum(pd_to_blkg(pd),
+					  &blkcg_policy_cfq, off);
 	return __blkg_prfill_u64(sf, pd, sum);
 }
 
 static u64 cfqg_prfill_rwstat_recursive(struct seq_file *sf,
 					struct blkg_policy_data *pd, int off)
 {
-	struct blkg_rwstat sum = blkg_rwstat_recursive_sum(pd, off);
-
+	struct blkg_rwstat sum = blkg_rwstat_recursive_sum(pd_to_blkg(pd),
+							&blkcg_policy_cfq, off);
 	return __blkg_prfill_rwstat(sf, pd, &sum);
 }
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 8d53fbc..67eeb27 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -179,9 +179,10 @@ u64 blkg_prfill_stat(struct seq_file *sf, struct blkg_policy_data *pd, int off);
 u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		       int off);
 
-u64 blkg_stat_recursive_sum(struct blkg_policy_data *pd, int off);
-struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkg_policy_data *pd,
-					     int off);
+u64 blkg_stat_recursive_sum(struct blkcg_gq *blkg,
+			    struct blkcg_policy *pol, int off);
+struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkcg_gq *blkg,
+					     struct blkcg_policy *pol, int off);
 
 struct blkg_conf_ctx {
 	struct gendisk			*disk;
-- 
2.4.3
