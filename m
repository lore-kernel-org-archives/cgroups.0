From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/7] btrfs: also use kthread_associate_blkcg for uncompressible ranges
Date: Mon, 27 Mar 2023 09:49:49 +0900
Message-ID: <20230327004954.728797-4-hch@lst.de>
References: <20230327004954.728797-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=s56AsIYlw5q14zHr9Gzs0WZIFhX1rh7X7dJ8YVLzjck=; b=osaR8wPjMXD5wK8oFuegBQydlT
        invB/3B/4gcOvmAjjqU3q+bMd4kHMkxNQR+nkpaz1ydBWTsFJ8egQ2UtHZgJYTCHXyiRmMXbRcT92
        kMXpdyD20pAnO7e03Vx6I7WZw31bNb7/BexopC/81XGrKsRp4TSwsfjuvNN2IasoUDR9oXhh3J1WO
        C0g7DIt3KeUJ6LpPyZUEqFg8qgX019WO/Ayhnbh4tJXCYoXm/KJg91x1/OA/di8pRCzzaRlYqxlFp
        N6xlw6JvdVqnZRFTo3fFLm7C/HdjLeFFW8SA+LINMmA4LVtI/FvbvfgSbXSsXQvZAgD11pg8CcJWG
        7qcEW5uw==;
In-Reply-To: <20230327004954.728797-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

submit_one_async_extent needs to use submit_one_async_extent no matter
if the range it handles ends up beeing compressed or not as the deadlock
risk due to cgroup thottling is the same.  Call kthread_associate_blkcg
earlier to cover submit_uncompressed_range case as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7a1bfce9532fe9..713b47792b9b7e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -982,6 +982,9 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 	u64 start = async_extent->start;
 	u64 end = async_extent->start + async_extent->ram_size - 1;
 
+	if (async_chunk->blkcg_css)
+		kthread_associate_blkcg(async_chunk->blkcg_css);
+
 	/*
 	 * If async_chunk->locked_page is in the async_extent range, we need to
 	 * handle it.
@@ -1052,8 +1055,6 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 			NULL, EXTENT_LOCKED | EXTENT_DELALLOC,
 			PAGE_UNLOCK | PAGE_START_WRITEBACK);
 
-	if (async_chunk->blkcg_css)
-		kthread_associate_blkcg(async_chunk->blkcg_css);
 	btrfs_submit_compressed_write(inode, start,	/* file_offset */
 			    async_extent->ram_size,	/* num_bytes */
 			    ins.objectid,		/* disk_bytenr */
@@ -1061,10 +1062,10 @@ static int submit_one_async_extent(struct btrfs_inode *inode,
 			    async_extent->pages,	/* compressed_pages */
 			    async_extent->nr_pages,
 			    async_chunk->write_flags, true);
-	if (async_chunk->blkcg_css)
-		kthread_associate_blkcg(NULL);
 	*alloc_hint = ins.objectid + ins.offset;
 done:
+	if (async_chunk->blkcg_css)
+		kthread_associate_blkcg(NULL);
 	kfree(async_extent);
 	return ret;
 
-- 
2.39.2

