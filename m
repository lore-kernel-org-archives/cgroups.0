From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 09/15] blkcg: associate writeback bios with a blkg
Date: Thu, 30 Aug 2018 21:53:50 -0400
Message-ID: <20180831015356.69796-10-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NsnPzyDZDwxPFXw0kGSp1IiDynM8Q8YeBDgpSlRtjjs=;
        b=rTvj6h3R/yy3aiSXUg7X0gIG5nN3ebq5gE8O6LhKOElzX56dF8QoXCu1NKO91o1yfi
         AQL9V5w0sY+sPI+ajPfyOfcVChYNCs+9RFZkDuL6QMC8jhNKiZ936xJC+6RNnRuzfZv3
         HMYjn/1HA7VvArOR04V3ZBS0Lt+7bZ+wRhEj2N5dNc64Kjmu8wKn7j89HQLfuMzb9yxk
         rx6GOctr/VFjcDcnf2/C4rpvsgb8bN61KVx5AYDUhrLk6ONQvQzvQ1GdtovFDD/vam5y
         P6qnoXWQe5o4iRnMmVLADFkyPDqR5RSq//ytpp2WyiwZpyDuHCBQ/JxrEb1jXTPdTo99
         Uzpg==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

One of the goals of this series is to remove a separate reference to
the css of the bio. This can and should be accessed via bio_blkcg. In
this patch, the wbc_init_bio call is changed such that it must be called
after a queue has been associated with the bio.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  8 +++++---
 fs/buffer.c                             | 10 +++++-----
 fs/ext4/page-io.c                       |  2 +-
 include/linux/writeback.h               |  5 +++--
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 1746131bc9cb..2dc8f95077aa 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1839,8 +1839,10 @@ following two functions.
 
   wbc_init_bio(@wbc, @bio)
 	Should be called for each bio carrying writeback data and
-	associates the bio with the inode's owner cgroup.  Can be
-	called anytime between bio allocation and submission.
+	associates the bio with the inode's owner cgroup and the
+	corresponding request queue.  This must be called after
+	a queue (device) has been associated with the bio and
+	before submission.
 
   wbc_account_io(@wbc, @page, @bytes)
 	Should be called for each data segment being written out.
@@ -1859,7 +1861,7 @@ the configuration, the bio may be executed at a lower priority and if
 the writeback session is holding shared resources, e.g. a journal
 entry, may lead to priority inversion.  There is no one easy solution
 for the problem.  Filesystems can try to work around specific problem
-cases by skipping wbc_init_bio() or using bio_associate_blkcg()
+cases by skipping wbc_init_bio() or using bio_associate_create_blkg()
 directly.
 
 
diff --git a/fs/buffer.c b/fs/buffer.c
index cabc045f483d..7fb8adb44583 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3049,11 +3049,6 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
 
-	if (wbc) {
-		wbc_init_bio(wbc, bio);
-		wbc_account_io(wbc, bh->b_page, bh->b_size);
-	}
-
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio_set_dev(bio, bh->b_bdev);
 	bio->bi_write_hint = write_hint;
@@ -3073,6 +3068,11 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 		op_flags |= REQ_PRIO;
 	bio_set_op_attrs(bio, op, op_flags);
 
+	if (wbc) {
+		wbc_init_bio(wbc, bio);
+		wbc_account_io(wbc, bh->b_page, bh->b_size);
+	}
+
 	submit_bio(bio);
 	return 0;
 }
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index db7590178dfc..2aa62d58d8dd 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -374,13 +374,13 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 	bio = bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
 	if (!bio)
 		return -ENOMEM;
-	wbc_init_bio(io->io_wbc, bio);
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio_set_dev(bio, bh->b_bdev);
 	bio->bi_end_io = ext4_end_bio;
 	bio->bi_private = ext4_get_io_end(io->io_end);
 	io->io_bio = bio;
 	io->io_next_block = bh->b_blocknr;
+	wbc_init_bio(io->io_wbc, bio);
 	return 0;
 }
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index fdfd04e348f6..738a0c24874f 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -246,7 +246,8 @@ static inline void wbc_attach_fdatawrite_inode(struct writeback_control *wbc,
  *
  * @bio is a part of the writeback in progress controlled by @wbc.  Perform
  * writeback specific initialization.  This is used to apply the cgroup
- * writeback context.
+ * writeback context.  Must be called after the bio has been associated with
+ * a device.
  */
 static inline void wbc_init_bio(struct writeback_control *wbc, struct bio *bio)
 {
@@ -257,7 +258,7 @@ static inline void wbc_init_bio(struct writeback_control *wbc, struct bio *bio)
 	 * regular writeback instead of writing things out itself.
 	 */
 	if (wbc->wb)
-		bio_associate_blkcg(bio, wbc->wb->blkcg_css);
+		bio_associate_blkg_from_css(bio, wbc->wb->blkcg_css);
 }
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
-- 
2.17.1

