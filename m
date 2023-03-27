From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/7] btrfs: move kthread_associate_blkcg out of btrfs_submit_compressed_write
Date: Mon, 27 Mar 2023 09:49:47 +0900
Message-ID: <20230327004954.728797-2-hch@lst.de>
References: <20230327004954.728797-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Trysqpweee+qWzGHqxcE1HT8iJvrLd8NeStOiz6Nac8=; b=t9r+LtTKkT/s7bbJCYSmxTg3R2
        WB05WrX7Diii3DvJ8p7nobg4U0Ekjjn04grlgNCRIgXAFfcyPgKdDfeEQ1JVpsyvBFZ+Hbhb6CWVo
        xC0PGSQFb3i2JBt3sVySdNCCWu+kRVTbSg/o7HsjgbWyg77gzct4ykXgtzlV4SEDf1YW749Zn3og1
        Bh00PNtYT12oIwOJCmV2uu0WpAVjB/zcSbNTy8NL1wn1AURLBwhRTleD5xU2UmZNQYCYXK3dgm9mG
        RjpwfqxL+dHu8Lzu8YCXm+8ArfEfcrrS79U9i0nVlcr6fePaZwPjk3P5ZKhIO8utjuWWtmfauOnnF
        bhdZGSMg==;
In-Reply-To: <20230327004954.728797-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

btrfs_submit_compressed_write should not have to care if it is called
from a helper thread or not.  Move the kthread_associate_blkcg handling
into submit_one_async_extent, as that is the one caller that needs it.
Also move the assignment of REQ_CGROUP_PUNT into cow_file_range_async,
as that is the routine that sets up the helper thread offload.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/btrfs/compression.c |  8 --------
 fs/btrfs/compression.h |  1 -
 fs/btrfs/inode.c       | 12 ++++++++----
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 44c4276741ceda..d532a8c8c9d8c6 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -286,7 +286,6 @@ void btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 				 struct page **compressed_pages,
 				 unsigned int nr_pages,
 				 blk_opf_t write_flags,
-				 struct cgroup_subsys_state *blkcg_css,
 				 bool writeback)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
@@ -295,10 +294,6 @@ void btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 	ASSERT(IS_ALIGNED(start, fs_info->sectorsize) &&
 	       IS_ALIGNED(len, fs_info->sectorsize));
 
-	if (blkcg_css) {
-		kthread_associate_blkcg(blkcg_css);
-		write_flags |= REQ_CGROUP_PUNT;
-	}
 	write_flags |= REQ_BTRFS_ONE_ORDERED;
 
 	cb = alloc_compressed_bio(inode, start, REQ_OP_WRITE | write_flags,
@@ -314,9 +309,6 @@ void btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 	btrfs_add_compressed_bio_pages(cb);
 
 	btrfs_submit_bio(&cb->bbio, 0);
-
-	if (blkcg_css)
-		kthread_associate_blkcg(NULL);
 }
 
 /*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 5d5146e72a860b..19ab2abeddc088 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -92,7 +92,6 @@ void btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 				  struct page **compressed_pages,
 				  unsigned int nr_pages,
 				  blk_opf_t write_flags,
-				  struct cgroup_subsys_state *blkcg_css,
 				  bool writeback);
 void btrfs_submit_compressed_read(struct btrfs_bio *bbio, int mirror_num);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 865d56ff2ce150..698915c032bddc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1053,14 +1053,18 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 	extent_clear_unlock_delalloc(inode, start, end,
 			NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 			PAGE_UNLOCK | PAGE_START_WRITEBACK);
+
+	if (async_chunk->blkcg_css)
+		kthread_associate_blkcg(async_chunk->blkcg_css);
 	btrfs_submit_compressed_write(inode, start,	/* file_offset */
 			    async_extent->ram_size,	/* num_bytes */
 			    ins.objectid,		/* disk_bytenr */
 			    ins.offset,			/* compressed_len */
 			    async_extent->pages,	/* compressed_pages */
 			    async_extent->nr_pages,
-			    async_chunk->write_flags,
-			    async_chunk->blkcg_css, true);
+			    async_chunk->write_flags, true);
+	if (async_chunk->blkcg_css)
+		kthread_associate_blkcg(NULL);
 	*alloc_hint = ins.objectid + ins.offset;
 	kfree(async_extent);
 	return ret;
@@ -1612,6 +1616,7 @@ static int cow_file_range_async(struct btrfs_inode *inode,
 		if (blkcg_css != blkcg_root_css) {
 			css_get(blkcg_css);
 			async_chunk[i].blkcg_css = blkcg_css;
+			async_chunk[i].write_flags |= REQ_CGROUP_PUNT;
 		} else {
 			async_chunk[i].blkcg_css = NULL;
 		}
@@ -10374,8 +10379,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	btrfs_delalloc_release_extents(inode, num_bytes);
 
 	btrfs_submit_compressed_write(inode, start, num_bytes, ins.objectid,
-					  ins.offset, pages, nr_pages, 0, NULL,
-					  false);
+					  ins.offset, pages, nr_pages, 0, false);
 	ret = orig_count;
 	goto out;
 
-- 
2.39.2

