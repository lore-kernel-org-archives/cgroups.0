From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] blkcg: s/CFQ_WEIGHT_*/CFQ_WEIGHT_LEGACY_*/
Date: Sun,  2 Aug 2015 16:23:43 -0400
Message-ID: <1438547024-23497-4-git-send-email-tj@kernel.org>
References: <1438547024-23497-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HgxX5hqWNh72Qut+i6E9317shS5vt3lPyw48l9PNOwA=;
        b=RVUFHxJUzAe307Y66VIyHRqImcEFfXCjkpwH9SHQwx7P6ettfSHwUpuwbc2MQ4BC0J
         UmOYTrUvqXF+PWg3aCaLjx8H1c95VCRYagxoJcVBeE/wlZKFf3tkDgMMVU4QGYNCkswh
         LWhjekLaDws5EDMzo0GGyvonTijpCkVmP99Uzpan/AclHcX7+TXIDyZZxr9XHmSkISOV
         LDBHwo9+3J9WADRYDIMdPI0j/wGwHuXR7Rbz3iJywqaoou8tYPlWlDZs0iZesw0JvT/a
         FMmfnkLtCtiBVG0OFq+Xm9LUaykxCu5LLC1nP4tPI0tdVMKvWcuFV8rqxUzOc5JyjyeO
         Z+Kw==
In-Reply-To: <1438547024-23497-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, hannes@cmpxchg.org, lizefan@huawei.com
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

blkcg is gonna switch to cgroup common weight range as defined by
CGROUP_WEIGHT_* on the unified hierarchy.  In preparation, rename
CFQ_WEIGHT_* constants to CFQ_WEIGHT_LEGACY_*.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/cfq-iosched.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 97da571..0fe721e 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -68,9 +68,9 @@ static struct kmem_cache *cfq_pool;
 #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
 
 /* blkio-related constants */
-#define CFQ_WEIGHT_MIN          10
-#define CFQ_WEIGHT_MAX          1000
-#define CFQ_WEIGHT_DEFAULT      500
+#define CFQ_WEIGHT_LEGACY_MIN	10
+#define CFQ_WEIGHT_LEGACY_DFL	500
+#define CFQ_WEIGHT_LEGACY_MAX	1000
 
 struct cfq_ttime {
 	unsigned long last_end_request;
@@ -1580,11 +1580,11 @@ static void cfq_cpd_init(struct blkcg_policy_data *cpd)
 	struct cfq_group_data *cgd = cpd_to_cfqgd(cpd);
 
 	if (cpd_to_blkcg(cpd) == &blkcg_root) {
-		cgd->weight = 2 * CFQ_WEIGHT_DEFAULT;
-		cgd->leaf_weight = 2 * CFQ_WEIGHT_DEFAULT;
+		cgd->weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
+		cgd->leaf_weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
 	} else {
-		cgd->weight = CFQ_WEIGHT_DEFAULT;
-		cgd->leaf_weight = CFQ_WEIGHT_DEFAULT;
+		cgd->weight = CFQ_WEIGHT_LEGACY_DFL;
+		cgd->leaf_weight = CFQ_WEIGHT_LEGACY_DFL;
 	}
 }
 
@@ -1769,7 +1769,7 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 	cfqgd = blkcg_to_cfqgd(blkcg);
 
 	ret = -ERANGE;
-	if (!v || (v >= CFQ_WEIGHT_MIN && v <= CFQ_WEIGHT_MAX)) {
+	if (!v || (v >= CFQ_WEIGHT_LEGACY_MIN && v <= CFQ_WEIGHT_LEGACY_MAX)) {
 		if (!is_leaf_weight) {
 			cfqg->dev_weight = v;
 			cfqg->new_weight = v ?: cfqgd->weight;
@@ -1804,7 +1804,7 @@ static int __cfq_set_weight(struct cgroup_subsys_state *css, u64 val,
 	struct cfq_group_data *cfqgd;
 	int ret = 0;
 
-	if (val < CFQ_WEIGHT_MIN || val > CFQ_WEIGHT_MAX)
+	if (val < CFQ_WEIGHT_LEGACY_MIN || val > CFQ_WEIGHT_LEGACY_MAX)
 		return -EINVAL;
 
 	spin_lock_irq(&blkcg->lock);
@@ -4513,8 +4513,8 @@ static int cfq_init_queue(struct request_queue *q, struct elevator_type *e)
 
 	cfq_init_cfqg_base(cfqd->root_group);
 #endif
-	cfqd->root_group->weight = 2 * CFQ_WEIGHT_DEFAULT;
-	cfqd->root_group->leaf_weight = 2 * CFQ_WEIGHT_DEFAULT;
+	cfqd->root_group->weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
+	cfqd->root_group->leaf_weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
-- 
2.4.3
