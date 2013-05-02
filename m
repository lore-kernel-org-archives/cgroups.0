From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/31] blk-throttle: rename throtl_rb_root to throtl_service_queue
Date: Wed,  1 May 2013 17:39:29 -0700
Message-ID: <1367455189-6957-12-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=dru3464WyN/EmhkKP14CP+9TjIyKtvYw44IOLqUd+R4=;
        b=BbN/vNnhKvraFvGESCGu5zvfPTNgTLoiNZax6stJRLQVe1TIQ+24yk06QDtq/rP77l
         7u+j98EvSnsaoOUE8x1JzKCdVFVd8vr9YE7wD8sHvil5pV1z7YlVaXSRCRZ05E+CmcoM
         ioTJ/oDvkg1JcT3QcvERLYj34hmHOIJw0nRwLc2UaaQJZD4eM8gzYldESYCLh3r3ivSu
         juyALquy+Wfe43JV0wt8rsSMqAr/p/+RVpMoBsyWbhL7jKF+UP6MJzrcLSRnB1VdeDGE
         P0j+HLgKQE5WjrRqvDdGbMnmUU70/ZNBMuXCG9PhgeP9NetUCnjeFi+NAtNmN9/m1rzw
         PuRA==
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

throtl_rb_root will be expanded to cover more roles for hierarchy
support.  Rename it to throtl_service_queue and make its fields more
descriptive.

* rb		-> pending_tree
* left		-> first_pending
* count		-> nr_pending
* min_disptime	-> first_pending_disptime

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org
---
 block/blk-throttle.c | 84 ++++++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6fd08a4..6723ca2 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -26,15 +26,15 @@ static struct blkcg_policy blkcg_policy_throtl;
 /* A workqueue to queue throttle related work */
 static struct workqueue_struct *kthrotld_workqueue;
 
-struct throtl_rb_root {
-	struct rb_root rb;
-	struct rb_node *left;
-	unsigned int count;
-	unsigned long min_disptime;
+struct throtl_service_queue {
+	struct rb_root		pending_tree;	/* RB tree of active tgs */
+	struct rb_node		*first_pending;	/* first node in the tree */
+	unsigned int		nr_pending;	/* # queued in the tree */
+	unsigned long		first_pending_disptime;	/* disptime of the first tg */
 };
 
-#define THROTL_RB_ROOT	(struct throtl_rb_root) { .rb = RB_ROOT, .left = NULL, \
-			.count = 0, .min_disptime = 0}
+#define THROTL_SERVICE_QUEUE_INITIALIZER				\
+	(struct throtl_service_queue){ .pending_tree = RB_ROOT }
 
 #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
 
@@ -50,7 +50,7 @@ struct throtl_grp {
 	/* must be the first member */
 	struct blkg_policy_data pd;
 
-	/* active throtl group service_tree member */
+	/* active throtl group service_queue member */
 	struct rb_node rb_node;
 
 	/*
@@ -93,7 +93,7 @@ struct throtl_grp {
 struct throtl_data
 {
 	/* service tree for active throtl groups */
-	struct throtl_rb_root tg_service_tree;
+	struct throtl_service_queue service_queue;
 
 	struct request_queue *queue;
 
@@ -296,17 +296,17 @@ static struct throtl_grp *throtl_lookup_create_tg(struct throtl_data *td,
 	return tg;
 }
 
-static struct throtl_grp *throtl_rb_first(struct throtl_rb_root *root)
+static struct throtl_grp *throtl_rb_first(struct throtl_service_queue *sq)
 {
 	/* Service tree is empty */
-	if (!root->count)
+	if (!sq->nr_pending)
 		return NULL;
 
-	if (!root->left)
-		root->left = rb_first(&root->rb);
+	if (!sq->first_pending)
+		sq->first_pending = rb_first(&sq->pending_tree);
 
-	if (root->left)
-		return rb_entry_tg(root->left);
+	if (sq->first_pending)
+		return rb_entry_tg(sq->first_pending);
 
 	return NULL;
 }
@@ -317,29 +317,29 @@ static void rb_erase_init(struct rb_node *n, struct rb_root *root)
 	RB_CLEAR_NODE(n);
 }
 
-static void throtl_rb_erase(struct rb_node *n, struct throtl_rb_root *root)
+static void throtl_rb_erase(struct rb_node *n, struct throtl_service_queue *sq)
 {
-	if (root->left == n)
-		root->left = NULL;
-	rb_erase_init(n, &root->rb);
-	--root->count;
+	if (sq->first_pending == n)
+		sq->first_pending = NULL;
+	rb_erase_init(n, &sq->pending_tree);
+	--sq->nr_pending;
 }
 
-static void update_min_dispatch_time(struct throtl_rb_root *st)
+static void update_min_dispatch_time(struct throtl_service_queue *sq)
 {
 	struct throtl_grp *tg;
 
-	tg = throtl_rb_first(st);
+	tg = throtl_rb_first(sq);
 	if (!tg)
 		return;
 
-	st->min_disptime = tg->disptime;
+	sq->first_pending_disptime = tg->disptime;
 }
 
-static void
-tg_service_tree_add(struct throtl_rb_root *st, struct throtl_grp *tg)
+static void tg_service_queue_add(struct throtl_service_queue *sq,
+				 struct throtl_grp *tg)
 {
-	struct rb_node **node = &st->rb.rb_node;
+	struct rb_node **node = &sq->pending_tree.rb_node;
 	struct rb_node *parent = NULL;
 	struct throtl_grp *__tg;
 	unsigned long key = tg->disptime;
@@ -358,19 +358,19 @@ tg_service_tree_add(struct throtl_rb_root *st, struct throtl_grp *tg)
 	}
 
 	if (left)
-		st->left = &tg->rb_node;
+		sq->first_pending = &tg->rb_node;
 
 	rb_link_node(&tg->rb_node, parent, node);
-	rb_insert_color(&tg->rb_node, &st->rb);
+	rb_insert_color(&tg->rb_node, &sq->pending_tree);
 }
 
 static void __throtl_enqueue_tg(struct throtl_data *td, struct throtl_grp *tg)
 {
-	struct throtl_rb_root *st = &td->tg_service_tree;
+	struct throtl_service_queue *sq = &td->service_queue;
 
-	tg_service_tree_add(st, tg);
+	tg_service_queue_add(sq, tg);
 	throtl_mark_tg_on_rr(tg);
-	st->count++;
+	sq->nr_pending++;
 }
 
 static void throtl_enqueue_tg(struct throtl_data *td, struct throtl_grp *tg)
@@ -381,7 +381,7 @@ static void throtl_enqueue_tg(struct throtl_data *td, struct throtl_grp *tg)
 
 static void __throtl_dequeue_tg(struct throtl_data *td, struct throtl_grp *tg)
 {
-	throtl_rb_erase(&tg->rb_node, &td->tg_service_tree);
+	throtl_rb_erase(&tg->rb_node, &td->service_queue);
 	throtl_clear_tg_on_rr(tg);
 }
 
@@ -403,18 +403,18 @@ static void throtl_schedule_delayed_work(struct throtl_data *td,
 
 static void throtl_schedule_next_dispatch(struct throtl_data *td)
 {
-	struct throtl_rb_root *st = &td->tg_service_tree;
+	struct throtl_service_queue *sq = &td->service_queue;
 
 	/* any pending children left? */
-	if (!st->count)
+	if (!sq->nr_pending)
 		return;
 
-	update_min_dispatch_time(st);
+	update_min_dispatch_time(sq);
 
-	if (time_before_eq(st->min_disptime, jiffies))
+	if (time_before_eq(sq->first_pending_disptime, jiffies))
 		throtl_schedule_delayed_work(td, 0);
 	else
-		throtl_schedule_delayed_work(td, (st->min_disptime - jiffies));
+		throtl_schedule_delayed_work(td, sq->first_pending_disptime - jiffies);
 }
 
 static inline void
@@ -794,10 +794,10 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 {
 	unsigned int nr_disp = 0;
 	struct throtl_grp *tg;
-	struct throtl_rb_root *st = &td->tg_service_tree;
+	struct throtl_service_queue *sq = &td->service_queue;
 
 	while (1) {
-		tg = throtl_rb_first(st);
+		tg = throtl_rb_first(sq);
 
 		if (!tg)
 			break;
@@ -1148,7 +1148,7 @@ void blk_throtl_drain(struct request_queue *q)
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct throtl_data *td = q->td;
-	struct throtl_rb_root *st = &td->tg_service_tree;
+	struct throtl_service_queue *sq = &td->service_queue;
 	struct throtl_grp *tg;
 	struct bio_list bl;
 	struct bio *bio;
@@ -1157,7 +1157,7 @@ void blk_throtl_drain(struct request_queue *q)
 
 	bio_list_init(&bl);
 
-	while ((tg = throtl_rb_first(st))) {
+	while ((tg = throtl_rb_first(sq))) {
 		throtl_dequeue_tg(td, tg);
 
 		while ((bio = bio_list_peek(&tg->bio_lists[READ])))
@@ -1182,7 +1182,7 @@ int blk_throtl_init(struct request_queue *q)
 	if (!td)
 		return -ENOMEM;
 
-	td->tg_service_tree = THROTL_RB_ROOT;
+	td->service_queue = THROTL_SERVICE_QUEUE_INITIALIZER;
 	INIT_DELAYED_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
 
 	q->td = td;
-- 
1.8.1.4
