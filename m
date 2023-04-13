From: chengming.zhou@linux.dev
Subject: [PATCH v2 1/2] blk-stat: fix QUEUE_FLAG_STATS clear
Date: Thu, 13 Apr 2023 14:28:04 +0800
Message-ID: <20230413062805.2081970-1-chengming.zhou@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681367316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=egK6cQcoNaTUC/dkRvlJHjCoro533vXXKI06JsMHHhk=;
        b=OLgzKgqo5RxBuxyyghem3Zr+nBfFIoz4x9MKZJJi9MVi/e3ETG7sXqdslYi9DYw1I1X1nH
        vIKa37IM3boWd8Vmt0udwAuuErkdq+EvP+gwE3dG//cSdwtDfTWQEFrVepocn8VC0wAGXk
        OdeaTC1QfLAE/f+X4ExEbHVfkF7qUsc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: josef@toxicpanda.com, osandov@fb.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>, stable@vger.kernel.org

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

The bug can be reproduced on kernel without BLK_DEV_THROTTLING
(since it unconditionally enable accounting, see the next patch).

  # cat /sys/block/sr0/queue/scheduler
  none mq-deadline [bfq]

  # cat /sys/kernel/debug/block/sr0/state
  SAME_COMP|IO_STAT|INIT_DONE|STATS|REGISTERED|NOWAIT|30

  # echo none > /sys/block/sr0/queue/scheduler

  # cat /sys/kernel/debug/block/sr0/state
  SAME_COMP|IO_STAT|INIT_DONE|REGISTERED|NOWAIT

  # cat /sys/block/sr0/queue/wbt_lat_usec
  75000

We can see that after changing elevator from "bfq" to "none",
"STATS" flag is lost even though WBT callback still need it.

Fixes: 68497092bde9 ("block: make queue stat accounting a reference")
Cc: <stable@vger.kernel.org> # v5.17+
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Tejun Heo <tj@kernel.org>
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

