From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/51] writeback, blkcg: associate each blkcg_gq with the corresponding bdi_writeback_congested
Date: Fri, 22 May 2015 17:13:38 -0400
Message-ID: <1432329245-5844-25-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qoUyPemHrwjJ9nLuGlz3w2NE1Omj65T1FqXHvZyNDyU=;
        b=R1/5fMqeraUTXtmo5uUIjFPuJa527CRTTaVKFTE1D7AmSUzw9XJHhn7bovmHejbXuA
         NtiNz3dMFUDubZTNXDw1J1uxWGBphH8Ewp+RBufnf7IRf8FR8oO112opxND5z3LA4bJJ
         lSaEXj/2d3j5AyhvLkZW8Y+Sik3dA9wSZWEHSYm7+o3pRdIShrep3NnaBDhQT8i6vBcm
         D4TY2wJg7C+DHfe4RM0A8FM5+SMOEjdAj5ziHiaGeOw4jpRJ4sGe3YcYaqmqWi5IHV91
         FCMVX2PZJTvz86wG2KSXgH6/lUs6uJctAT/UDLsIX2KUS26mYqyvNKzjz8Filb8ouSGe
         GzUg==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>

A blkg (blkcg_gq) can be congested and decongested independently from
other blkgs on the same request_queue.  Accordingly, for cgroup
writeback support, the congestion status at bdi (backing_dev_info)
should be split and updated separately from matching blkg's.

This patch prepares by adding blkg->wb_congested and associating a
blkg with its matching per-blkcg bdi_writeback_congested on creation.

v2: Updated to associate bdi_writeback_congested instead of
    bdi_writeback.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c         | 17 +++++++++++++++--
 include/linux/blk-cgroup.h |  6 ++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 979cfdb..31610ae 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -182,6 +182,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 				    struct blkcg_gq *new_blkg)
 {
 	struct blkcg_gq *blkg;
+	struct bdi_writeback_congested *wb_congested;
 	int i, ret;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
@@ -193,22 +194,30 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 		goto err_free_blkg;
 	}
 
+	wb_congested = wb_congested_get_create(&q->backing_dev_info,
+					       blkcg->css.id, GFP_ATOMIC);
+	if (!wb_congested) {
+		ret = -ENOMEM;
+		goto err_put_css;
+	}
+
 	/* allocate */
 	if (!new_blkg) {
 		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
-			goto err_put_css;
+			goto err_put_congested;
 		}
 	}
 	blkg = new_blkg;
+	blkg->wb_congested = wb_congested;
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
 		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
 		if (WARN_ON_ONCE(!blkg->parent)) {
 			ret = -EINVAL;
-			goto err_put_css;
+			goto err_put_congested;
 		}
 		blkg_get(blkg->parent);
 	}
@@ -245,6 +254,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	blkg_put(blkg);
 	return ERR_PTR(ret);
 
+err_put_congested:
+	wb_congested_put(wb_congested);
 err_put_css:
 	css_put(&blkcg->css);
 err_free_blkg:
@@ -391,6 +402,8 @@ void __blkg_release_rcu(struct rcu_head *rcu_head)
 	if (blkg->parent)
 		blkg_put(blkg->parent);
 
+	wb_congested_put(blkg->wb_congested);
+
 	blkg_free(blkg);
 }
 EXPORT_SYMBOL_GPL(__blkg_release_rcu);
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 3033eb1..07a32b8 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -99,6 +99,12 @@ struct blkcg_gq {
 	struct hlist_node		blkcg_node;
 	struct blkcg			*blkcg;
 
+	/*
+	 * Each blkg gets congested separately and the congestion state is
+	 * propagated to the matching bdi_writeback_congested.
+	 */
+	struct bdi_writeback_congested	*wb_congested;
+
 	/* all non-root blkcg_gq's are guaranteed to have access to parent */
 	struct blkcg_gq			*parent;
 
-- 
2.4.0

