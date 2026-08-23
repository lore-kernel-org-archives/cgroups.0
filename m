Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B3D38BF7F;
	Sun, 23 Aug 2026 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787499015; cv=none; b=ccS4ywHwehd3oLoqK6ujG/P0UH7YU1rvMi+69v4fujdDExI2RyjDxpXc7KcK2NcobgiWchY6meVZkSlDadIGHn1RUUoOzRk/Ee173GSQYnKG8Hc3FFA6o2n9FBCktjAT+aULnD44Ohv+3xAkkEQI6vWjDBWuSeLgpx1a9555X3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787499015; c=relaxed/simple;
	bh=lZLXyzGI3BPPufsSN+QptIf0HcFnvcIkm/66+VsJYs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqL9qsY2W1sh4HbZUto9s+LWXGeCkr/rN74YQmrgE4zprMGTC/+lDh7yJdRXpAPjdYLLPKgb2UcGSt8AjCh9bhLAwxeEPlxpbTFGBtlY4aQzMmZA4FKtI9LnTY4/sQTGzswji0ljjRBAnaucB2Qiz7zuKjusZMBD3bpgp3JctyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MT7emHK4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MT7emHK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E711F00A3D;
	Sun, 23 Aug 2026 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787499009;
	bh=QZpqZ1N6Q8eI05SmOt+SeVXizm3rCf2SBy2S4yV0Ajk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MT7emHK4/o8bo/uYiquUF2bNOXCMkt/ntv6GyPL/3y6sqhQOs8joOq2kImmAkja04
	 3k47GPz4NCjcPgyC7ACWsauTcUgKrcy8Gg3vQVnR3nCRvuQyszKP+4+PfnLC3pSFaP
	 GBmo8U7zN+KzhPk2wiSNbTcczc7K57Byt4i0V4fxKmfrvR0KwgP/z4Gb0oAHqL6kUf
	 rVxSvLAsu/3RiI/0N+kWYZdOZJeTPfy1JbNWwSl947uSTB+t1kBFXP13/ZIp5yKQBf
	 lll5JmHLIDhPc1wRz4Dp7Oi+3Y+gg8WlfTI9JuBK75HtLiUgg4bOTnD/G4OEMi0ejK
	 KI9rh/34WTcrw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>,
	Hannes Reinecke <hare@suse.de>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 5/6] blk-cgroup: share blkg creation between lookup and config prep
Date: Sun, 23 Aug 2026 23:29:24 +0800
Message-ID: <20260823152926.1043863-6-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260823152926.1043863-1-yukuai@kernel.org>
References: <20260823152926.1043863-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blkg_conf_prep() open-codes the same parent walk and blkg creation that
blkg_lookup_create() now performs. Give blkg_lookup_create() an out
parameter for the created/found blkg and have it report whether the target
blkg was created or found (returning the closest existing blkg in the out
parameter on failure), then have blkg_conf_prep() use the helper and treat
errors as config failures.

This keeps the bio association path's closest-blkg fallback and removes the
duplicate config path loop.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 77 +++++++++++++---------------------------------
 1 file changed, 21 insertions(+), 56 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 33fba781017b..31afb433ab18 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -473,34 +473,36 @@ static struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
 
 /**
  * blkg_lookup_create - lookup blkg, try to create one if not there
  * @blkcg: blkcg of interest
  * @disk: gendisk of interest
+ * @gfp_mask: allocation mask to use
+ * @blkgp: out parameter for the target blkg, or closest blkg on failure
  *
  * Lookup blkg for the @blkcg - @disk pair.  If it doesn't exist, try to
  * create one.  blkg creation is performed recursively from blkcg_root such
  * that all non-root blkg's have access to the parent blkg.  This function
  * must be called with @disk->queue->blkcg_mutex held.
  *
- * Returns the closest blkg with an extra reference acquired.  If
- * blkg_create() fails while walking down from root, the returned blkg may
- * belong to an ancestor of @blkcg.  This function never returns %NULL.
+ * On success, *@blkgp points to the target blkg and 0 is returned.  On
+ * failure, *@blkgp points to the closest blkg and the errno is returned.
+ * The returned blkg does not have an extra reference acquired.
  */
-static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
-		struct gendisk *disk)
+static int blkg_lookup_create(struct blkcg *blkcg, struct gendisk *disk,
+			      gfp_t gfp_mask, struct blkcg_gq **blkgp)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
 
 	lockdep_assert_held(&q->blkcg_mutex);
 
 	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
 	if (blkg) {
-		blkg = blkg_lookup_tryget(blkg);
+		*blkgp = blkg;
 		rcu_read_unlock();
-		return blkg;
+		return 0;
 	}
 	rcu_read_unlock();
 
 	/*
 	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
@@ -523,20 +525,20 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
 		rcu_read_unlock();
 
-		blkg = blkg_create(pos, disk, GFP_NOIO);
+		blkg = blkg_create(pos, disk, gfp_mask);
 		if (IS_ERR(blkg)) {
-			blkg = ret_blkg;
-			break;
+			*blkgp = ret_blkg;
+			return PTR_ERR(blkg);
+		}
+		if (pos == blkcg) {
+			*blkgp = blkg;
+			return 0;
 		}
-		if (pos == blkcg)
-			break;
 	}
-
-	return blkg_lookup_tryget(blkg);
 }
 
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
 	struct blkcg *blkcg = blkg->blkcg;
@@ -844,52 +846,14 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	if (!blkcg_policy_enabled(q, pol)) {
 		ret = -EOPNOTSUPP;
 		goto fail_unlock;
 	}
 
-	rcu_read_lock();
-	blkg = blkg_lookup(blkcg, q);
-	rcu_read_unlock();
-	if (blkg)
-		goto success;
-
-	/*
-	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
-	 * non-root blkgs have access to their parents.
-	 */
-	while (true) {
-		struct blkcg *pos = blkcg;
-		struct blkcg *parent;
-
-		parent = blkcg_parent(blkcg);
-		rcu_read_lock();
-		while (parent && !blkg_lookup(parent, q)) {
-			pos = parent;
-			parent = blkcg_parent(parent);
-		}
-		rcu_read_unlock();
-
-		if (!blkcg_policy_enabled(q, pol)) {
-			ret = -EOPNOTSUPP;
-			goto fail_unlock;
-		}
-
-		rcu_read_lock();
-		blkg = blkg_lookup(pos, q);
-		rcu_read_unlock();
-		if (!blkg) {
-			blkg = blkg_create(pos, disk, GFP_NOIO);
-			if (IS_ERR(blkg)) {
-				ret = PTR_ERR(blkg);
-				goto fail_unlock;
-			}
-		}
+	ret = blkg_lookup_create(blkcg, disk, GFP_NOIO, &blkg);
+	if (ret)
+		goto fail_unlock;
 
-		if (pos == blkcg)
-			goto success;
-	}
-success:
 	ctx->blkg = blkg;
 	return 0;
 
 fail_unlock:
 	mutex_unlock(&q->blkcg_mutex);
@@ -2124,11 +2088,12 @@ struct blkcg_gq *bio_blkg(struct bio *bio)
 		bio_set_blkg_ref(bio, blkg);
 		return blkg;
 	}
 
 	mutex_lock(&q->blkcg_mutex);
-	blkg = blkg_lookup_create(blkcg, disk);
+	blkg_lookup_create(blkcg, disk, GFP_NOIO, &blkg);
+	blkg = blkg_lookup_tryget(blkg);
 	mutex_unlock(&q->blkcg_mutex);
 
 	bio_set_blkg_ref(bio, blkg);
 	return blkg;
 }
-- 
2.51.0

