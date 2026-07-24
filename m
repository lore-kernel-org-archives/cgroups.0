Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ED84071E2;
	Fri, 24 Jul 2026 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896258; cv=none; b=ATlIcbdJhsIuths0gEWAJtIrBfUBGSCPzDk6gZ6U9fWIO+fPLneT5o6AQE1qIi53vADa7T1G43Rf2J1TxvpsBc69JTEcPtoSoIDM6/pL3lcxdliwqswqC+eE0+lPVFYiDAg5HgKBRQlDbi3xD+66ZgmxaGXWVc++LhFRAvN8pQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896258; c=relaxed/simple;
	bh=8J0WmG9epTVAaLW03/Tcr2FUg5AkUKjue3YP6LuQ0ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+Zk7Xw0Guz6LSLJ+lt/P+fl+Kso5g95LPSbnjJlw4ggS0PWwaZgQL74Wvqzvxs+YP4vq425DayK54Qy3zwrVDesDqvw02dSwmbNDPHAbfxZG/NavnZ/yIcGA3K3yTd8+VlN+0l9PznN7i3MwuLkA1pgon9eReJ5qGbORekVdP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oCJX0T1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oCJX0T1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A2C1F000E9;
	Fri, 24 Jul 2026 12:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896257;
	bh=6N2EKzGhi9+4tCRJlL5oFA469fy3sjHXV5Ueo8Dujvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCJX0T1Funfqiv3lVNfAbrchk6eieumSt0eP/QWxpqwhzL+0WIdoHppzUYBEQE8qQ
	 S3CRu6QgH1FGLds4V+5kd1uOQJDCaLWhuAwKvnNCh0RPbf/mmJZWUHzI3ie5WJqg99
	 njEzfpz3OJT9GzYLfQyE6GFzv1hGhmLVC80afQHUnLa3oJSuKTOBD2jIt+FO2TtMKN
	 kxSocYXQBLuCMnDNxqcdhKH12OKrnZAGunwT+D4wbJEjKpZV3t3jruE0c4d9p23SM6
	 PcLN90I9bDd764kSsCi6bM6DH5BT82Dl91XWjybxtTAomN3YiqoEXqERFigV4V8zcE
	 rva215u6KHjjg==
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
Subject: [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of bio_set_dev
Date: Fri, 24 Jul 2026 20:30:30 +0800
Message-ID: <20260724123037.3004560-2-yukuai@kernel.org>
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

bio_set_dev(), bio_init() and bio_reset() associate a bio with a blkg for
its target queue. That association may have to create a new blkg, and
currently there are lots of callers that are under atomic context.

Move the association out of those helpers and into the submit path, which
is always sleepable (submit_bio_noacct() already does might_sleep()):

  - submit_bio() associates new I/O before bio_set_ioprio(), whose
    blkcg_set_ioprio() reads the policy from bio->bi_blkg.

  - submit_bio_noacct() (re)associates when a bio has no blkg yet or was
    remapped to a different queue.  blk_throtl_bio() and the rq_qos
    throttlers (iocost, iolatency) pair bio->bi_blkg with the queue of
    bio->bi_bdev, so a remapped bio must be reassociated to the new queue.

  - bio_set_dev() no longer associates; instead it drops the existing blkg
    when the device changes, since that blkg is tied to the old queue.
    bio_init()/bio_reset() leave bi_blkg NULL.

Introduce bio_disassociate_blkg() to drop a bio's blkg reference and use it
from bio_set_dev(), bio_uninit() and the bio freeing path, replacing their
open-coded blkg_put().

This is the first step to convert protecting blkg with blkcg_mutex.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bio.c         | 18 ++----------------
 block/blk-cgroup.c  | 18 ++++++++++++++++++
 block/blk-core.c    | 21 +++++++++++++++++++++
 include/linux/bio.h |  7 +++++--
 4 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 6a2f6fc3413e..ea030c5e39a4 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -179,12 +179,7 @@ static inline gfp_t try_alloc_gfp(gfp_t gfp)
 
 void bio_uninit(struct bio *bio)
 {
-#ifdef CONFIG_BLK_CGROUP
-	if (bio->bi_blkg) {
-		blkg_put(bio->bi_blkg);
-		bio->bi_blkg = NULL;
-	}
-#endif
+	bio_disassociate_blkg(bio);
 	if (bio_integrity(bio))
 		bio_integrity_free(bio);
 
@@ -235,8 +230,6 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 #ifdef CONFIG_BLK_CGROUP
 	bio->bi_blkg = NULL;
 	bio->issue_time_ns = 0;
-	if (bdev)
-		bio_associate_blkg(bio);
 #ifdef CONFIG_BLK_CGROUP_IOCOST
 	bio->bi_iocost_cost = 0;
 #endif
@@ -280,8 +273,6 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
 	atomic_set(&bio->__bi_remaining, 1);
 	bio->bi_io_vec = bv;
 	bio->bi_bdev = bdev;
-	if (bio->bi_bdev)
-		bio_associate_blkg(bio);
 	bio->bi_opf = opf;
 }
 EXPORT_SYMBOL(bio_reset);
@@ -1803,17 +1794,12 @@ void bio_endio(struct bio *bio)
 		goto again;
 	}
 
-#ifdef CONFIG_BLK_CGROUP
 	/*
 	 * Release cgroup info.  We shouldn't have to do this here, but quite
 	 * a few callers of bio_init fail to call bio_uninit, so we cover up
 	 * for that here at least for now.
 	 */
-	if (bio->bi_blkg) {
-		blkg_put(bio->bi_blkg);
-		bio->bi_blkg = NULL;
-	}
-#endif
+	bio_disassociate_blkg(bio);
 
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio);
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d9676126c5b5..618e5566fa52 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2170,6 +2170,24 @@ void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 
+/**
+ * bio_disassociate_blkg - disassociate a bio from its blkg
+ * @bio: target bio
+ *
+ * Drop the blkg reference held by @bio and clear the association.  This is
+ * used when a bio's target device changes (e.g. via bio_set_dev()): the old
+ * blkg is tied to the previous request_queue, so it is dropped here and the
+ * bio is reassociated to the new queue from the submit path.
+ */
+void bio_disassociate_blkg(struct bio *bio)
+{
+	if (bio->bi_blkg) {
+		blkg_put(bio->bi_blkg);
+		bio->bi_blkg = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(bio_disassociate_blkg);
+
 static int blk_cgroup_io_type(struct bio *bio)
 {
 	if (op_is_discard(bio->bi_opf))
diff --git a/block/blk-core.c b/block/blk-core.c
index 365641266c9e..8103643b39fc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -822,6 +822,20 @@ void submit_bio_noacct(struct bio *bio)
 
 	might_sleep();
 
+	/*
+	 * Associate the bio with a blkg for its target queue here, where it is
+	 * safe to sleep, instead of in bio_set_dev()/bio_init() which may run
+	 * under a spinlock.  bio_set_dev() no longer associates, so a freshly
+	 * allocated or remapped bio has no blkg until it reaches the submit path.
+	 * Reassociate only when the bio was remapped to a different queue since
+	 * it was last associated; blk_throtl_bio() and the rq_qos throttlers
+	 * rely on bio->bi_blkg matching the queue of bio->bi_bdev.
+	 */
+#ifdef CONFIG_BLK_CGROUP
+	if (!bio->bi_blkg || bio->bi_blkg->q != q)
+		bio_associate_blkg(bio);
+#endif
+
 	/*
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
 	 * if queue does not support NOWAIT.
@@ -958,6 +972,13 @@ void submit_bio(struct bio *bio)
 		count_vm_events(PGPGOUT, bio_sectors(bio));
 	}
 
+	/*
+	 * bio_set_ioprio() -> blkcg_set_ioprio() reads the policy from
+	 * bio->bi_blkg, so associate the blkg (for new I/O, the first time) before
+	 * it runs.  This is the sleepable entry point for new I/O; remapped bios
+	 * that reach submit_bio_noacct() directly are reassociated there.
+	 */
+	bio_associate_blkg(bio);
 	bio_set_ioprio(bio);
 	submit_bio_noacct(bio);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8f33f717b14f..7a7509c8a59a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -507,6 +507,7 @@ void bio_associate_blkg(struct bio *bio);
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css);
 void bio_clone_blkg_association(struct bio *dst, struct bio *src);
+void bio_disassociate_blkg(struct bio *bio);
 void blkcg_punt_bio_submit(struct bio *bio);
 #else	/* CONFIG_BLK_CGROUP */
 static inline void bio_associate_blkg(struct bio *bio) { }
@@ -515,6 +516,7 @@ static inline void bio_associate_blkg_from_css(struct bio *bio,
 { }
 static inline void bio_clone_blkg_association(struct bio *dst,
 					      struct bio *src) { }
+static inline void bio_disassociate_blkg(struct bio *bio) { }
 static inline void blkcg_punt_bio_submit(struct bio *bio)
 {
 	submit_bio(bio);
@@ -524,10 +526,11 @@ static inline void blkcg_punt_bio_submit(struct bio *bio)
 static inline void bio_set_dev(struct bio *bio, struct block_device *bdev)
 {
 	bio_clear_flag(bio, BIO_REMAPPED);
-	if (bio->bi_bdev != bdev)
+	if (bio->bi_bdev != bdev) {
 		bio_clear_flag(bio, BIO_BPS_THROTTLED);
+		bio_disassociate_blkg(bio);
+	}
 	bio->bi_bdev = bdev;
-	bio_associate_blkg(bio);
 }
 
 /*
-- 
2.51.0

