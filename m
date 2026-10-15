Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE269519DEE
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064454; cv=none; b=B3f3tZ+e6FOe8FUM0WZ79hyTRKlG7OYB32+kxqhixpVFo6DxUdUsth1aF4WbNf1Cfs3WeGXguj4Ih7Siz+Jgb2X2rQ1bvC0QOVaTT+kSNtFLaK2IzTTVk4RldFvpPv3RiGx8mE+aghwyBh1CqhKW5SqmmBg8dNi3bl3HuitdLy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064454; c=relaxed/simple;
	bh=KpZtVcE0e93c8SSc9s2GJpU+FeKJqfZm1yKTRBZwwoM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kJ1Ii6k1AXAOOO+syokQjkBnvZmgTJLDpJGJoU8kfpuv9dRjCC/p/cyGwa2pWuxBSfNk7USKkN86ykXMhVSUQmuCtIn1ptQi8W981XeT0xR84PDd9KTizchegxRNiosan9XCcuIJ897+2yxJj6j/Qzpcfs6k4fb1TKx+bPvgdRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=ED7E6pCD; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="ED7E6pCD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1792064448;
	bh=RzdjeW3U5iYSc9UlhhANALmazAl1WFbkgMQQE/uB9R8=;
	b=ED7E6pCDZ9E3NddvBkiDAeRfFDhwRevyv0sk27ZIeeVlEWk0eLvzEqHVN88Y0Wl2+Y9X
	h9D8JDY64TOlmWw+ThcLUM8/7bKkHqvOk3K4dyk7euRc+0c8/bZTboGkVWiL90erFVCg84
	7ZeSc1aikEoiq8eyL8bcljyxO8lmGOFIQsMEZ1Q66RfN+NlmclAcpbfOQXoEzbAggO37XT
	7X40YZcwcITshnjdu35P1pE1uGnrdtEZ4tNLWdj2gKqHoZzrhQlttB7Qn6CsG7AyDRRkGc
	3KvgxasnmcuTrUQM2F9aowKcOFC1MdLowV5FWs14f/zX0MWZ5MliGjtLvpAWjo4w==
Received: by recvd-569578f769-lx66h with SMTP id recvd-569578f769-lx66h-1-6AD0BBBF-97
	2026-10-15 11:40:47.887096221 +0000 UTC m=+1363195.448437516
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-34 (SG) with ESMTP
	id LoJ_VN_dSUO18XbpkEy_-w
	Thu, 15 Oct 2026 11:40:47.815 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 15 Oct 2026 11:40:48 +0000 (UTC)
Subject: [PATCH v7 2/3] writeback: let foreign flushes reach dying cgwbs
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-wb-dying-cgwb-flush-v7-2-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12048; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=KpZtVcE0e93c8SSc9s2GJpU+FeKJqfZm1yKTRBZwwoM=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBq0Lu8K/v4KoBE/vIKtWWmebyTaNtPOK8U4log0
 mRWfVnOvhOJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCatC7vAAKCRClztTjl62v
 wgTSCACPZ7/uHHXOtB3n/GcA6BvGlQxFAASYnD/C98Vlwej7JIVam/1bvLvaecEVbGyRt4T2ptf
 YV9Rku3DFB47t01Ht54ZWTpqOD+rAZz5y5mPQdDwhmzpOmjM0XqLgat6vh4YC+Bm2L58RKtJjGG
 OQSfnWVp9P2jZqMob+p4RbLNCmarh2iC+1mm0w7tjPFY5ZPfw8Dn2S0ldWi11ZPho5EeC2hm585
 sa2QO6k29xX4zZkSf2m+zFkUas7LRYRJJdLHNKZhlCWaPpdypVglot402q+ZVSODaHrTBN0iJk5
 6a9FqrvTGmi9ySG8SNldFFkmrwEx/VES0Z348YpbezOLvh3j
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeZ0YSzsY9DTf?=
 =?us-ascii?Q?DvVSKj0dU7yEZMF2m9tZskb8d+oJwMDVHdcKQuF?=
 =?us-ascii?Q?oh3Ja7OflLxlUUz0KeHuplAH0tbgy+V5MjWOd8g?=
 =?us-ascii?Q?PBAP38jZO0QkDWBsbI=2FWmdh6vmdmFquOryTvnyC?=
 =?us-ascii?Q?LAQE7IYm5FtlgglOriB8fUrPObb3b6RdmdbAlYY?= =?us-ascii?Q?SpoY?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==

When a container is replaced and the new one keeps appending to files
the old one left dirty, the new one can stall in balance_dirty_pages()
for seconds to minutes, with little CPU use and its write lag growing
linearly before it recovers. This matches a 30-60s stall after each
deploy of a container at Honeycomb that reads from Kafka and writes
columnar files to a host volume.

Trigger: a cgroup dirties files and is removed while they are still
dirty, and a sibling keeps appending to the same files under a parent
memory limit. cgwb_kill() takes the removed memcg's wbs out of
bdi->cgwb_tree, but the inodes stay attached to them, so the sibling's
foreign flushes fail with -ENOENT in wb_get_lookup().

Keep killed wbs in bdi->cgwb_tree until they are released, so that
cgroup_writeback_by_id() finds them through the regular lookup. The
creation paths skip dying wbs, and a new wb takes over the slot of a
dying one when the memcg's blkcg association changes; release only
removes a wb that still owns its slot. The blkcg association check moves
from wb_get_lookup() to the creation side: once a memcg with io enabled
is removed, cgroup_get_e_css() returns an ancestor's io css and its
dying wb would not match.

With commit 168a8c13159c ("writeback: size foreign flushes by target
wb dirty pages"), the flush is then sized from the wb's own dirty
pages and writes out what the replacement dirtied.

Test, on top of that commit: a cgroup appends to 1000 files at
250MiB/s and is removed, then a second cgroup keeps appending to the
same files under a 4G parent limit. Worst lag of the second writer
behind schedule over 120s, in three runs:

  without this patch   85.3s  46.9s  52.1s
  with this patch       1.0s   1.2s   1.2s

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 include/linux/backing-dev-defs.h | 22 ++++++++--
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 90 ++++++++++++++++++++++++++++++----------
 3 files changed, 86 insertions(+), 28 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4f1084937315..33e06b1b1e1c 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -100,8 +100,10 @@ struct wb_completion {
  * refcounted with the number of inodes attached to it, and pins the memcg
  * and the corresponding blkcg.  As the corresponding blkcg for a memcg may
  * change as blkcg is disabled and enabled higher up in the hierarchy, a wb
- * is tested for blkcg after lookup and removed from index on mismatch so
- * that a new wb for the combination can be created.
+ * is tested for blkcg after lookup and killed on mismatch so that a new wb
+ * for the combination can be created.  A killed wb stays in the index until
+ * it is released or a new wb takes over its slot, so that foreign flushes
+ * can still reach it.
  *
  * Each bdi_writeback that is not embedded into the backing_dev_info must hold
  * a reference to the parent backing_dev_info.  See cgwb_create() for details.
@@ -196,7 +198,7 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
-	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
+	struct radix_tree_root cgwb_tree; /* radix tree of cgroup wbs, incl. killed */
 	struct mutex cgwb_release_mutex;  /* protect shutdown of wb structs */
 	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
 #endif
@@ -229,6 +231,17 @@ static inline bool wb_tryget(struct bdi_writeback *wb)
 	return true;
 }
 
+/**
+ * wb_tryget_live - try to increment a wb's refcount if it hasn't been killed
+ * @wb: bdi_writeback to get
+ */
+static inline bool wb_tryget_live(struct bdi_writeback *wb)
+{
+	if (wb != &wb->bdi->wb)
+		return percpu_ref_tryget_live(&wb->refcnt);
+	return true;
+}
+
 /**
  * wb_get - increment a wb's refcount
  * @wb: bdi_writeback to get
@@ -271,7 +284,8 @@ static inline void wb_put(struct bdi_writeback *wb)
  * wb_dying - is a wb dying?
  * @wb: bdi_writeback of interest
  *
- * Returns whether @wb is unlinked and being drained.
+ * Returns whether @wb has been killed and is being drained.  A dying wb may
+ * still be in bdi->cgwb_tree, see cgwb_kill().
  */
 static inline bool wb_dying(struct bdi_writeback *wb)
 {
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c2284466e7aa..f7ef5895625a 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -222,7 +222,7 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
 
 	rcu_read_lock();
 	wb = wb_find_current(bdi);
-	if (wb && unlikely(!wb_tryget(wb)))
+	if (wb && unlikely(!wb_tryget_live(wb)))
 		wb = NULL;
 	rcu_read_unlock();
 
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cecbcf9060a6..85b2c95a920c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -614,6 +614,12 @@ static void cgwb_release_workfn(struct work_struct *work)
 						release_work);
 	struct backing_dev_info *bdi = wb->bdi;
 
+	scoped_guard(spinlock_irq, &cgwb_lock) {
+		/* a newer wb may have taken the slot, see cgwb_create() */
+		radix_tree_delete_item(&bdi->cgwb_tree, wb->memcg_css->id, wb);
+		list_del(&wb->offline_node);
+	}
+
 	mutex_lock(&wb->bdi->cgwb_release_mutex);
 	wb_shutdown(wb);
 
@@ -627,10 +633,6 @@ static void cgwb_release_workfn(struct work_struct *work)
 
 	fprop_local_destroy_percpu(&wb->memcg_completions);
 
-	spin_lock_irq(&cgwb_lock);
-	list_del(&wb->offline_node);
-	spin_unlock_irq(&cgwb_lock);
-
 	wb_exit(wb);
 	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
@@ -645,11 +647,16 @@ static void cgwb_release(struct percpu_ref *refcnt)
 	queue_work(cgwb_release_wq, &wb->release_work);
 }
 
+/*
+ * A killed wb stays in bdi->cgwb_tree until it is released or replaced in
+ * cgwb_create(), so that foreign flushes can still find it through
+ * wb_get_lookup().  Inodes attached to it can keep collecting dirty pages
+ * from other memcgs until they are written back and switched away.
+ */
 static void cgwb_kill(struct bdi_writeback *wb)
 {
 	lockdep_assert_held(&cgwb_lock);
 
-	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
 	list_del(&wb->memcg_node);
 	list_del(&wb->blkcg_node);
 	list_add(&wb->offline_node, &offline_cgwbs);
@@ -669,7 +676,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	struct mem_cgroup *memcg;
 	struct cgroup_subsys_state *blkcg_css;
 	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
-	struct bdi_writeback *wb;
+	struct bdi_writeback *wb, *old_wb;
+	void __rcu **slot;
 	unsigned long flags;
 	int ret = 0;
 
@@ -681,6 +689,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	/* look up again under lock and discard on blkcg mismatch */
 	spin_lock_irqsave(&cgwb_lock, flags);
 	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	if (wb && wb_dying(wb))
+		wb = NULL;
 	if (wb && wb->blkcg_css != blkcg_css) {
 		cgwb_kill(wb);
 		wb = NULL;
@@ -727,8 +737,22 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	spin_lock_irqsave(&cgwb_lock, flags);
 	if (test_bit(WB_registered, &bdi->wb.state) &&
 	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
-		/* we might have raced another instance of this function */
-		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
+		/*
+		 * We might have raced another instance of this function.  A
+		 * dying wb keeps its slot until released; take it over.
+		 */
+		slot = radix_tree_lookup_slot(&bdi->cgwb_tree, memcg_css->id);
+		if (!slot) {
+			ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
+		} else {
+			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
+			if (wb_dying(old_wb)) {
+				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+				ret = 0;
+			} else {
+				ret = -EEXIST;
+			}
+		}
 		if (!ret) {
 			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
@@ -765,13 +789,27 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * @bdi: target bdi
  * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
  *
- * Try to get the wb for @memcg_css on @bdi.  The returned wb has its
- * refcount incremented.
- *
- * This function uses css_get() on @memcg_css and thus expects its refcnt
- * to be positive on invocation.  IOW, rcu_read_lock() protection on
- * @memcg_css isn't enough.  try_get it before calling this function.
- *
+ * Try to get the wb in @memcg_css's slot on @bdi, killed or not.  The
+ * returned wb has its refcount incremented.
+ */
+struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
+				    struct cgroup_subsys_state *memcg_css)
+{
+	struct bdi_writeback *wb;
+
+	if (!memcg_css->parent)
+		return &bdi->wb;
+
+	rcu_read_lock();
+	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	if (wb && !wb_tryget(wb))
+		wb = NULL;
+	rcu_read_unlock();
+
+	return wb;
+}
+
+/*
  * A wb is keyed by its associated memcg.  As blkcg implicitly enables
  * memcg on the default hierarchy, memcg association is guaranteed to be
  * more specific (equal or descendant to the associated blkcg) and thus can
@@ -783,8 +821,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * each lookup.  On mismatch, the existing wb is discarded and a new one is
  * created.
  */
-struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
-				    struct cgroup_subsys_state *memcg_css)
+static struct bdi_writeback *cgwb_get_live(struct backing_dev_info *bdi,
+					   struct cgroup_subsys_state *memcg_css)
 {
 	struct bdi_writeback *wb;
 
@@ -798,7 +836,7 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 
 		/* see whether the blkcg association has changed */
 		blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
-		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget(wb)))
+		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget_live(wb)))
 			wb = NULL;
 		css_put(blkcg_css);
 	}
@@ -813,8 +851,12 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
  * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
  * @gfp: allocation mask to use
  *
- * Try to get the wb for @memcg_css on @bdi.  If it doesn't exist, try to
- * create one.  See wb_get_lookup() for more details.
+ * Try to get the live wb for @memcg_css on @bdi.  If it doesn't exist, try
+ * to create one.  See cgwb_get_live() for more details.
+ *
+ * This function uses css_get() on @memcg_css and thus expects its refcnt
+ * to be positive on invocation.  IOW, rcu_read_lock() protection on
+ * @memcg_css isn't enough.  try_get it before calling this function.
  */
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css,
@@ -825,7 +867,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 	might_alloc(gfp);
 
 	do {
-		wb = wb_get_lookup(bdi, memcg_css);
+		wb = cgwb_get_live(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
 
 	return wb;
@@ -858,8 +900,10 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
 	WARN_ON(test_bit(WB_registered, &bdi->wb.state));
 
 	spin_lock_irq(&cgwb_lock);
-	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
-		cgwb_kill(*slot);
+	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0) {
+		if (!wb_dying(*slot))
+			cgwb_kill(*slot);
+	}
 	spin_unlock_irq(&cgwb_lock);
 
 	mutex_lock(&bdi->cgwb_release_mutex);

-- 
2.53.0

