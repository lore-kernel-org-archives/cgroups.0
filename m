From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/5] block: add request->io_data_len
Date: Wed,  8 Apr 2020 16:14:47 -0400
Message-ID: <20200408201450.3959560-3-tj@kernel.org>
References: <20200408201450.3959560-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ih5upVjhUxfYMhdnP4A5/T8a9y3p/p63bXQ1Cpw5ptI=;
        b=ahdDMthtvdSscTfVMy/vrgXkEE6ZLB/M6Kqlcr4R1o5OQHWIEAP1lo7TbzBshjqpCi
         ijZq34NRYb1Wu/xEtN7bQcDJNh6Gv/5gE9N3nKqoQdfjvMtx9Gohf9fADM/CRUc3c/CZ
         9rKw14KxaKSEjoftno62YvA0eZ0wBdQOFpRG0QiJgot3SK8khszhzpQKBdBkDxhpXX7u
         pXyrkGGwxgGc35KEFON+hvf2NVTqYgULNGVY6GczJRq/gohaYTmvIkP5/Jn6AD8sm5jA
         UFDc3fRkF6wXTWUq86zn7wMUK4PuykXM3UtoOcF6+Nw2CiBwktkCj78chNE6Gia7VXd3
         2qhw==
In-Reply-To: <20200408201450.3959560-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, at the time of completeion, there's no way of knowing how big a
request was. blk-iocost will need this information to account for IO size when
calculating expected latencies.

This patch adds rq->io_data_len which remembers blk_rq_bytes() at the time the
request gets issued. The field is enabled iff CONFIG_BLK_IO_DATA_LEN is set and
doesn't increase the size of the struct even when enabled.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/Kconfig          | 3 +++
 block/blk-mq.c         | 6 ++++++
 include/linux/blkdev.h | 8 ++++++++
 3 files changed, 17 insertions(+)

diff --git a/block/Kconfig b/block/Kconfig
index 3bc76bb113a0..48308e600dc8 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -26,6 +26,9 @@ menuconfig BLOCK
 
 if BLOCK
 
+config BLK_RQ_IO_DATA_LEN
+	bool
+
 config BLK_RQ_ALLOC_TIME
 	bool
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index f6291ceedee4..64ed22712fe4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -415,6 +415,9 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 		return ERR_PTR(-EWOULDBLOCK);
 
 	rq->__data_len = 0;
+#ifdef CONFIG_BLK_RQ_IO_DATA_LEN
+	rq->io_data_len = 0;
+#endif
 	rq->__sector = (sector_t) -1;
 	rq->bio = rq->biotail = NULL;
 	return rq;
@@ -655,6 +658,9 @@ void blk_mq_start_request(struct request *rq)
 
 	trace_block_rq_issue(q, rq);
 
+#ifdef CONFIG_BLK_RQ_IO_DATA_LEN
+	rq->io_data_len = blk_rq_bytes(rq);
+#endif
 	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
 		rq->io_start_time_ns = ktime_get_ns();
 		rq->stats_sectors = blk_rq_sectors(rq);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32868fbedc9e..bfd34c6a27ef 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -142,6 +142,14 @@ struct request {
 
 	/* the following two fields are internal, NEVER access directly */
 	unsigned int __data_len;	/* total data len */
+#ifdef CONFIG_BLK_RQ_IO_DATA_LEN
+	/*
+	 * Total data len at the time of issue. This doesn't get deducted by
+	 * blk_update_request() and can be used by completion path to determine
+	 * the request size.
+	 */
+	unsigned int io_data_len;
+#endif
 	sector_t __sector;		/* sector cursor */
 
 	struct bio *bio;
-- 
2.25.1

