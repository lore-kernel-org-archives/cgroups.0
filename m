Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A02488757
	for <cgroups@vger.kernel.org>; Thu,  1 Oct 2026 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790898628; cv=none; b=Kq06/S1LmYqljlN9MuI+ua/fTZ2zRiXSRVvx3oUo6Xw/k4Wl6Wo38bJh7w0ANTIR7QgfLcDu5vXEMFOwkWihuvdOAnqlM1Int5Qgy0/DbdiBOr0fOSeTWIEX3NPa0TAwJriOar3ueUcw5Z8zYufNdzeUCN83x6Gpg8a/CJJARfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790898628; c=relaxed/simple;
	bh=YRbhWrPvT5vwC7RVdqWrGq4zYuwCvAVvR/CEAsOnKZ8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=l24UHUFz0DWNH8/sakha38AIRh6Cs/mocQ/TNpm9nvOt3GXtTF2vLBqxqsoQbeyZgn9xjmvBY1+532jRDv9D8Lu0EsHlGJjlGMwUG/FfxgYu0SD+OwFa1yU5Aai4wJzMUHSHTYmnrHkVU6QndBYU3dq9dPxQdgCV/NbLFO/AK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=xQb7Cbo+; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="xQb7Cbo+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790898621;
	bh=Tg4ppXXVVjnMQ6UEGhpcHjjpr3r+46JLWKe/8p6U5W8=;
	b=xQb7Cbo+Xc/9iB6UHK5LcV6ZNhzEfm2aj7BqB4bScq8R0FnEuOx9c5dmpKHu6R8NcswY
	beJD9nLweoLksfoCl06obDppiQEaUZ5wHAG+ApfGnusrkbFYrzMha5Z9/lmAxQFOM1zhWc
	ePyUBzDN/Dw36Gp2mxVsR66clNf/p/UgnmpKekSuq+sB27Quuh+yG0WGwhPwkshFo/CtKI
	x5kUdoTkN7SPLQ9m66E5WK9gn+7n+ViumNQPQ93Dp8vN3xMlWXdLcOLyS+50pisJvssOoH
	4ZrHCUsD3zhsMEVG9rB4kuL7xwo+qDYSx9KTG8kJ2A3vl/T2Jtm6+ItMFDZQyH5Q==
Received: by recvd-5dd7ccd7b6-bvrdz with SMTP id recvd-5dd7ccd7b6-bvrdz-1-6ABEF1BC-AB
	2026-10-01 23:50:20.883098402 +0000 UTC m=+197355.990267287
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-1 (SG) with ESMTP
	id 16rqit50Ql2Ye7l-pyoTLQ
	Thu, 01 Oct 2026 23:50:20.859 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 01 Oct 2026 23:50:21 +0000 (UTC)
Subject: [PATCH v5 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-wb-dying-cgwb-flush-v5-3-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8030; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=YRbhWrPvT5vwC7RVdqWrGq4zYuwCvAVvR/CEAsOnKZ8=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvvG7qknTCVvAZ6ZniFRS77iwT+EnsNN8/NjIZ
 NvbNv1PZHKJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar7xuwAKCRClztTjl62v
 wr7HCACiXqmnKq6I/MiWA8gd2MeOwgnuXBbHasIlmE3+Vtybu1osyZeENISZc6kUY5OsG0KNT3b
 t/ouxqq9JnJq2z2aUXra3mjSUdwtbzkz1SztMRFHLr+oiQB4F8VeiC55BDqNggHBloTPgjzIxzv
 Yb/bTgCiY80RELiREN36duR2Fc7W4c7tlnKtOjHw4SKxKB3KQbD1Kp4n15SLyfMeI7aU8m/ivNy
 hnnIuFY4j0yHXz0y6eXyq/JpD8ElLN8J/0CqCOgzNjvu8cIvq3/goQtJGL5CdILSGioc+QkbpYn
 BGRXK7oL+z6x4dXmkIrC68j+lbPGvPO74/VfOn0IRLtrCTTk
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmefOlJgNFT2+h?=
 =?us-ascii?Q?IUz2LtsBtTcgXfyA1sLVs9COF=2FimB1AyAg9YqCv?=
 =?us-ascii?Q?X5DdUu1qG=2F5Yq3HIiQ4f9emqTXTfhT9Dxo08jen?=
 =?us-ascii?Q?Orfe5ZZAgubpu60JvKtKyRXYf0N9tCJSHaElNeD?=
 =?us-ascii?Q?BkcTO0lQv74elc7SaH+5A4YH4O+xYDwgHnyAMKE?= =?us-ascii?Q?VHoZ?=
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
it only queues the work, after dropping cgwb_lock. Inodes already being
switched when the work runs are left to the existing per-inode
switching, so this is best effort. If the successor is already gone,
fall back like cleanup_offline_cgwb() does, to the nearest live
ancestor's wb or the root wb.

Test: a live cgroup appends to 5000 files on XFS at 250MiB/s, io is
disabled on its parent so its wb is killed, it creates a file (the
takeover), and a sibling keeps appending to its files under a 4G parent
limit. Worst lag of the sibling behind schedule over 30s, in three runs:

  without this patch    9.1s   4.0s   1.0s
  with this patch       1.2s   1.0s   1.0s

Without this patch, moving the old wb's inodes over took up to 11s,
first switch to last; with it, all 5001 were switched in a 30-60ms
window, with up to 553MiB of the old cgroup's pages dirty.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c                | 59 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  1 +
 include/linux/writeback.h        |  1 +
 mm/backing-dev.c                 | 28 ++++++++++++++++++-
 4 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 050d507aa554..9be641800934 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -809,6 +809,65 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
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
index 035d25f5b81b..0d9a113f6fd6 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -160,6 +160,7 @@ struct bdi_writeback {
 					 * to this wb */
 	struct llist_head switch_wbs_ctxs;	/* queued contexts for
 						 * writeback switching */
+	struct work_struct replaced_work;	/* see switch_replaced_cgwb() */
 
 	union {
 		struct work_struct release_work;
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
index 839a3c476c5b..49b7b86a7221 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -637,9 +637,21 @@ static void cgwb_release_workfn(struct work_struct *work)
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
 static void cgwb_release(struct percpu_ref *refcnt)
 {
 	struct bdi_writeback *wb = container_of(refcnt, struct bdi_writeback,
@@ -676,7 +688,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	struct mem_cgroup *memcg;
 	struct cgroup_subsys_state *blkcg_css;
 	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
-	struct bdi_writeback *wb, *old_wb;
+	struct bdi_writeback *wb, *old_wb, *replaced_wb = NULL;
 	void __rcu **slot;
 	unsigned long flags;
 	int ret = 0;
@@ -724,6 +736,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	INIT_WORK(&wb->switch_work, inode_switch_wbs_work_fn);
 	init_llist_head(&wb->switch_wbs_ctxs);
 	INIT_WORK(&wb->release_work, cgwb_release_workfn);
+	INIT_WORK(&wb->replaced_work, cgwb_replaced_workfn);
 	set_bit(WB_registered, &wb->state);
 	bdi_get(bdi);
 
@@ -748,6 +761,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
 			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
 			if (wb_dying(old_wb)) {
 				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+				if (wb_tryget(old_wb))
+					replaced_wb = old_wb;
 				ret = 0;
 			} else {
 				ret = -EEXIST;
@@ -763,6 +778,17 @@ static int cgwb_create(struct backing_dev_info *bdi,
 		}
 	}
 	spin_unlock_irqrestore(&cgwb_lock, flags);
+
+	/*
+	 * The replaced wb is out of foreign flushes' reach but may still have
+	 * inodes attached, dirty or not.  Switch them over to @wb.  We may be
+	 * running with interrupts disabled, so use a work item.  A replaced wb
+	 * never returns to the tree, so its work can't already be pending.
+	 */
+	if (replaced_wb &&
+	    !queue_work(system_dfl_wq, &replaced_wb->replaced_work))
+		wb_put(replaced_wb);
+
 	if (ret) {
 		if (ret == -EEXIST)
 			ret = 0;

-- 
2.53.0

