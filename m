From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 06/15] blkcg: always associate a bio with a blkg
Date: Thu, 30 Aug 2018 21:53:47 -0400
Message-ID: <20180831015356.69796-7-dennisszhou@gmail.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mj25J0UoslyA5YmwNy0OqZFtdVfhQZOp37ROGcHR3Fc=;
        b=QEXfyhc5/2+9jk5xLBPys7D34HzM2ObH4YFt7r0EnTI0aeKtvb9LXYDRQF1lpMBMak
         zbi8UQMIqu4nbcPSomeVaG7vwWOJN3aT9xnL5gacaY0t6uRfuQTnR7zJAyXYSP/x4Jxi
         SkL9XTyOlWBeFFL1BYuikzyoZJPRCzRGwFvAc8wBFA3Zl80lMibBkqaM9AP7lQhddUwV
         LKzURAPrN2AXwiBjecsqqYILKRG22PoFln2HIRIhhhZKdIhwk4rNQGdnM6waZ7oa8rXE
         QOLelyydMejuQSOHBb4xqMC+QF8tW35E1IOcP80Ul21wmuDjap1pcLc95zEwAWRWUYtN
         bNvQ==
In-Reply-To: <20180831015356.69796-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

Previously, blkg's were only assigned as needed by blk-iolatency and
blk-throttle. bio->css was also always being associated while blkg was
being looked up and then thrown away in blkcg_bio_issue_check.

This patch beings the cleanup of bio->css and bio->bi_blkg by always
associating a blkg in blkcg_bio_issue_check. This tries to create the
blkg, but if it is not possible, falls back to using the root_blkg of
the request_queue. Therefore, a bio will always be associated with a
blkg.

A missing definition for bio_associate_blkg is also added for parity in
bio.h.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
---
 block/bio.c                | 41 ++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h        |  5 +++++
 include/linux/blk-cgroup.h | 19 ++----------------
 3 files changed, 48 insertions(+), 17 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 09a31e4d46bb..e937f9681188 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1999,6 +1999,44 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
 	return 0;
 }
 
+/**
+ * bio_associate_create_blkg - associate a bio with a blkg from q
+ * @q: request_queue where bio is going
+ * @bio: target bio
+ *
+ * Associate @bio with the blkg found from the bio's css and the request_queue.
+ * If one is not found, bio_lookup_blkg creates the blkg.
+ */
+int bio_associate_create_blkg(struct request_queue *q, struct bio *bio)
+{
+	struct blkcg *blkcg;
+	struct blkcg_gq *blkg;
+	int ret = 0;
+
+	/* someone has already associated this bio with a blkg */
+	if (bio->bi_blkg)
+		return ret;
+
+	rcu_read_lock();
+
+	bio_associate_blkcg(bio, NULL);
+	blkcg = bio_blkcg(bio);
+
+	if (!blkcg->css.parent) {
+		ret = bio_associate_blkg(bio, q->root_blkg);
+		goto assoc_out;
+	}
+
+	blkg = blkg_lookup_create(blkcg, q);
+	if (IS_ERR(blkg))
+		blkg = q->root_blkg;
+
+	ret = bio_associate_blkg(bio, blkg);
+assoc_out:
+	rcu_read_unlock();
+	return ret;
+}
+
 /**
  * bio_disassociate_task - undo bio_associate_current()
  * @bio: target bio
@@ -2028,6 +2066,9 @@ void bio_clone_blkcg_association(struct bio *dst, struct bio *src)
 {
 	if (src->bi_css)
 		WARN_ON(bio_associate_blkcg(dst, src->bi_css));
+
+	if (src->bi_blkg)
+		bio_associate_blkg(dst, src->bi_blkg);
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkcg_association);
 #endif /* CONFIG_BLK_CGROUP */
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 51371740d2a8..d4626108b9d7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -556,11 +556,16 @@ static inline int bio_associate_blkcg_from_page(struct bio *bio,
 #ifdef CONFIG_BLK_CGROUP
 int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css);
 int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg);
+int bio_associate_create_blkg(struct request_queue *q, struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
 void bio_clone_blkcg_association(struct bio *dst, struct bio *src);
 #else	/* CONFIG_BLK_CGROUP */
 static inline int bio_associate_blkcg(struct bio *bio,
 			struct cgroup_subsys_state *blkcg_css) { return 0; }
+static inline int bio_associate_blkg(struct bio *bio,
+				     struct blkcg_gq *blkg) { return 0; }
+static inline int bio_associate_create_blkg(struct request_queue *q,
+					    struct bio *bio) { return 0; }
 static inline void bio_disassociate_task(struct bio *bio) { }
 static inline void bio_clone_blkcg_association(struct bio *dst,
 			struct bio *src) { }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index ea2dd6e6baf2..9931ec2f4e9e 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -824,29 +824,15 @@ static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg
 static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio)
 {
-	struct blkcg *blkcg;
 	struct blkcg_gq *blkg;
 	bool throtl = false;
 
-	rcu_read_lock();
-
-	/* associate blkcg if bio hasn't attached one */
-	bio_associate_blkcg(bio, NULL);
-	blkcg = bio_blkcg(bio);
-
-	blkg = blkg_lookup(blkcg, q);
-	if (unlikely(!blkg)) {
-		spin_lock_irq(q->queue_lock);
-		blkg = __blkg_lookup_create(blkcg, q);
-		if (IS_ERR(blkg))
-			blkg = NULL;
-		spin_unlock_irq(q->queue_lock);
-	}
+	bio_associate_create_blkg(q, bio);
+	blkg = bio->bi_blkg;
 
 	throtl = blk_throtl_bio(q, blkg, bio);
 
 	if (!throtl) {
-		blkg = blkg ?: q->root_blkg;
 		/*
 		 * If the bio is flagged with BIO_QUEUE_ENTERED it means this
 		 * is a split bio and we would have already accounted for the
@@ -858,7 +844,6 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
 	}
 
-	rcu_read_unlock();
 	return !throtl;
 }
 
-- 
2.17.1

