From: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH v2 RESEND] cfq-iosched: Fix wrong children_weight calculation
Date: Wed, 27 Aug 2014 17:32:32 +0900
Message-ID: <1409128352.11712.2.camel@ubuntu-vm-makita>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

cfq_group_service_tree_add() is applying new_weight at the beginning of
the function via cfq_update_group_weight().
This actually allows weight to change between adding it to and subtracting
it from children_weight, and triggers WARN_ON_ONCE() in
cfq_group_service_tree_del(), or even causes oops by divide error during
vfr calculation in cfq_group_service_tree_add().

The detailed scenario is as follows:
1. Create blkio cgroups P and P's child C.
   Set P's weight to 500 and perform some I/O to apply new_weight.
   This P's I/O completes before starting C's I/O.
2. C starts I/O and cfq_group_service_tree_add() is called with C.
3. cfq_group_service_tree_add() walks up the tree during children_weight
   calculation and adds parent P's weight (500) to children_weight of root.
   children_weight becomes 500.
4. Set P's weight to 1000.
5. P starts I/O and cfq_group_service_tree_add() is called with P.
6. cfq_group_service_tree_add() applies its new_weight (1000).
7. I/O of C completes and cfq_group_service_tree_del() is called with C.
8. I/O of P completes and cfq_group_service_tree_del() is called with P.
9. cfq_group_service_tree_del() subtracts P's weight (1000) from
   children_weight of root. children_weight becomes -500.
   This triggers WARN_ON_ONCE().
10. Set P's weight to 500.
11. P starts I/O and cfq_group_service_tree_add() is called with P.
12. cfq_group_service_tree_add() applies its new_weight (500) and adds it
    to children_weight of root. children_weight becomes 0. Calculation of
    vfr triggers oops by divide error.

weight should be updated right before adding it to children_weight.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reported-by: Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Signed-off-by: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
v2:
- Add comments in the code.
- Reword cgroup names in changelog.

 block/cfq-iosched.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cadc378..faf175e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1272,15 +1272,22 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	rb_insert_color(&cfqg->rb_node, &st->rb);
 }
 
+/*
+ * This has to be called only on activation of cfqg
+ */
 static void
 cfq_update_group_weight(struct cfq_group *cfqg)
 {
-	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
-
 	if (cfqg->new_weight) {
 		cfqg->weight = cfqg->new_weight;
 		cfqg->new_weight = 0;
 	}
+}
+
+static void
+cfq_update_group_leaf_weight(struct cfq_group *cfqg)
+{
+	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
 	if (cfqg->new_leaf_weight) {
 		cfqg->leaf_weight = cfqg->new_leaf_weight;
@@ -1299,7 +1306,11 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	/* add to the service tree */
 	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
-	cfq_update_group_weight(cfqg);
+	/*
+	 * Update leaf_weight.  We cannot update weight at this point
+	 * because cfqg might already have been activated by its child.
+	 */
+	cfq_update_group_leaf_weight(cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/*
@@ -1323,6 +1334,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	 */
 	while ((parent = cfqg_parent(pos))) {
 		if (propagate) {
+			cfq_update_group_weight(pos);
 			propagate = !parent->nr_active++;
 			parent->children_weight += pos->weight;
 		}
-- 
1.8.1.2

