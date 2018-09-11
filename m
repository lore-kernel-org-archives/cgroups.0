From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 10/12] blkcg: cleanup and make blk_get_rl use blkg_lookup_create
Date: Tue, 11 Sep 2018 14:41:35 -0400
Message-ID: <20180911184137.35897-11-dennisszhou@gmail.com>
References: <20180911184137.35897-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r2kxmE2i/F4zOX3cOoXMsnwx5/PIHFb0myqGCKQDXp8=;
        b=tZuNmPTwD++oiilT/SKFfVULg1rxGXW6srQaCTr04qW0cVciRTV5lzHvQurnUDbR9S
         llwwaZ1SwqS6vKH/uRmSlH+ITvlRmRVjgvIK57VjYCvS8b5HS4M/6ez7ixHpkvVuoQ5y
         CJjmws4EfPwseBRRXBGqXFU3FnbcBww8pTN+3YvfM2aeItvfjYt2aq6QyLGrL5IuoKa7
         666KDlW9aPbob9Pg6IqOb++VDEbZAcpdbLU4j/bHtqmN67tU9kfKhaicyqjPmD5Dzmq3
         w86C42pzxSPdb3S26HRTyORjWXRc46Wd87zC33NFnnJ7zNoRl0yJrvedYk9PloZQ0/0g
         ygxw==
In-Reply-To: <20180911184137.35897-1-dennisszhou@gmail.com>
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
Acked-by: Tejun Heo <tj@kernel.org>
---
 include/linux/blk-cgroup.h | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 2951ea3541b1..d2f7f1b00fcf 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -586,28 +586,36 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
 
 	rcu_read_lock();
 
-	blkcg = bio_blkcg(bio);
-	if (!blkcg)
-		blkcg = css_to_blkcg(blkcg_css());
+	if (bio && bio->bi_blkg) {
+		blkcg = bio->bi_blkg->blkcg;
+		if (blkcg == &blkcg_root)
+			goto rl_use_root;
+
+		blkg_get(bio->bi_blkg);
+		rcu_read_unlock();
+		return &bio->bi_blkg->rl;
+	}
 
-	/* bypass blkg lookup and use @q->root_rl directly for root */
+	blkcg = css_to_blkcg(blkcg_css());
 	if (blkcg == &blkcg_root)
-		goto root_rl;
+		goto rl_use_root;
 
-	/*
-	 * Try to use blkg->rl.  blkg lookup may fail under memory pressure
-	 * or if either the blkcg or queue is going away.  Fall back to
-	 * root_rl in such cases.
-	 */
 	blkg = blkg_lookup(blkcg, q);
 	if (unlikely(!blkg))
-		goto root_rl;
+		blkg = __blkg_lookup_create(blkcg, q);
 
 	if (!blkg_try_get(blkg))
-		goto root_rl;
+		goto rl_use_root;
+
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

