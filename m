From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] blkcg, memcg: make blkcg depend on memcg on the default hierarchy
Date: Fri, 27 Jun 2014 21:03:12 -0400
Message-ID: <1403917392-32555-7-git-send-email-tj@kernel.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CAe7fDg9qO/Hg6aL1huLxT4q8dANWD/ZT1N3Afx5InI=;
        b=X+dxyUT+cXVqSfRdm7fiGC1g2e6Mr/y+suY29TT3yja/v5GsOx3WYxO/FzwLf7ogBP
         87V13aXUR7UbLOdXW+Ft7s3AtPzX8fuFk7VbollLW1XRgK6nDsuikAweybQU0ifSc30U
         ttVMvACERKkIwnEWvM+3ohQFr8G9WUUF2H6dD/h1eFKd6NWERCXUYTH+0Q7N630T/UrM
         oKZQQXFHqiqctFhnSAEIt0JrdSPsbDy3MIhGuAwryPxsZMIsrfoxJBg754rKKmOLBy1x
         zXRbuyt7ZLYp3+Vy0af9C+8G3Rm4cgwwknqGy1b0k94zj3+snhcl4Xlbkz1E6FV+Bl9u
         Z/NQ==
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk, Tejun Heo <tj@kernel.org>

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

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c |  7 +++++++
 mm/memcontrol.c    | 24 ++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 069bc20..c9f7547 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -925,6 +925,13 @@ struct cgroup_subsys blkio_cgrp_subsys = {
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
 	.base_cftypes = blkcg_files,
+
+	/*
+	 * This ensures that, if available, memcg is automatically enabled
+	 * together on the default hierarchy so that the owner cgroup can
+	 * be retrieved from writeback pages.
+	 */
+	.depends_on = 1 << memory_cgrp_id,
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
