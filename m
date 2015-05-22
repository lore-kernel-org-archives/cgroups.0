From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 49/51] buffer, writeback: make __block_write_full_page() honor cgroup writeback
Date: Fri, 22 May 2015 17:14:03 -0400
Message-ID: <1432329245-5844-50-git-send-email-tj@kernel.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SETB5Y6y88991m5we9VHcLx5AJoZBo7UBYjAc2lN3RE=;
        b=bOKbVcGrk+R2XVK+ZKpFLIzJWNUKYZvZzKh0dGf2NFavUHzCzB2/NXouL11tEYukre
         hBTOwfvofH54myfS+dIyYs5KMz72rf4L0tR+W6jfYQun639eh/dm0SULZByZhFqddoJ/
         NgtD5EbEOGsD2J0HktGtDHOUkyc2W3mkmRxfC1E0Y03GF3H9NwCaxBpBzmRyRJwcsgLC
         48QLePCmkteVIt25L6gWzzQ+KnCAXn+at/oUW/cqgphqf435awBRVqEHgvG6cm/7hapC
         I6AX5SkcGywByKQd1mX/PDmdmNEXVD9VXexXhYIlWA8lJC974BHnyuOwC2YmEb+3iqTd
         zA6Q==
In-Reply-To: <1432329245-5844-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

[__]block_write_full_page() is used to implement ->writepage in
various filesystems.  All writeback logic is now updated to handle
cgroup writeback and the block cgroup to issue IOs for is encoded in
writeback_control and can be retrieved from the inode; however,
[__]block_write_full_page() currently ignores the blkcg indicated by
inode and issues all bio's without explicit blkcg association.

This patch adds submit_bh_blkcg() which associates the bio with the
specified blkio cgroup before issuing and uses it in
__block_write_full_page() so that the issued bio's are associated with
inode_to_wb_blkcg_css(inode).

v2: Updated for per-inode wb association.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/buffer.c                 | 26 ++++++++++++++++++++------
 include/linux/backing-dev.h | 12 ++++++++++++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c8aecf5..18cd378 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -30,6 +30,7 @@
 #include <linux/quotaops.h>
 #include <linux/highmem.h>
 #include <linux/export.h>
+#include <linux/backing-dev.h>
 #include <linux/writeback.h>
 #include <linux/hash.h>
 #include <linux/suspend.h>
@@ -44,6 +45,9 @@
 #include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
+static int submit_bh_blkcg(int rw, struct buffer_head *bh,
+			   unsigned long bio_flags,
+			   struct cgroup_subsys_state *blkcg_css);
 
 #define BH_ENTRY(list) list_entry((list), struct buffer_head, b_assoc_buffers)
 
@@ -1704,8 +1708,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	struct buffer_head *bh, *head;
 	unsigned int blocksize, bbits;
 	int nr_underway = 0;
-	int write_op = (wbc->sync_mode == WB_SYNC_ALL ?
-			WRITE_SYNC : WRITE);
+	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
+	struct cgroup_subsys_state *blkcg_css = inode_to_wb_blkcg_css(inode);
 
 	head = create_page_buffers(page, inode,
 					(1 << BH_Dirty)|(1 << BH_Uptodate));
@@ -1794,7 +1798,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(write_op, bh);
+			submit_bh_blkcg(write_op, bh, 0, blkcg_css);
 			nr_underway++;
 		}
 		bh = next;
@@ -1848,7 +1852,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(write_op, bh);
+			submit_bh_blkcg(write_op, bh, 0, blkcg_css);
 			nr_underway++;
 		}
 		bh = next;
@@ -3013,7 +3017,9 @@ void guard_bio_eod(int rw, struct bio *bio)
 	}
 }
 
-int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
+static int submit_bh_blkcg(int rw, struct buffer_head *bh,
+			   unsigned long bio_flags,
+			   struct cgroup_subsys_state *blkcg_css)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -3036,6 +3042,9 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
 
+	if (blkcg_css)
+		bio_associate_blkcg(bio, blkcg_css);
+
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_io_vec[0].bv_page = bh->b_page;
@@ -3060,11 +3069,16 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 	submit_bio(rw, bio);
 	return ret;
 }
+
+int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
+{
+	return submit_bh_blkcg(rw, bh, bio_flags, NULL);
+}
 EXPORT_SYMBOL_GPL(_submit_bh);
 
 int submit_bh(int rw, struct buffer_head *bh)
 {
-	return _submit_bh(rw, bh, 0);
+	return submit_bh_blkcg(rw, bh, 0, NULL);
 }
 EXPORT_SYMBOL(submit_bh);
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 9cc11e5..e9d7373 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -393,6 +393,12 @@ static inline struct bdi_writeback *inode_to_wb(struct inode *inode)
 	return inode->i_wb;
 }
 
+static inline struct cgroup_subsys_state *
+inode_to_wb_blkcg_css(struct inode *inode)
+{
+	return inode_to_wb(inode)->blkcg_css;
+}
+
 struct wb_iter {
 	int			start_blkcg_id;
 	struct radix_tree_iter	tree_iter;
@@ -510,6 +516,12 @@ static inline void wb_blkcg_offline(struct blkcg *blkcg)
 {
 }
 
+static inline struct cgroup_subsys_state *
+inode_to_wb_blkcg_css(struct inode *inode)
+{
+	return blkcg_root_css;
+}
+
 struct wb_iter {
 	int		next_id;
 };
-- 
2.4.0
