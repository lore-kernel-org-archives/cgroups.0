Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BAA457E77
	for <cgroups@vger.kernel.org>; Fri,  2 Oct 2026 21:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790977251; cv=none; b=mgibpnN6z2QtWVu8LgGjNTm8Wx323xy9GMyrZUOvfi5PUVBBuBp890aBrd26mPJgQMmPP3Mo2psasD4m2fAsKnVRosEkk1L1wr26AGexs3GS6du70HFcMwSVQA1HnTkIWufQ5Nk1eHlcVlb22qpbrNMIDZy8IYCHpa3+tuGvZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790977251; c=relaxed/simple;
	bh=TaJ96eAP9ZvlJaB/oaYWVShJw6soFhZ9A+v9EXM/oNY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QiD+tXsWO6UzON06KUdAim7IFuGSPiz/Q6Vyf4UjM5ASzMHu7bx+1gxLr2q/Ky8r1g8PidTdxQQ4FrKMAey5M/Jl2U4qre0OPR8MskSDfdGzlMNKwqdKlB3i3DIG8S03Px9lmTUeqVB/W5lyjVbEmJTWMDuUpppR7j18brQdLhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=Lt0bqQbO; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="Lt0bqQbO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790977248;
	bh=ZZSgt5MHbuMy96FzQg2jJF/fM32gw9HZvMthV0QC2tQ=;
	b=Lt0bqQbO6/KNQZXMY5tqp2c+/7d9//UPrABGd0DLwVqVwT7M0Z2HiAAZMS77aSO22kJU
	oaFewB9xEza0ggNsmJ/H93xIBqbeQYzHQB9tF8MxBoid8ZCAUy3IXUAyfidTR+RI1/ySUP
	lFQv83t/J1EbbFe+o9jxpbUOVno1T0AQNd7jijPbnNWvrxEHM7GK7ietBL5SskCfXePtUQ
	ISILRCrEyR5WwZFnQ8C1ASqzlyK09q1fEgiSHSFePf9ClS+JtiLpk5R+xB4cJoQ2vmXC+P
	hLlrxEIuDTruvW/UUN77eRXL79le548StuZ5jcoq0F3IYihzUnFb3lWaIAXiUIiA==
Received: by recvd-78f69d66c6-mmd9r with SMTP id recvd-78f69d66c6-mmd9r-1-6AC024DF-6B
	2026-10-02 21:40:47.860113864 +0000 UTC m=+276013.216322016
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-64 (SG) with ESMTP
	id CTqInHbbTPG47dSJ-QBv1g
	Fri, 02 Oct 2026 21:40:47.772 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Fri, 02 Oct 2026 21:40:48 +0000 (UTC)
Subject: [PATCH v6 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9387; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=TaJ96eAP9ZvlJaB/oaYWVShJw6soFhZ9A+v9EXM/oNY=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqwCTby7Jn8Y62NtDUeGteMNW2ahZB7chqxyg43
 KjdpdxBnf+JATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCasAk2wAKCRClztTjl62v
 wpDxCADMCHJ1aslZXLpWfRIPZogVFM1747z7vx5+5Tfh2m0glKx5JXiVIGGskRrRcGyRq0t4Edw
 O2QVAkxn5N8PdmUYYxel9+/ysHloERS0GbVuULUH3Ko9OgDWZnmCY6TFw/Wa6kbYQTSowGsDW7C
 PyuqcclCUP9dzqAW3f+TWnb9EVZU/4YJoBVUibb+nHLdgReMchhLTw7cnKKO3rO1MEJLe6z30ZG
 9gPOeDBg8t7f3+6VXK6/VnN1eFenUaq6GfYY4FXVkbBHEkKMJQtMGxkDExxvFBWYYXIJxCipFEW
 pYUKisbcQ7zhwuzrziVK//TQI3MO2DsfdQB/Gwcf0Ltb6yWw
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeXtG8KLSBU8C?=
 =?us-ascii?Q?7cAoK9L2NnThO7N+wBOB2U2au6QE7d=2FXSxMQxgY?=
 =?us-ascii?Q?+zHZ4gkxSr=2FsSvoRktmIfFH95O77u7SXULD6=2FBl?=
 =?us-ascii?Q?2JSkZVaHMOJYMDhTEs1nn+VpirPdUnf9VQdv+bN?=
 =?us-ascii?Q?bysvql8KWMbkBlalOuzlwND++bb8ecpJ3EsC9Xg?= =?us-ascii?Q?777o?=
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

When a live memcg's blkcg association changes, cgwb_create() replaces
its killed wb in bdi->cgwb_tree. Foreign flushes for the memcg then
find the new wb, but the inodes, dirty or not, are still attached to the
old one, and they only move over as they are written back (see
wbc_attach_and_unlock_inode()). Until then, other memcgs appending to
those inodes stall in balance_dirty_pages().

After the takeover, queue a work item that switches all of the old wb's
inodes to the wb foreign flushes now find, like cleanup_offline_cgwb()
does for b_attached and b_dirty_time, but including b_dirty, b_io and
b_more_io. The switch carries the dirty and writeback page counts, so
nothing needs to be written back first. cgwb_create() can run with
interrupts disabled (folio_account_dirtied() -> inode_attach_wb()), so
it only queues the work. A switch to the old wb that was queued before
it was replaced can land after the work ran, so
inode_switch_wbs_work_fn() queues the work again when the wb it switched
inodes to is dying and no longer owns its slot. An inode attached to the
old wb as it is replaced (see __inode_attach_wb()) still moves over only
when written back. If the successor is already gone, fall back like
cleanup_offline_cgwb() does, to the nearest live ancestor's wb or the
root wb.

Test: a live cgroup appends to 5000 files on XFS at 250MiB/s, io is
disabled on its parent so its wb is killed, it creates a file (the
takeover), and a sibling keeps appending to its files under a 4G parent
limit. Worst lag of the sibling behind schedule over 30s, in three runs:

  without this patch    9.1s   4.0s   1.0s
  with this patch       1.0s   1.1s   1.1s

Without this patch, moving the old wb's inodes over took up to 11s,
first switch to last; with it, all 5001 were switched in a 27-39ms
window, with up to 311MiB of the old cgroup's pages dirty.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c                | 61 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  1 +
 include/linux/backing-dev.h      |  1 +
 include/linux/writeback.h        |  1 +
 mm/backing-dev.c                 | 49 ++++++++++++++++++++++++++++++++
 5 files changed, 113 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 050d507aa554..7e80f3935dce 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -624,6 +624,8 @@ void inode_switch_wbs_work_fn(struct work_struct *work)
 
 	llist_for_each_entry_safe(isw, next_isw, list, list)
 		process_inode_switch_wbs(new_wb, isw);
+	/* @new_wb may have been replaced while the switches were queued */
+	cgwb_kick_replaced(new_wb);
 	wb_put(new_wb);
 }
 
@@ -809,6 +811,65 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 	return restart;
 }
 
+/**
+ * switch_replaced_cgwb - switch a replaced wb's inodes to its successor
+ * @wb: target wb, replaced in bdi->cgwb_tree by another wb of its memcg
+ *
+ * Switch all inodes attached to @wb, dirty or not, to the wb that foreign
+ * flushes now find for @wb's memcg.  If that one is already gone, fall back
+ * like cleanup_offline_cgwb() does, to the nearest live ancestor's wb or the
+ * root wb.  The switch carries the dirty and writeback page counts, so
+ * nothing needs to be written back first.  Returns %true if not all inodes
+ * were switched and the function has to be restarted.
+ */
+bool switch_replaced_cgwb(struct bdi_writeback *wb)
+{
+	struct cgroup_subsys_state *memcg_css;
+	struct inode_switch_wbs_context *isw;
+	struct bdi_writeback *new_wb;
+	bool restart;
+	int nr = 0;
+
+	new_wb = wb_get_lookup(wb->bdi, wb->memcg_css);
+	for (memcg_css = wb->memcg_css->parent; !new_wb && memcg_css;
+	     memcg_css = memcg_css->parent)
+		new_wb = wb_get_create(wb->bdi, memcg_css, GFP_KERNEL);
+	if (!new_wb)
+		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
+	if (WARN_ON_ONCE(new_wb == wb)) {
+		wb_put(new_wb);
+		return false;
+	}
+
+	isw = kzalloc_flex(*isw, inodes, WB_MAX_INODES_PER_ISW);
+	if (!isw) {
+		wb_put(new_wb);
+		return false;
+	}
+
+	atomic_inc(&isw_nr_in_flight);
+
+	spin_lock(&wb->list_lock);
+	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
+	spin_unlock(&wb->list_lock);
+
+	if (nr == 0) {
+		atomic_dec(&isw_nr_in_flight);
+		wb_put(new_wb);
+		kfree(isw);
+		return restart;
+	}
+
+	trace_inode_switch_wbs_queue(wb, new_wb, nr);
+	wb_queue_isw(new_wb, isw);
+
+	return restart;
+}
+
 /**
  * wbc_attach_and_unlock_inode - associate wbc with target inode and unlock it
  * @wbc: writeback_control of interest
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 33e06b1b1e1c..7713fd60c985 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -162,6 +162,7 @@ struct bdi_writeback {
 					 * to this wb */
 	struct llist_head switch_wbs_ctxs;	/* queued contexts for
 						 * writeback switching */
+	struct work_struct replaced_work;	/* see switch_replaced_cgwb() */
 
 	union {
 		struct work_struct release_work;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index f7ef5895625a..84057fa92f24 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -151,6 +151,7 @@ static inline void bdi_wb_stat_mod(struct inode *inode, enum wb_stat_item item,
 
 struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css);
+void cgwb_kick_replaced(struct bdi_writeback *wb);
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css,
 				    gfp_t gfp);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b749a9a5a5ee..88e4b5049698 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -209,6 +209,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 			   enum wb_reason reason, struct wb_completion *done);
 void cgroup_writeback_umount(struct super_block *sb);
 bool cleanup_offline_cgwb(struct bdi_writeback *wb);
+bool switch_replaced_cgwb(struct bdi_writeback *wb);
 
 /**
  * inode_attach_wb - associate an inode with its wb
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 85b2c95a920c..e401293c260a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -637,9 +637,51 @@ static void cgwb_release_workfn(struct work_struct *work)
 	bdi_put(bdi);
 	WARN_ON_ONCE(!list_empty(&wb->b_attached));
 	WARN_ON_ONCE(work_pending(&wb->switch_work));
+	WARN_ON_ONCE(work_pending(&wb->replaced_work));
 	call_rcu(&wb->rcu, cgwb_free_rcu);
 }
 
+static void cgwb_replaced_workfn(struct work_struct *work)
+{
+	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
+						replaced_work);
+
+	do {
+		cond_resched_tasks_rcu_qs();
+	} while (switch_replaced_cgwb(wb));
+	wb_put(wb);
+}
+
+/* called with cgwb_lock held, possibly with interrupts disabled */
+static void cgwb_queue_replaced_work(struct bdi_writeback *wb)
+{
+	lockdep_assert_held(&cgwb_lock);
+
+	if (wb_tryget(wb) && !queue_work(system_dfl_wq, &wb->replaced_work))
+		wb_put(wb);
+}
+
+/**
+ * cgwb_kick_replaced - switch inodes away from @wb again if it was replaced
+ * @wb: wb that inodes were just switched to
+ *
+ * An inode switch pins its target wb before the switch lands, and the wb
+ * may be replaced in cgwb_create() and have its replaced_work run in
+ * between.  Kick the work again so that those inodes reach the successor
+ * too.  A dying wb that still owns its slot is left alone: foreign flushes
+ * can reach it, and the work would look up @wb itself.
+ */
+void cgwb_kick_replaced(struct bdi_writeback *wb)
+{
+	if (!wb_dying(wb))
+		return;
+
+	spin_lock_irq(&cgwb_lock);
+	if (radix_tree_lookup(&wb->bdi->cgwb_tree, wb->memcg_css->id) != wb)
+		cgwb_queue_replaced_work(wb);
+	spin_unlock_irq(&cgwb_lock);
+}
+
 static void cgwb_release(struct percpu_ref *refcnt)
 {
 	struct bdi_writeback *wb = container_of(refcnt, struct bdi_writeback,
@@ -724,6 +766,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	INIT_WORK(&wb->switch_work, inode_switch_wbs_work_fn);
 	init_llist_head(&wb->switch_wbs_ctxs);
 	INIT_WORK(&wb->release_work, cgwb_release_workfn);
+	INIT_WORK(&wb->replaced_work, cgwb_replaced_workfn);
 	set_bit(WB_registered, &wb->state);
 	bdi_get(bdi);
 
@@ -748,6 +791,12 @@ static int cgwb_create(struct backing_dev_info *bdi,
 			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
 			if (wb_dying(old_wb)) {
 				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+				/*
+				 * @old_wb is out of foreign flushes' reach
+				 * but may still have inodes attached, dirty
+				 * or not.  Switch them over to @wb.
+				 */
+				cgwb_queue_replaced_work(old_wb);
 				ret = 0;
 			} else {
 				ret = -EEXIST;

-- 
2.53.0

