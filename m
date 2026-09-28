Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7279A478842
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 22:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790633582; cv=none; b=eH7izkdZkEXYSSbBwmFxBZG8mmY5Qi6e7q4Y87IgEoag+zZJKnHNuVGUejR4vXJbAed4q/yIbQSNVd1gEtIxcrSS+lRQdebSBqLhZwutVQ5fksT4z/7zFCrP1f6LcgAPUcBK591winqb9JWaGWHq2A5IQDQxZdEMlgTQs/wqvX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790633582; c=relaxed/simple;
	bh=ZyZ8sPdrhi5ZjKJwyFeVoLx+6dEC+1pAiqsYVIfiIe4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=XBi92K73nsy+PWcCJ3UK2R34ztSsQJE5moH2KTFMu3DaWW9gsWWNRC7tjcvPdVGBxo2ANFt8CnxycS44EN+Jt1j9yAG3azcCo/DrimlJ1B3BVS5lQAPXThzZmjIFWP43evpKvuHzTuXzf8E5pK+68eAE2VGaGkbxGkmoKngbMWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=GTYXhtrq; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="GTYXhtrq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790633579;
	bh=UBnD0y8kt2bsWncNoIGjUKY/sfGv28DPZ3wZNndFr0A=;
	b=GTYXhtrq7EyKXyjVCXIHyBPlVhN2fVEC+0mLZLeqr7jnV6fn0uF1uPUK7hP97ESeeLXA
	HeHTGw/wuZY+jjlhK1wXd9UFEsqoaWFy5IotQIr3hak14NfiqBrctySOa5/ndT6PDmFkjP
	pKRRjPWF1b9Serj/Om8yMKznJdAlSSG9Y+L2EQoHJ9hfqfn69Fmn9GmyiSAE4UvDfoSkJ8
	2+3CrHe2PCT7aalrt/VRTyKZOAQTMKNT430M1+dAbgGXonkHYrN3ReYVzPU/gqxgyjGiKl
	5Ny5esjNhgxEoxMACrr1U2aPjckhsf9zuoDn9F2BEmuzafEe71iZAGVnEzqNMdGA==
Received: by recvd-57cdcfbc54-vvkzp with SMTP id recvd-57cdcfbc54-vvkzp-1-6ABAE66B-17
	2026-09-28 22:12:59.132503961 +0000 UTC m=+353757.717913333
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-4 (SG) with ESMTP
	id NKh7AoO7Qq2zsEPDN0s8eQ
	Mon, 28 Sep 2026 22:12:59.065 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Mon, 28 Sep 2026 22:12:59 +0000 (UTC)
Subject: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32Nyw6CMBBFf4XM2ppSIymu/A/Doo+BjtHWtFAlh
 H+34N7dPbmvBRJGwgSXaoGImRIFX0AcKjBO+QEZ2cIguGh4Kxr21szO5AdmhiL7x5Qc4w0WF4X
 SykJpviL29NlXb92P06TvaMZtaks4SmOI836b6y33/yHXrGZKWtlKLs/qpK4ueJxNeOojBejWd
 f0C/uf/4MsAAAA=
X-Change-ID: 20260926-wb-dying-cgwb-flush-06e260e2abad
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15963; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=ZyZ8sPdrhi5ZjKJwyFeVoLx+6dEC+1pAiqsYVIfiIe4=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBquuZqTMpDTAn/GuVKKK+JeZM/JocHNAP/bSF9E
 WJTPH8OyI2JATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCarrmagAKCRClztTjl62v
 wjYpCACjugaluzdc296Z23x27FjnK1MpaarBaNl0W/bpd2/uAtJHl0BEkIlxNMvnDLQphWAzI5f
 KAS/PxHz7HRw2XlV05fIm3VhEZw8KOi87glQTQTtOVopOWZaUwHkaKEZ7ZfYt7jLWNeUL7B6lSg
 hRWhobUQhaUiBqvEbmSigqvhwdOgMd7APAQslxreRD6PDdP1gYm4a51JP2ndF/Bdi13QthTy4O4
 N6U9P4yruEkrGUH+gWMJkjbFNQjHefZq5aswIPqf6DV7s+mKili+jK78Iyom3aabOg5kQzQb/DC
 qCCL4rSGBs2qh42MfgDSXVJDrSyoG8CE5WNCdLvL8X9DFWxa
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmecQLCuNsHO2v?=
 =?us-ascii?Q?trMkYvtFCGL=2F3zbSl8hP6SD0yS=2FRI9hkd5H176i?=
 =?us-ascii?Q?UNUA4P6yIM72mE1ERVIbtALrAnl9cyurQGT8vGh?=
 =?us-ascii?Q?KyM46MpyWFUfl+M2lFHskRdEsfl5RQB1ROy=2FDa=2F?=
 =?us-ascii?Q?9pfd6VMPB5+rRfUAQkPOwfOXQXNoCZ9qYxC77wz?= =?us-ascii?Q?AZhG?=
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

cgwb_kill() takes an offline memcg's wbs out of bdi->cgwb_tree, but
inodes that are still being dirtied stay attached to them. When a
replacement container keeps appending to those files, its foreign
flushes fail with -ENOENT in wb_get_lookup(), and it sleeps in
balance_dirty_pages() for seconds to minutes.

Keep killed wbs in bdi->cgwb_tree until they are released, so that
cgroup_writeback_by_id() finds them through the regular lookup. The
creation paths skip dying wbs, and a new wb takes over the slot of a
dying one when a live memcg's blkcg association changes; release only
removes a wb that still owns its slot. The blkcg association check
moves from wb_get_lookup() to the creation side: once a memcg with io
enabled is removed, cgroup_get_e_css() returns an ancestor's io css
and its dying wb would not match.

With commit 168a8c13159c ("writeback: size foreign flushes by target
wb dirty pages"), the flush is then sized from the wb's own dirty
pages and writes out what the replacement dirtied.

Test, on top of that commit: a cgroup appends to 1000 files at
250MiB/s and is removed, then a second cgroup keeps appending to the
same files under a 4G parent limit. Worst lag of the second writer
behind schedule over 120s, in three runs:

  without this patch   85.3s  46.9s  52.1s
  with this patch       1.0s   1.0s   1.4s

Suggested-by: Tejun Heo <tj@kernel.org>
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
At Honeycomb, a container that reads from Kafka and writes columnar
files to a host volume stalls for 30-60s after each deploy replaces it
(v6.18). We're increasingly confident this is the cause: the stall
looks the same as in the reproducer (little CPU use, lag growing
linearly and then recovering), and the mitigation it predicts, moving
our final syncfs after the last write, worked in production (below).
We haven't caught it with probes in production yet.

Based on vfs-7.4.misc, next to Xin Yin's 168a8c13159c, which fixes the
sizing but not the lookup of a removed cgroup's wb. Each helps without
the other; this one also applies cleanly to mainline. On mainline
(fd179f8a05be), without 168a8c13159c, the test from the changelog gave
52.8s, 73.3s and 5.2s worst lag before this patch and 3.9s, 1.0s and
1.0s after.

Trigger: a cgroup dirties files and is removed while they are still
dirty; a sibling keeps appending to the same files under a parent memory
limit. Symptom: cgroup_writeback_by_id() returns -ENOENT and the sibling
stalls in balance_dirty_pages(). Minimal recipe below; the harness that
produced the numbers (paced writer, lag per second, MODE=alive control)
is at https://gist.github.com/lizthegrey/2209d831930588f63076bdc0ac7b78e2.

Syncing before the removal isn't enough: cleanup_offline_cgwbs_workfn()
skips a dying wb with any dirty inode and only retries on the next memcg
offline. On ext4, syncfs can leave inodes I_DIRTY_SYNC: at 5000 files
one syncfs still stalled in 7 of 9 runs (19-26s worst lag), a second
syncfs avoided it in 5 of 5, and with this patch one syncfs lagged at
most 1.5s in 3 of 3. On XFS one syncfs left the wb clean in 5 of 5 runs,
but a single 4KiB append from the old cgroup after it stranded the wb
again (15-28s worst lag, 5 of 5; 1.0-1.1s with this patch). In
production, our writer synced after closing its data files but before
writing its final Kafka offset to a small shutdown file, and moving the
syncfs after that write mitigated the stall for us on XFS. In the
reproducer, a 14-byte file written after the syncfs stranded the wb the
same way, whether created directly or via a temp file and rename (16-29s
worst lag, 7 of 7; 1.1-1.2s with this patch); an empty file did not.

Harness settings for all numbers: MEM_MAX=max POD_MAX=4G RATE_MBPS=250,
plus NFILES=5000 SYNC_OLD=1 (or 2) and DIRTY_AFTER=1 or
SHUTDOWN_FILE=offset|offset_rename|empty for the syncfs runs and
NFILES=500000 OLD_SECS=120 SYNC_OLD=1 POD_HOP=10 for the 500k-file runs.

Also reproduced unpatched on bare-metal arm64 with Ubuntu's 7.0 kernel
(ext4 on a loop device): 12.9s worst lag with the old cgroup removed,
2.5s with it kept.

Tested: arm64 KVM guests (virtme-ng), ext4 and XFS on virtio. No KASAN,
lockdep, PROVE_RCU, DEBUG_LIST, DEBUG_OBJECTS_WORK, DEBUG_ATOMIC_SLEEP
or DEBUG_PAGEALLOC reports, including a stress run toggling io on the
parent of two writers 40 times so their wbs are killed and replaced in
the same slot (160 takeovers, checked with temporary trace_printk()s).
W=1 and checkpatch --strict clean, no new sparse warnings. All changes
are under CONFIG_CGROUP_WRITEBACK; only arm64 builds with it enabled
were done for v2.

Not tested: x86 runtime, this patch in production, linux-next.

Workaround until this lands: syncfs after the old container's last
write (twice on ext4). Lowering vm.dirty_expire_centisecs from 3000 to
500 cut the worst lag on unpatched mainline to 4.8s, 4.6s and 14.3s, but
did not remove the stall.

Related: without 168a8c13159c the flush is sized from the dead memcg's
own dirty pages, so this only helps while it has some. f6988c90671e
(mainline) also matters: on XFS with 500k synced inodes and the pod
cgroup removed 10s later, the handover was slow enough without it that
the replacement fell 21-22s behind (vfs-7.4.misc), against 1.0-1.2s
with it (mainline).

Not covered: when a live memcg's blkcg association changes, the new wb
takes over the slot, and a killed wb with dirty inodes is unreachable
again, as before this patch.

Developed with Claude Opus 5.5, which wrote the code, the reproducers
and first drafts of this text, and ran the builds and VM tests. I drove
the investigation from the production symptoms, designed the
experiments and controls (repeated runs, parent-commit baselines,
testing this patch on its own), and reviewed the analysis, code and
results.

Minimal recipe:
	#!/bin/bash
	# As root, cgroup v2, in a directory on ext4/xfs/btrfs ($DIR).
	cg=/sys/fs/cgroup/wbmini
	mkdir $cg && echo +memory > $cg/cgroup.subtree_control
	echo 4G > $cg/memory.max
	mkdir $cg/old $cg/new
	append() {  # append $1 blocks of $2 to each of 1000 files
		for i in $(seq 1000); do
			dd if=/dev/zero of=$DIR/f$i bs=$2 count=$1 \
			   oflag=append conv=notrunc status=none
		done
	}
	(echo $BASHPID > $cg/old/cgroup.procs
	 append 8 1M            # old owner writes the files...
	 append 1 64k)          # ...and exits with all of them dirty
	rmdir $cg/old           # its cgroup goes away while they are dirty
	bpftrace -e 'kretprobe:cgroup_writeback_by_id { @ret[(int32)retval] = count(); }' &
	sleep 3
	time (echo $BASHPID > $cg/new/cgroup.procs
	      append 4 1M)      # replacement keeps appending to the same files
	kill -INT $!; wait
	rmdir $cg/new $cg
	# Unpatched: many @ret[-2] (-ENOENT) and the append stalls.
	# Patched: @ret[0] only.
---
Changes in v2:
- Keep killed wbs in bdi->cgwb_tree until release instead of walking
  bdi->wb_list (Tejun)
- Drop Fixes: and Cc: stable (Tejun)
- Link to v1: https://patch.msgid.link/20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io
---
 include/linux/backing-dev-defs.h | 13 +++++-
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 86 ++++++++++++++++++++++++++++++++--------
 3 files changed, 83 insertions(+), 18 deletions(-)

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
index cecbcf9060a6..a74caa5c348a 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -614,6 +614,11 @@ static void cgwb_release_workfn(struct work_struct *work)
 						release_work);
 	struct backing_dev_info *bdi = wb->bdi;
 
+	/* a newer wb may have taken the slot, see cgwb_create() */
+	spin_lock_irq(&cgwb_lock);
+	radix_tree_delete_item(&bdi->cgwb_tree, wb->memcg_css->id, wb);
+	spin_unlock_irq(&cgwb_lock);
+
 	mutex_lock(&wb->bdi->cgwb_release_mutex);
 	wb_shutdown(wb);
 
@@ -645,11 +650,23 @@ static void cgwb_release(struct percpu_ref *refcnt)
 	queue_work(cgwb_release_wq, &wb->release_work);
 }
 
+static bool cgwb_dying(struct bdi_writeback *wb)
+{
+	lockdep_assert_held(&cgwb_lock);
+
+	return percpu_ref_is_dying(&wb->refcnt);
+}
+
+/*
+ * A killed wb stays in bdi->cgwb_tree until it is released, so that foreign
+ * flushes can still find it through wb_get_lookup().  Inodes attached to it
+ * can keep collecting dirty pages from other memcgs until they are written
+ * back and switched away.
+ */
 static void cgwb_kill(struct bdi_writeback *wb)
 {
 	lockdep_assert_held(&cgwb_lock);
 
-	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
 	list_del(&wb->memcg_node);
 	list_del(&wb->blkcg_node);
 	list_add(&wb->offline_node, &offline_cgwbs);
@@ -670,6 +687,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	struct cgroup_subsys_state *blkcg_css;
 	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
 	struct bdi_writeback *wb;
+	void __rcu **slot;
 	unsigned long flags;
 	int ret = 0;
 
@@ -681,10 +699,10 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	/* look up again under lock and discard on blkcg mismatch */
 	spin_lock_irqsave(&cgwb_lock, flags);
 	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
-	if (wb && wb->blkcg_css != blkcg_css) {
+	if (wb && !cgwb_dying(wb) && wb->blkcg_css != blkcg_css)
 		cgwb_kill(wb);
+	if (wb && cgwb_dying(wb))
 		wb = NULL;
-	}
 	spin_unlock_irqrestore(&cgwb_lock, flags);
 	if (wb)
 		goto out_put;
@@ -727,8 +745,20 @@ static int cgwb_create(struct backing_dev_info *bdi,
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
+		} else if (cgwb_dying(radix_tree_deref_slot_protected(slot,
+								      &cgwb_lock))) {
+			radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
+			ret = 0;
+		} else {
+			ret = -EEXIST;
+		}
 		if (!ret) {
 			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
@@ -768,10 +798,29 @@ static int cgwb_create(struct backing_dev_info *bdi,
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
@@ -782,9 +831,13 @@ static int cgwb_create(struct backing_dev_info *bdi,
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
 
@@ -798,7 +851,7 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 
 		/* see whether the blkcg association has changed */
 		blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
-		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget(wb)))
+		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget_live(wb)))
 			wb = NULL;
 		css_put(blkcg_css);
 	}
@@ -813,8 +866,8 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
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
@@ -825,7 +878,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 	might_alloc(gfp);
 
 	do {
-		wb = wb_get_lookup(bdi, memcg_css);
+		wb = cgwb_get_live(bdi, memcg_css);
 	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
 
 	return wb;
@@ -859,7 +912,8 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
 
 	spin_lock_irq(&cgwb_lock);
 	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
-		cgwb_kill(*slot);
+		if (!cgwb_dying(*slot))
+			cgwb_kill(*slot);
 	spin_unlock_irq(&cgwb_lock);
 
 	mutex_lock(&bdi->cgwb_release_mutex);

---
base-commit: 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd
change-id: 20260926-wb-dying-cgwb-flush-06e260e2abad

Best regards,
--  
Liz Fong-Jones <lizf@honeycomb.io>

