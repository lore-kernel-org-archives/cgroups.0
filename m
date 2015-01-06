From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 41/45] writeback: make __writeback_single_inode() cgroup writeback aware
Date: Tue,  6 Jan 2015 16:26:18 -0500
Message-ID: <1420579582-8516-42-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xRtH2RGlXR6/nbwrqk50q+hhyaaEl1mum1+ZPCB8jHQ=;
        b=DahYpeNJkXeUEkDFOE4Jh9pTzYZQJjalMWAQT2qKykrZ8HWI59FQyAICcMD/RpwFH0
         v2TvFBgNRELbOU7VqV7g+gF3YS2xcOHD+Hu5Vy735w/lXDKo0trkiklYmoBm0/2b4BWC
         B+VOm5dK/MektKoTRexr3L1K6XlOXiWMHVpn2VL1PONpDLQOCRBmH/rJp9WYi6/nTwIR
         yRASul4rodwhTN7COIDhG4Xh1eqlSjqIZIDD+vB8poNMq8CevACXThMN2Cd3HpcoazQw
         C+K8mdj6CjP5Ns5rrMHGbfT8qAMnjBKvjgkCn8h1SPDaGaVO76rAMDCt9KlTDxZq4iDU
         VkUA==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

Metadata is always dirtied against the root cgroup and should thus be
written out only by the root cgroup writeback.  This patch updates
__writeback_single_inode() so that it skips writing out metadata if
the writeback is for a non-root cgroup.  wbc_skip_metadata() is added
to decide whether to skip metadata writeback.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index dbfd0b0..2bb14d5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -684,6 +684,19 @@ static inline bool iwbl_still_has_dirty_pages(struct inode_wb_link *iwbl,
 	return test_bit(IWBL_DIRTY_PAGES, &iwbl->data);
 }
 
+/**
+ * wbc_skip_metadata - determine whether to skip writing out metadata
+ * @wbc: writeback_control in effect
+ *
+ * Called by __writeback_single_inode() to decide whether to skip writing
+ * out metadata.  Metadata is always dirtied against the root cgroup and
+ * should only be written out by the root.
+ */
+static inline bool wbc_skip_metadata(struct writeback_control *wbc)
+{
+	return wbc->iwbl && !iwbl_is_root(wbc->iwbl);
+}
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static void init_cgwb_dirty_page_context(struct dirty_context *dctx)
@@ -791,6 +804,11 @@ static inline bool iwbl_still_has_dirty_pages(struct inode_wb_link *iwbl,
 	return mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY);
 }
 
+static inline bool wbc_skip_metadata(struct writeback_control *wbc)
+{
+	return false;
+}
+
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
 /**
@@ -1128,6 +1146,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	struct address_space *mapping = inode->i_mapping;
 	struct inode_wb_link *iwbl = inode_writeback_iwbl(inode, wbc);
 	long nr_to_write = wbc->nr_to_write;
+	bool skip_metadata = wbc_skip_metadata(wbc);
 	unsigned dirty;
 	int ret;
 
@@ -1144,7 +1163,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	 * separate, external IO completion path and ->sync_fs for guaranteeing
 	 * inode metadata is written back correctly.
 	 */
-	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync && !skip_metadata) {
 		int err = filemap_fdatawait(mapping);
 		if (ret == 0)
 			ret = err;
@@ -1157,8 +1176,12 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	 */
 	spin_lock(&inode->i_lock);
 
-	dirty = inode->i_state & I_DIRTY;
-	inode->i_state &= ~I_DIRTY;
+	if (skip_metadata)
+		dirty = inode->i_state & I_DIRTY_PAGES;
+	else
+		dirty = inode->i_state & I_DIRTY;
+
+	inode->i_state &= ~dirty;
 
 	/*
 	 * Paired with smp_mb() in __mark_inode_dirty_dctx().  This allows
-- 
2.1.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
