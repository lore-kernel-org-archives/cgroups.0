From: chengming.zhou@linux.dev
Subject: [PATCH 1/2] blk-stat: fix QUEUE_FLAG_STATS clear
Date: Thu, 13 Apr 2023 00:07:53 +0800
Message-ID: <20230412160754.1981705-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681315714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YI/qDpTMRdMgkTJuLjq2rEZXaIXEU3z1owrkp+3opps=;
        b=ou71pWVf5VT9CbBBk9if3KGgvw/QwtAA4Qyb6AjKM61VVmqQPp3TudZiYdL6I9cZ0krY9u
        Vbv1Oz0VBiydJUZ5MpaYEe5+l3EnwB5Dh6R19Q96tBfvtqQBsT75c2SsTW9cmZsJ5x64VR
        2OYkq5pZE6L72eC6MABobv5TuFFSoaE=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: josef@toxicpanda.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

From: Chengming Zhou <zhouchengming@bytedance.com>

We need to set QUEUE_FLAG_STATS for two cases:
1. blk_stat_enable_accounting()
2. blk_stat_add_callback()

So we should clear it only when ((q->stats->accounting == 0) &&
list_empty(&q->stats->callbacks)).

blk_stat_disable_accounting() only check if q->stats->accounting
is 0 before clear the flag, this patch fix it.

Also add list_empty(&q->stats->callbacks)) check when enable, or
the flag is already set.

Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 block/blk-stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index 74a1a8c32d86..bc7e0ed81642 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -190,7 +190,7 @@ void blk_stat_disable_accounting(struct request_queue *q)
 	unsigned long flags;
 
 	spin_lock_irqsave(&q->stats->lock, flags);
-	if (!--q->stats->accounting)
+	if (!--q->stats->accounting && list_empty(&q->stats->callbacks))
 		blk_queue_flag_clear(QUEUE_FLAG_STATS, q);
 	spin_unlock_irqrestore(&q->stats->lock, flags);
 }
@@ -201,7 +201,7 @@ void blk_stat_enable_accounting(struct request_queue *q)
 	unsigned long flags;
 
 	spin_lock_irqsave(&q->stats->lock, flags);
-	if (!q->stats->accounting++)
+	if (!q->stats->accounting++ && list_empty(&q->stats->callbacks))
 		blk_queue_flag_set(QUEUE_FLAG_STATS, q);
 	spin_unlock_irqrestore(&q->stats->lock, flags);
 }
-- 
2.39.2

