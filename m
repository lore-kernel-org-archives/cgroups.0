From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/9] blkcg, cfq-iosched: use GFP_NOWAIT instead of GFP_ATOMIC for non-critical allocations
Date: Tue,  7 Jul 2015 11:35:57 -0400
Message-ID: <1436283361-3889-6-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DFDk9Mo+OqY16KROFeMxduWqkEEO1NlO1sCtPgEqRlA=;
        b=hQNc6RRjUneym/tG3D5Fai7dj04S/tVYBAxnRoqFAfzKCdKadPT8zZZUiUmyS1aJuQ
         dw+6gsbFz8/Z0mdsdYAohWAThTJajRXZBtVJ5nBmeURsV3pemzz0cA39rZTUsXVDLbwy
         NgaUexrJoXWOZE55Wy2PNNaQCWzZ0U2jHT5EZy/vA0B1m6xjWG++4FntQcPQ9tesU8YG
         0FSY3+ICssNHl2Vf+G6xfiRpZI05yEASG/cw6fffgSn0HyPHg0NEGyBYiHv2SFneLR2D
         hpZQ5NhIn7+7PAAUWvZOvtkfIXXGyVokQiuFakTSOS3Nl/nxhJ7knfd5AxpMh5/O02FI
         hJXA==
In-Reply-To: <1436283361-3889-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

blkcg performs several allocations to track IOs per cgroup and enforce
resource control.  Most of these allocations are performed lazily on
demand in the IO path and thus can't involve reclaim path.  Currently,
these allocations use GFP_ATOMIC; however, blkcg can gracefully deal
with occassional failures of these allocations by punting IOs to the
root cgroup and there's no reason to reach into the emergency reserve.

This patch replaces GFP_ATOMIC with GFP_NOWAIT for the following
allocations.

* bdi_writeback_congested and blkcg_gq allocations in blkg_create().

* radix tree node allocations for blkcg->blkg_tree.

* cfq_queue allocation on ioprio changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-and-Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Suggested-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  | 8 ++++----
 block/cfq-iosched.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9f97da5..dacd95d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -178,7 +178,7 @@ EXPORT_SYMBOL_GPL(blkg_lookup);
 
 /*
  * If @new_blkg is %NULL, this function tries to allocate a new one as
- * necessary using %GFP_ATOMIC.  @new_blkg is always consumed on return.
+ * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on return.
  */
 static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 				    struct request_queue *q,
@@ -198,7 +198,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	}
 
 	wb_congested = wb_congested_get_create(&q->backing_dev_info,
-					       blkcg->css.id, GFP_ATOMIC);
+					       blkcg->css.id, GFP_NOWAIT);
 	if (!wb_congested) {
 		ret = -ENOMEM;
 		goto err_put_css;
@@ -206,7 +206,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 
 	/* allocate */
 	if (!new_blkg) {
-		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
+		new_blkg = blkg_alloc(blkcg, q, GFP_NOWAIT);
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
 			goto err_put_congested;
@@ -870,7 +870,7 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 
 done:
 	spin_lock_init(&blkcg->lock);
-	INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_ATOMIC);
+	INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_NOWAIT);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index bf6f49c..5f11929 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3575,7 +3575,7 @@ static void check_ioprio_changed(struct cfq_io_cq *cic, struct bio *bio)
 	cfqq = cic_to_cfqq(cic, false);
 	if (cfqq) {
 		cfq_put_queue(cfqq);
-		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio, GFP_ATOMIC);
+		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio, GFP_NOWAIT);
 		cic_set_cfqq(cic, cfqq, false);
 	}
 
-- 
2.4.3
