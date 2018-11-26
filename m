From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 08/13] blkcg: associate writeback bios with a blkg
Date: Mon, 26 Nov 2018 16:19:41 -0500
Message-ID: <20181126211946.77067-9-dennis@kernel.org>
References: <20181126211946.77067-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126211946.77067-1-dennis@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

One of the goals of this series is to remove a separate reference to
the css of the bio. This can and should be accessed via bio_blkcg. In
this patch, wbc_init_bio() now requires a bio to have a device
associated with it.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  8 +++++---
 block/bio.c                             | 21 +++++++++++++++++++++
 fs/buffer.c                             | 10 +++++-----
 fs/ext4/page-io.c                       |  2 +-
 include/linux/bio.h                     |  5 +++++
 include/linux/writeback.h               |  5 +++--
 6 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 476722b7b636..baf19bf28385 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1879,8 +1879,10 @@ following two functions.
 
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
@@ -1899,7 +1901,7 @@ the configuration, the bio may be executed at a lower priority and if
 the writeback session is holding shared resources, e.g. a journal
 entry, may lead to priority inversion.  There is no one easy solution
 for the problem.  Filesystems can try to work around specific problem
-cases by skipping wbc_init_bio() or using bio_associate_blkcg()
+cases by skipping wbc_init_bio() and using bio_associate_blkg()
 directly.
 
 
diff --git a/block/bio.c b/block/bio.c
index 4600808ac606..e9e930b6a10c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -2048,6 +2048,27 @@ static void __bio_associate_blkg_from_css(struct bio *bio,
 	rcu_read_unlock();
 }
 
+/**
+ * bio_associate_blkg_from_css - associate a bio with a specified css
+ * @bio: target bio
+ * @css: target css
+ *
+ * Associate @bio with the blkg found by combining the css's blkg and the
+ * request_queue of the @bio.  This takes a reference on the css that will
+ * be put upon freeing of @bio.
+ */
+void bio_associate_blkg_from_css(struct bio *bio,
+				 struct cgroup_subsys_state *css)
+{
+	if (!bio_has_queue(bio))
+		return;
+
+	css_get(css);
+	bio->bi_css = css;
+	__bio_associate_blkg_from_css(bio, css);
+}
+EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
+
 #ifdef CONFIG_MEMCG
 /**
  * bio_associate_blkg_from_page - associate a bio with the page's blkg
diff --git a/fs/buffer.c b/fs/buffer.c
index 9661e5be87e2..45452bd55c8e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3060,11 +3060,6 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
 
-	if (wbc) {
-		wbc_init_bio(wbc, bio);
-		wbc_account_io(wbc, bh->b_page, bh->b_size);
-	}
-
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio_set_dev_only(bio, bh->b_bdev);
 	bio->bi_write_hint = write_hint;
@@ -3084,6 +3079,11 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
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
index cadf91a42fa5..ab383085fb5e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -374,13 +374,13 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 	bio = bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
 	if (!bio)
 		return -ENOMEM;
-	wbc_init_bio(io->io_wbc, bio);
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio_set_dev_only(bio, bh->b_bdev);
 	bio->bi_end_io = ext4_end_bio;
 	bio->bi_private = ext4_get_io_end(io->io_end);
 	io->io_bio = bio;
 	io->io_next_block = bh->b_blocknr;
+	wbc_init_bio(io->io_wbc, bio);
 	return 0;
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ad322232db3e..a9958f2bcb48 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -520,6 +520,8 @@ static inline void bio_associate_blkg_from_page(struct bio *bio,
 int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css);
 void bio_disassociate_blkg(struct bio *bio);
 void bio_associate_blkg(struct bio *bio);
+void bio_associate_blkg_from_css(struct bio *bio,
+				 struct cgroup_subsys_state *css);
 void bio_disassociate_task(struct bio *bio);
 void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
@@ -527,6 +529,9 @@ static inline int bio_associate_blkcg(struct bio *bio,
 			struct cgroup_subsys_state *blkcg_css) { return 0; }
 static inline void bio_disassociate_blkg(struct bio *bio) { }
 static inline void bio_associate_blkg(struct bio *bio) { }
+static inline void bio_associate_blkg_from_css(struct bio *bio,
+					       struct cgroup_subsys_state *css)
+{ }
 static inline void bio_disassociate_task(struct bio *bio) { }
 static inline void bio_clone_blkcg_association(struct bio *dst,
 			struct bio *src) { }
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

