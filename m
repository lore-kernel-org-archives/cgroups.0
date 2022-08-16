From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 2/3] block, bfq: remove useless checking in bfq_put_queue()
Date: Tue, 16 Aug 2022 09:56:30 +0800
Message-ID: <20220816015631.1323948-3-yukuai1@huaweicloud.com>
References: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

'bfqq->bfqd' is ensured to set in bfq_init_queue(), and it will never
change afterwards.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index c740b41fe0a4..f39067389b2b 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5255,9 +5255,7 @@ void bfq_put_queue(struct bfq_queue *bfqq)
 	struct hlist_node *n;
 	struct bfq_group *bfqg = bfqq_group(bfqq);
 
-	if (bfqq->bfqd)
-		bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d",
-			     bfqq, bfqq->ref);
+	bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d", bfqq, bfqq->ref);
 
 	bfqq->ref--;
 	if (bfqq->ref)
@@ -5321,7 +5319,7 @@ void bfq_put_queue(struct bfq_queue *bfqq)
 		hlist_del_init(&item->woken_list_node);
 	}
 
-	if (bfqq->bfqd && bfqq->bfqd->last_completed_rq_bfqq == bfqq)
+	if (bfqq->bfqd->last_completed_rq_bfqq == bfqq)
 		bfqq->bfqd->last_completed_rq_bfqq = NULL;
 
 	kmem_cache_free(bfq_pool, bfqq);
-- 
2.31.1

