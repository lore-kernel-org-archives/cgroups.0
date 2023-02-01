From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/19] blk-cgroup: simplify blkg freeing from initialization failure paths
Date: Wed,  1 Feb 2023 14:41:08 +0100
Message-ID: <20230201134123.2656505-5-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=+O0wtgs0ywxcDMDObI1WZ1tnT52fphswe/ZBKd2lIUI=; b=x+5V9DI/d139HgFUaY/ZK0bw2G
        EBpn1hLi3lbdkgYPr2lTKPgPbBx9EsQ5jnMvbobyiStvTXjJl44XFZR2x+s4FEtkPm60exsAA2ojR
        yzgbVEXBNZauWZ4yyuz8euQ9kx4z8jROO4YWAah0xRH6i72iZkS1j4MamES6IRpF2OPkfYYT9+Ha7
        iMkg1arLPU4Eh++NWP/tCKviWGCsOWLiUVWE5tL6Fv9CbSRbfxIrZdLAzGQpSJcSP0ei2qvoZuHuS
        g9YvW2sE61UEcPFTJsj6alS46iFZ/8fEwg5xBBmjpRXPMI7zCCKC+D1oftGRqjfDe1SMnNIgdfkR3
        DxaFicuA==;
In-Reply-To: <20230201134123.2656505-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

There is no need to delay freeing a blkg to a workqueue when freeing it
after an initialization failure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

