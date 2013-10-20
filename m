From: Hong Zhiguo <honkiko@gmail.com>
Subject: [PATCH v4 2/2] blk-throttle: trim tokens generated for an idle tree
Date: Sun, 20 Oct 2013 20:11:12 +0800
Message-ID: <1382271072-15664-3-git-send-email-zhiguohong@tencent.com>
References: <20131018155532.GD2277@redhat.com>
 <1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7076zQOUD9wf2s3g5ZfWt+jhRMwnY6N05s6SK10kUvQ=;
        b=NlcVYft5RLjx1iIwJreBWViN5pmatRM72rFPUMUCCXwPoxX0L9r2gen5o/cUzkeso6
         3Cvsd6aGx6lYqroC8Q1nOQqKjzmXGqRnt2o+OxQwthjIlx9629GOcG5LpYCwAXD9gZXx
         cSHvbYLIfsc6qq+1tbZpLKee6kcocXF/xgej5HSv6HAnguamemujpjEIxlcCAEL44xyq
         rVgtIHFdG0tW4mL9jgjfbxktG3qB6H/zSrKscEIGy2EWya2nLMWJ1QFom1o8xXHN9aao
         wZ9Asgxo5jWjihLus65JggZDgkpfMNNarsE0eknCVKQpAsI7eZZjxYy8ag4UYCns1QIa
         9k3g==
In-Reply-To: <1382271072-15664-1-git-send-email-zhiguohong@tencent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, vgoyal@redhat.com
Cc: cgroups@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

From: Hong Zhiguo <zhiguohong@tencent.com>

Why
====
Pointed out by Vivek: Tokens generated during idle period should
be trimmed. Otherwise a huge bio may be permited immediately.
Overlimit behaviour may be observed during short I/O throughput
test.

Vivek also pointed out: We should not over-trim for hierarchical
groups. Suppose a subtree of groups are idle when a big bio comes.
The token of the child group is trimmed and not enough. So the bio is
queued on the child group. After some jiffies the child group reserved
enough tokens and the bio climbs up. If we trim the parent group at
this time again, this bio will wait too much time than expected.

Analysis
========
When the bio is queued on child group, all it's ancestor groups
becomes non-idle. They should start to reserve tokens for that
bio from this moment. And their reserved tokens before should be
trimmed at this moment.

How
====
service_queue now has a new member nr_queued_tree[2], to represent
the the number of bios waiting on the subtree rooted by this sq.

When a bio is queued on the hierarchy first time, nr_queued_tree
of all ancestors and the child group itself are increased. When a
bio climbs up, nr_queued_tree of the child group is decreased.

When nr_queued_tree turns from zero to one, the tokens reserved
before are trimmed. And after this switch, this group will never
be trimmed to reserve tokens for the bio waiting on it's descendant
group.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
---
 block/blk-throttle.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 45d4d91..d10a5e1 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -63,6 +63,10 @@ struct throtl_service_queue {
 	 */
 	struct list_head	queued[2];	/* throtl_qnode [READ/WRITE] */
 	unsigned int		nr_queued[2];	/* number of queued bios */
+	/*
+	 * number of bios queued on this subtree
+	 */
+	unsigned int		nr_queued_tree[2];
 
 	/*
 	 * RB tree of active children throtl_grp's, which are sorted by
@@ -699,6 +703,11 @@ static void tg_update_token(struct throtl_grp *tg, bool rw)
 	do_div(token, HZ);
 	tg->bytes_token[rw] += token;
 
+	/* trim token if the whole subtree is idle */
+	if (!tg->service_queue.nr_queued_tree[rw] &&
+	    tg->bytes_token[rw] > THROTL_BURST_BYTES)
+		token = THROTL_BURST_BYTES;
+
 	tg->t_c[rw] = jiffies;
 }
 
@@ -843,6 +852,28 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 }
 
 /**
+ * tg_update_nr_queue_tree - update nr_queued_tree of all ancestors
+ * @sq: the target service_queue
+ *
+ * Traverse from @sq to the top throtl_grp, increase their
+ * nr_queued_tree. If one sq has zero nr_queued_tree and now turns to
+ * one, trim the tokens generated before. From now on it will never
+ * get trimmed until same thing happens next time.
+ */
+static void tg_update_nr_queue_tree(struct throtl_service_queue *sq, bool rw)
+{
+	struct throtl_grp *tg;
+
+	while (sq && (tg = sq_to_tg(sq))) {
+		if (!sq->nr_queued_tree[rw])
+			tg_update_token(tg, rw);
+
+		sq->nr_queued_tree[rw]++;
+		sq = sq->parent_sq;
+	}
+}
+
+/**
  * throtl_add_bio_tg - add a bio to the specified throtl_grp
  * @bio: bio to add
  * @qn: qnode to use
@@ -916,6 +947,9 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 	bio = throtl_pop_queued(&sq->queued[rw], &tg_to_put);
 	sq->nr_queued[rw]--;
 
+	/* Here's the only place nr_queued_tree get decreased */
+	sq->nr_queued_tree[rw]--;
+
 	throtl_charge_bio(tg, bio);
 
 	/*
@@ -1375,6 +1409,10 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 
 	bio_associate_current(bio);
 	tg->td->nr_queued[rw]++;
+
+	/* Here's the only place nr_queued_tree get increased */
+	tg_update_nr_queue_tree(sq, rw);
+
 	throtl_add_bio_tg(bio, qn, tg);
 	throttled = true;
 
-- 
1.8.1.2
