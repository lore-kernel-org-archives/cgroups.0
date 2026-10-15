Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A255F4FD78B
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 11:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064455; cv=none; b=NysCGr/uICiuKMLf/SwHjKXLdStm6Lq630GAc4t7vhhQC4pk6EzQRvxH7brxtoAl2e0pwQ/haMFOpUFDIZf3RoTonK/gyJVMa/gViV7isWU5OiBM2Q2oTjOw+uYPW7cydcOchha9oY1G9IDQwqEqEljnNLNic61NGf4ZDLEWPeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064455; c=relaxed/simple;
	bh=EOUFPzaXXBL5LIsCoIVhylFtOir+N4LjEMyTLE7RxXw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DKsDJkqNfpiVvZfIIswG93wFZzaBzdHfMyLQ56/tfoxUT1fTH3dD20DneDZhEYfo9nE9ns5A59jjBG8xSwc3uUuIs7FtoBaRTY9XsCZFnYFWNZhIP2QIBbC7Lfaao2Qb5uAmv29kbZujJ7XS0VZtwJUFlVR8NURLQAQnRULSmRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=p4Jb80sF; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="p4Jb80sF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	references:in-reply-to:to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1792064449;
	bh=g9zPEjdqzeftXjAFlwNKTuUI/Q0TI5SBmPG5yYlzU0s=;
	b=p4Jb80sFh3+r9sMIwmr+S+FiTRnGJQJwfFHkTYevYR7z0/H+CncOatVk8BmeJQDlHnuv
	tz344nqQQ5eXkvCWqn2XBAdWUVtKmYQ4tRAKGVKhqx1pbwFrGAzUC4NWLximVFyw+PXsG7
	CWxZYkCXW6Ut0FcoHyLpc/XHaFVanER3UfxRgZXOB0d1LrS54CJB3+GrZCfN/JrgBu5Voy
	3132DlWPs+Xgyul9MUi0zdS5ADv72vDe/NDXlI5NOOpPr9M/hlwphcqhtR6uy3gTxpG9iC
	eCL+CsTOnEjCgR4WyrCsVeLREPi/k1DhPG8JTz4V9cioN8YzsHvN9FeNIvGlmH7w==
Received: by recvd-7dd44dbfb-xtt67 with SMTP id recvd-7dd44dbfb-xtt67-1-6AD0BBC0-94
	2026-10-15 11:40:48.974646699 +0000 UTC m=+1363210.471780216
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-34 (SG) with ESMTP
	id HwkYD4PQT62gGITnmY5big
	Thu, 15 Oct 2026 11:40:48.880 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Thu, 15 Oct 2026 11:40:49 +0000 (UTC)
Subject: [PATCH v7 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-wb-dying-cgwb-flush-v7-3-9278d9ebaf5d@honeycomb.io>
References: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
In-Reply-To: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10110; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=EOUFPzaXXBL5LIsCoIVhylFtOir+N4LjEMyTLE7RxXw=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBq0Lu8Nz3+ZFaYgxjl18aa1sbxXGJlFR+1q8Yyb
 7sK8oVfNk2JATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCatC7vAAKCRClztTjl62v
 wnFUB/0WF9UayyAY3c1x+kRcUnD/w4SixYxG1NaDvBMs75tjNu6StKOEv0goPT9hNy09yMghHUO
 grODQuFQ87YwhP79k6OOrQdrqp18X1Gs74OSlNTINGMr6otGEiheyINyENt9J92/ldmrAny35h1
 rRb1qfc1unF9DoNjfOtTX5s6K46uF2go7nXBjFZ25/0gRSL5XDN+IxpfPKUZc0BxtsnRX15brc7
 qRMjnqNfZpjplY1QtbfJefMnNLqqaQlh74BBtJnweSsh7F3bAUE5lywl4yomWI8RLPZ5cPKHBGv
 KIunHQIHuJHk442U+ZnPJn7rxvxkdr5KOTv0Bb4rh1nKJo8G
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeYGeH8fsp8CL?=
 =?us-ascii?Q?edR=2FZhwrSbP=2FOwSw5EjBx5TUKicZYtObFQ1D6of?=
 =?us-ascii?Q?vDgD3Ni3kwdVi6ZzF+PbmZkIRZbZWPZiZMmNJzj?=
 =?us-ascii?Q?X2cAODMDb3MotS=2F8FJGxw2t5Ao6zyNgJ3JMPsJv?=
 =?us-ascii?Q?dk8EemGODAf7ZdWpx880Dls6R+XguZHCZL1qsY9?= =?us-ascii?Q?poPc?=
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

After the takeover, queue a work item that switches all inodes on the
old wb's lists to the wb foreign flushes now find, like
cleanup_offline_cgwb() does for b_attached and b_dirty_time, but
including b_dirty, b_io and b_more_io. The switch carries the dirty and
writeback page counts, so nothing needs to be written back first.
cgwb_create() can run with interrupts disabled (folio_account_dirtied()
-> inode_attach_wb()), so it only queues the work. A switch to the old
wb that was queued before it was replaced can land after the work ran,
so inode_switch_wbs_work_fn() queues the work again when the wb it
switched inodes to is dying and no longer owns its slot. Inodes attached
to the old wb but on none of its lists, such as one attached as the wb
is replaced (see __inode_attach_wb()) or a clean one switched over from
the root wb, still move over only when written back. If the successor is
already gone, fall back like cleanup_offline_cgwb() does, to the nearest
live ancestor's wb or the root wb.

Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
rescans by rotating scanned inodes"), the scan moves the inodes it walks
to the newest end of each list, so hold wb_switch_rwsem for read across
it, like the switches themselves. Otherwise a sync that has fixed its
cutoff but not yet queued inodes can find older dirty inodes moved
behind a newer one on b_dirty and return without writing them.

Test: a live cgroup appends to 5000 files on XFS at 250MiB/s, io is
disabled on its parent so its wb is killed, it creates a file (the
takeover), and a sibling keeps appending to its files under a 4G parent
limit. Worst lag of the sibling behind schedule over 30s, in three runs:

  without this patch    9.1s   4.0s   1.0s
  with this patch       1.7s   1.3s   1.0s

Without this patch, moving the old wb's inodes over took up to 11s,
first switch to last; with it, all 5001 were switched in a 23-35ms
window, with up to 98MiB of the old cgroup's pages dirty.

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Assisted-by: Claude:claude-fable-5-1
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
 fs/fs-writeback.c                | 67 ++++++++++++++++++++++++++++++++++++++++
 include/linux/backing-dev-defs.h |  1 +
 include/linux/backing-dev.h      |  1 +
 include/linux/writeback.h        |  1 +
 mm/backing-dev.c                 | 48 ++++++++++++++++++++++++++++
 5 files changed, 118 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 050d507aa554..eeaca6b41619 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -624,6 +624,8 @@ void inode_switch_wbs_work_fn(struct work_struct *work)
 
 	llist_for_each_entry_safe(isw, next_isw, list, list)
 		process_inode_switch_wbs(new_wb, isw);
+	/* @new_wb may have been replaced while the switches were queued */
+	cgwb_kick_replaced(new_wb);
 	wb_put(new_wb);
 }
 
@@ -809,6 +811,71 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 	return restart;
 }
 
+/**
+ * switch_replaced_cgwb - switch a replaced wb's inodes to its successor
+ * @wb: target wb, replaced in bdi->cgwb_tree by another wb of its memcg
+ *
+ * Switch all inodes on @wb's lists, dirty or not, to the wb that foreign
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
+	/*
+	 * The scan reorders @wb's lists.  Keep it out of a sync's way, which
+	 * could otherwise miss dirty inodes moved past its cutoff on b_dirty.
+	 */
+	down_read(&wb->bdi->wb_switch_rwsem);
+	spin_lock(&wb->list_lock);
+	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
+		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
+	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
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
index 85b2c95a920c..0c09b51d5f40 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -637,9 +637,50 @@ static void cgwb_release_workfn(struct work_struct *work)
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
+static void cgwb_queue_replaced_work(struct bdi_writeback *wb)
+{
+	lockdep_assert_held(&cgwb_lock);
+
+	if (wb_tryget(wb) && !queue_work(system_dfl_wq, &wb->replaced_work))
+		wb_put(wb);
+}
+
+/**
+ * cgwb_kick_replaced - queue @wb's replaced_work if @wb has been replaced
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
@@ -724,6 +765,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	INIT_WORK(&wb->switch_work, inode_switch_wbs_work_fn);
 	init_llist_head(&wb->switch_wbs_ctxs);
 	INIT_WORK(&wb->release_work, cgwb_release_workfn);
+	INIT_WORK(&wb->replaced_work, cgwb_replaced_workfn);
 	set_bit(WB_registered, &wb->state);
 	bdi_get(bdi);
 
@@ -748,6 +790,12 @@ static int cgwb_create(struct backing_dev_info *bdi,
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

