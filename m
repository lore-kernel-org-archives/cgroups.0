Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B013DA7DB
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 19:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796940; cv=none; b=U6+3UHWQTGUfGY5Pj6ntlP/cYkuw6dur4QzHKXS20r4o9Fim3OR+pM4uxZgTZBnm4B3fJHmXsmZE6OcrkjbfAkkLy+Zxg7aIiOrjupXcr69gBWzahDpy4y9fIHIde1j9b7KdWp2/YWaCNoaZBn5TUXNaj6rqH9MbcPZUS+3SSnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796940; c=relaxed/simple;
	bh=jKrYWwk4onhmgmY5DmeqhqvtAbrL5u/RIlGh8+c8pyg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lu7fWLLAO7favMP7b1SczGeJTT7BnP19gn4rBZgAjr3kvoVzuAquc60GCm+rV9otIWA4ou5ProY6vPylsGRBF1CIwjrqCOT5tj8LKY764ERWct7SGjZmJaJJg9L+XdeALSnBzedwfY3/dlEh5a4KJ2vKJoeDkzHEW1wgrBraezE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=UWUOxSWc; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="UWUOxSWc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790796937;
	bh=RZNT40kMMmQsLfWsdnWmdKdkeVlJ/tQq17QZr/ljVmM=;
	b=UWUOxSWcJrpmQ5M0gk5NfNRpMI/f1rYFjOc8Pj5UMd4gZB/Da4n5JsgG0fpGG+J4hALa
	FLf903NJEVMkD0BfLjmFOxycMu6bu4+ScpB4bVIE/PZGIczGugkk/11L4u9TIQwLmvXBx/
	J1SldyZkZ6mC5VgmEdcwiVosfY5/j9qKYKWunJvbNhig6YFYMEFFkrLuUnsksJX0FumyaI
	awSRqHxEC/+75FfFeTWamOTBTkdAeVv0xfN6/5pvLI9Eo65RbRMS56hcqcV8kMEoEzJE8g
	FKmJRkwHMFHhpokUKSPrFgbeAHWbrIRfjZpPi3JDbNyiKWv40Byw6ZmmNb0PrTsw==
Received: by recvd-6cd5f4b4b8-8rsqc with SMTP id recvd-6cd5f4b4b8-8rsqc-1-6ABD6488-F4
	2026-09-30 19:35:36.891619089 +0000 UTC m=+95694.696487392
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-6 (SG) with ESMTP
	id P6Dj4YSyT_WDY3Gt71wefA
	Wed, 30 Sep 2026 19:35:36.848 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Wed, 30 Sep 2026 19:35:37 +0000 (UTC)
Subject: [PATCH v4 1/2] writeback: let foreign flushes reach dying cgwbs
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-wb-dying-cgwb-flush-v4-1-bde637803a96@honeycomb.io>
References: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
In-Reply-To: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11107; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=jKrYWwk4onhmgmY5DmeqhqvtAbrL5u/RIlGh8+c8pyg=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvWSIBVzHo5qdjRMPWTu+yKAV6CkqxWq68egAc
 XF2f8YAK7uJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar1kiAAKCRClztTjl62v
 wicSB/0bZq4NrYtmbCxzwKSyMY1OnYMWJQ3m30vnpgkkikBpd7OZGPmJdIdjGBxIFY1aNUeXgDO
 21wf+OubxOfzF4dD7Ppiia1nkGPgClnJi4Jbbd6vNbUztdUuEorZW7LPvFec/EvhnGn0ZNKvoWy
 mTSCgDv9haWg39qB/WkpRt2rqCLDIIsL10hB6dbCNpVkVfxxbo7AnmOMMI0MNDhRDM67o+SVyUp
 rHDiuwVKIdbepLUhnRzX/gQcAOHV2KQdo9J4d8+cPUceNuk4mX2ls3kh0mfjdIjScgxBbCj55by
 yvebik44STXbNP6tJ4u/Kjp+uIJQgXbMXIB/o/Gi5Twyj6KE
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmed02bYO7=2FYQC?=
 =?us-ascii?Q?ZivW1+V+v6u807eM5Q+nYN=2FH5UukAlUEFJYHhI9?=
 =?us-ascii?Q?bzyynNtLy1uiShXLFPtzy01jbqhfw+VrMJ2XlmC?=
 =?us-ascii?Q?6oKsOXEE4SJfNIGVQDdjk3czf1G2u14DtJo1Osy?=
 =?us-ascii?Q?dCFhgICqiNBw1p4KWxicj22yrgH2iY8TBEl0Cy2?= =?us-ascii?Q?uxms?=
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
dying one when a live memcg's blkcg association changes; release only
removes a wb that still owns its slot. cgwb_create() also refuses to
link a new wb for a dying memcg, so a removed memcg's dirty wb can't be
replaced before wb_memcg_offline() kills the new one. The blkcg
association check moves from wb_get_lookup() to the creation side: once
a memcg with io enabled is removed, cgroup_get_e_css() returns an
ancestor's io css and its dying wb would not match.

With commit 168a8c13159c ("writeback: size foreign flushes by target
wb dirty pages"), the flush is then sized from the wb's own dirty
pages and writes out what the replacement dirtied.

Test, on top of that commit: a cgroup appends to 1000 files at
250MiB/s and is removed, then a second cgroup keeps appending to the
same files under a 4G parent limit. Worst lag of the second writer
behind schedule over 120s, in three runs:

  without this patch   85.3s  46.9s  52.1s
  with this patch       1.0s   1.4s   1.0s

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 include/linux/backing-dev-defs.h | 13 +++++-
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 92 +++++++++++++++++++++++++++++++---------
 3 files changed, 84 insertions(+), 23 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 4f1084937315..035d25f5b81b 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -196,7 +196,7 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
-	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
+	struct radix_tree_root cgwb_tree; /* radix tree of cgroup wbs, incl. killed */
 	struct mutex cgwb_release_mutex;  /* protect shutdown of wb structs */
 	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
 #endif
@@ -229,6 +229,17 @@ static inline bool wb_tryget(struct bdi_writeback *wb)
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
index cecbcf9060a6..a370dd94b6a4 100644
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
@@ -726,9 +736,24 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	ret = -ENODEV;
 	spin_lock_irqsave(&cgwb_lock, flags);
 	if (test_bit(WB_registered, &bdi->wb.state) &&
-	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
-		/* we might have raced another instance of this function */
-		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
+	    blkcg_cgwb_list->next && memcg_cgwb_list->next &&
+	    !css_is_dying(memcg_css)) {
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
@@ -768,10 +793,29 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * Try to get the wb for @memcg_css on @bdi.  The returned wb has its
  * refcount incremented.
  *
- * This function uses css_get() on @memcg_css and thus expects its refcnt
- * to be positive on invocation.  IOW, rcu_read_lock() protection on
- * @memcg_css isn't enough.  try_get it before calling this function.
- *
+ * The wb may have been killed and its blkcg association may be stale.  This
+ * is what foreign flushes want: they target the wb that owns the dirty
+ * inodes, which can be a killed one.  Use wb_get_create() to get a wb to
+ * attach inodes to.
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
@@ -782,9 +826,13 @@ static int cgwb_create(struct backing_dev_info *bdi,
  * both the memcg and blkcg associated with it and verifies the blkcg on
  * each lookup.  On mismatch, the existing wb is discarded and a new one is
  * created.
+ *
+ * This function uses css_get() on @memcg_css and thus expects its refcnt
+ * to be positive on invocation.  IOW, rcu_read_lock() protection on
+ * @memcg_css isn't enough.  try_get it before calling this function.
  */
-struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
-				    struct cgroup_subsys_state *memcg_css)
+static struct bdi_writeback *cgwb_get_live(struct backing_dev_info *bdi,
+					   struct cgroup_subsys_state *memcg_css)
 {
 	struct bdi_writeback *wb;
 
@@ -798,7 +846,7 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 
 		/* see whether the blkcg association has changed */
 		blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
-		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget(wb)))
+		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget_live(wb)))
 			wb = NULL;
 		css_put(blkcg_css);
 	}
@@ -813,8 +861,8 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
  * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
  * @gfp: allocation mask to use
  *
- * Try to get the wb for @memcg_css on @bdi.  If it doesn't exist, try to
- * create one.  See wb_get_lookup() for more details.
+ * Try to get the live wb for @memcg_css on @bdi.  If it doesn't exist, try
+ * to create one.  See cgwb_get_live() for more details.
  */
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css,
@@ -825,7 +873,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 	might_alloc(gfp);
 
 	do {
-		wb = wb_get_lookup(bdi, memcg_css);
+		wb = cgwb_get_live(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
 
 	return wb;
@@ -858,8 +906,10 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
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

