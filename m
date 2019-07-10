From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] blk-mq: add optional request->pre_start_time_ns
Date: Wed, 10 Jul 2019 13:51:25 -0700
Message-ID: <20190710205128.1316483-8-tj@kernel.org>
References: <20190710205128.1316483-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ScBcM61apkDk75/JsLl96sQtCEBUZUTLoTR5gwJBrN4=;
        b=qu/qvFUa5a8xG+LW40FVIKkdlqaczOHb92BUNg5qhnyc6vFWRuRyZj96v2W7vq3bPn
         MUAP3zq/OfR+wSUvUlYV4XAyNAUZKe95X83FPC/Vj8wWx7Boj5mv//8guJxClICPyezb
         /NOZim8SpoGvf/liW3fkVdjORdQZlq7Cu9bekmdVk9cClYISxS/ekXfwbR7VhXVfJZeY
         kTRd/qjVk/HIQxse5qHZpcquQnT18HefCe09ADi/HQPGPlSwGrusXuIB2E84bNungyCu
         nWmfzJdjzz9WOHVshYw6hU6J5HObnqJ0lP4kcB/xQXDlv++TdXl0rhDIbCjh94dHgzsS
         w5og==
In-Reply-To: <20190710205128.1316483-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

There are currently two start time timestamps - start_time_ns and
io_start_time_ns.  The former marks the request allocation and and the
second issue-to-device time.  The planned io.weight controller needs
to measure the total time bios take to execute after it leaves rq_qos
including the time spent waiting for request to become available,
which can easily dominate on saturated devices.

This patch adds request->pre_start_time_ns which records when the
request allocation attempt started.  As it isn't used for the usual
stats, make it optional behind QUEUE_FLAG_REC_PRESTART.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-mq.c         | 11 +++++++++--
 include/linux/blkdev.h |  7 ++++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e5ef40c603ca..90b46988cc02 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -291,7 +291,7 @@ static inline bool blk_mq_need_time_stamp(struct request *rq)
 }
 
 static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
-		unsigned int tag, unsigned int op)
+		unsigned int tag, unsigned int op, u64 pre_start_time_ns)
 {
 	struct blk_mq_tags *tags = blk_mq_tags_from_data(data);
 	struct request *rq = tags->static_rqs[tag];
@@ -325,6 +325,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->rq_disk = NULL;
 	rq->part = NULL;
+	rq->pre_start_time_ns = pre_start_time_ns;
 	if (blk_mq_need_time_stamp(rq))
 		rq->start_time_ns = ktime_get_ns();
 	else
@@ -356,8 +357,14 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 	struct request *rq;
 	unsigned int tag;
 	bool clear_ctx_on_error = false;
+	u64 pre_start_time_ns = 0;
 
 	blk_queue_enter_live(q);
+
+	/* pre_start_time includes depth and tag waits */
+	if (blk_queue_rec_prestart(q))
+		pre_start_time_ns = ktime_get_ns();
+
 	data->q = q;
 	if (likely(!data->ctx)) {
 		data->ctx = blk_mq_get_ctx(q);
@@ -393,7 +400,7 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 		return NULL;
 	}
 
-	rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags);
+	rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags, pre_start_time_ns);
 	if (!op_is_flush(data->cmd_flags)) {
 		rq->elv.icq = NULL;
 		if (e && e->type->ops.prepare_request) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 259bd7ad8312..4247a9bc44b7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -194,7 +194,9 @@ struct request {
 
 	struct gendisk *rq_disk;
 	struct hd_struct *part;
-	/* Time that I/O was submitted to the kernel. */
+	/* Time that the first bio started allocating this request. */
+	u64 pre_start_time_ns;
+	/* Time that this request was allocated for this IO. */
 	u64 start_time_ns;
 	/* Time that I/O was submitted to the device. */
 	u64 io_start_time_ns;
@@ -606,6 +608,7 @@ struct request_queue {
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 23	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED	24	/* queue has been quiesced */
 #define QUEUE_FLAG_PCI_P2PDMA	25	/* device supports PCI p2p requests */
+#define QUEUE_FLAG_REC_PRESTART	26	/* record pre_start_time_ns */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP))
@@ -632,6 +635,8 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 	test_bit(QUEUE_FLAG_SCSI_PASSTHROUGH, &(q)->queue_flags)
 #define blk_queue_pci_p2pdma(q)	\
 	test_bit(QUEUE_FLAG_PCI_P2PDMA, &(q)->queue_flags)
+#define blk_queue_rec_prestart(q)	\
+	test_bit(QUEUE_FLAG_REC_PRESTART, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
2.17.1

