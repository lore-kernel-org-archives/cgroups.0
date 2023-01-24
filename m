From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Tue, 24 Jan 2023 07:57:01 +0100
Message-ID: <20230124065716.152286-2-hch@lst.de>
References: <20230124065716.152286-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=30NLUDFY6LwZkFlJss4wE81ByRWLz/1+fz+0qS7Tg/s=; b=fr+cpc3Un7SR+MPks821I9do58
        4gvK6XD7UwBOfLrsYQrp3od3butIZSOmtLLOvXIL8Om/vErdYLTCwegnRDH3s7H1cDE0h5YQewKWs
        L5IW1drnvQxnB5ecRuA8IHCMELafyXHiDEwqi/ONMr2hL6CbbKReaebCVGP76S8zGpoSSXbzPuQDX
        fYh/KKahuSfQ2SbgzXF9e/Dv/l1+b0ztaXQc3Rs8LnebFukkL9GJNvTcdbRHORaOtIJ3hNhsDDkc5
        Pi6Ov3Opx2CQdlCKTwS8T74vgFE4GSQcF58WTS9F04yTCImoCfgCC51MXTugYi8m2lMKrfwyPvU5u
        zQ+XqFUw==;
In-Reply-To: <20230124065716.152286-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

Now that blk_put_queue can be called from process context, there is no
need for the asynchronous execution.

This effectively reverts commit d578c770c85233af592e54537f93f3831bde7e9a.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
---
 block/blk-cgroup.c | 32 ++++++++++----------------------
 block/blk-cgroup.h |  5 +----
 2 files changed, 11 insertions(+), 26 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ce6a2b7d3dfb2b..30d493b43f9272 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -114,12 +114,19 @@ static bool blkcg_policy_enabled(struct request_queue *q,
 	return pol && test_bit(pol->plid, q->blkcg_pols);
 }
 
-static void blkg_free_workfn(struct work_struct *work)
+/**
+ * blkg_free - free a blkg
+ * @blkg: blkg to free
+ *
+ * Free @blkg which may be partially allocated.
+ */
+static void blkg_free(struct blkcg_gq *blkg)
 {
-	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
-					     free_work);
 	int i;
 
+	if (!blkg)
+		return;
+
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
@@ -131,25 +138,6 @@ static void blkg_free_workfn(struct work_struct *work)
 	kfree(blkg);
 }
 
-/**
- * blkg_free - free a blkg
- * @blkg: blkg to free
- *
- * Free @blkg which may be partially allocated.
- */
-static void blkg_free(struct blkcg_gq *blkg)
-{
-	if (!blkg)
-		return;
-
-	/*
-	 * Both ->pd_free_fn() and request queue's release handler may
-	 * sleep, so free us by scheduling one work func
-	 */
-	INIT_WORK(&blkg->free_work, blkg_free_workfn);
-	schedule_work(&blkg->free_work);
-}
-
 static void __blkg_release(struct rcu_head *rcu)
 {
 	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1e94e404eaa80a..f126fe36001eb3 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -75,10 +75,7 @@ struct blkcg_gq {
 
 	spinlock_t			async_bio_lock;
 	struct bio_list			async_bios;
-	union {
-		struct work_struct	async_bio_work;
-		struct work_struct	free_work;
-	};
+	struct work_struct		async_bio_work;
 
 	atomic_t			use_delay;
 	atomic64_t			delay_nsec;
-- 
2.39.0

