From: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: [PATCH] cfq-iosched: Fix wrong children_weight calculation
Date: Tue, 26 Aug 2014 20:56:36 +0900
Message-ID: <1409054196-20945-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cfq_group_service_tree_add() is applying new_weight at the beginning of
the function via cfq_update_group_weight().
This actually allows weight to change between adding it to and subtracting
it from children_weight, and triggers WARN_ON_ONCE() in
cfq_group_service_tree_del(), or even causes oops by divide error during
vfr calculation in cfq_group_service_tree_add().

The detailed scenario is as follows:
1. Create blkio cgroups X and Y as a child of X.
   Set X's weight to 500 and perform some I/O to apply new_weight.
   This X's I/O completes before starting Y's I/O.
2. Y starts I/O and cfq_group_service_tree_add() is called with Y.
3. cfq_group_service_tree_add() walks up the tree during children_weight
   calculation and adds parent X's weight (500) to children_weight of root.
   children_weight becomes 500.
4. Set X's weight to 1000.
5. X starts I/O and cfq_group_service_tree_add() is called with X.
6. cfq_group_service_tree_add() applies its new_weight (1000).
7. I/O of Y completes and cfq_group_service_tree_del() is called with Y.
8. I/O of X completes and cfq_group_service_tree_del() is called with X.
9. cfq_group_service_tree_del() subtracts X's weight (1000) from
   children_weight of root. children_weight becomes -500.
   This triggers WARN_ON_ONCE().
10. Set X's weight to 500.
11. X starts I/O and cfq_group_service_tree_add() is called with X.
12. cfq_group_service_tree_add() applies its new_weight (500) and adds it
    to children_weight of root. children_weight becomes 0. Calcularion of
    vfr triggers oops by divide error.

weight should be updated right before adding it to children_weight.

Reported-by: Ruki Sekiya <sekiya.ruki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Signed-off-by: Toshiaki Makita <makita.toshiaki-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 block/cfq-iosched.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cadc378..d749463 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1275,12 +1275,16 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
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
@@ -1299,7 +1303,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	/* add to the service tree */
 	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
-	cfq_update_group_weight(cfqg);
+	cfq_update_group_leaf_weight(cfqg);
 	__cfq_group_service_tree_add(st, cfqg);
 
 	/*
@@ -1323,6 +1327,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	 */
 	while ((parent = cfqg_parent(pos))) {
 		if (propagate) {
+			cfq_update_group_weight(pos);
 			propagate = !parent->nr_active++;
 			parent->children_weight += pos->weight;
 		}
-- 
1.8.1.2
