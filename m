From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v5] blk-throtl: Introduce sync and async queues for blk-throtl
Date: Thu, 12 Jan 2023 00:20:30 +0800
Message-ID: <20230111162030.31094-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kVHAo3awTuH7uv2ocQzd8egYHAsLyd2VFmRrNVFOoFA=;
        b=fF8uzf8SQN53af2PoAITNN4OpUocVwqq70mltC9Gj9NXF8FAz3lqBofDb0iuhkX2hK
         IBXmLS8qLPX5vJ/Qh/j7gRFlW7eUNRM7fIgV3HUSZpPCyG78ZyiXMadYQW+W9fc2QS+w
         oPLX4oYy89PYaiptxoLMn0bjnDF35ioBEYvo9SzmJYn8gm+OFv5ngOxj9XpsYFaMTvUy
         KoWL5x5GDSZZJbo5xYNeOCj0zd43CcpOpo2XhLc9G1VrBfaL0CJAxJgaucPQ5Vf+M9Zv
         UdVCcJSAcdRj5ii8WkJoyrpX38PJ/oHXDk0Q+256EucG/3N1QuHeRdqA3LSwVtvIQ7hf
         dD2Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Now we don't distinguish sync write ios from normal buffer write ios
in blk-throtl. A bio with REQ_SYNC tagged always mean it will be wait
until write completion soon after it submit. So it's reasonable for sync
io to complete as soon as possible.

In our test, fio writes a 100g file in sequential 4k blocksize in
a container with low bps limit configured (wbps=10M). More than 1200
ios were throttled in blk-throtl queue and the avarage throtle time
of each io is 140s. At the same time, the operation of saving a small
file by vim will be blocked amolst 140s. As a fsync will be send by vim,
the sync ios of fsync will be blocked by a huge amount of buffer write
ios ahead. This is also a priority inversion problem within one cgroup.
In the database scene, things got really bad with blk-throtle enabled
as fsync is called very often.

This patch splits bio queue into sync and async queues for blk-throtl
and gives a huge priority to sync write ios. Sync queue only make sense
for write ios as we treat all read io as sync io. I think it's a nice
respond to the semantics of REQ_SYNC. Bios with REQ_META and REQ_PRIO
gains the same priority as they are important to fs. This may avoid
some potential priority inversion problems.

With this patch, do the same test above, the duration of the fsync sent
by vim drops to several hundreds of milliseconds.

Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Signed-off-by: Xin Yin <yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---

Changes in v2
- Make code more simple.
Changes in v3
- Fix mismatch of waiting bio and the next dispatched bio.
- Rename dispatch_sync_cnt to disp_sync_cnt.
- Add more comments.
Changes in v4
- Improve patch in code style and code comments.
Changes in v5
- Add more comments for next_to_disp.

 block/blk-throttle.c | 150 ++++++++++++++++++++++++++++++++++++++++---
 block/blk-throttle.h |  13 +++-
 2 files changed, 154 insertions(+), 9 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6fb5a2f9e1ee..7f519eafa546 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -21,6 +21,13 @@
 /* Total max dispatch from all groups in one round */
 #define THROTL_QUANTUM 32
 
+/* For write ios, dispatch 4 sync ios and 1 normal io in one loop */
+#define THROTL_SYNC_FACTOR 4
+
+/* Only make sense for write ios, all read ios are treated as SYNC */
+#define SYNC	0
+#define ASYNC	1
+
 /* Throttling is performed over a slice and after that slice is renewed */
 #define DFL_THROTL_SLICE_HD (HZ / 10)
 #define DFL_THROTL_SLICE_SSD (HZ / 50)
@@ -241,11 +248,30 @@ static inline unsigned int throtl_bio_data_size(struct bio *bio)
 	return bio->bi_iter.bi_size;
 }
 
-static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg)
+static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg,
+			      bool rw)
 {
 	INIT_LIST_HEAD(&qn->node);
-	bio_list_init(&qn->bios);
+	bio_list_init(&qn->bios[SYNC]);
+	bio_list_init(&qn->bios[ASYNC]);
 	qn->tg = tg;
+	qn->disp_sync_cnt = rw == READ ? UINT_MAX : 0;
+	qn->next_to_disp = NULL;
+}
+
+static inline void throtl_qnode_add_bio_list(struct throtl_qnode *qn,
+					     struct bio *bio)
+{
+	bool rw = bio_data_dir(bio);
+
+	/*
+	 * All read bios and those write bios with REQ_SYNC, REQ_META or
+	 * REQ_PRIO flags set are treated as SYNC io.
+	 */
+	if (rw == READ || bio->bi_opf & (REQ_SYNC | REQ_META | REQ_PRIO))
+		bio_list_add(&qn->bios[SYNC], bio);
+	else
+		bio_list_add(&qn->bios[ASYNC], bio);
 }
 
 /**
@@ -261,13 +287,90 @@ static void throtl_qnode_init(struct throtl_qnode *qn, struct throtl_grp *tg)
 static void throtl_qnode_add_bio(struct bio *bio, struct throtl_qnode *qn,
 				 struct list_head *queued)
 {
-	bio_list_add(&qn->bios, bio);
+	throtl_qnode_add_bio_list(qn, bio);
 	if (list_empty(&qn->node)) {
 		list_add_tail(&qn->node, queued);
 		blkg_get(tg_to_blkg(qn->tg));
 	}
 }
 
+/**
+ * throtl_qnode_bio_list_pop: pop a bio from sync/async queue
+ * @qn: the qnode to pop a bio from
+ *
+ * For writes, target SYNC or ASYNC queue based on disp_sync_cnt. If empty,
+ * try the other queue.
+ */
+static struct bio *throtl_qnode_bio_list_pop(struct throtl_qnode *qn)
+{
+	struct bio *bio;
+	int from = qn->disp_sync_cnt == THROTL_SYNC_FACTOR ? ASYNC : SYNC;
+
+	bio = bio_list_pop(&qn->bios[from]);
+	if (!bio) {
+		from = 1 - from;
+		bio = bio_list_pop(&qn->bios[from]);
+	}
+
+	if (qn->disp_sync_cnt < THROTL_SYNC_FACTOR && from == SYNC)
+		qn->disp_sync_cnt++;
+	else
+		qn->disp_sync_cnt = 0;
+
+	return bio;
+}
+
+/**
+ * throtl_qnode_bio_peek - peek a bio from a qn
+ * @qn: the qnode to peek from
+ *
+ * For read, always peek bio from the SYNC queue.
+ *
+ * For write, we always peek bio from next_to_disp. If it's NULL, a bio
+ * will be popped from SYNC or ASYNC queue to fill it. The next_to_disp
+ * is used to make sure that the peeked bio and the next popped bio are
+ * always the same even in case that the spinlock of queue was released
+ * and re-holded.
+ *
+ * Without the next_to_disp, consider the following situation:
+ *
+ * Assumed that there are only bios queued in ASYNC queue and the SYNC
+ * queue is empty and all ASYNC bios are 1M in size and the bps limit is
+ * 1M/s. The throtl_slice is 100ms. The current slice is [jiffies1,
+ * jiffies1+100] and the bytes_disp[w] is 0.
+ *
+ * The disp_sync_cnt is 0 as it was set 0 after each dispatching of a
+ * ASYNC bio. A ASYNC bio wil be peeked to check in tg_may_dispatch.
+ * Obviously, it can't be dispatched in current slice and the wait time
+ * is 900ms. The slice will be extended to [jiffies1, jiffies1+1000] in
+ * tg_may_dispatch. The spinlock of the queue will be released after the
+ * process of dispatch giving up. A 4k size SYNC bio was queued in and
+ * the SYNC queue becomes no-empty. After 900ms, it's time to dispatch
+ * the tg, the SYNC bio will be popped to dispatched as the disp_sync_cnt
+ * is 0 and the SYNC queue is no-empty. The slice will be extended to
+ * [jiffies1, jiffies1+1100] in tg_may_dispatch. Then the slice will be
+ * trimed to [jiffies1+1000, jiffies1+1100] after the SYNC bio was
+ * dispatched. Then the former 1M size ASYNC bio will be peeked to be
+ * checked and still can't be dispatched because of overlimit within
+ * the current slice. The same thing may happen DISPACH_SYNC_FACTOR times
+ * if always there is a SYNC bio be queued in the SYNC queue when the
+ * ASYNC bio is waiting. This means that in nearly 5s, we have dispathed
+ * four 4k SYNC bios and one  1M ASYNC bio. It is hard to fill up the
+ * bandwidth considering that the bps limit is 1M/s.
+ */
+static inline struct bio *throtl_qnode_bio_peek(struct throtl_qnode *qn)
+{
+	/* qn for read ios */
+	if (qn->disp_sync_cnt == UINT_MAX)
+		return bio_list_peek(&qn->bios[SYNC]);
+
+	/* qn for write ios */
+	if (!qn->next_to_disp)
+		qn->next_to_disp  = throtl_qnode_bio_list_pop(qn);
+
+	return qn->next_to_disp;
+}
+
 /**
  * throtl_peek_queued - peek the first bio on a qnode list
  * @queued: the qnode list to peek
@@ -281,11 +384,42 @@ static struct bio *throtl_peek_queued(struct list_head *queued)
 		return NULL;
 
 	qn = list_first_entry(queued, struct throtl_qnode, node);
-	bio = bio_list_peek(&qn->bios);
+	bio = throtl_qnode_bio_peek(qn);
 	WARN_ON_ONCE(!bio);
 	return bio;
 }
 
+/**
+ * throtl_qnode_bio_pop: pop a bio from a qnode
+ * @qn: the qnode to pop a bio from
+ */
+static inline struct bio *throtl_qnode_bio_pop(struct throtl_qnode *qn)
+{
+	struct bio *bio;
+
+	/* qn for read ios */
+	if (qn->disp_sync_cnt == UINT_MAX)
+		return bio_list_pop(&qn->bios[SYNC]);
+
+	/* qn for write ios */
+	if (qn->next_to_disp) {
+		bio = qn->next_to_disp;
+		qn->next_to_disp = NULL;
+		return bio;
+	}
+
+	return throtl_qnode_bio_list_pop(qn);
+}
+
+static inline bool throtl_qnode_empty(struct throtl_qnode *qn)
+{
+	if (!qn->next_to_disp &&
+	    bio_list_empty(&qn->bios[SYNC]) &&
+			   bio_list_empty(&qn->bios[ASYNC]))
+		return true;
+	return false;
+}
+
 /**
  * throtl_pop_queued - pop the first bio form a qnode list
  * @queued: the qnode list to pop a bio from
@@ -310,10 +444,10 @@ static struct bio *throtl_pop_queued(struct list_head *queued,
 		return NULL;
 
 	qn = list_first_entry(queued, struct throtl_qnode, node);
-	bio = bio_list_pop(&qn->bios);
+	bio = throtl_qnode_bio_pop(qn);
 	WARN_ON_ONCE(!bio);
 
-	if (bio_list_empty(&qn->bios)) {
+	if (throtl_qnode_empty(qn)) {
 		list_del_init(&qn->node);
 		if (tg_to_put)
 			*tg_to_put = qn->tg;
@@ -355,8 +489,8 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp,
 	throtl_service_queue_init(&tg->service_queue);
 
 	for (rw = READ; rw <= WRITE; rw++) {
-		throtl_qnode_init(&tg->qnode_on_self[rw], tg);
-		throtl_qnode_init(&tg->qnode_on_parent[rw], tg);
+		throtl_qnode_init(&tg->qnode_on_self[rw], tg, rw);
+		throtl_qnode_init(&tg->qnode_on_parent[rw], tg, rw);
 	}
 
 	RB_CLEAR_NODE(&tg->rb_node);
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index ef4b7a4de987..bd4fff65b6d9 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -28,8 +28,19 @@
  */
 struct throtl_qnode {
 	struct list_head	node;		/* service_queue->queued[] */
-	struct bio_list		bios;		/* queued bios */
+	struct bio_list		bios[2];	/* queued bios */
 	struct throtl_grp	*tg;		/* tg this qnode belongs to */
+
+	struct bio		*next_to_disp;	/* pinned for next to dispatch */
+	/*
+	 * 1) for write throtl_qnode:
+	 * [0, THROTL_SYNC_FACTOR-1]: dispatch sync io
+	 * [THROTL_SYNC_FACTOR]: dispatch async io
+	 *
+	 * 2) for read throtl_qnode:
+	 * UINT_MAX
+	 */
+	unsigned int disp_sync_cnt;         /* sync io dispatch counter */
 };
 
 struct throtl_service_queue {
-- 
2.20.1

