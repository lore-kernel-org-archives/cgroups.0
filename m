From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 13/15] blkcg: change blkg reference counting to use percpu_ref
Date: Thu, 30 Aug 2018 21:53:54 -0400
Message-ID: <20180831015356.69796-14-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Tu/AriW7HdBy3hcsN7f/g+VUfGV9GCz/UgAHKU8KDmw=;
        b=L4pGlUrxrEzZMR8p1KPpJpEOBv6PlROFKL19Z+Co1NyRMzzYpT36JXKdJyhaLS6bO3
         GjOcIAShcjSmBMHCgcDOSkMrpO62nQJMShLwmrHQ7ouXVbbw6l0oIJzvPAE+gHQq/wkM
         Dn99dyAfJduPXusYjkX1zeusfVZNzAJcvK0t7a+35zhE6Iuo5/HbQvfkdtVeftf0N1ZW
         gWxWHleWSoXoyJuOxZf52ULtbNJmt+Mw+PqleW6lwhcVPszJwSjX/eBdythvLZkwFtsM
         Vo1jzvg3TjmGI6JgfmER06xvh8Z6BDFY2cVoK0WO0ehRxQYSILfhN0FzHvF139fmZXup
         eI3g==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

Now that every bio is associated with a blkg, this puts the use of
blkg_get, blkg_try_get, and blkg_put on the hot path. This switches over
the refcnt in blkg to use percpu_ref.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
---
 block/blk-cgroup.c         | 56 +++++++++++++++++++++-----------------
 include/linux/blk-cgroup.h | 14 +++-------
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f678cd555814..bbea4b44bd8f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -84,6 +84,30 @@ static void blkg_free(struct blkcg_gq *blkg)
 	kfree(blkg);
 }
 
+/*
+ * A group is RCU protected, but having an rcu lock does not mean that one
+ * can access all the fields of blkg and assume these are valid.  For
+ * example, don't try to follow throtl_data and request queue links.
+ *
+ * Having a reference to blkg under an rcu allows accesses to only values
+ * local to groups like group stats and group rate limits.
+ */
+static void __blkg_release(struct percpu_ref *ref)
+{
+	struct blkcg_gq *blkg = container_of(ref, struct blkcg_gq, refcnt);
+
+	percpu_ref_exit(&blkg->refcnt);
+
+	/* release the blkcg and parent blkg refs this blkg has been holding */
+	css_put(&blkg->blkcg->css);
+	if (blkg->parent)
+		blkg_put(blkg->parent);
+
+	wb_congested_put(blkg->wb_congested);
+
+	blkg_free(blkg);
+}
+
 /**
  * blkg_alloc - allocate a blkg
  * @blkcg: block cgroup the new blkg is associated with
@@ -110,7 +134,6 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
-	atomic_set(&blkg->refcnt, 1);
 
 	/* root blkg uses @q->root_rl, init rl only for !root blkgs */
 	if (blkcg != &blkcg_root) {
@@ -217,6 +240,10 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 		blkg_get(blkg->parent);
 	}
 
+	ret = percpu_ref_init(&blkg->refcnt, __blkg_release, 0, GFP_KERNEL);
+	if (ret)
+		goto err_cancel_ref;
+
 	/* invoke per-policy init */
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
@@ -249,6 +276,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 	blkg_put(blkg);
 	return ERR_PTR(ret);
 
+err_cancel_ref:
+	percpu_ref_exit(&blkg->refcnt);
 err_put_congested:
 	wb_congested_put(wb_congested);
 err_put_css:
@@ -378,7 +407,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
-	blkg_put(blkg);
+	percpu_ref_kill(&blkg->refcnt);
 }
 
 /**
@@ -405,29 +434,6 @@ static void blkg_destroy_all(struct request_queue *q)
 	q->root_rl.blkg = NULL;
 }
 
-/*
- * A group is RCU protected, but having an rcu lock does not mean that one
- * can access all the fields of blkg and assume these are valid.  For
- * example, don't try to follow throtl_data and request queue links.
- *
- * Having a reference to blkg under an rcu allows accesses to only values
- * local to groups like group stats and group rate limits.
- */
-void __blkg_release_rcu(struct rcu_head *rcu_head)
-{
-	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
-
-	/* release the blkcg and parent blkg refs this blkg has been holding */
-	css_put(&blkg->blkcg->css);
-	if (blkg->parent)
-		blkg_put(blkg->parent);
-
-	wb_congested_put(blkg->wb_congested);
-
-	blkg_free(blkg);
-}
-EXPORT_SYMBOL_GPL(__blkg_release_rcu);
-
 /*
  * The next function used by blk_queue_for_each_rl().  It's a bit tricky
  * because the root blkg uses @q->root_rl instead of its own rl.
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 97cb82029b18..b60d063fb0d7 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -126,7 +126,7 @@ struct blkcg_gq {
 	struct request_list		rl;
 
 	/* reference count */
-	atomic_t			refcnt;
+	struct percpu_ref		refcnt;
 
 	/* is this blkg online? protected by both blkcg and q locks */
 	bool				online;
@@ -455,8 +455,7 @@ static inline int blkg_path(struct blkcg_gq *blkg, char *buf, int buflen)
  */
 static inline void blkg_get(struct blkcg_gq *blkg)
 {
-	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
-	atomic_inc(&blkg->refcnt);
+	percpu_ref_get(&blkg->refcnt);
 }
 
 /**
@@ -468,23 +467,18 @@ static inline void blkg_get(struct blkcg_gq *blkg)
  */
 static inline struct blkcg_gq *blkg_try_get(struct blkcg_gq *blkg)
 {
-	if (atomic_inc_not_zero(&blkg->refcnt))
+	if (percpu_ref_tryget(&blkg->refcnt))
 		return blkg;
 	return NULL;
 }
 
-
-void __blkg_release_rcu(struct rcu_head *rcu);
-
 /**
  * blkg_put - put a blkg reference
  * @blkg: blkg to put
  */
 static inline void blkg_put(struct blkcg_gq *blkg)
 {
-	WARN_ON_ONCE(atomic_read(&blkg->refcnt) <= 0);
-	if (atomic_dec_and_test(&blkg->refcnt))
-		call_rcu(&blkg->rcu_head, __blkg_release_rcu);
+	percpu_ref_put(&blkg->refcnt);
 }
 
 /**
-- 
2.17.1

