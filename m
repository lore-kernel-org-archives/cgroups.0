From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v6 94/99] f2fs: Convert extent_tree_root to XArray
Date: Wed, 17 Jan 2018 12:21:58 -0800
Message-ID: <20180117202203.19756-95-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/a6OGWRc2ZLVnDjmJc12Mjc/f/sFqqYukAEJhi/KYjo=; b=efn8fvAUACKFKPKaEaureEs4R
        wnlOJ/seiL1eUALkkSpEbvCrSkDO3G7C0z8h7XDthvsIstRxdcXg2ZHyP5+WHLuZKZVq98hG1hJd0
        d5oDYelnr18UzmZqVC7P4kSEL1z1yqcWpQ2cynw/r5QKATpl2WY5YanwelP2acILAOKmGPaSEp8sa
        9cLUM8S9sL0OMhwEmK0O0uUNkGgosWyIGQNqkHF7f7LqMTo9D2nppJcO46gPAANzhIbvTrWprcBmS
        VvDii+dZiqJY0i9c8vnh0lP1EFtWIuWeridDjCMxYiBmwj1qOVw9+B334XD5TqOe/ljTu9P+viKEn
    
In-Reply-To: <20180117202203.19756-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Rename it to extent_array and use the xa_lock in place of the
extent_tree_lock mutex.

Signed-off-by: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/f2fs/extent_cache.c | 59 +++++++++++++++++++++++++-------------------------
 fs/f2fs/f2fs.h         |  3 +--
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index ff2352a0ed15..da5f3bd1808d 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -250,25 +250,25 @@ static struct extent_tree *__grab_extent_tree(struct inode *inode)
 	struct extent_tree *et;
 	nid_t ino = inode->i_ino;
 
-	mutex_lock(&sbi->extent_tree_lock);
-	et = radix_tree_lookup(&sbi->extent_tree_root, ino);
-	if (!et) {
-		et = f2fs_kmem_cache_alloc(extent_tree_slab, GFP_NOFS);
-		f2fs_radix_tree_insert(&sbi->extent_tree_root, ino, et);
-		memset(et, 0, sizeof(struct extent_tree));
-		et->ino = ino;
-		et->root = RB_ROOT;
-		et->cached_en = NULL;
-		rwlock_init(&et->lock);
-		INIT_LIST_HEAD(&et->list);
-		atomic_set(&et->node_cnt, 0);
-		atomic_inc(&sbi->total_ext_tree);
-	} else {
+	et = xa_load(&sbi->extent_array, ino);
+	if (et) {
 		atomic_dec(&sbi->total_zombie_tree);
 		list_del_init(&et->list);
+		goto out;
 	}
-	mutex_unlock(&sbi->extent_tree_lock);
 
+	et = f2fs_kmem_cache_alloc(extent_tree_slab, GFP_NOFS | __GFP_ZERO);
+	et->ino = ino;
+	et->root = RB_ROOT;
+	et->cached_en = NULL;
+	rwlock_init(&et->lock);
+	INIT_LIST_HEAD(&et->list);
+	atomic_set(&et->node_cnt, 0);
+
+	xa_store(&sbi->extent_array, ino, et, GFP_NOFS);
+	atomic_inc(&sbi->total_ext_tree);
+
+out:
 	/* never died until evict_inode */
 	F2FS_I(inode)->extent_tree = et;
 
@@ -622,7 +622,7 @@ unsigned int f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 	if (!atomic_read(&sbi->total_zombie_tree))
 		goto free_node;
 
-	if (!mutex_trylock(&sbi->extent_tree_lock))
+	if (!xa_trylock(&sbi->extent_array))
 		goto out;
 
 	/* 1. remove unreferenced extent tree */
@@ -634,7 +634,7 @@ unsigned int f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 		}
 		f2fs_bug_on(sbi, atomic_read(&et->node_cnt));
 		list_del_init(&et->list);
-		radix_tree_delete(&sbi->extent_tree_root, et->ino);
+		xa_erase(&sbi->extent_array, et->ino);
 		kmem_cache_free(extent_tree_slab, et);
 		atomic_dec(&sbi->total_ext_tree);
 		atomic_dec(&sbi->total_zombie_tree);
@@ -642,13 +642,13 @@ unsigned int f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 
 		if (node_cnt + tree_cnt >= nr_shrink)
 			goto unlock_out;
-		cond_resched();
+		cond_resched_lock(&sbi->extent_array.xa_lock);
 	}
-	mutex_unlock(&sbi->extent_tree_lock);
+	xa_unlock(&sbi->extent_array);
 
 free_node:
 	/* 2. remove LRU extent entries */
-	if (!mutex_trylock(&sbi->extent_tree_lock))
+	if (!xa_trylock(&sbi->extent_array))
 		goto out;
 
 	remained = nr_shrink - (node_cnt + tree_cnt);
@@ -678,7 +678,7 @@ unsigned int f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
 	spin_unlock(&sbi->extent_lock);
 
 unlock_out:
-	mutex_unlock(&sbi->extent_tree_lock);
+	xa_unlock(&sbi->extent_array);
 out:
 	trace_f2fs_shrink_extent_tree(sbi, node_cnt, tree_cnt);
 
@@ -725,23 +725,23 @@ void f2fs_destroy_extent_tree(struct inode *inode)
 
 	if (inode->i_nlink && !is_bad_inode(inode) &&
 					atomic_read(&et->node_cnt)) {
-		mutex_lock(&sbi->extent_tree_lock);
+		xa_lock(&sbi->extent_array);
 		list_add_tail(&et->list, &sbi->zombie_list);
 		atomic_inc(&sbi->total_zombie_tree);
-		mutex_unlock(&sbi->extent_tree_lock);
+		xa_unlock(&sbi->extent_array);
 		return;
 	}
 
 	/* free all extent info belong to this extent tree */
 	node_cnt = f2fs_destroy_extent_node(inode);
 
-	/* delete extent tree entry in radix tree */
-	mutex_lock(&sbi->extent_tree_lock);
+	/* delete extent from array */
+	xa_lock(&sbi->extent_array);
 	f2fs_bug_on(sbi, atomic_read(&et->node_cnt));
-	radix_tree_delete(&sbi->extent_tree_root, inode->i_ino);
-	kmem_cache_free(extent_tree_slab, et);
+	__xa_erase(&sbi->extent_array, inode->i_ino);
 	atomic_dec(&sbi->total_ext_tree);
-	mutex_unlock(&sbi->extent_tree_lock);
+	xa_unlock(&sbi->extent_array);
+	kmem_cache_free(extent_tree_slab, et);
 
 	F2FS_I(inode)->extent_tree = NULL;
 
@@ -787,8 +787,7 @@ void f2fs_update_extent_cache_range(struct dnode_of_data *dn,
 
 void init_extent_cache_info(struct f2fs_sb_info *sbi)
 {
-	INIT_RADIX_TREE(&sbi->extent_tree_root, GFP_NOIO);
-	mutex_init(&sbi->extent_tree_lock);
+	xa_init(&sbi->extent_array);
 	INIT_LIST_HEAD(&sbi->extent_list);
 	spin_lock_init(&sbi->extent_lock);
 	atomic_set(&sbi->total_ext_tree, 0);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b3ee784b49bc..4eacef9c7274 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1064,8 +1064,7 @@ struct f2fs_sb_info {
 	spinlock_t inode_lock[NR_INODE_TYPE];	/* for dirty inode list lock */
 
 	/* for extent tree cache */
-	struct radix_tree_root extent_tree_root;/* cache extent cache entries */
-	struct mutex extent_tree_lock;	/* locking extent radix tree */
+	struct xarray extent_array;		/* cache extent cache entries */
 	struct list_head extent_list;		/* lru list for shrinker */
 	spinlock_t extent_lock;			/* locking extent lru list */
 	atomic_t total_ext_tree;		/* extent tree count */
-- 
2.15.1
