From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 6/6] blkcg, memcg: make blkcg depend on memcg on the
 default hierarchy
Date: Sat, 28 Jun 2014 07:49:07 -0400
Message-ID: <20140628114907.GA10829@htj.dyndns.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
 <1403917392-32555-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pbAQpmWMHbBoK1aMK4zu62Ku6pGlHBkv+uO2NMAd1Pk=;
        b=rWNr5OG3NfbOL6cHxLv+SH9SMC0WqnUOerW4dnG0RbdzWSkvacZuwMlvohkcwHC3jn
         1+WDvwiLKeu8IP/hEsbF9Rc+Sp6vEVgEkMu3aTHudRT41sicDz+mPshx6cWzxOZGbBHc
         KnVWDeqgbXQdrgj7qgl6+TY5k9VekW+prtdME+t+EWUXO/eG+5i9hHZwVE8mXXSYv/fh
         gx7h+ioRtEHbi51tK1/p4l0eKeGZ5xwn/MKjoi/jyteLfpuGqaO+Gm436wjrNTIw2Ra6
         WQANN4zroSa1RY7PK+KivDdB32RN6/H9nr7xw7mI/HvbEDCmbzhjKXyppvPkIkdNLBII
         pVNA==
Content-Disposition: inline
In-Reply-To: <1403917392-32555-7-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

From 8e67ad03ab03839456816e922c57a7ab3bcf5474 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Sat, 28 Jun 2014 07:47:57 -0400

Currently, the blkio subsystem attributes all of writeback IOs to the
root.  One of the issues is that there's no way to tell who originated
a writeback IO from block layer.  Those IOs are usually issued
asynchronously from a task which didn't have anything to do with
actually generating the dirty pages.  The memory subsystem, when
enabled, already keeps track of the ownership of each dirty page and
it's desirable for blkio to piggyback instead of adding its own
per-page tag.

cgroup now has a mechanism to express such dependency -
cgroup_subsys->depends_on.  This patch declares that blkcg depends on
memcg so that memcg is enabled automatically on the default hierarchy
when available.  Future changes will make blkcg map the memcg tag to
find out the cgroup to blame for writeback IOs.

As this means that a memcg may be made invisible, this patch also
implements css_reset() for memcg which resets its basic
configurations.  This implementation will probably need to be expanded
to cover other states which are used in the default hierarchy.

v2: blkcg's dependency on memcg is wrapped with CONFIG_MEMCG to avoid
    build failure.  Reported by kbuild test robot.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
---
 block/blk-cgroup.c |  8 ++++++++
 mm/memcontrol.c    | 24 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 069bc20..63c3cd4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -925,6 +925,14 @@ struct cgroup_subsys blkio_cgrp_subsys = {
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
 	.base_cftypes = blkcg_files,
+#ifdef CONFIG_MEMCG
+	/*
+	 * This ensures that, if available, memcg is automatically enabled
+	 * together on the default hierarchy so that the owner cgroup can
+	 * be retrieved from writeback pages.
+	 */
+	.depends_on = 1 << memory_cgrp_id,
+#endif
 };
 EXPORT_SYMBOL_GPL(blkio_cgrp_subsys);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a2c7bcb..db536e9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6407,6 +6407,29 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	__mem_cgroup_free(memcg);
 }
 
+/**
+ * mem_cgroup_css_reset - reset the states of a mem_cgroup
+ * @css: the target css
+ *
+ * Reset the states of the mem_cgroup associated with @css.  This is
+ * invoked when the userland requests disabling on the default hierarchy
+ * but the memcg is pinned through dependency.  The memcg should stop
+ * applying policies and should revert to the vanilla state as it may be
+ * made visible again.
+ *
+ * The current implementation only resets the essential configurations.
+ * This needs to be expanded to cover all the visible parts.
+ */
+static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	mem_cgroup_resize_limit(memcg, ULLONG_MAX);
+	mem_cgroup_resize_memsw_limit(memcg, ULLONG_MAX);
+	memcg_update_kmem_limit(memcg, ULLONG_MAX);
+	res_counter_set_soft_limit(&memcg->res, ULLONG_MAX);
+}
+
 #ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
 #define PRECHARGE_COUNT_AT_ONCE	256
@@ -7019,6 +7042,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
 	.css_online = mem_cgroup_css_online,
 	.css_offline = mem_cgroup_css_offline,
 	.css_free = mem_cgroup_css_free,
+	.css_reset = mem_cgroup_css_reset,
 	.can_attach = mem_cgroup_can_attach,
 	.cancel_attach = mem_cgroup_cancel_attach,
 	.attach = mem_cgroup_move_task,
-- 
1.9.3
