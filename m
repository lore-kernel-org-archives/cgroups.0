From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/10] blkcg: move body parsing from blkg_conf_prep() to its callers
Date: Fri, 24 Jul 2015 14:43:51 -0400
Message-ID: <1437763434-28699-8-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3cAYmW6vp3gvyImqx7PdhHCKdeGd/ujBiRN9i595HPI=;
        b=DoFigAEsl8h6RvwF1fklQg4v8s24lpCsCIx0Tqyr/U/0x1pdFZ2K84xQuUgAxYAfkV
         l4qIzhUZpyAfaKDY0+DrSUBifLRV2G68z95+Sj0tXgnfZKIU/u90qu1rrlG1Fa30LtrS
         RDXUHJzHsvqIxJYIdEbBOCDRwPGvDQjfPndYY6NxsQx/oXYF2Ir8aekMMzuF6ljGtQlc
         TH0sQM3wpENOrj7Mboxnsauxdd0PYYG2tQ2QAFGdQSZWqZqr2nsiZEoqgSHufP+HmuaB
         IJOycYIxV+YV/FYTOanzLEMRaycfGyrjlxWWHb1T5HRk7xAAMuZ2gWWhaPqs3p8Eul5s
         /xcQ==
In-Reply-To: <1437763434-28699-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

Currently, blkg_conf_prep() expects input to be of the following form

 MAJ:MIN NUM

and reads the NUM part into blkg_conf_ctx->v.  This is quite
restrictive and gets in the way in implementing blkcg interface for
the unified hierarchy.  This patch updates blkg_conf_prep() so that it
expects

 MAJ:MIN BODY_STR

where BODY_STR is an arbitrary string.  blkg_conf_ctx->v is replaced
with ->body which is a char pointer pointing to the start of BODY_STR.
Parsing of the body is moved to blkg_conf_prep()'s callers.

To allow using, for example, strsep() on blkg_conf_ctx->val, it is a
non-const pointer and to accommodate that const is dropped from @input
too.

This doesn't cause any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c         | 22 ++++++++++++++--------
 block/blk-throttle.c       | 18 ++++++++++++------
 block/cfq-iosched.c        | 17 +++++++++++------
 include/linux/blk-cgroup.h |  4 ++--
 4 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index db7b3cc..2ea3a2a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -24,6 +24,7 @@
 #include <linux/genhd.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
+#include <linux/ctype.h>
 #include <linux/blk-cgroup.h>
 #include "blk.h"
 
@@ -773,23 +774,28 @@ EXPORT_SYMBOL_GPL(blkg_rwstat_recursive_sum);
  * @ctx: blkg_conf_ctx to be filled
  *
  * Parse per-blkg config update from @input and initialize @ctx with the
- * result.  @ctx->blkg points to the blkg to be updated and @ctx->v the new
- * value.  This function returns with RCU read lock and queue lock held and
- * must be paired with blkg_conf_finish().
+ * result.  @ctx->blkg points to the blkg to be updated and @ctx->body the
+ * part of @input following MAJ:MIN.  This function returns with RCU read
+ * lock and queue lock held and must be paired with blkg_conf_finish().
  */
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
-		   const char *input, struct blkg_conf_ctx *ctx)
+		   char *input, struct blkg_conf_ctx *ctx)
 	__acquires(rcu) __acquires(disk->queue->queue_lock)
 {
 	struct gendisk *disk;
 	struct blkcg_gq *blkg;
 	unsigned int major, minor;
-	unsigned long long v;
-	int part, ret;
+	int key_len, part, ret;
+	char *body;
 
-	if (sscanf(input, "%u:%u %llu", &major, &minor, &v) != 3)
+	if (sscanf(input, "%u:%u%n", &major, &minor, &key_len) != 2)
 		return -EINVAL;
 
+	body = input + key_len;
+	if (!isspace(*body))
+		return -EINVAL;
+	body = skip_spaces(body);
+
 	disk = get_gendisk(MKDEV(major, minor), &part);
 	if (!disk)
 		return -ENODEV;
@@ -826,7 +832,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 
 	ctx->disk = disk;
 	ctx->blkg = blkg;
-	ctx->v = v;
+	ctx->body = body;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(blkg_conf_prep);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8b4f6b8..0e17c8f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1154,21 +1154,25 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	struct blkcg_gq *blkg;
 	struct cgroup_subsys_state *pos_css;
 	int ret;
+	u64 v;
 
 	ret = blkg_conf_prep(blkcg, &blkcg_policy_throtl, buf, &ctx);
 	if (ret)
 		return ret;
 
+	ret = -EINVAL;
+	if (sscanf(ctx.body, "%llu", &v) != 1)
+		goto out_finish;
+	if (!v)
+		v = -1;
+
 	tg = blkg_to_tg(ctx.blkg);
 	sq = &tg->service_queue;
 
-	if (!ctx.v)
-		ctx.v = -1;
-
 	if (is_u64)
-		*(u64 *)((void *)tg + of_cft(of)->private) = ctx.v;
+		*(u64 *)((void *)tg + of_cft(of)->private) = v;
 	else
-		*(unsigned int *)((void *)tg + of_cft(of)->private) = ctx.v;
+		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
 
 	throtl_log(&tg->service_queue,
 		   "limit change rbps=%llu wbps=%llu riops=%u wiops=%u",
@@ -1201,8 +1205,10 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 		throtl_schedule_next_dispatch(sq->parent_sq, true);
 	}
 
+	ret = 0;
+out_finish:
 	blkg_conf_finish(&ctx);
-	return nbytes;
+	return ret ?: nbytes;
 }
 
 static ssize_t tg_set_conf_u64(struct kernfs_open_file *of,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index baa8459..ea88d89 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1747,26 +1747,31 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 	struct cfq_group *cfqg;
 	struct cfq_group_data *cfqgd;
 	int ret;
+	u64 v;
 
 	ret = blkg_conf_prep(blkcg, &blkcg_policy_cfq, buf, &ctx);
 	if (ret)
 		return ret;
 
+	ret = -EINVAL;
+	if (sscanf(ctx.body, "%llu", &v) != 1)
+		goto out_finish;
+
 	cfqg = blkg_to_cfqg(ctx.blkg);
 	cfqgd = blkcg_to_cfqgd(blkcg);
 
 	ret = -ERANGE;
-	if (!ctx.v || (ctx.v >= CFQ_WEIGHT_MIN && ctx.v <= CFQ_WEIGHT_MAX)) {
+	if (!v || (v >= CFQ_WEIGHT_MIN && v <= CFQ_WEIGHT_MAX)) {
 		if (!is_leaf_weight) {
-			cfqg->dev_weight = ctx.v;
-			cfqg->new_weight = ctx.v ?: cfqgd->weight;
+			cfqg->dev_weight = v;
+			cfqg->new_weight = v ?: cfqgd->weight;
 		} else {
-			cfqg->dev_leaf_weight = ctx.v;
-			cfqg->new_leaf_weight = ctx.v ?: cfqgd->leaf_weight;
+			cfqg->dev_leaf_weight = v;
+			cfqg->new_leaf_weight = v ?: cfqgd->leaf_weight;
 		}
 		ret = 0;
 	}
-
+out_finish:
 	blkg_conf_finish(&ctx);
 	return ret ?: nbytes;
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 6e016e6..85a4d98 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -206,11 +206,11 @@ struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkcg_gq *blkg,
 struct blkg_conf_ctx {
 	struct gendisk			*disk;
 	struct blkcg_gq			*blkg;
-	u64				v;
+	char				*body;
 };
 
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
-		   const char *input, struct blkg_conf_ctx *ctx);
+		   char *input, struct blkg_conf_ctx *ctx);
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
 
 
-- 
2.4.3
