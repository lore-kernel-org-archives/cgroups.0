From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 43/45] buffer, writeback: make __block_write_full_page() honor cgroup writeback
Date: Tue,  6 Jan 2015 16:26:20 -0500
Message-ID: <1420579582-8516-44-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ktBcOy0s4jHSwuEFnNZgSG9P2qzDcFoxC6xQDm0Eto0=;
        b=hZoFAyQjBs11GrUDsL9sy/g9J8o/ANzi8ziHSN7qRWzKUnH+OmDjBfnWRHcbhINtdO
         m8etjlpGz2Q8xaRX/0PfSGK8XlsoilRmDBOBEIklq70SFp5AzovyyT6a6GbH//bdkwTZ
         kD4m1dKHzd5trN732S99oeaRL8eVHsLUOeSMukBcZyUkiDjx/o/gJSj5WXgTUbCf4cn9
         ikD1ruSM+naGrDWY08tXRcUaVbV2g+4eO4sElC/xVU0jb9o1aehAWoHu26oxPb4ufVni
         sxxOAqAEI7uB4sbU3NDpqPOn6kRX39Wp4pticZTs9HnwIm/A8+OIAmFK6kxTFL42gM3Z
         ttOw==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

[__]block_write_full_page() is used to implement ->writepage in
various filesystems.  All writeback logic is now updated to handle
cgroup writeback and the block cgroup to issue IOs for is encoded in
writeback_control and can be retrieved using wbc_blkcg_css(); however,
[__]block_write_full_page() currently ignores the blkcg indicated by
wbc and issues all bio's without explicit blkcg association.

This patch adds submit_bh_blkcg() which associates the bio with the
specified blkio cgroup before issuing and uses it in
__block_write_full_page() so that the issued bio's are associated with
wbc_blkcg_css().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/buffer.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 2dab7dd..1377346 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -45,6 +45,9 @@
 #include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
+static int submit_bh_blkcg(int rw, struct buffer_head *bh,
+			   unsigned long bio_flags,
+			   struct cgroup_subsys_state *blkcg_css);
 
 #define BH_ENTRY(list) list_entry((list), struct buffer_head, b_assoc_buffers)
 
@@ -1777,7 +1780,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
-			submit_bh(write_op, bh);
+			submit_bh_blkcg(write_op, bh, 0, wbc_blkcg_css(wbc));
 			nr_underway++;
 		}
 		bh = next;
@@ -1831,7 +1834,7 @@ recover:
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
 			clear_buffer_dirty(bh);
-			submit_bh(write_op, bh);
+			submit_bh_blkcg(write_op, bh, 0, wbc_blkcg_css(wbc));
 			nr_underway++;
 		}
 		bh = next;
@@ -3000,7 +3003,9 @@ void guard_bio_eod(int rw, struct bio *bio)
 	}
 }
 
-int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
+static int submit_bh_blkcg(int rw, struct buffer_head *bh,
+			   unsigned long bio_flags,
+			   struct cgroup_subsys_state *blkcg_css)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -3023,6 +3028,9 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
 
+	if (blkcg_css)
+		bio_associate_blkcg(bio, blkcg_css);
+
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_io_vec[0].bv_page = bh->b_page;
@@ -3053,11 +3061,16 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 	bio_put(bio);
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
 
-- 
2.1.0
