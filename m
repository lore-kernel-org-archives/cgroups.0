From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 12/15] blkcg: cleanup and make blk_get_rl use blkg_lookup_create
Date: Thu, 30 Aug 2018 21:53:53 -0400
Message-ID: <20180831015356.69796-13-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ru9Qz6kW5Z2dkilYGK5da+gwQEIQ16H8/tvKmMoSEbM=;
        b=MHpSs+I62J6Op19vonhV08rs6EraCMW+KPzHndWzozzK76abz4lzjc/WGwXFdpTHH8
         nuo09GdHXH0dPbv9LeZ6i8jw1JdQ9//Yiq2a//47vuYatMTH7h+9eNnGPe/ndIDzNr5U
         QLR6Fbc62U/8y7Dal2RLbFPo1L3Oe+hdxqTxzMyyLCuyKZ8rQeL4un9MJPDm2zrNVC6j
         OPSJ1ZWOPJHIn2eI54bvyKGbRrOIxnmT7QNTJrXGiv4WxGK7Tp4MX2NwcotIgVxUgdFp
         rOEXYedjby9j10x5oYVhFPex9sQ0f1U5Adw9E235V6fLRSbIdud+B7uZWeQ8jpL3NsbX
         kw9A==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

blk_get_rl is responsible for identifying which request_list a request
should be allocated to. Try get logic was added earlier, but
semantically the logic was not changed.

This patch makes better use of the bio already having a reference to the
blkg in the hot path. The cold path uses a better fallback of
blkg_lookup_create rather than just blkg_lookup and then falling back to
the q->root_rl. If lookup_create fails with anything but -ENODEV, it
falls back to q->root_rl.

A clarifying comment is added to explain why q->root_rl is used rather
than the root blkg's rl.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
---
 include/linux/blk-cgroup.h | 53 ++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 3eed491e4daa..97cb82029b18 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -537,28 +537,49 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
 
 	rcu_read_lock();
 
-	blkcg = bio_blkcg(bio);
-	if (!blkcg)
+	blkg = bio->bi_blkg;
+	if (blkg) {
+		blkcg = bio->bi_blkg->blkcg;
+		if (blkcg == &blkcg_root)
+			goto rl_use_root;
+
+		blkg_get(blkg);
+		return &blkg->rl;
+	}
+
+	while (true) {
 		blkcg = css_to_blkcg(blkcg_css());
+		if (blkcg == &blkcg_root)
+			goto rl_use_root;
 
-	/* bypass blkg lookup and use @q->root_rl directly for root */
-	if (blkcg == &blkcg_root)
-		goto root_rl;
+		blkg = blkg_lookup(blkcg, q);
 
-	/*
-	 * Try to use blkg->rl.  blkg lookup may fail under memory pressure
-	 * or if either the blkcg or queue is going away.  Fall back to
-	 * root_rl in such cases.
-	 */
-	blkg = blkg_lookup(blkcg, q);
-	if (unlikely(!blkg))
-		goto root_rl;
+		if (unlikely(!blkg))
+			blkg = __blkg_lookup_create(blkcg, q);
+
+		if (IS_ERR(blkg)) {
+			if (PTR_ERR(blkg) == -ENODEV) {
+				cpu_relax();
+				continue;
+			} else {
+				goto rl_use_root;
+			}
+		}
+
+		if (blkg_try_get(blkg))
+			break;
+		cpu_relax();
+	}
 
-	if (!blkg_try_get(blkg))
-		goto root_rl;
 	rcu_read_unlock();
 	return &blkg->rl;
-root_rl:
+
+	/*
+	 * Each blkg has its own request_list, however, the root blkcg
+	 * uses the request_queue's root_rl.  This is to avoid most
+	 * overhead for the root blkcg.
+	 */
+rl_use_root:
 	rcu_read_unlock();
 	return &q->root_rl;
 }
-- 
2.17.1

