From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/27] blk-stat: make q->stats->lock irqsafe
Date: Tue,  1 Sep 2020 14:52:32 -0400
Message-ID: <20200901185257.645114-3-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uLHwGiWfWkP5kcHSnqjONlJj/O0Qbx60l9TYb+oGkco=;
        b=B3K+LIBrV807PBKY6u2wypELmyggq3KtY8cxZwTKZ8RQA/n1e71fVHCy4sRQklcUtr
         CREI/4x1mQ+mcdi46kL6S9vLmtbUlnz9bBxhQWCYyCv2fc8NYLI9HGzXRFS12nQnr/7r
         ClhF+3BwIXFLZqWPw7pfXSiCSun3gZx/vd+gKCAmgcbETNSruJmVVwEXokDYSM3piiJU
         Kl96VzKmr+GcZYj7+ZLR+PoPVmd0WtAM4O/uxMk5okGAOPNdjr14YsIo2gBwdDgqKjIQ
         2rly3BSMOKkL/pVu0MvnbEvXy4n1PpK9mIplhN1bpK56tpdiUGmth5nbGN49e2UaWbtV
         H2aA==
In-Reply-To: <20200901185257.645114-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

blk-iocost calls blk_stat_enable_accounting() while holding an irqsafe lock
which triggers a lockdep splat because q->stats->lock isn't irqsafe. Let's
make it irqsafe.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: cd006509b0a9 ("blk-iocost: account for IO size when testing latencies")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # v5.8+
---
 block/blk-stat.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index 7da302ff88d0..ae3dd1fb8e61 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -137,6 +137,7 @@ void blk_stat_add_callback(struct request_queue *q,
 			   struct blk_stat_callback *cb)
 {
 	unsigned int bucket;
+	unsigned long flags;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -147,20 +148,22 @@ void blk_stat_add_callback(struct request_queue *q,
 			blk_rq_stat_init(&cpu_stat[bucket]);
 	}
 
-	spin_lock(&q->stats->lock);
+	spin_lock_irqsave(&q->stats->lock, flags);
 	list_add_tail_rcu(&cb->list, &q->stats->callbacks);
 	blk_queue_flag_set(QUEUE_FLAG_STATS, q);
-	spin_unlock(&q->stats->lock);
+	spin_unlock_irqrestore(&q->stats->lock, flags);
 }
 
 void blk_stat_remove_callback(struct request_queue *q,
 			      struct blk_stat_callback *cb)
 {
-	spin_lock(&q->stats->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->stats->lock, flags);
 	list_del_rcu(&cb->list);
 	if (list_empty(&q->stats->callbacks) && !q->stats->enable_accounting)
 		blk_queue_flag_clear(QUEUE_FLAG_STATS, q);
-	spin_unlock(&q->stats->lock);
+	spin_unlock_irqrestore(&q->stats->lock, flags);
 
 	del_timer_sync(&cb->timer);
 }
@@ -183,10 +186,12 @@ void blk_stat_free_callback(struct blk_stat_callback *cb)
 
 void blk_stat_enable_accounting(struct request_queue *q)
 {
-	spin_lock(&q->stats->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->stats->lock, flags);
 	q->stats->enable_accounting = true;
 	blk_queue_flag_set(QUEUE_FLAG_STATS, q);
-	spin_unlock(&q->stats->lock);
+	spin_unlock_irqrestore(&q->stats->lock, flags);
 }
 EXPORT_SYMBOL_GPL(blk_stat_enable_accounting);
 
-- 
2.26.2

