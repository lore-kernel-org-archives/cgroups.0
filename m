From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/10] blkcg: mark existing cftypes as legacy
Date: Fri, 24 Jul 2015 14:43:50 -0400
Message-ID: <1437763434-28699-7-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Kgo2W//SVwzhwFhwylY6olsCpfU4mhXFfmLfkhvof9k=;
        b=ReWNSJRSNGI7N0HgMQt9WCQAc4qmwgqj++az1D846xF0cKqE7U2jJz9JuCRG/ORtjZ
         J/T+34SYFo2EDnGL3AcMd6vwxW4TnnOm+v6xi4K+3EX60YtzkwAewdEXxP2qMMQ6l19A
         OC7z9VfL3h7YuhYCXLBX9jgphWn0xkTFspI5R24ZItpfHrtUfa55lbmQklI6I0ZtWEvV
         rYOu2Vk65EkTlirg0/30V9MgiHXtlbX/BuvpVAIc930uPy75gXS0ev3MNQlYxu5bxsCK
         LvT2oYG2QNGHBfRAkJhSdAAAQLcocaE+LDDfo+vyrx47R/uPsxUrNWb2JDzsCxiIpFqn
         u+qA==
In-Reply-To: <1437763434-28699-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

blkcg is about to grow interface for the unified hierarchy.  Add
legacy to existing cftypes.

* blkcg_policy->cftypes -> blkcg_policy->legacy_cftypes
* blk-cgroup.c:blkcg_files -> blkcg_legacy_files
* cfq-iosched.c:cfq_blkcg_files -> cfq_blkcg_legacy_files
* blk-throttle.c:throtl_files -> throtl_legacy_files

Pure renames.  No functional change.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-cgroup.c         | 12 ++++++------
 block/blk-throttle.c       |  4 ++--
 block/cfq-iosched.c        |  4 ++--
 include/linux/blk-cgroup.h |  2 +-
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c2fb867..db7b3cc 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -847,7 +847,7 @@ void blkg_conf_finish(struct blkg_conf_ctx *ctx)
 }
 EXPORT_SYMBOL_GPL(blkg_conf_finish);
 
-struct cftype blkcg_files[] = {
+struct cftype blkcg_legacy_files[] = {
 	{
 		.name = "reset_stats",
 		.write_u64 = blkcg_reset_stats,
@@ -1093,7 +1093,7 @@ struct cgroup_subsys io_cgrp_subsys = {
 	.css_offline = blkcg_css_offline,
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
-	.legacy_cftypes = blkcg_files,
+	.legacy_cftypes = blkcg_legacy_files,
 	.legacy_name = "blkio",
 #ifdef CONFIG_MEMCG
 	/*
@@ -1264,9 +1264,9 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 	mutex_unlock(&blkcg_pol_mutex);
 
 	/* everything is in place, add intf files for the new policy */
-	if (pol->cftypes)
+	if (pol->legacy_cftypes)
 		WARN_ON(cgroup_add_legacy_cftypes(&io_cgrp_subsys,
-						  pol->cftypes));
+						  pol->legacy_cftypes));
 	mutex_unlock(&blkcg_pol_register_mutex);
 	return 0;
 
@@ -1303,8 +1303,8 @@ void blkcg_policy_unregister(struct blkcg_policy *pol)
 		goto out_unlock;
 
 	/* kill the intf files first */
-	if (pol->cftypes)
-		cgroup_rm_cftypes(pol->cftypes);
+	if (pol->legacy_cftypes)
+		cgroup_rm_cftypes(pol->legacy_cftypes);
 
 	/* remove cpds and unregister */
 	mutex_lock(&blkcg_pol_mutex);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index bd3e4b2..8b4f6b8 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1217,7 +1217,7 @@ static ssize_t tg_set_conf_uint(struct kernfs_open_file *of,
 	return tg_set_conf(of, buf, nbytes, off, false);
 }
 
-static struct cftype throtl_files[] = {
+static struct cftype throtl_legacy_files[] = {
 	{
 		.name = "throttle.read_bps_device",
 		.private = offsetof(struct throtl_grp, bps[READ]),
@@ -1263,7 +1263,7 @@ static void throtl_shutdown_wq(struct request_queue *q)
 }
 
 static struct blkcg_policy blkcg_policy_throtl = {
-	.cftypes		= throtl_files,
+	.legacy_cftypes		= throtl_legacy_files,
 
 	.pd_alloc_fn		= throtl_pd_alloc,
 	.pd_init_fn		= throtl_pd_init,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 38277e3..baa8459 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1944,7 +1944,7 @@ static int cfqg_print_avg_queue_size(struct seq_file *sf, void *v)
 }
 #endif	/* CONFIG_DEBUG_BLK_CGROUP */
 
-static struct cftype cfq_blkcg_files[] = {
+static struct cftype cfq_blkcg_legacy_files[] = {
 	/* on root, weight is mapped to leaf_weight */
 	{
 		.name = "weight_device",
@@ -4654,7 +4654,7 @@ static struct elevator_type iosched_cfq = {
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static struct blkcg_policy blkcg_policy_cfq = {
-	.cftypes		= cfq_blkcg_files,
+	.legacy_cftypes		= cfq_blkcg_legacy_files,
 
 	.cpd_alloc_fn		= cfq_cpd_alloc,
 	.cpd_init_fn		= cfq_cpd_init,
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index db89acd..6e016e6 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -148,7 +148,7 @@ typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkg_policy_data *pd);
 struct blkcg_policy {
 	int				plid;
 	/* cgroup files for the policy */
-	struct cftype			*cftypes;
+	struct cftype			*legacy_cftypes;
 
 	/* operations */
 	blkcg_pol_alloc_cpd_fn		*cpd_alloc_fn;
-- 
2.4.3
