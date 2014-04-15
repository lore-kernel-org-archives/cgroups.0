From: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] blk-throttle: trim tokens generated for an idle tree
Date: Tue, 15 Apr 2014 15:18:23 +0800
Message-ID: <1397546303-6709-3-git-send-email-zhiguohong@tencent.com>
References: <1397546303-6709-1-git-send-email-zhiguohong@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W5LSdyQ3yd+euJXZhDzE52h9xs/BBPkUDBMu6ExOz0k=;
        b=F90tD9nPQZlQkGNS7pTp3HBi15VqLLQ3i5OArZvNv+ruyizvnZKGWsGNzdRt4RjkmL
         GCPdWWYtEylrqzgTQ3RVp5BMidpKF3L44KC1eVZEOPB8ttL7c28y8sHuzHgDhDyxQ7i4
         u3/UoRqWJxYrvxuhw/jvv609iTyCeg7cVE/ywCxJaJNJdNSAp+3/OWU/Nd8B2bMS6r2w
         s1GLnXu+yC4qeE0pjKKMBZLcBZsFWcRU5+s35n/iAxIbJCR+exvUB347ylJk4uzaF5tF
         ABwq/1GGbnJ9PAEYEIm1CzHdHrlOp+IA1xSEdJlKjrt26P9EnkELXNYoT87LYCchHx6A
         zgWA==
In-Reply-To: <1397546303-6709-1-git-send-email-zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

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

Signed-off-by: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/blk-throttle.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6274734..749e583 100644
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
@@ -708,9 +712,40 @@ static void tg_update_token(struct throtl_grp *tg, bool rw)
 	do_div(token, HZ);
 	tg->bytes_token[rw] += token;
 
+	/* 
+	 * trim token if the whole subtree is idle. 
+	 * trim of io_token[rw] is not necessary since trim it or not 
+	 * dosn't change the result of tg_may_dispatch
+	 */
+	if (!tg->service_queue.nr_queued_tree[rw] &&
+	    tg->bytes_token[rw] > THROTL_BURST_BYTES)
+		token = THROTL_BURST_BYTES;
+
 	tg->t_c[rw] = jiffies;
 }
 
+/**
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
 static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 				  unsigned long *wait)
 {
@@ -925,6 +960,8 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 	 */
 	bio = throtl_pop_queued(&sq->queued[rw], &tg_to_put);
 	sq->nr_queued[rw]--;
+	/* Here's the only place nr_queued_tree get decreased */
+	sq->nr_queued_tree[rw]--;
 
 	throtl_charge_bio(tg, bio);
 
@@ -1374,6 +1411,10 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 
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
