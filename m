From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 33/49] writeback: don't issue wb_writeback_work if clean
Date: Mon,  6 Apr 2015 15:58:22 -0400
Message-ID: <1428350318-8215-34-git-send-email-tj@kernel.org>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nu1iPuMX5jMZ6CGHGwlyy54DMxNLC2l6kTthI8anOFg=;
        b=s88Lc4MB9YA1dot33Pk2nnrqldiOYhihRxE7Wm7278mW4EQlQEOH9XwmqXHHNBx4e4
         +XibM19VqYSgAG2AWmsSkHIaWBKRnRv7bEvPfIqHaXSfjVa0ZupX5d/RT/RDZffRH8Mu
         +02OI91sdiOkBvkQBGdcTb1H5RbKp8+IwuJAdqJZa9jX7BJPFfZ8cGO2Ke91hjwmLi2i
         aRmtNud2Spx9gUA8sxzNpbirYZZKf1QvhzOhLXp4wacQy4RghUAfZeiQRqUoaxSBNZdU
         6NDIufvJLU91MBnhHpkTXR6YewCwyQlp2OODrUSk/F1NZkAoyDHiQjwkn8G2TxCp5s24
         jKyA==
In-Reply-To: <1428350318-8215-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, Tejun Heo <tj@kernel.org>

There are several places in fs/fs-writeback.c which queues
wb_writeback_work without checking whether the target wb
(bdi_writeback) has dirty inodes or not.  The only thing
wb_writeback_work does is writing back the dirty inodes for the target
wb and queueing a work item for a clean wb is essentially noop.  There
are some side effects such as bandwidth stats being updated and
triggering tracepoints but these don't affect the operation in any
meaningful way.

This patch makes all writeback_inodes_sb_nr() and sync_inodes_sb()
skip wb_queue_work() if the target bdi is clean.  Also, it moves
dirtiness check from wakeup_flusher_threads() to
__wb_start_writeback() so that all its callers benefit from the check.

While the overhead incurred by scheduling a noop work isn't currently
significant, the overhead may be higher with cgroup writeback support
as we may end up issuing noop work items to a lot of clean wb's.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5df1bc7..6720af9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -177,6 +177,9 @@ static void __wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
 {
 	struct wb_writeback_work *work;
 
+	if (!wb_has_dirty_io(wb))
+		return;
+
 	/*
 	 * This is WB_SYNC_NONE writeback, so if allocation fails just
 	 * wakeup the thread for old dirty data writeback
@@ -1197,11 +1200,8 @@ void wakeup_flusher_threads(long nr_pages, enum wb_reason reason)
 		nr_pages = get_nr_dirty_pages();
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
-		if (!bdi_has_dirty_io(bdi))
-			continue;
+	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
 		__wb_start_writeback(&bdi->wb, nr_pages, false, reason);
-	}
 	rcu_read_unlock();
 }
 
@@ -1435,11 +1435,12 @@ void writeback_inodes_sb_nr(struct super_block *sb,
 		.nr_pages		= nr,
 		.reason			= reason,
 	};
+	struct backing_dev_info *bdi = sb->s_bdi;
 
-	if (sb->s_bdi == &noop_backing_dev_info)
+	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
-	wb_queue_work(&sb->s_bdi->wb, &work);
+	wb_queue_work(&bdi->wb, &work);
 	wait_for_completion(&done);
 }
 EXPORT_SYMBOL(writeback_inodes_sb_nr);
@@ -1517,13 +1518,14 @@ void sync_inodes_sb(struct super_block *sb)
 		.reason		= WB_REASON_SYNC,
 		.for_sync	= 1,
 	};
+	struct backing_dev_info *bdi = sb->s_bdi;
 
 	/* Nothing to do? */
-	if (sb->s_bdi == &noop_backing_dev_info)
+	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	wb_queue_work(&sb->s_bdi->wb, &work);
+	wb_queue_work(&bdi->wb, &work);
 	wait_for_completion(&done);
 
 	wait_sb_inodes(sb);
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
