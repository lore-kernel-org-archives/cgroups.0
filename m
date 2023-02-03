From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/19] blk-cgroup: simplify blkg freeing from initialization failure paths
Date: Fri,  3 Feb 2023 16:03:45 +0100
Message-ID: <20230203150400.3199230-5-hch@lst.de>
References: <20230203150400.3199230-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EPfnq7z73vpmLopiiLSTsg+UYOgAEEjPrhtrmGL5ArE=; b=AwMWRjxiNUZumIZ/RvVRdozfgz
        Nfas8+h6EDKSy8XDYq2bAODAwkQUR1l/nA78fvNicYSKbjpYO+ha5q8/Xk/NCUaybuDMb8dw2ITgg
        bDF93rneapU48ftfXzGVDLBnoCUimwbPLk9R0dyLkow1hKH80/YpNcMTK3HYRTu68sQQWwQvHzFuL
        1bmTCe9uy6HWQmwKiec+jk9qbtvdkuh0iMff6A19quScNyCC1XEp9oD7AcXvKX3NSl3Fo6zUaicw5
        RMMIqI1kbZK/Rg9QrK0wA3NTWXVtDE67P9E+j+bI4nVehr/49u7eCC+P7c4w293I0y2GCuURrcRYO
        LujfEDyA==;
In-Reply-To: <20230203150400.3199230-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There is no need to delay freeing a blkg to a workqueue when freeing it
after an initialization failure.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-cgroup.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9df02a6d04d35a..1038688568926e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -114,10 +114,8 @@ static bool blkcg_policy_enabled(struct request_queue *q,
 	return pol && test_bit(pol->plid, q->blkcg_pols);
 }
 
-static void blkg_free_workfn(struct work_struct *work)
+static void blkg_free(struct blkcg_gq *blkg)
 {
-	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
-					     free_work);
 	struct request_queue *q = blkg->q;
 	int i;
 
@@ -143,23 +141,9 @@ static void blkg_free_workfn(struct work_struct *work)
 	kfree(blkg);
 }
 
-/**
- * blkg_free - free a blkg
- * @blkg: blkg to free
- *
- * Free @blkg which may be partially allocated.
- */
-static void blkg_free(struct blkcg_gq *blkg)
+static void blkg_free_workfn(struct work_struct *work)
 {
-	if (!blkg)
-		return;
-
-	/*
-	 * Both ->pd_free_fn() and request queue's release handler may
-	 * sleep, so free us by scheduling one work func
-	 */
-	INIT_WORK(&blkg->free_work, blkg_free_workfn);
-	schedule_work(&blkg->free_work);
+	blkg_free(container_of(work, struct blkcg_gq, free_work));
 }
 
 static void __blkg_release(struct rcu_head *rcu)
@@ -170,7 +154,10 @@ static void __blkg_release(struct rcu_head *rcu)
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
-	blkg_free(blkg);
+
+	/* ->pd_free_fn() may sleep, so free from a work queue */
+	INIT_WORK(&blkg->free_work, blkg_free_workfn);
+	schedule_work(&blkg->free_work);
 }
 
 /*
-- 
2.39.0

