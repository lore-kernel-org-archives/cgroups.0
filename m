From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/24] cfq-iosched: enable full blkcg hierarchy support
Date: Fri, 28 Dec 2012 12:35:37 -0800
Message-ID: <1356726946-26037-16-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=zalUG+DdabZF8JxFua6mAXzqYSx/Gx60y5SP9l0pdIs=;
        b=MmaMvV+OwDTKvi2QX98OuZ1DpgLN5o28OrjUtFCEFdRl0RD009DTsj0VMiHX1TPOW1
         DKUsghvN5uMFlSmWqZl7Y85ncT82p38qMxj+IP/hwhG0Jd+D3EJjJItwzDohcmPg8C2x
         EhSSNNT7X3TA09k+VghhjS4PWBtVxR4sLWs9+SgcJq38i4rh6ftLjQ6drBjWCkchiOMQ
         t1YXNGl167NdDcJVXqAQyHRp3lqqNwNMoMytucubJgiI6PnPJd7Wo6zxjwgOzx0KB0jW
         ZhDlvZEVcYhv4pnkYaEIlTlJkqv1tU5UgAb/032NF9ENWr6ef2qZTK8c45bqELRUjSXZ
         KKCw==
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>

With the previous two patches, all cfqg scheduling decisions are based
on vfraction and ready for hierarchy support.  The only thing which
keeps the behavior flat is cfqg_flat_parent() which makes vfraction
calculation consider all non-root cfqgs children of the root cfqg.

Replace it with cfqg_parent() which returns the real parent.  This
enables full blkcg hierarchy support for cfq-iosched.  For example,
consider the following hierarchy.

        root
      /      \
   A:500      B:250
  /     \
 AA:500  AB:1000

For simplicity, let's say all the leaf nodes have active tasks and are
on service tree.  For each leaf node, vfraction would be

 AA: (500  / 1500) * (500 / 750) =~ 0.2222
 AB: (1000 / 1500) * (500 / 750) =~ 0.4444
  B:                 (250 / 750) =~ 0.3333

and vdisktime will be distributed accordingly.  For more detail,
please refer to Documentation/block/cfq-iosched.txt.

v2: cfq-iosched.txt updated to describe group scheduling as suggested
    by Vivek.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/block/cfq-iosched.txt | 58 +++++++++++++++++++++++++++++++++++++
 block/cfq-iosched.c                 | 21 ++++----------
 2 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
index d89b4fe..a5eb7d1 100644
--- a/Documentation/block/cfq-iosched.txt
+++ b/Documentation/block/cfq-iosched.txt
@@ -102,6 +102,64 @@ processing of request. Therefore, increasing the value can imporve the
 performace although this can cause the latency of some I/O to increase due
 to more number of requests.
 
+CFQ Group scheduling
+====================
+
+CFQ supports blkio cgroup and has "blkio." prefixed files in each
+blkio cgroup directory. It is weight-based and there are four knobs
+for configuration - weight[_device] and leaf_weight[_device].
+Internal cgroup nodes (the ones with children) can also have tasks in
+them, so the former two configure how much proportion the cgroup as a
+whole is entitled to at its parent's level while the latter two
+configure how much proportion the tasks in the cgroup have compared to
+its direct children.
+
+Another way to think about it is assuming that each internal node has
+an implicit leaf child node which hosts all the tasks whose weight is
+configured by leaf_weight[_device]. Let's assume a blkio hierarchy
+composed of five cgroups - root, A, B, AA and AB - with the following
+weights where the names represent the hierarchy.
+
+        weight leaf_weight
+ root :  125    125
+ A    :  500    750
+ B    :  250    500
+ AA   :  500    500
+ AB   : 1000    500
+
+root never has a parent making its weight is meaningless. For backward
+compatibility, weight is always kept in sync with leaf_weight. B, AA
+and AB have no child and thus its tasks have no children cgroup to
+compete with. They always get 100% of what the cgroup won at the
+parent level. Considering only the weights which matter, the hierarchy
+looks like the following.
+
+          root
+       /    |   \
+      A     B    leaf
+     500   250   125
+   /  |  \
+  AA  AB  leaf
+ 500 1000 750
+
+If all cgroups have active IOs and competing with each other, disk
+time will be distributed like the following.
+
+Distribution below root. The total active weight at this level is
+A:500 + B:250 + C:125 = 875.
+
+ root-leaf :   125 /  875      =~ 14%
+ A         :   500 /  875      =~ 57%
+ B(-leaf)  :   250 /  875      =~ 28%
+
+A has children and further distributes its 57% among the children and
+the implicit leaf node. The total active weight at this level is
+AA:500 + AB:1000 + A-leaf:750 = 2250.
+
+ A-leaf    : ( 750 / 2250) * A =~ 19%
+ AA(-leaf) : ( 500 / 2250) * A =~ 12%
+ AB(-leaf) : (1000 / 2250) * A =~ 25%
+
 CFQ IOPS Mode for group scheduling
 ===================================
 Basic CFQ design is to provide priority based time slices. Higher priority
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ee34282..e8f3106 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -606,20 +606,11 @@ static inline struct cfq_group *blkg_to_cfqg(struct blkcg_gq *blkg)
 	return pd_to_cfqg(blkg_to_pd(blkg, &blkcg_policy_cfq));
 }
 
-/*
- * Determine the parent cfqg for weight calculation.  Currently, cfqg
- * scheduling is flat and the root is the parent of everyone else.
- */
-static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg)
+static inline struct cfq_group *cfqg_parent(struct cfq_group *cfqg)
 {
-	struct blkcg_gq *blkg = cfqg_to_blkg(cfqg);
-	struct cfq_group *root;
-
-	while (blkg->parent)
-		blkg = blkg->parent;
-	root = blkg_to_cfqg(blkg);
+	struct blkcg_gq *pblkg = cfqg_to_blkg(cfqg)->parent;
 
-	return root != cfqg ? root : NULL;
+	return pblkg ? blkg_to_cfqg(pblkg) : NULL;
 }
 
 static inline void cfqg_get(struct cfq_group *cfqg)
@@ -722,7 +713,7 @@ static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
 
 #else	/* CONFIG_CFQ_GROUP_IOSCHED */
 
-static inline struct cfq_group *cfqg_flat_parent(struct cfq_group *cfqg) { return NULL; }
+static inline struct cfq_group *cfqg_parent(struct cfq_group *cfqg) { return NULL; }
 static inline void cfqg_get(struct cfq_group *cfqg) { }
 static inline void cfqg_put(struct cfq_group *cfqg) { }
 
@@ -1290,7 +1281,7 @@ cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	 * stops once an already activated node is met.  vfraction
 	 * calculation should always continue to the root.
 	 */
-	while ((parent = cfqg_flat_parent(pos))) {
+	while ((parent = cfqg_parent(pos))) {
 		if (propagate) {
 			propagate = !parent->nr_active++;
 			parent->children_weight += pos->weight;
@@ -1341,7 +1332,7 @@ cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	pos->children_weight -= pos->leaf_weight;
 
 	while (propagate) {
-		struct cfq_group *parent = cfqg_flat_parent(pos);
+		struct cfq_group *parent = cfqg_parent(pos);
 
 		/* @pos has 0 nr_active at this point */
 		WARN_ON_ONCE(pos->children_weight);
-- 
1.8.0.2
