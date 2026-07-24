Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6037727FB1F;
	Fri, 24 Jul 2026 12:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896300; cv=none; b=KH/sg7YPzj08ITIKLqfTpjzopCbMx3yJyD97z3lG99eZdaH6NMKMUewx8Zvg/7hqlfcRlh4PHZRVnxqlnFKU4ogMlPw7lzio/9sa7vujXukH1mpRvDRMn/zvipAPoty6Zm9F1Kvymkwxm96WRmVvjt0USpZJ8XmGgrNI+jlNrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896300; c=relaxed/simple;
	bh=5tFNU4s28uw1wANodMzU4hTdWSbgrC5nMHuUbNAFV84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCFCvgPUHq3W9OuLovV3Nyyk0UF6OW0j0sj0QMWzMbr7h/QIkvEJuchUUAsf9ELnKCpfA/8Gk0CIkvqPfY8heJFka5r1wHCvZaK4UwfdGKFn7MRYbFozte5Vzp1HSpbO1snTUbxIjJuMdLrqPXefz1JnA6YgRAOYulL+Zg/eDpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpthSAjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpthSAjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D2A1F000E9;
	Fri, 24 Jul 2026 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896299;
	bh=VAZx5z6/Aznq0vRlWUGgoZ5pMoW/FyB0YAVfNh1mIbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpthSAjpFOjdjs955qqkv8W5L0jN1Zs9ASw3DWXOSwtM8OrET8zCu9mSNbdfedQmZ
	 lFBH/3/2T+18TMuhjUYdH6N9jl2MGfbAMv2Cxy3dQ8+70PwO+KzTEijpbrtmS2zR9i
	 mcZAY8ExZeP/aovkXVRTh7pvVttMK2nt3QKqBv4YSdENFxL1VrFE4yiUEzb0JmLxYQ
	 stN6ZjDXJZgQJtT15ZJGf0c4H9pOIIiu5Sbitlkfapuy6WctVCgIoOoXZHJryM/dZr
	 i/4Gik+Y9LxpnVew1GGb4EYCd/rNpYpe1BsdtnGR5oEtmhmbP6y2HfTCG1xSyE09JB
	 joVuGe8/Dx+BQ==
From: Yu Kuai <yukuai@kernel.org>
To: axboe@kernel.dk,
	tj@kernel.org
Cc: hch@lst.de,
	dongsheng.yang@linux.dev,
	cengku@gmail.com,
	josef@toxicpanda.com,
	nilay@linux.ibm.com,
	ming.lei@redhat.com,
	yukuai@fygo.io,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 8/8] block: fail nowait bio submit if blkg allocation can't sleep
Date: Fri, 24 Jul 2026 20:30:37 +0800
Message-ID: <20260724123037.3004560-9-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260724123037.3004560-1-yukuai@kernel.org>
References: <20260724123037.3004560-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blkg association now happens from the submit path, which is allowed to sleep
when creating a missing blkg.  REQ_NOWAIT I/O must not be made to sleep,
though: if a nowait bio is the first I/O for its cgroup/queue pair and the
blkg does not exist yet, creating it would require sleeping on
q->blkcg_mutex and allocating with a sleeping GFP.

blkg_tryget_closest() derives the nowait mode from the bio's REQ_NOWAIT flag.
For nowait, create the missing blkg without sleeping: mutex_trylock()
q->blkcg_mutex and allocate with GFP_ATOMIC.  If that fails (atomic context,
contended mutex, or allocation failure), leave the bio unassociated and
return failure, so submit_bio()/submit_bio_noacct() complete the bio with
BLK_STS_AGAIN and the submitter can retry once the blkg exists.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c  | 85 ++++++++++++++++++++++++++++++++++-----------
 block/blk-core.c    | 19 ++++++++--
 include/linux/bio.h | 11 +++---
 3 files changed, 86 insertions(+), 29 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d611cf701f14..3c8efba2e69a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -30,6 +30,7 @@
 #include <linux/resume_user_mode.h>
 #include <linux/psi.h>
 #include <linux/part_stat.h>
+#include <linux/preempt.h>
 #include "blk.h"
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
@@ -1984,6 +1985,30 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	if (blkg)
 		return blkg;
 
+	if (bio->bi_opf & REQ_NOWAIT) {
+		int ret;
+
+		/*
+		 * Nowait callers must not sleep on the mutex nor allocate with
+		 * sleeping GFPs.  Trylock the mutex and create the missing blkg
+		 * atomically; if the mutex is contended, the caller is atomic,
+		 * or blkg allocation fails, return NULL so the caller can fail
+		 * the bio and let the submitter retry once the blkg exists.
+		 */
+		if (!preemptible() || !mutex_trylock(&q->blkcg_mutex))
+			return NULL;
+
+		ret = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk,
+					 GFP_ATOMIC, &blkg);
+		if (ret)
+			blkg = NULL;
+		else if (blkg)
+			blkg = blkg_lookup_tryget(blkg);
+		mutex_unlock(&q->blkcg_mutex);
+
+		return blkg;
+	}
+
 	/*
 	 * Fast path failed, we're probably issuing IO in this cgroup the first
 	 * time, hold lock to create new blkg.
@@ -2010,19 +2035,33 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
  *
  * A reference will be taken on the blkg and will be released when @bio is
  * freed.
+ *
+ * If @bio is REQ_NOWAIT and associating requires creating a new blkg, this
+ * function does not sleep; when the blkg cannot be created atomically it
+ * returns %false with @bio left unassociated so the caller can fail the I/O.
+ *
+ * Return: %true if @bio is associated with a blkg, %false on nowait failure.
  */
-void bio_associate_blkg_from_css(struct bio *bio,
+bool bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css)
 {
-	if (bio->bi_blkg)
+	struct blkcg_gq *blkg;
+
+	if (bio->bi_blkg) {
 		blkg_put(bio->bi_blkg);
+		bio->bi_blkg = NULL;
+	}
 
 	if (css && css->parent) {
-		bio->bi_blkg = blkg_tryget_closest(bio, css);
+		blkg = blkg_tryget_closest(bio, css);
+		if (!blkg)
+			return false;
+		bio->bi_blkg = blkg;
 	} else {
 		blkg_get(bdev_get_queue(bio->bi_bdev)->root_blkg);
 		bio->bi_blkg = bdev_get_queue(bio->bi_bdev)->root_blkg;
 	}
+	return true;
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
 
@@ -2030,32 +2069,38 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
  * bio_associate_blkg - associate a bio with a blkg
  * @bio: target bio
  *
- * Associate @bio with the blkg found from the bio's css and request_queue.
- * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
- * already associated, the css is reused and association redone as the
- * request_queue may have changed.
+ * Associate @bio with the blkg found from the bio's css and request_queue,
+ * creating it if necessary.  If a blkg is already associated, the css is
+ * reused and association redone as the request_queue may have changed.
+ *
+ * If @bio is REQ_NOWAIT, association does not sleep; if the blkg cannot be
+ * created without sleeping, %false is returned with @bio left unassociated.
+ *
+ * Return: %true on success, %false on nowait failure.
  */
-void bio_associate_blkg(struct bio *bio)
+bool bio_associate_blkg(struct bio *bio)
 {
 	struct cgroup_subsys_state *css;
+	bool ret;
 
 	if (blk_op_is_passthrough(bio->bi_opf))
-		return;
+		return true;
 
 	if (bio->bi_blkg) {
 		css = bio_blkcg_css(bio);
-		bio_associate_blkg_from_css(bio, css);
-	} else {
-		rcu_read_lock();
-		css = blkcg_css();
-		if (!css_tryget_online(css))
-			css = NULL;
-		rcu_read_unlock();
-
-		bio_associate_blkg_from_css(bio, css);
-		if (css)
-			css_put(css);
+		return bio_associate_blkg_from_css(bio, css);
 	}
+
+	rcu_read_lock();
+	css = blkcg_css();
+	if (!css_tryget_online(css))
+		css = NULL;
+	rcu_read_unlock();
+
+	ret = bio_associate_blkg_from_css(bio, css);
+	if (css)
+		css_put(css);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg);
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 0a1d2b09a5d9..9b96dd802c92 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -832,8 +832,16 @@ void submit_bio_noacct(struct bio *bio)
 	 * rely on bio->bi_blkg matching the queue of bio->bi_bdev.
 	 */
 #ifdef CONFIG_BLK_CGROUP
-	if (!bio->bi_blkg || bio->bi_blkg->q != q)
-		bio_associate_blkg(bio);
+	if (!bio->bi_blkg || bio->bi_blkg->q != q) {
+		/*
+		 * For REQ_NOWAIT, do not sleep to create a new blkg: fail the
+		 * bio so the submitter retries once the blkg exists.
+		 */
+		if (!bio_associate_blkg(bio)) {
+			bio_endio_status(bio, BLK_STS_AGAIN);
+			return;
+		}
+	}
 #endif
 
 	/*
@@ -979,8 +987,13 @@ void submit_bio(struct bio *bio)
 	 * bio->bi_blkg, so associate the blkg (for new I/O, the first time) before
 	 * it runs.  This is the sleepable entry point for new I/O; remapped bios
 	 * that reach submit_bio_noacct() directly are reassociated there.
+	 * For REQ_NOWAIT I/O, fail the bio instead of sleeping if a new blkg
+	 * cannot be allocated.
 	 */
-	bio_associate_blkg(bio);
+	if (!bio_associate_blkg(bio)) {
+		bio_endio_status(bio, BLK_STS_AGAIN);
+		return;
+	}
 	bio_set_ioprio(bio);
 	submit_bio_noacct(bio);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7a7509c8a59a..570b62e676dc 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -503,17 +503,16 @@ static inline void bio_release_pages(struct bio *bio, bool mark_dirty)
 	disk_devt((bio)->bi_bdev->bd_disk)
 
 #ifdef CONFIG_BLK_CGROUP
-void bio_associate_blkg(struct bio *bio);
-void bio_associate_blkg_from_css(struct bio *bio,
+bool bio_associate_blkg(struct bio *bio);
+bool bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css);
 void bio_clone_blkg_association(struct bio *dst, struct bio *src);
 void bio_disassociate_blkg(struct bio *bio);
 void blkcg_punt_bio_submit(struct bio *bio);
 #else	/* CONFIG_BLK_CGROUP */
-static inline void bio_associate_blkg(struct bio *bio) { }
-static inline void bio_associate_blkg_from_css(struct bio *bio,
-					       struct cgroup_subsys_state *css)
-{ }
+static inline bool bio_associate_blkg(struct bio *bio) { return true; }
+static inline bool bio_associate_blkg_from_css(struct bio *bio,
+					       struct cgroup_subsys_state *css) { return true; }
 static inline void bio_clone_blkg_association(struct bio *dst,
 					      struct bio *src) { }
 static inline void bio_disassociate_blkg(struct bio *bio) { }
-- 
2.51.0

