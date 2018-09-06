From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 06/12] blkcg: associate a blkg for pages being evicted by swap
Date: Thu,  6 Sep 2018 17:10:39 -0400
Message-ID: <20180906211045.29055-7-dennisszhou@gmail.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wgmJ6EXhA/y/tOqwdMZZ5+cOrvKrmLtj/CHSmhVjz3A=;
        b=QUsjw59ZPqpDEV4uKiKsG1Fw6W8Uz6Wkl7j3Je5LYne2xprqRpP47kDq+ehvHAUdfG
         K+TjYa1nHVJP4dooRSKwfH2U4DStntjTFz/GpuCfK6QyZxYeD7o3bFg8F/4UwmVXnRfL
         g5ttqorgmMC3v4qNYTDm73n9EIgC0HT/oYiOJ4cw2H++Uvi1Plb1g992PmCEDyYTHCUl
         lzF6IyIQzC3Z35trFg1pgYYGlQiw5plPUGitzqgjkdRasvR5QgSlU7A0c51qJstaUXLx
         EmAwJrn0h1Mq30/FGKh069EmSODUwoyL8jRgppTxklCJlKbUY09zOo4KqnKLfiPee3yC
         TENw==
In-Reply-To: <20180906211045.29055-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

A prior patch in this series added blkg association to bios issued by
cgroups. There are two other paths that we want to attribute work back
to the appropriate cgroup: swap and writeback. Here we modify the way
swap tags bios to include the blkg. Writeback will be tackle in the next
patch.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bio.c         | 83 ++++++++++++++++++++++++++++++++-------------
 include/linux/bio.h | 11 ++++--
 mm/page_io.c        |  2 +-
 3 files changed, 68 insertions(+), 28 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index a05997bdb967..6c69c35db8c7 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1958,30 +1958,6 @@ EXPORT_SYMBOL(bioset_init_from_src);
 
 #ifdef CONFIG_BLK_CGROUP
 
-#ifdef CONFIG_MEMCG
-/**
- * bio_associate_blkcg_from_page - associate a bio with the page's blkcg
- * @bio: target bio
- * @page: the page to lookup the blkcg from
- *
- * Associate @bio with the blkcg from @page's owning memcg.  This works like
- * every other associate function wrt references.
- */
-int bio_associate_blkcg_from_page(struct bio *bio, struct page *page)
-{
-	struct cgroup_subsys_state *blkcg_css;
-
-	if (unlikely(bio->bi_css))
-		return -EBUSY;
-	if (!page->mem_cgroup)
-		return 0;
-	blkcg_css = cgroup_get_e_css(page->mem_cgroup->css.cgroup,
-				     &io_cgrp_subsys);
-	bio->bi_css = blkcg_css;
-	return 0;
-}
-#endif /* CONFIG_MEMCG */
-
 /**
  * bio_associate_blkcg - associate a bio with the specified blkcg
  * @bio: target bio
@@ -2027,6 +2003,65 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 	return 0;
 }
 
+static int __bio_associate_blkg_from_css(struct bio *bio,
+					 struct cgroup_subsys_state *css)
+{
+	struct blkcg_gq *blkg;
+
+	rcu_read_lock();
+
+	blkg = blkg_lookup_create(css_to_blkcg(css), bio->bi_disk->queue);
+
+	rcu_read_unlock();
+
+	return bio_associate_blkg(bio, blkg);
+}
+
+/**
+ * bio_associate_blkg_from_css - associate a bio with a specified css
+ * @bio: target bio
+ * @css: target css
+ *
+ * Associate @bio with the blkg found by combining the css's blkg and the
+ * request_queue of the @bio.  This takes a reference on the css that will
+ * be put upon freeing of @bio.
+ */
+int bio_associate_blkg_from_css(struct bio *bio,
+				struct cgroup_subsys_state *css)
+{
+	css_get(css);
+	bio->bi_css = css;
+	return __bio_associate_blkg_from_css(bio, css);
+}
+EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
+
+#ifdef CONFIG_MEMCG
+/**
+ * bio_associate_blkg_from_page - associate a bio with the page's blkg
+ * @bio: target bio
+ * @page: the page to lookup the blkcg from
+ *
+ * Associate @bio with the blkg from @page's owning memcg and the respective
+ * request_queue.  This works like every other associate function wrt
+ * references.
+ *
+ * Note: this must be called after bio has an associated device.
+ */
+int bio_associate_blkg_from_page(struct bio *bio, struct page *page)
+{
+	struct cgroup_subsys_state *css;
+
+	if (unlikely(bio->bi_css))
+		return -EBUSY;
+	if (!page->mem_cgroup)
+		return 0;
+	css = cgroup_get_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
+	bio->bi_css = css;
+
+	return __bio_associate_blkg_from_css(bio, css);
+}
+#endif /* CONFIG_MEMCG */
+
 /**
  * bio_associate_create_blkg - associate a bio with a blkg from q
  * @q: request_queue where bio is going
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d1435643f5b7..bd8e67c01aa1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -547,21 +547,26 @@ do {						\
 	disk_devt((bio)->bi_disk)
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-int bio_associate_blkcg_from_page(struct bio *bio, struct page *page);
+int bio_associate_blkg_from_page(struct bio *bio, struct page *page);
 #else
-static inline int bio_associate_blkcg_from_page(struct bio *bio,
-						struct page *page) {  return 0; }
+static inline int bio_associate_blkg_from_page(struct bio *bio,
+					       struct page *page) { return 0; }
 #endif
 
 #ifdef CONFIG_BLK_CGROUP
 int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css);
 int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg);
+int bio_associate_blkg_from_css(struct bio *bio,
+				struct cgroup_subsys_state *css);
 int bio_associate_create_blkg(struct request_queue *q, struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
 void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
 static inline int bio_associate_blkcg(struct bio *bio,
 			struct cgroup_subsys_state *blkcg_css) { return 0; }
+static inline int bio_associate_blkg_from_css(struct bio *bio,
+					      struct cgroup_subsys_state *css)
+{ return 0; }
 static inline int bio_associate_create_blkg(struct request_queue *q,
 					    struct bio *bio) { return 0; }
 static inline void bio_disassociate_task(struct bio *bio) { }
diff --git a/mm/page_io.c b/mm/page_io.c
index aafd19ec1db4..573d3663d846 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -339,7 +339,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		goto out;
 	}
 	bio->bi_opf = REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc);
-	bio_associate_blkcg_from_page(bio, page);
+	bio_associate_blkg_from_page(bio, page);
 	count_swpout_vm_event(page);
 	set_page_writeback(page);
 	unlock_page(page);
-- 
2.17.1

