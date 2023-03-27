From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/7] btrfs: don't free the async_extent in submit_uncompressed_range
Date: Mon, 27 Mar 2023 09:49:48 +0900
Message-ID: <20230327004954.728797-3-hch@lst.de>
References: <20230327004954.728797-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IcR9WNRaoxss7fLW0ETcKOS8EdYmX7y+mCZKK90iRwg=; b=cJb+AO2QZ13dW24wgLGF2UtMek
        7SD74w/Ih5smi2PHCmAJhat5SLqQ82RKAl3vtbm7EkUaISCdWadxP/QrqQT8rmycE80LCi0FkLeak
        pgEDHr08kSzQr4XD6dPecVBLDxSv33f1llgQ+y96gXFp3FDhWvrvqd4WPlhbg1mid/7Kf3HsT+/8k
        Pqn+rEoDHH2+lPPFDnY6dHlXOPkDTw9P9sCuX/sqLkdqtnWy24UApdHuj6vWp5ytbQKMdzgtfj+2z
        D4ML9iZ4oTrF8ryJ7Q1cqs2WJGGZEvPz6UIFKCsl0x/M6zhmb0K3G/4vEQuOc5wOXFLsmbBiL1Pxz
        wiNHgGJA==;
In-Reply-To: <20230327004954.728797-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Let submit_one_async_extent, which is the only caller of
submit_uncompressed_range handle freeing of the async_extent in one
central place.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/btrfs/inode.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 698915c032bddc..7a1bfce9532fe9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -944,10 +944,9 @@ static int submit_uncompressed_range(struct btrfs_inode *inode,
 	ret = cow_file_range(inode, locked_page, start, end, &page_started,
 			     &nr_written, 0, NULL);
 	/* Inline extent inserted, page gets unlocked and everything is done */
-	if (page_started) {
-		ret = 0;
-		goto out;
-	}
+	if (page_started)
+		return 0;
+
 	if (ret < 0) {
 		btrfs_cleanup_ordered_extents(inode, locked_page, start, end - start + 1);
 		if (locked_page) {
@@ -961,14 +960,11 @@ static int submit_uncompressed_range(struct btrfs_inode *inode,
 			end_extent_writepage(locked_page, ret, page_start, page_end);
 			unlock_page(locked_page);
 		}
-		goto out;
+		return ret;
 	}
 
-	ret = extent_write_locked_range(&inode->vfs_inode, start, end);
 	/* All pages will be unlocked, including @locked_page */
-out:
-	kfree(async_extent);
-	return ret;
+	return extent_write_locked_range(&inode->vfs_inode, start, end);
 }
 
 static int submit_one_async_extent(struct btrfs_inode *inode,
@@ -1000,8 +996,10 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 	lock_extent(io_tree, start, end, NULL);
 
 	/* We have fall back to uncompressed write */
-	if (!async_extent->pages)
-		return submit_uncompressed_range(inode, async_extent, locked_page);
+	if (!async_extent->pages) {
+		ret = submit_uncompressed_range(inode, async_extent, locked_page);
+		goto done;
+	}
 
 	ret = btrfs_reserve_extent(root, async_extent->ram_size,
 				   async_extent->compressed_size,
@@ -1066,6 +1064,7 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 	if (async_chunk->blkcg_css)
 		kthread_associate_blkcg(NULL);
 	*alloc_hint = ins.objectid + ins.offset;
+done:
 	kfree(async_extent);
 	return ret;
 
@@ -1080,8 +1079,7 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 				     PAGE_UNLOCK | PAGE_START_WRITEBACK |
 				     PAGE_END_WRITEBACK | PAGE_SET_ERROR);
 	free_async_extent_pages(async_extent);
-	kfree(async_extent);
-	return ret;
+	goto done;
 }
 
 /*
-- 
2.39.2

