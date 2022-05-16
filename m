From: bh1scw@gmail.com
Subject: [PATCH] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
Date: Tue, 17 May 2022 01:39:30 +0800
Message-ID: <20220516173930.159535-1-bh1scw@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QlC2UOYMPKKudwLjLWBF40eX+oeG8Yvuxzp6LWYy94=;
        b=lN5q6KoGnMVKq8KOjsovYc0Ea9Rz2wCpQaF48i5eMxFhf3pMQhJODDGAvdMNRqWL2n
         1kuhXkOG7R5wJOM/NAWz7J4UIEiIRaBQzILAI5v2Su+zwhL0GL/t0lZWPP9pPWi9X5w1
         TRmLsarTXjfHK8MzG/jFj58z06sJ6O70HdWHKxHpNJMABQaWzn4ySx0XB977Cqy6L+Ms
         68LQaNkjgqCJaydfqryJPKMsb++N4qxHLOKJWhJR9AvA7TVZ0iSC6ytp/1cGqiViasIS
         jDUUNTS1nVh0xyNxGTDlH8awrM/IWxq4zVYrTKv/Qp1yO7yesfSIN0YJWuUzfIiCwqMP
         08PA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Fanjun Kong <bh1scw@gmail.com>

From: Fanjun Kong <bh1scw@gmail.com>

spin_lock_irq/spin_unlock_irq contains preempt_disable/enable().
Which can serve as RCU read-side critical region, so remove
rcu_read_lock/unlock().

Signed-off-by: Fanjun Kong <bh1scw@gmail.com>
---
 block/blk-cgroup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a91f8ae18b49..7bdc16a36560 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1283,14 +1283,13 @@ int blkcg_init_queue(struct request_queue *q)
 	preloaded = !radix_tree_preload(GFP_KERNEL);
 
 	/* Make sure the root blkg exists. */
-	rcu_read_lock();
+	/* spin_lock_irq can serve as RCU read-side critical section. */
 	spin_lock_irq(&q->queue_lock);
 	blkg = blkg_create(&blkcg_root, q, new_blkg);
 	if (IS_ERR(blkg))
 		goto err_unlock;
 	q->root_blkg = blkg;
 	spin_unlock_irq(&q->queue_lock);
-	rcu_read_unlock();
 
 	if (preloaded)
 		radix_tree_preload_end();
@@ -1316,7 +1315,6 @@ int blkcg_init_queue(struct request_queue *q)
 	return ret;
 err_unlock:
 	spin_unlock_irq(&q->queue_lock);
-	rcu_read_unlock();
 	if (preloaded)
 		radix_tree_preload_end();
 	return PTR_ERR(blkg);
-- 
2.36.0

