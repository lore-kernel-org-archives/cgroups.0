From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] blkcg: relocate __blkg_release_rcu()
Date: Sun, 12 Nov 2017 14:26:07 -0800
Message-ID: <20171112222613.3613362-2-tj@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RdBB6b1Q+BPcJqiQqYUolyum316TU1Ak9ajmvcZEnes=;
        b=RFm6DGzdTNBJ9ebpNUadN/BKbwM8JUEy63l02WD0dZT2Es+DeZQvpPakdVQ/pXWP+V
         3FrE8iTywByhO1bsAgDu++vuyh1Dh+ds35SzThHEzTGQdmIc57MBr7VPUZVjlnjAmDPL
         9Holmmd1jg6LKjuyNuS1dhpszzhkm9cVYPLEdH7T/xBsGuLwKcnShETa/Q2YTht/JT21
         5yZlVNaKFJ6aeHnUBB9Jd+KbdnDaZ0fzlTXDoTvAtVhAiFnmR5AMMC8nAZkKMRp9TXN0
         lMbb/tJwgChuxfr4tyliaslI59MAdivpHtJMkTgUNff2zOYWPPgWpsAXgLMRLjO+OmnB
         GXxg==
In-Reply-To: <20171112222613.3613362-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: shli@kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, guro@fb.com, Tejun Heo <tj@kernel.org>

Move __blkg_release_rcu() above blkg_alloc().  This is a pure code
reorganization to prepare for the switch to percpu_ref.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d3f56ba..6482be5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -81,6 +81,29 @@ static void blkg_free(struct blkcg_gq *blkg)
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
+void __blkg_release_rcu(struct rcu_head *rcu_head)
+{
+	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
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
+EXPORT_SYMBOL_GPL(__blkg_release_rcu);
+
 /**
  * blkg_alloc - allocate a blkg
  * @blkcg: block cgroup the new blkg is associated with
@@ -378,29 +401,6 @@ static void blkg_destroy_all(struct request_queue *q)
 }
 
 /*
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
-/*
  * The next function used by blk_queue_for_each_rl().  It's a bit tricky
  * because the root blkg uses @q->root_rl instead of its own rl.
  */
-- 
2.9.5

