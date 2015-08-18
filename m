From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 38/45] blkcg: rename subsystem name from blkio to io
Date: Tue, 18 Aug 2015 14:55:29 -0700
Message-ID: <1439934936-6738-39-git-send-email-tj@kernel.org>
References: <1439934936-6738-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ahp5ISBgB1Ke7rcgO3x3ZknnNBl5yxjxdbilk9xSOBc=;
        b=QpKWSSCiU3oKyhbEbyqv7I1yRhN1AKh5KKtpCbG3So8njQ2c4YbogrYQqc03rXckhX
         Zt7fvytMexbuXaOQ+3z6xZKM+esnZv6VfQfStNqcD3eQPZelPYM+8zXL8n/iWm18hiDn
         0lEHSYamAby30Ptj1exCKt7opS8LERhycDmFvnbYh/hQ2Mg06Nd1JoeEbeM6MjSS1hkF
         7w4uf53L4eJVWZkZ6YIPy2VbXTyqQpWwwpk5MPPTqRh3FZ9gIizbO+VgewslJ2zeOFAC
         moVUnBdzsVRuPVqq9SqjfXrYbOMU06/y++RwhemPckGTZ7UrMiMR9iPuFbYqTWaISy++
         yyQw==
In-Reply-To: <1439934936-6738-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

blkio interface has become messy over time and is currently the
largest.  In addition to the inconsistent naming scheme, it has
multiple stat files which report more or less the same thing, a number
of debug stat files which expose internal details which shouldn't have
been part of the public interface in the first place, recursive and
non-recursive stats and leaf and non-leaf knobs.

Both recursive vs. non-recursive and leaf vs. non-leaf distinctions
don't make any sense on the unified hierarchy as only leaf cgroups can
contain processes.  cgroups is going through a major interface
revision with the unified hierarchy involving significant fundamental
usage changes and given that a significant portion of the interface
doesn't make sense anymore, it's a good time to reorganize the
interface.

As the first step, this patch renames the external visible subsystem
name from "blkio" to "io".  This is more concise, matches the other
two major subsystem names, "cpu" and "memory", and better suited as
blkcg will be involved in anything writeback related too whether an
actual block device is involved or not.

As the subsystem legacy_name is set to "blkio", the only userland
visible change outside the unified hierarchy is that blkcg is reported
as "io" instead of "blkio" in the subsystem initialized message during
boot.  On the unified hierarchy, blkcg now appears as "io".

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 block/bio.c                   | 2 +-
 block/blk-cgroup.c            | 7 ++++---
 include/linux/backing-dev.h   | 2 +-
 include/linux/blk-cgroup.h    | 4 ++--
 include/linux/cgroup_subsys.h | 2 +-
 mm/backing-dev.c              | 4 ++--
 6 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index d6e5ba3..c52222c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2046,7 +2046,7 @@ int bio_associate_current(struct bio *bio)
 
 	get_io_context_active(ioc);
 	bio->bi_ioc = ioc;
-	bio->bi_css = task_get_css(current, blkio_cgrp_id);
+	bio->bi_css = task_get_css(current, io_cgrp_id);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(bio_associate_current);
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0af3bff..fc197ea 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1089,12 +1089,13 @@ static int blkcg_can_attach(struct cgroup_subsys_state *css,
 	return ret;
 }
 
-struct cgroup_subsys blkio_cgrp_subsys = {
+struct cgroup_subsys io_cgrp_subsys = {
 	.css_alloc = blkcg_css_alloc,
 	.css_offline = blkcg_css_offline,
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
 	.legacy_cftypes = blkcg_files,
+	.legacy_name = "blkio",
 #ifdef CONFIG_MEMCG
 	/*
 	 * This ensures that, if available, memcg is automatically enabled
@@ -1104,7 +1105,7 @@ struct cgroup_subsys blkio_cgrp_subsys = {
 	.depends_on = 1 << memory_cgrp_id,
 #endif
 };
-EXPORT_SYMBOL_GPL(blkio_cgrp_subsys);
+EXPORT_SYMBOL_GPL(io_cgrp_subsys);
 
 /**
  * blkcg_activate_policy - activate a blkcg policy on a request_queue
@@ -1266,7 +1267,7 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 
 	/* everything is in place, add intf files for the new policy */
 	if (pol->cftypes)
-		WARN_ON(cgroup_add_legacy_cftypes(&blkio_cgrp_subsys,
+		WARN_ON(cgroup_add_legacy_cftypes(&io_cgrp_subsys,
 						  pol->cftypes));
 	mutex_unlock(&blkcg_pol_register_mutex);
 	return 0;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 23ebb94..5a5d79e 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -286,7 +286,7 @@ static inline struct bdi_writeback *wb_find_current(struct backing_dev_info *bdi
 	 * %current's blkcg equals the effective blkcg of its memcg.  No
 	 * need to use the relatively expensive cgroup_get_e_css().
 	 */
-	if (likely(wb && wb->blkcg_css == task_css(current, blkio_cgrp_id)))
+	if (likely(wb && wb->blkcg_css == task_css(current, io_cgrp_id)))
 		return wb;
 	return NULL;
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 286e1bd..db89acd 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -221,7 +221,7 @@ static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
 
 static inline struct blkcg *task_blkcg(struct task_struct *tsk)
 {
-	return css_to_blkcg(task_css(tsk, blkio_cgrp_id));
+	return css_to_blkcg(task_css(tsk, io_cgrp_id));
 }
 
 static inline struct blkcg *bio_blkcg(struct bio *bio)
@@ -234,7 +234,7 @@ static inline struct blkcg *bio_blkcg(struct bio *bio)
 static inline struct cgroup_subsys_state *
 task_get_blkcg_css(struct task_struct *task)
 {
-	return task_get_css(task, blkio_cgrp_id);
+	return task_get_css(task, io_cgrp_id);
 }
 
 /**
diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index e4a96fb..86b5056 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -16,7 +16,7 @@ SUBSYS(cpuacct)
 #endif
 
 #if IS_ENABLED(CONFIG_BLK_CGROUP)
-SUBSYS(blkio)
+SUBSYS(io)
 #endif
 
 #if IS_ENABLED(CONFIG_MEMCG)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index dac5bf5..d0ee90e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -523,7 +523,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	int ret = 0;
 
 	memcg = mem_cgroup_from_css(memcg_css);
-	blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &blkio_cgrp_subsys);
+	blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
 	blkcg = css_to_blkcg(blkcg_css);
 	memcg_cgwb_list = mem_cgroup_cgwb_list(memcg);
 	blkcg_cgwb_list = &blkcg->cgwb_list;
@@ -645,7 +645,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 
 			/* see whether the blkcg association has changed */
 			blkcg_css = cgroup_get_e_css(memcg_css->cgroup,
-						     &blkio_cgrp_subsys);
+						     &io_cgrp_subsys);
 			if (unlikely(wb->blkcg_css != blkcg_css ||
 				     !wb_tryget(wb)))
 				wb = NULL;
-- 
2.4.3
