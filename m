Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795694938;
	b=Xm3gJbEHiepfaI++qVjsoz0dy4TAGOT2K0x4Pw5sxDePskymrSH4QjRWNHw7y5UTDOEl
	 TF9o+Lu7ndYpubcDil0k1yoeY1R8992S7mMteLL4yHaVDjfFt24Z/E535DQPzMixOCn/Y
	 TDG5q8crAedAEsWuD9EOKm8kwNgSWF82ge+g2f4CdkWldEAus1GJ445ONAPKibRo3ot8Q
	 IP2lZB4XtYV710VlUJ7OAhs8/isEPH6uTruq0NTq1n61IgJeeLzL1YK5+wGfD6ab3tvcn
	 LAxXhG0x4p9vJ7hxFaMNuSZ31flZPLrRfnZn41wf8hwNEt0kOVV5y7kUsONfqJL54NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795694938;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=RJ6ABZmDyn/Dl1B0+dcioahhPK/gYG42Zr7uAiRksnI=;
	b=ftMo3Egba654nGPHvCA24+cjtibmYrX1Tocvn5A0ZLAhQKMxqff90hsS6zngWWvl/LUn
	 EAPeiUd1AV7HfvAe2PiR/h4M99hVU7JQuOhqAQ9flTStPgttN1n8FtO7C0Z/LKUZAM/j/
	 2Ohm1hshmtv8o9wkmelkKJ70w9SScc3kKduDg31nm4+LVsFAm6/AZoPxTcjvlaX45ymG1
	 oDG1vdBirygGA6GpygwgtbCbIindWnacFuLu2sbcA/w4d7DtRuASOvSwtm9+iO6y5i3E2
	 G9gzPaghwVv++aS94szWgufAc7JW0qvrbjJyJ9IAkdf1og8/bQqJ+hWn85ihy5xhDRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZRCpdFj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EE7606A31E;
	Thu, 26 Nov 2026 12:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZRCpdFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E151F000C4;
	Thu, 26 Nov 2026 12:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795694938;
	bh=RJ6ABZmDyn/Dl1B0+dcioahhPK/gYG42Zr7uAiRksnI=;
	h=Date:From:To:Cc:Subject;
	b=oZRCpdFjKa3WVZWONiR2bV3G9Y70FwuGXfrhSRv2rLb/Mruc5Z6jGKM/rmrIgsFKN
	 dgLaZ/yDUJJrPX25DteDDDxzFb7twuKux8nl2CW9Fc/4M2RthlSFz4zCL2Nbv2+IY0
	 PARsMuyP6UBeSqgz5lukDWWbfDrUyAriW2L6RI/WU56QQ4DeFwTu12mh5BO7Fg9Zhz
	 0Cxf+7HeNsT4ca2LB+dqMv6Tbw+I+bJiAVtPzMnrZyCM3tmOfeoHsRTVXAtoEoq1xo
	 LcE2mBVWgZcumD0fu4Mows+Neh3Af80rwOA/aUitItjxexOzIUNBkr8Q9aS3TWhmCs
	 a+3dhMpRRa0zw==
Date: Thu, 26 Nov 2026 02:08:56 -1000
Message-ID: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock against filesystem freeze
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Legacy memcg reclaim has no dirty throttling, and shrink_folio_list() waits
for a folio that is under writeback and already marked for reclaim (case 3
in its comment). That wait can deadlock against a filesystem freeze:

1. A task in write() to filesystem B holds freeze protection on B, enters
   memcg reclaim and waits for writeback of a folio of a filesystem on a
   loop device backed by a file on B.

2. A freeze of B waits for the task to drop its freeze protection.

3. The loop worker has to take freeze protection on B to write the folio out
   and blocks behind the freeze.

The same applies to any driver that writes to a file on a local filesystem
to serve block I/O and takes freeze protection for it.

Reclaim can't tell which filesystem a writeback depends on. Count the
superblocks that are being frozen and make the wait time out after 15
seconds. If one is being frozen at that point, warn and give up. Until none
is, treat such folios like case 2 and skip the legacy writeback throttle, so
that the task a freeze may be waiting for isn't held up.

This trades the deadlock for premature memcg OOM kills during such a freeze.
The wait also no longer hits the folio_wait_writeback tracepoint, and the
hung task detector no longer reports a task stuck in it for another reason
as the task wakes up every 15 seconds.

Fixes: e62e384e9da8 ("memcg: prevent OOM with too many dirty pages")
Reported-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
This was first posted in a private thread and is resent here for the lists,
rebased onto the current mainline. The only other change is the added
Reviewed-by tags.

This is on top of v7.4-rc4-388 (25faec9ce61c). In a test with a filesystem
on a loop device backed by a file on another filesystem, writers to both in
a v1 memcg and the backing filesystem frozen and thawed in a loop, the
unpatched kernel deadlocks within seconds. With the patch, a stuck freeze
gets through in 15 to 18 seconds.

 fs/super.c               |    7 +++++
 include/linux/fs/super.h |    1 
 mm/filemap.c             |   22 +++++++++++++++--
 mm/internal.h            |    1 
 mm/vmscan.c              |   58 ++++++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 83 insertions(+), 6 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -48,6 +48,9 @@ static int thaw_super_locked(struct supe
 static LIST_HEAD(super_blocks);
 static DEFINE_SPINLOCK(sb_lock);
 
+/* nr of superblocks that freeze_super() is in the middle of freezing */
+atomic_t sb_nr_freezing;
+
 static char *sb_writers_name[SB_FREEZE_LEVELS] = {
 	"sb_writers",
 	"sb_pagefaults",
@@ -2235,6 +2238,7 @@ retry:
 		return 0;
 	}
 
+	atomic_inc(&sb_nr_freezing);
 	sb->s_writers.frozen = SB_FREEZE_WRITE;
 	/* Release s_umount to preserve sb_start_write -> s_umount ordering */
 	super_unlock_excl(sb);
@@ -2249,6 +2253,7 @@ retry:
 	ret = sync_filesystem(sb);
 	if (ret) {
 		sb->s_writers.frozen = SB_UNFROZEN;
+		atomic_dec(&sb_nr_freezing);
 		sb_freeze_unlock(sb, SB_FREEZE_PAGEFAULT);
 		wake_up_var(&sb->s_writers.frozen);
 		deactivate_locked_super(sb);
@@ -2265,6 +2270,7 @@ retry:
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_writers.frozen = SB_UNFROZEN;
+			atomic_dec(&sb_nr_freezing);
 			sb_freeze_unlock(sb, SB_FREEZE_FS);
 			wake_up_var(&sb->s_writers.frozen);
 			deactivate_locked_super(sb);
@@ -2278,6 +2284,7 @@ retry:
 	WARN_ON_ONCE(freeze_inc(sb, who) > 1);
 	sb->s_writers.freeze_owner = freeze_owner;
 	sb->s_writers.frozen = SB_FREEZE_COMPLETE;
+	atomic_dec(&sb_nr_freezing);
 	wake_up_var(&sb->s_writers.frozen);
 	lockdep_sb_freeze_release(sb);
 	super_unlock_excl(sb);
--- a/include/linux/fs/super.h
+++ b/include/linux/fs/super.h
@@ -234,6 +234,7 @@ int freeze_super(struct super_block *sup
 		 const void *freeze_owner);
 int thaw_super(struct super_block *super, enum freeze_holder who,
 	       const void *freeze_owner);
+extern atomic_t sb_nr_freezing;
 
 int sb_init_dio_done_wq(struct super_block *sb);
 
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1245,8 +1245,8 @@ static inline bool folio_trylock_flag(st
 	return true;
 }
 
-static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
-		int state, enum behavior behavior)
+static inline int folio_wait_bit_common_timeout(struct folio *folio, int bit_nr, int state,
+		enum behavior behavior, long timeout)
 {
 	wait_queue_head_t *q = folio_waitqueue(folio);
 	int unfairness = sysctl_page_lock_unfairness;
@@ -1324,7 +1324,9 @@ repeat:
 			if (signal_pending_state(state, current))
 				break;
 
-			io_schedule();
+			timeout = io_schedule_timeout(timeout);
+			if (!timeout)
+				break;
 			continue;
 		}
 
@@ -1393,6 +1395,13 @@ repeat:
 	return wait->flags & WQ_FLAG_WOKEN ? 0 : -EINTR;
 }
 
+static inline int folio_wait_bit_common(struct folio *folio, int bit_nr, int state,
+		enum behavior behavior)
+{
+	return folio_wait_bit_common_timeout(folio, bit_nr, state, behavior,
+					     MAX_SCHEDULE_TIMEOUT);
+}
+
 #ifdef CONFIG_MIGRATION
 /**
  * softleaf_entry_wait_on_locked - Wait for a migration entry or
@@ -1490,6 +1499,13 @@ int folio_wait_bit_killable(struct folio
 }
 EXPORT_SYMBOL(folio_wait_bit_killable);
 
+/* wait up to @timeout jiffies for @bit_nr to clear, true if it cleared */
+bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout)
+{
+	return !folio_wait_bit_common_timeout(folio, bit_nr, TASK_UNINTERRUPTIBLE, SHARED,
+					      timeout);
+}
+
 /**
  * folio_put_wait_locked - Drop a reference and wait for it to be unlocked
  * @folio: The folio to wait for.
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1276,6 +1276,7 @@ struct migration_target_control {
  */
 ssize_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 			       struct folio *folio, loff_t fpos, size_t size);
+bool folio_wait_bit_timeout(struct folio *folio, int bit_nr, long timeout);
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1157,6 +1157,55 @@ static bool may_enter_fs(struct folio *f
 }
 
 /*
+ * Legacy memcg reclaim has no dirty throttling and waits for writeback in
+ * shrink_folio_list() instead. That wait can deadlock against a filesystem
+ * freeze:
+ *
+ * 1. A task holds freeze protection on filesystem B, e.g. in write(), enters
+ *    reclaim and waits for writeback of a folio whose I/O ends up as a write to
+ *    B, e.g. through a loop device backed by a file on B.
+ *
+ * 2. A freeze of B waits for the task to drop its freeze protection.
+ *
+ * 3. The write to B waits for the freeze.
+ *
+ * Reclaim can't tell which filesystem a writeback depends on. As a crude
+ * workaround, memcg_wait_writeback() times out and, if any filesystem is being
+ * frozen at that point, sets memcg_wb_wait_skip. While it is set, legacy memcg
+ * reclaim neither waits for nor throttles on writeback, so that the task a
+ * freeze may be waiting for isn't held up in reclaim and can drop its freeze
+ * protection. This can cause premature memcg OOM kills.
+ */
+static bool memcg_wb_wait_skip;
+
+/*
+ * Test memcg_wb_wait_skip. It takes effect only while a filesystem is being
+ * frozen and is cleared here once none is. A freeze that starts before it is
+ * cleared inherits the skip.
+ */
+static bool memcg_skip_wb_wait(void)
+{
+	if (!READ_ONCE(memcg_wb_wait_skip))
+		return false;
+	if (atomic_read(&sb_nr_freezing))
+		return true;
+	WRITE_ONCE(memcg_wb_wait_skip, false);
+	return false;
+}
+
+/* wait for writeback of @folio, see memcg_wb_wait_skip for the timeout */
+static void memcg_wait_writeback(struct folio *folio)
+{
+	while (!folio_wait_bit_timeout(folio, PG_writeback, 15 * HZ)) {
+		if (atomic_read(&sb_nr_freezing)) {
+			WRITE_ONCE(memcg_wb_wait_skip, true);
+			pr_warn("memcg1 writeback wait timed out during fs freeze, skipping waits, may OOM early\n");
+			return;
+		}
+	}
+}
+
+/*
  * shrink_folio_list() returns the number of reclaimed pages
  */
 static unsigned int shrink_folio_list(struct list_head *folio_list,
@@ -1277,7 +1326,9 @@ retry:
 		 *    reclaim flag set. memcg does not have any dirty folio
 		 *    throttling so we could easily OOM just because too many
 		 *    folios are in writeback and there is nothing else to
-		 *    reclaim. Wait for the writeback to complete.
+		 *    reclaim. Wait for the writeback to complete. If
+		 *    memcg_wait_writeback() gives up, such folios are treated
+		 *    as in case 2 until no filesystem is being frozen.
 		 *
 		 * In cases 1) and 2) we activate the folios to get them out of
 		 * the way while we continue scanning for clean folios on the
@@ -1300,6 +1351,7 @@ retry:
 
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
+			    memcg_skip_wb_wait() ||
 			    !folio_test_reclaim(folio) ||
 			    !may_enter_fs(folio, sc->gfp_mask) ||
 			    (mapping &&
@@ -1325,7 +1377,7 @@ retry:
 			/* Case 3 above */
 			} else {
 				folio_unlock(folio);
-				folio_wait_writeback(folio);
+				memcg_wait_writeback(folio);
 				/* then go back and try same folio again */
 				list_add_tail(&folio->lru, folio_list);
 				continue;
@@ -2086,7 +2138,7 @@ static void handle_reclaim_writeback(uns
 		 * enough for cgroupv1 writeback throttling to work
 		 * on a large system.
 		 */
-		if (!writeback_throttling_sane(sc))
+		if (!writeback_throttling_sane(sc) && !memcg_skip_wb_wait())
 			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
 	}
 
