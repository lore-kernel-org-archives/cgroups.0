Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8B634D382;
	Mon,  8 Jun 2026 03:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780890196; cv=none; b=BOf3w8PtlB9fwkVNTy4NVavjw7+baVmEvPJZVE6QcF3u7GBwtbkUh+fwBJMtFifnSVKtg6+kDj1sbh6IRwfPxfmsM31gSXbhEGN6s0IRBMAr+rOMkXOS7HFgqqsld2MV8nm26YRgSWNmPQ5ZsCh1oFxHWV4HGft+EDc8uTCkgME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780890196; c=relaxed/simple;
	bh=Ywh/pOq61c8tBbSiPsr/6aJSHg5spVpyQgkQezDzeoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3n1F/ctR1HmHBOXsGr2wBS234QPsH9M/z3bCeOy+28bPFpurDOGTKKeBoLPDHw8HZSTvYMQwCo4t41j0nnlxT015yys+m5goqpljqsZmqyUEOHgMz0fhiCdOilrHVN16v8oP+gohqgAkRpC9goNGJFbdpx7xP3pPWJJeLD6IpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbA68OU7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbA68OU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0CB1F00898;
	Mon,  8 Jun 2026 03:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890195;
	bh=vuwEd9q0hgQ/W0hmwr4wo03yb5oe8N9Mp2bIxGqEObI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbA68OU7rwCZh52sRF98htb0dhiuh/KATAF4tJlKA4uL0h1y72Rwfg5n1HwT2Iatq
	 2QBs5e+7arpdsq+7Dy8/9Z3KL6bO2QOi0AtlsP02SyS6J6r5ume+CRnpXLmyLe/8LO
	 K8MiJuKAyIiZVOv9OFkM8WBUshcOEkxA55DgwKbYZ9By9NUHmYb+RJ6tavH/5UuyZh
	 bGfpofy7aTfCFCXLladRntpq0W0VQHF+oN5McMMVfsdPEdUACiYEIV1/7YO9HBunEu
	 oxXFmVx4xZ6airi8Ma5C3tnUoluJ4Ab34CdPYb8KqeKVg/ut1OTZng7rxPfURzMumA
	 ZruqfS3oUKxhg==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
Date: Mon,  8 Jun 2026 11:42:45 +0800
Message-ID: <93f33cc9e5a39dddb78dcd934d0c1d04b564fb00.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

Change this in two steps:

1) hold rcu lock and do blkg_lookup() from fast path;
2) hold queue_lock directly from slow path, and don't nest it under rcu
   lock;

Prepare to convert protecting blkcg with blkcg_mutex instead of
queue_lock.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 57 +++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 46fc65050c38..e2896d582235 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -466,26 +466,21 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
-	unsigned long flags;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	blkg = blkg_lookup(blkcg, q);
-	if (blkg)
-		return blkg;
-
-	spin_lock_irqsave(&q->queue_lock, flags);
+	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
 	if (blkg) {
 		if (blkcg != &blkcg_root &&
 		    blkg != rcu_dereference(blkcg->blkg_hint))
 			rcu_assign_pointer(blkcg->blkg_hint, blkg);
-		goto found;
+		rcu_read_unlock();
+		return blkg;
 	}
+	rcu_read_unlock();
 
 	/*
 	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
 	 * non-root blkgs have access to their parents.  Returns the closest
 	 * blkg to the intended blkg should blkg_create() fail.
@@ -513,12 +508,10 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		}
 		if (pos == blkcg)
 			break;
 	}
 
-found:
-	spin_unlock_irqrestore(&q->queue_lock, flags);
 	return blkg;
 }
 
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
@@ -2098,10 +2091,22 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
 		return;
 	blkcg_scale_delay(blkg, now);
 	atomic64_add(delta, &blkg->delay_nsec);
 }
 
+static inline struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
+{
+retry:
+	if (blkg_tryget(blkg))
+		return blkg;
+
+	blkg = blkg->parent;
+	if (blkg)
+		goto retry;
+
+	return NULL;
+}
 /**
  * blkg_tryget_closest - try and get a blkg ref on the closet blkg
  * @bio: target bio
  * @css: target css
  *
@@ -2110,24 +2115,34 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
  * up taking a reference on or %NULL if no reference was taken.
  */
 static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 		struct cgroup_subsys_state *css)
 {
-	struct blkcg_gq *blkg, *ret_blkg = NULL;
+	struct request_queue *q = bio->bi_bdev->bd_queue;
+	struct blkcg *blkcg = css_to_blkcg(css);
+	struct blkcg_gq *blkg;
 
 	rcu_read_lock();
-	blkg = blkg_lookup_create(css_to_blkcg(css), bio->bi_bdev->bd_disk);
-	while (blkg) {
-		if (blkg_tryget(blkg)) {
-			ret_blkg = blkg;
-			break;
-		}
-		blkg = blkg->parent;
-	}
+	blkg = blkg_lookup(blkcg, q);
+	if (likely(blkg))
+		blkg = blkg_lookup_tryget(blkg);
 	rcu_read_unlock();
 
-	return ret_blkg;
+	if (blkg)
+		return blkg;
+
+	/*
+	 * Fast path failed, we're probably issuing IO in this cgroup the first
+	 * time, hold lock to create new blkg.
+	 */
+	spin_lock_irq(&q->queue_lock);
+	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
+	if (blkg)
+		blkg = blkg_lookup_tryget(blkg);
+	spin_unlock_irq(&q->queue_lock);
+
+	return blkg;
 }
 
 /**
  * bio_associate_blkg_from_css - associate a bio with a specified css
  * @bio: target bio
-- 
2.51.0
