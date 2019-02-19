From: Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 3/3] blkcg: implement sync() isolation
Date: Tue, 19 Feb 2019 16:27:12 +0100
Message-ID: <20190219152712.9855-4-righi.andrea@gmail.com>
References: <20190219152712.9855-1-righi.andrea@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=c98WFQKqSGewnmjGR+VAUu2jdbTDTi2eXPqlfHCbeCU=;
        b=P+6GFnyVpg2KZGAIvcNuVcwUz8RKDcIJqgGs+wbGQMM/EqhXUxwX0boLM2h38zYuKH
         JF9igYIFbiaVwv+rzAwyq7wRD9ltKKasUpaIRHZ6Hm2O5/Y18QXHx7oGN9B++3bG5TTM
         iR4i8+mu3M4JEDaNSPlMQK2UhFh8TXwA2SoNePLRKuB/mRqi8wRVmNegc4+Pp+gcgwyn
         IpeueEJ9cFjHGFbFu8O9LTE1svbaOhLrjToACAJNmeAqYoklqRiHW/iaaCY6LQjEd4BB
         ulyYxlxqpdpIOshBcPLOp2qUuAOuOawp/lApQMoTcO9XLjXxH1feNEUAYwYmLn9G2FEL
         uRtQ==
In-Reply-To: <20190219152712.9855-1-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Paolo Valente <paolo.valente@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Keep track of the inodes that have been dirtied by each blkcg cgroup and
make sure that a blkcg issuing a sync() can trigger the writeback + wait
of only those pages that belong to the cgroup itself.

This behavior is enabled only when io.sync_isolation is enabled in the
cgroup, otherwise the old behavior is applied: sync() triggers the
writeback of any dirty page.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 block/blk-cgroup.c         | 47 ++++++++++++++++++++++++++++++++++
 fs/fs-writeback.c          | 52 +++++++++++++++++++++++++++++++++++---
 fs/inode.c                 |  1 +
 include/linux/blk-cgroup.h | 22 ++++++++++++++++
 include/linux/fs.h         |  4 +++
 mm/page-writeback.c        |  1 +
 6 files changed, 124 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fb3c39eadf92..c6ddf9eeab37 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1422,6 +1422,53 @@ void blkcg_stop_wb_wait_on_bdi(struct backing_dev_info *bdi)
 	rcu_read_unlock();
 	synchronize_rcu();
 }
+
+/**
+ * blkcg_set_mapping_dirty - set owner of a dirty mapping
+ * @mapping: target address space
+ *
+ * Set the current blkcg as the owner of the address space @mapping (the first
+ * blkcg that dirties @mapping becomes the owner).
+ */
+void blkcg_set_mapping_dirty(struct address_space *mapping)
+{
+	struct blkcg *curr_blkcg, *blkcg;
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
+	    mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+		return;
+
+	rcu_read_lock();
+	curr_blkcg = blkcg_from_current();
+	blkcg = blkcg_from_mapping(mapping);
+	if (curr_blkcg != blkcg) {
+		if (blkcg)
+			css_put(&blkcg->css);
+		css_get(&curr_blkcg->css);
+		rcu_assign_pointer(mapping->i_blkcg, curr_blkcg);
+	}
+	rcu_read_unlock();
+}
+
+/**
+ * blkcg_set_mapping_dirty - clear the owner of a dirty mapping
+ * @mapping: target address space
+ *
+ * Unset the owner of @mapping when it becomes clean.
+ */
+
+void blkcg_set_mapping_clean(struct address_space *mapping)
+{
+	struct blkcg *blkcg;
+
+	rcu_read_lock();
+	blkcg = rcu_dereference(mapping->i_blkcg);
+	if (blkcg) {
+		css_put(&blkcg->css);
+		RCU_INIT_POINTER(mapping->i_blkcg, NULL);
+	}
+	rcu_read_unlock();
+}
 #endif
 
 /**
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 77c039a0ec25..d003d0593f41 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -58,6 +58,9 @@ struct wb_writeback_work {
 
 	struct list_head list;		/* pending work list */
 	struct wb_completion *done;	/* set if the caller waits */
+#ifdef CONFIG_CGROUP_WRITEBACK
+	struct blkcg *blkcg;
+#endif
 };
 
 /*
@@ -916,6 +919,29 @@ static int __init cgroup_writeback_init(void)
 }
 fs_initcall(cgroup_writeback_init);
 
+static void blkcg_set_sync_domain(struct wb_writeback_work *work)
+{
+	rcu_read_lock();
+	work->blkcg = blkcg_from_current();
+	rcu_read_unlock();
+}
+
+static bool blkcg_same_sync_domain(struct wb_writeback_work *work,
+				   struct address_space *mapping)
+{
+	struct blkcg *blkcg;
+
+	if (!work->blkcg || work->blkcg == &blkcg_root)
+		return true;
+	if (!test_bit(BLKCG_SYNC_ISOLATION, &work->blkcg->flags))
+		return true;
+	rcu_read_lock();
+	blkcg = blkcg_from_mapping(mapping);
+	rcu_read_unlock();
+
+	return blkcg == work->blkcg;
+}
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi) { }
@@ -959,6 +985,15 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 	}
 }
 
+static void blkcg_set_sync_domain(struct wb_writeback_work *work)
+{
+}
+
+static bool blkcg_same_sync_domain(struct wb_writeback_work *work,
+				   struct address_space *mapping)
+{
+	return true;
+}
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 /*
@@ -1131,7 +1166,7 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 	LIST_HEAD(tmp);
 	struct list_head *pos, *node;
 	struct super_block *sb = NULL;
-	struct inode *inode;
+	struct inode *inode, *next;
 	int do_sb_sort = 0;
 	int moved = 0;
 
@@ -1141,11 +1176,12 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 		expire_time = jiffies - (dirtytime_expire_interval * HZ);
 		older_than_this = &expire_time;
 	}
-	while (!list_empty(delaying_queue)) {
-		inode = wb_inode(delaying_queue->prev);
+	list_for_each_entry_safe(inode, next, delaying_queue, i_io_list) {
 		if (older_than_this &&
 		    inode_dirtied_after(inode, *older_than_this))
 			break;
+		if (!blkcg_same_sync_domain(work, inode->i_mapping))
+			continue;
 		list_move(&inode->i_io_list, &tmp);
 		moved++;
 		if (flags & EXPIRE_DIRTY_ATIME)
@@ -1560,6 +1596,15 @@ static long writeback_sb_inodes(struct super_block *sb,
 			break;
 		}
 
+		/*
+		 * Only write out inodes that belong to the blkcg that issued
+		 * the sync().
+		 */
+		if (!blkcg_same_sync_domain(work, inode->i_mapping)) {
+			redirty_tail(inode, wb);
+			continue;
+		}
+
 		/*
 		 * Don't bother with new inodes or inodes being freed, first
 		 * kind does not need periodic writeout yet, and for the latter
@@ -2447,6 +2492,7 @@ void sync_inodes_sb(struct super_block *sb)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
+	blkcg_set_sync_domain(&work);
 	blkcg_start_wb_wait_on_bdi(bdi);
 
 	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
diff --git a/fs/inode.c b/fs/inode.c
index 73432e64f874..d60a2042d39a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -564,6 +564,7 @@ static void evict(struct inode *inode)
 		bd_forget(inode);
 	if (S_ISCHR(inode->i_mode) && inode->i_cdev)
 		cd_forget(inode);
+	blkcg_set_mapping_clean(&inode->i_data);
 
 	remove_inode_hash(inode);
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 6ac5aa049334..a2bcc83c8c3e 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -441,6 +441,15 @@ extern void blkcg_destroy_blkgs(struct blkcg *blkcg);
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 
+static inline struct blkcg *blkcg_from_mapping(struct address_space *mapping)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return rcu_dereference(mapping->i_blkcg);
+}
+
+void blkcg_set_mapping_dirty(struct address_space *mapping);
+void blkcg_set_mapping_clean(struct address_space *mapping);
+
 /**
  * blkcg_cgwb_get - get a reference for blkcg->cgwb_list
  * @blkcg: blkcg of interest
@@ -474,6 +483,19 @@ void blkcg_stop_wb_wait_on_bdi(struct backing_dev_info *bdi);
 
 #else
 
+static inline struct blkcg *blkcg_from_mapping(struct address_space *mapping)
+{
+	return NULL;
+}
+
+static inline void blkcg_set_mapping_dirty(struct address_space *mapping)
+{
+}
+
+static inline void blkcg_set_mapping_clean(struct address_space *mapping)
+{
+}
+
 static inline void blkcg_cgwb_get(struct blkcg *blkcg) { }
 
 static inline void blkcg_cgwb_put(struct blkcg *blkcg)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 29d8e2cfed0e..502a2b94f183 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -414,6 +414,7 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
  * @nrpages: Number of page entries, protected by the i_pages lock.
  * @nrexceptional: Shadow or DAX entries, protected by the i_pages lock.
  * @writeback_index: Writeback starts here.
+ * @i_blkcg: blkcg owner (that dirtied the address_space)
  * @a_ops: Methods.
  * @flags: Error bits and flags (AS_*).
  * @wb_err: The most recent error which has occurred.
@@ -432,6 +433,9 @@ struct address_space {
 	unsigned long		nrexceptional;
 	pgoff_t			writeback_index;
 	const struct address_space_operations *a_ops;
+#ifdef CONFIG_CGROUP_WRITEBACK
+	struct blkcg __rcu	*i_blkcg;
+#endif
 	unsigned long		flags;
 	errseq_t		wb_err;
 	spinlock_t		private_lock;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7d1010453fb9..a58071ee5f1c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2410,6 +2410,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 		inode_attach_wb(inode, page);
 		wb = inode_to_wb(inode);
 
+		blkcg_set_mapping_dirty(mapping);
 		__inc_lruvec_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
 		__inc_node_page_state(page, NR_DIRTIED);
-- 
2.17.1

