From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4.5/8] blkcg, cfq-iosched: use GFP_NOWAIT instead of
 GFP_ATOMIC for non-critical allocations
Date: Tue, 9 Jun 2015 13:21:31 +0900
Message-ID: <20150609042131.GN21465@mtj.duckdns.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2IleTfsGt6IxHCBEZ7f173cQTOJ4S866cZAx0qgQmXk=;
        b=sz1GFDrP/13J6RBYv/B97GjWutSwOqDlTkgGTU8LsZo06nU3HqpPaqLJ+hn+GE4OgV
         Zklt2WgNKkasP3myLyHhgbaATUDwCfSmXKI2s0198Qn5w48CeOWgwUMWDK+sdBZPl358
         mDHYeMFxsqBiDRplEI3nzByAoRwBhxdoNfNLEI68+BlxxGyb6nH3oD8jT8Nn/nPgtr3a
         /hLqoIvHv0zItNVCXjXoTBp75Q1bE5Q2//UXTtfXPtN248FbFdJS8NAJoZv4H63kTB5m
         os62FRTQvWUN95adUwwSrihcDm28xKsL/EPcRGw5MAdw7GP/sacMAc4Tn6fO9wnUyVji
         N+iQ==
Content-Disposition: inline
In-Reply-To: <1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

From b848495d2c987e960d1f7794966d82c05fcefc6d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 9 Jun 2015 13:19:40 +0900

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

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Suggested-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
Hello,

git branch updated accordingly.  A couple of later patches need to be
updated but the changes are trivial.  I'll repost the patchset once
review is done.

Thanks.

 block/blk-cgroup.c  | 8 ++++----
 block/cfq-iosched.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 31610ae..1fddbbd 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -175,7 +175,7 @@ EXPORT_SYMBOL_GPL(blkg_lookup);
 
 /*
  * If @new_blkg is %NULL, this function tries to allocate a new one as
- * necessary using %GFP_ATOMIC.  @new_blkg is always consumed on return.
+ * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on return.
  */
 static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 				    struct request_queue *q,
@@ -195,7 +195,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	}
 
 	wb_congested = wb_congested_get_create(&q->backing_dev_info,
-					       blkcg->css.id, GFP_ATOMIC);
+					       blkcg->css.id, GFP_NOWAIT);
 	if (!wb_congested) {
 		ret = -ENOMEM;
 		goto err_put_css;
@@ -203,7 +203,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 
 	/* allocate */
 	if (!new_blkg) {
-		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
+		new_blkg = blkg_alloc(blkcg, q, GFP_NOWAIT);
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
 			goto err_put_congested;
@@ -841,7 +841,7 @@ blkcg_css_alloc(struct cgroup_subsys_state *parent_css)
 	blkcg->cfq_leaf_weight = CFQ_WEIGHT_DEFAULT;
 done:
 	spin_lock_init(&blkcg->lock);
-	INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_ATOMIC);
+	INIT_RADIX_TREE(&blkcg->blkg_tree, GFP_NOWAIT);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 #ifdef CONFIG_CGROUP_WRITEBACK
 	INIT_LIST_HEAD(&blkcg->cgwb_list);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 90d5a87..97863ce 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3507,7 +3507,7 @@ static void check_ioprio_changed(struct cfq_io_cq *cic, struct bio *bio)
 	cfqq = cic_to_cfqq(cic, false);
 	if (cfqq) {
 		cfq_put_queue(cfqq);
-		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio, GFP_ATOMIC);
+		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio, GFP_NOWAIT);
 		cic_set_cfqq(cic, cfqq, false);
 	}
 
-- 
2.4.2
