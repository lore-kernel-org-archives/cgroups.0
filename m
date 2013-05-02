From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/31] blk-throttle: implement proper hierarchy support
Date: Wed,  1 May 2013 17:39:49 -0700
Message-ID: <1367455189-6957-32-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=Sc6+xcaOYgjKoKGTe8zNOEVRV+NAsqr1+ZMUW7hlT68=;
        b=V7PlDwOupEi+Mqo9IJ9JdbrcKuXSTyZOC95a7F9vCxsyIjUgCodaxm2zZKIZfSBPIL
         qR/eVbi+bYJ98RWDSz9rzEw7zLryQxPXNhD3CiqcYrz2HDmKBqD4KJu7jZQhmsJId8KI
         umrGBsTNHcHWOAwpfo/lWdZhnAnYe7USvPSyRgMVntzZMg/bmkBnN8F+Ylkzi64pXsef
         TBhsiFc569wRfVv6aIBpn22siBA/9Mq4vLQwCSkkg5x5FXWuJrYJyRbrdw0mNns8Y8A/
         3n9nZsRsXLbYdE1lm3mYryH0Csm9Wslb8CP1NcYkfKP4G7v+p7jbtNUfqWzSb3OPPUz5
         Dkbg==
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

With the recent updates, blk-throttle is finally ready for proper
hierarchy support.  Dispatching now honors service_queue->parent_sq
and propagates correctly.  The only thing missing is setting
->parent_sq correctly so that throtl_grp hierarchy matches the cgroup
hierarchy.

This patch updates throtl_pd_init() such that service_queues form the
same hierarchy as the cgroup hierarchy if sane_behavior is enabled.
As this concludes proper hierarchy support for blkcg, the shameful
.broken_hierarchy tag is removed from blkio_subsys.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 block/blk-cgroup.c     |  8 --------
 block/blk-throttle.c   | 21 ++++++++++++++++++++-
 include/linux/cgroup.h |  2 ++
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index af2ca27..8d9edc8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -911,14 +911,6 @@ struct cgroup_subsys blkio_subsys = {
 	.subsys_id = blkio_subsys_id,
 	.base_cftypes = blkcg_files,
 	.module = THIS_MODULE,
-
-	/*
-	 * blkio subsystem is utterly broken in terms of hierarchy support.
-	 * It treats all cgroups equally regardless of where they're
-	 * located in the hierarchy - all cgroups are treated as if they're
-	 * right below the root.  Fix it and remove the following.
-	 */
-	.broken_hierarchy = true,
 };
 EXPORT_SYMBOL_GPL(blkio_subsys);
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 970355e..fa3e237 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -271,9 +271,28 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_data *td = blkg->q->td;
+	struct throtl_service_queue *parent_sq;
 	unsigned long flags;
 
-	throtl_service_queue_init(&tg->service_queue, &td->service_queue);
+	/*
+	 * If sane_hierarchy is enabled, we switch to properly hierarchical
+	 * behavior where limits on a given throtl_grp are applied to the
+	 * whole subtree rather than just the group itself.  e.g. If 16M
+	 * read_bps limit is set on the root group, the whole system can't
+	 * exceed 16M for the device.
+	 *
+	 * If sane_hierarchy is not enabled, the broken flat hierarchy
+	 * behavior is retained where all throtl_grps are treated as if
+	 * they're all separate root groups right below throtl_data.
+	 * Limits of a group don't interact with limits of other groups
+	 * regardless of the position of the group in the hierarchy.
+	 */
+	parent_sq = &td->service_queue;
+
+	if (cgroup_sane_behavior(blkg->blkcg->css.cgroup) && blkg->parent)
+		parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
+
+	throtl_service_queue_init(&tg->service_queue, parent_sq);
 	RB_CLEAR_NODE(&tg->rb_node);
 	tg->td = td;
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c371888..3c5f780 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -271,6 +271,8 @@ enum {
 	 * - memcg: use_hierarchy is on by default and the cgroup file for
 	 *   the flag is not created.
 	 *
+	 * - blkcg: blk-throttle becomes properly hierarchical.
+	 *
 	 * The followings are planned changes.
 	 *
 	 * - release_agent will be disallowed once replacement notification
-- 
1.8.1.4
