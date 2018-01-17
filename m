From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v6 93/99] f2fs: Convert ino_root to XArray
Date: Wed, 17 Jan 2018 12:21:57 -0800
Message-ID: <20180117202203.19756-94-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7NlhZLzEe862nsjjn+PzkATmLIpT8jJP4lXQ6PTbYLg=; b=tNpBishKcVY2TJvh04kJ6iLEe
        wuI80h9QimCuAUMH5JwxTqo74bjKHkzu4SDLyqQeRR1TW3HWbqfdD97P8/RF8QlSI84VvyvWq3RHZ
        IY5opuVMnXjquNJ/EOmcyXF0G18dTmJVtzyDQoGzf06Oe04rQpBpu8tCgMQiIz06Ls6nEzMN5HvEc
        mu/kE616fg93M3ST1sO9u8ThokoAaYjRFqWxO9wL7E9Uzc98vTkC1VmGCGjsF3zkq7WFAlTP2AhHv
        9ta2u2rjPWI3fiH1c5vcJRJOo/JtUdQMQIaB9ZfvWKgJvyHeUhEQmIerd/7YHT3w8NM74djGpICDG
    
In-Reply-To: <20180117202203.19756-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

I did a fairly major rewrite of __add_ino_entry(); please check carefully.
Also, we can remove ino_list unless it's important to write out orphan
inodes in the order they were orphaned.  It may also make more sense to
combine the array of inode_management structures into a single XArray
with tags, but that would be a job for someone who understands this
filesystem better than I do.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/f2fs/checkpoint.c | 85 +++++++++++++++++++++++-----------------------------
 fs/f2fs/f2fs.h       |  3 +-
 2 files changed, 38 insertions(+), 50 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 4aa69bc1c70a..04d69679da13 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -403,33 +403,30 @@ static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino,
 	struct inode_management *im = &sbi->im[type];
 	struct ino_entry *e, *tmp;
 
-	tmp = f2fs_kmem_cache_alloc(ino_entry_slab, GFP_NOFS);
-
-	radix_tree_preload(GFP_NOFS | __GFP_NOFAIL);
-
-	spin_lock(&im->ino_lock);
-	e = radix_tree_lookup(&im->ino_root, ino);
-	if (!e) {
-		e = tmp;
-		if (unlikely(radix_tree_insert(&im->ino_root, ino, e)))
-			f2fs_bug_on(sbi, 1);
-
-		memset(e, 0, sizeof(struct ino_entry));
-		e->ino = ino;
-
-		list_add_tail(&e->list, &im->ino_list);
-		if (type != ORPHAN_INO)
-			im->ino_num++;
+	xa_lock(&im->ino_root);
+	e = xa_load(&im->ino_root, ino);
+	if (e)
+		goto found;
+	xa_unlock(&im->ino_root);
+
+	tmp = f2fs_kmem_cache_alloc(ino_entry_slab, GFP_NOFS | __GFP_ZERO);
+	xa_lock(&im->ino_root);
+	e = __xa_cmpxchg(&im->ino_root, ino, NULL, tmp,
+						GFP_NOFS | __GFP_NOFAIL);
+	if (e) {
+		kmem_cache_free(ino_entry_slab, tmp);
+		goto found;
 	}
+	e = tmp;
 
+	e->ino = ino;
+	list_add_tail(&e->list, &im->ino_list);
+	if (type != ORPHAN_INO)
+		im->ino_num++;
+found:
 	if (type == FLUSH_INO)
 		f2fs_set_bit(devidx, (char *)&e->dirty_device);
-
-	spin_unlock(&im->ino_lock);
-	radix_tree_preload_end();
-
-	if (e != tmp)
-		kmem_cache_free(ino_entry_slab, tmp);
+	xa_unlock(&im->ino_root);
 }
 
 static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
@@ -437,17 +434,14 @@ static void __remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 	struct inode_management *im = &sbi->im[type];
 	struct ino_entry *e;
 
-	spin_lock(&im->ino_lock);
-	e = radix_tree_lookup(&im->ino_root, ino);
+	xa_lock(&im->ino_root);
+	e = __xa_erase(&im->ino_root, ino);
 	if (e) {
 		list_del(&e->list);
-		radix_tree_delete(&im->ino_root, ino);
 		im->ino_num--;
-		spin_unlock(&im->ino_lock);
 		kmem_cache_free(ino_entry_slab, e);
-		return;
 	}
-	spin_unlock(&im->ino_lock);
+	xa_unlock(&im->ino_root);
 }
 
 void add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
@@ -466,12 +460,8 @@ void remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
 bool exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
 {
 	struct inode_management *im = &sbi->im[mode];
-	struct ino_entry *e;
 
-	spin_lock(&im->ino_lock);
-	e = radix_tree_lookup(&im->ino_root, ino);
-	spin_unlock(&im->ino_lock);
-	return e ? true : false;
+	return xa_load(&im->ino_root, ino) ? true : false;
 }
 
 void release_ino_entry(struct f2fs_sb_info *sbi, bool all)
@@ -482,14 +472,14 @@ void release_ino_entry(struct f2fs_sb_info *sbi, bool all)
 	for (i = all ? ORPHAN_INO : APPEND_INO; i < MAX_INO_ENTRY; i++) {
 		struct inode_management *im = &sbi->im[i];
 
-		spin_lock(&im->ino_lock);
+		xa_lock(&im->ino_root);
 		list_for_each_entry_safe(e, tmp, &im->ino_list, list) {
 			list_del(&e->list);
-			radix_tree_delete(&im->ino_root, e->ino);
+			__xa_erase(&im->ino_root, e->ino);
 			kmem_cache_free(ino_entry_slab, e);
 			im->ino_num--;
 		}
-		spin_unlock(&im->ino_lock);
+		xa_unlock(&im->ino_root);
 	}
 }
 
@@ -506,11 +496,11 @@ bool is_dirty_device(struct f2fs_sb_info *sbi, nid_t ino,
 	struct ino_entry *e;
 	bool is_dirty = false;
 
-	spin_lock(&im->ino_lock);
-	e = radix_tree_lookup(&im->ino_root, ino);
+	xa_lock(&im->ino_root);
+	e = xa_load(&im->ino_root, ino);
 	if (e && f2fs_test_bit(devidx, (char *)&e->dirty_device))
 		is_dirty = true;
-	spin_unlock(&im->ino_lock);
+	xa_unlock(&im->ino_root);
 	return is_dirty;
 }
 
@@ -519,11 +509,11 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 	struct inode_management *im = &sbi->im[ORPHAN_INO];
 	int err = 0;
 
-	spin_lock(&im->ino_lock);
+	xa_lock(&im->ino_root);
 
 #ifdef CONFIG_F2FS_FAULT_INJECTION
 	if (time_to_inject(sbi, FAULT_ORPHAN)) {
-		spin_unlock(&im->ino_lock);
+		xa_unlock(&im->ino_root);
 		f2fs_show_injection_info(FAULT_ORPHAN);
 		return -ENOSPC;
 	}
@@ -532,7 +522,7 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 		err = -ENOSPC;
 	else
 		im->ino_num++;
-	spin_unlock(&im->ino_lock);
+	xa_unlock(&im->ino_root);
 
 	return err;
 }
@@ -541,10 +531,10 @@ void release_orphan_inode(struct f2fs_sb_info *sbi)
 {
 	struct inode_management *im = &sbi->im[ORPHAN_INO];
 
-	spin_lock(&im->ino_lock);
+	xa_lock(&im->ino_root);
 	f2fs_bug_on(sbi, im->ino_num == 0);
 	im->ino_num--;
-	spin_unlock(&im->ino_lock);
+	xa_unlock(&im->ino_root);
 }
 
 void add_orphan_inode(struct inode *inode)
@@ -677,7 +667,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	orphan_blocks = GET_ORPHAN_BLOCKS(im->ino_num);
 
 	/*
-	 * we don't need to do spin_lock(&im->ino_lock) here, since all the
+	 * we don't need to lock the ino_root here, since all the
 	 * orphan inode operations are covered under f2fs_lock_op().
 	 * And, spin_lock should be avoided due to page operations below.
 	 */
@@ -1433,8 +1423,7 @@ void init_ino_entry_info(struct f2fs_sb_info *sbi)
 	for (i = 0; i < MAX_INO_ENTRY; i++) {
 		struct inode_management *im = &sbi->im[i];
 
-		INIT_RADIX_TREE(&im->ino_root, GFP_ATOMIC);
-		spin_lock_init(&im->ino_lock);
+		xa_init(&im->ino_root);
 		INIT_LIST_HEAD(&im->ino_list);
 		im->ino_num = 0;
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 6abf26c31d01..b3ee784b49bc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -994,8 +994,7 @@ enum inode_type {
 
 /* for inner inode cache management */
 struct inode_management {
-	struct radix_tree_root ino_root;	/* ino entry array */
-	spinlock_t ino_lock;			/* for ino entry lock */
+	struct xarray ino_root;			/* ino entry array */
 	struct list_head ino_list;		/* inode list head */
 	unsigned long ino_num;			/* number of entries */
 };
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
