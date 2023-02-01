From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 03/19] blk-cgroup: improve error unwinding in blkg_alloc
Date: Wed,  1 Feb 2023 14:41:07 +0100
Message-ID: <20230201134123.2656505-4-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mVU0LSbQrgY0kTXJqE3yzR4ugX07Xq7vcZHfeKk7dSk=; b=WgprGuRYz9uBkccKCNEFGM5hpF
        LFxBjBmW/HNeCIi1IH0BgHyVHGCmGMGHlef3BCNYKgG68AFkMTD1DJyIvm+LY3nfBny1990//qjmE
        jZWYFVQcsNu6yppLSEV8QB22wIwjyniCY6bqXaK4JOoGHjgQsldUMRQO2QOe5wHdLmcg2ldbSyCUe
        VS3Wylgv2nI+XvEHpW8/cikMLS6Os+JNVnXjnPfAEaadKCTKh8mDn2pFw4r6rD8EeG8IL5OWd0ENK
        8qjtHzCkg++FNdKVGnJ/nT2OJArw687KctRJxTkQ0Re9tXU2oCrxtmCgr+0Tv+e0Bok/qGrP0xWcY
        D9F/Nl/Q==;
In-Reply-To: <20230201134123.2656505-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Unwind only the previous initialization steps that happened in blkg_alloc
using goto based unwinding.  This avoids the need for the !queue special
case in blkg_free.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-cgroup.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cb110fc51940aa..9df02a6d04d35a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -128,22 +128,16 @@ static void blkg_free_workfn(struct work_struct *work)
 	 * blkcg_mutex is used to synchronize blkg_free_workfn() and
 	 * blkcg_deactivate_policy().
 	 */
-	if (q)
-		mutex_lock(&q->blkcg_mutex);
-
+	mutex_lock(&q->blkcg_mutex);
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
-
 	if (blkg->parent)
 		blkg_put(blkg->parent);
+	list_del_init(&blkg->q_node);
+	mutex_unlock(&q->blkcg_mutex);
 
-	if (q) {
-		list_del_init(&blkg->q_node);
-		mutex_unlock(&q->blkcg_mutex);
-		blk_put_queue(q);
-	}
-
+	blk_put_queue(q);
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -265,16 +259,13 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 	blkg = kzalloc_node(sizeof(*blkg), gfp_mask, disk->queue->node);
 	if (!blkg)
 		return NULL;
-
 	if (percpu_ref_init(&blkg->refcnt, blkg_release, 0, gfp_mask))
-		goto err_free;
-
+		goto out_free_blkg;
 	blkg->iostat_cpu = alloc_percpu_gfp(struct blkg_iostat_set, gfp_mask);
 	if (!blkg->iostat_cpu)
-		goto err_free;
-
+		goto out_exit_refcnt;
 	if (!blk_get_queue(disk->queue))
-		goto err_free;
+		goto out_free_iostat;
 
 	blkg->q = disk->queue;
 	INIT_LIST_HEAD(&blkg->q_node);
@@ -299,8 +290,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 		/* alloc per-policy data and attach it to blkg */
 		pd = pol->pd_alloc_fn(gfp_mask, disk->queue, blkcg);
 		if (!pd)
-			goto err_free;
-
+			goto out_free_pds;
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
 		pd->plid = i;
@@ -309,8 +299,17 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 
 	return blkg;
 
-err_free:
-	blkg_free(blkg);
+out_free_pds:
+	while (--i >= 0)
+		if (blkg->pd[i])
+			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
+	blk_put_queue(disk->queue);
+out_free_iostat:
+	free_percpu(blkg->iostat_cpu);
+out_exit_refcnt:
+	percpu_ref_exit(&blkg->refcnt);
+out_free_blkg:
+	kfree(blkg);
 	return NULL;
 }
 
-- 
2.39.0

