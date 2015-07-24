From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/10] blkcg: separate out tg_conf_updated() from tg_set_conf()
Date: Fri, 24 Jul 2015 14:43:52 -0400
Message-ID: <1437763434-28699-9-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=k9SSG2KN0yb9UVo8a+LY7y+qydxZX/MR0Yk83+LOpnk=;
        b=bcAcJoEDYfeHkfeAZeZRFFa78ImQGJxC7x0ODdYiCLnbHHGUlOUl005zkTnf1CM4gg
         Txb6mbUA2ZreEFbK/BuMmsdOpLolKsS91cHi+jd5d/aags3e45ymVHPLPHZMTBzRb3Vz
         sBIIDQNh4gI8YQAGIoZs/Jn/nlu2H1wK66cAVOPj0z5Uyvo4yHo+DPLJXtWqOsku8KKS
         GrV8FdBNRDFkdvzwPHrlfJQXeTLgy/Wu2fOjAdGONPQ2dsRaa7i+ZlgYmOtXaiuf/fG8
         KeoYrznOd0/oCKmmbUXTABqb6CmLcw0s4IZ8TKVPSgp7iA6am8SD/6xQmaRzObWWNx8/
         c10A==
In-Reply-To: <1437763434-28699-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

tg_set_conf() is largely consisted of parsing and setting the new
config and the follow-up application and propagation.  This patch
separates out the latter part into tg_conf_updated().  This will be
used to implement interface for the unified hierarchy.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 60 ++++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0e17c8f..a8bb2fd 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1144,35 +1144,11 @@ static int tg_print_conf_uint(struct seq_file *sf, void *v)
 	return 0;
 }
 
-static ssize_t tg_set_conf(struct kernfs_open_file *of,
-			   char *buf, size_t nbytes, loff_t off, bool is_u64)
+static void tg_conf_updated(struct throtl_grp *tg)
 {
-	struct blkcg *blkcg = css_to_blkcg(of_css(of));
-	struct blkg_conf_ctx ctx;
-	struct throtl_grp *tg;
-	struct throtl_service_queue *sq;
-	struct blkcg_gq *blkg;
+	struct throtl_service_queue *sq = &tg->service_queue;
 	struct cgroup_subsys_state *pos_css;
-	int ret;
-	u64 v;
-
-	ret = blkg_conf_prep(blkcg, &blkcg_policy_throtl, buf, &ctx);
-	if (ret)
-		return ret;
-
-	ret = -EINVAL;
-	if (sscanf(ctx.body, "%llu", &v) != 1)
-		goto out_finish;
-	if (!v)
-		v = -1;
-
-	tg = blkg_to_tg(ctx.blkg);
-	sq = &tg->service_queue;
-
-	if (is_u64)
-		*(u64 *)((void *)tg + of_cft(of)->private) = v;
-	else
-		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
+	struct blkcg_gq *blkg;
 
 	throtl_log(&tg->service_queue,
 		   "limit change rbps=%llu wbps=%llu riops=%u wiops=%u",
@@ -1186,7 +1162,7 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	 * restrictions in the whole hierarchy and allows them to bypass
 	 * blk-throttle.
 	 */
-	blkg_for_each_descendant_pre(blkg, pos_css, ctx.blkg)
+	blkg_for_each_descendant_pre(blkg, pos_css, tg_to_blkg(tg))
 		tg_update_has_rules(blkg_to_tg(blkg));
 
 	/*
@@ -1204,7 +1180,35 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 		tg_update_disptime(tg);
 		throtl_schedule_next_dispatch(sq->parent_sq, true);
 	}
+}
+
+static ssize_t tg_set_conf(struct kernfs_open_file *of,
+			   char *buf, size_t nbytes, loff_t off, bool is_u64)
+{
+	struct blkcg *blkcg = css_to_blkcg(of_css(of));
+	struct blkg_conf_ctx ctx;
+	struct throtl_grp *tg;
+	int ret;
+	u64 v;
+
+	ret = blkg_conf_prep(blkcg, &blkcg_policy_throtl, buf, &ctx);
+	if (ret)
+		return ret;
+
+	ret = -EINVAL;
+	if (sscanf(ctx.body, "%llu", &v) != 1)
+		goto out_finish;
+	if (!v)
+		v = -1;
+
+	tg = blkg_to_tg(ctx.blkg);
+
+	if (is_u64)
+		*(u64 *)((void *)tg + of_cft(of)->private) = v;
+	else
+		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
 
+	tg_conf_updated(tg);
 	ret = 0;
 out_finish:
 	blkg_conf_finish(&ctx);
-- 
2.4.3
