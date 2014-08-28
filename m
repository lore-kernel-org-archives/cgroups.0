From: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] cfq-iosched: Add comments on update timing of weight
Date: Thu, 28 Aug 2014 17:14:58 +0900
Message-ID: <1409213698-10136-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Explain that weight has to be updated on activation.
This complements previous fix e15693ef18e1 ("cfq-iosched: Fix wrong
children_weight calculation").

Signed-off-by: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 block/cfq-iosched.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d749463..3f31cf9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1272,6 +1272,9 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	rb_insert_color(&cfqg->rb_node, &st->rb);
 }
 
+/*
+ * This has to be called only on activation of cfqg
+ */
 static void
 cfq_update_group_weight(struct cfq_group *cfqg)
 {
@@ -1303,6 +1306,11 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	/* add to the service tree */
 	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
+	/*
+	 * Update leaf_weight.  We cannot update weight at this point
+	 * because cfqg might already have been activated and is
+	 * contributing its current weight to the parent's child_weight.
+	 */
 	cfq_update_group_leaf_weight(cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
-- 
1.8.1.2
