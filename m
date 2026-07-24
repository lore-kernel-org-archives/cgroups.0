Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A4442F6E4;
	Fri, 24 Jul 2026 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896290; cv=none; b=d7PRspdnpNh5lw7EtBG3E6ykq4DfP4YcquWf727Xv9rwl1mzETqMWGCEN+aPLd6M+Kk4YNJlOM8tioHr0F5AsRpTx2t2T+lJHL82fDDVO+bnPL6xi6X5WZ/PenCMOHueaGflf8O2GJJBW5SLLYd2hsEwxgoET5TrdWvLTxeVdCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896290; c=relaxed/simple;
	bh=4PM7LGkhraeBd0VGEADGZ5lgiB2uz+P4zucVDr0XpUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X60u+srYjNmPoVStVnPXribM773Qj49HwcyUA4c3+Pga96UXWPHCy+6YmKGLVSu874vfb/8aYA/K1DbZAZwmyhxk12DPkEBc16raiTPyYkMkznfsr8xjwSUReRZbGMMJVg8ZIsUkKLKgwPszlOZVNsXGMVSwr4UMR1PRmVyVU/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfB149ZK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfB149ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732071F000E9;
	Fri, 24 Jul 2026 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896288;
	bh=XMp/IesQP25u/Pie4/xQScDi1untoQjIPZx3TD3aXOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfB149ZK+beK0YGYD1DpmKk1oOdemkPHvWadqVP6t/5Mosq8imvKXf4tcw+LAQqCB
	 gCB20eRtQvdmG3rcs+RxAH/006zGRtK9b3W6bH+LcGq6jQzbYyC9HJyg2PddoJcF3a
	 NQ1IEKambnPid2Cw5v1d2utoL8pQoyEKyArIjm0ZY8ZrXpuAX0fnN6aL4yL1riCxG/
	 3TuxTd7Zsscbf3qxvNrgXuC7cTzgFQuSiGe7AOK7+ueiJpGwrBu9GPK8snHBoVm+ba
	 aT+Vk4KeOLmcjiCs0SAoOL0vtx50r6t00xvThDWotIP/kFmYYGa/xWuAH9oKOkZREw
	 h38DrB7b1qyAg==
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
Subject: [RFC PATCH v2 6/8] blk-cgroup: share blkg creation between lookup and config prep
Date: Fri, 24 Jul 2026 20:30:35 +0800
Message-ID: <20260724123037.3004560-7-yukuai@kernel.org>
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
 block/blk-cgroup.c | 71 +++++++++++++---------------------------------
 1 file changed, 19 insertions(+), 52 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 345c02a4ac32..d611cf701f14 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -447,17 +447,19 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
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
- * Returns the blkg or the closest blkg if blkg_create() fails as it walks
- * down from root.
+ * On success, *@blkgp points to the target blkg and 0 is returned.  On
+ * failure, *@blkgp points to the closest blkg and the errno is returned.
  */
-static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
-		struct gendisk *disk)
+static int blkg_lookup_create(struct blkcg *blkcg, struct gendisk *disk,
+			      gfp_t gfp_mask, struct blkcg_gq **blkgp)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
@@ -469,7 +471,8 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		    blkg != rcu_dereference(blkcg->blkg_hint))
 			rcu_assign_pointer(blkcg->blkg_hint, blkg);
 		rcu_read_unlock();
-		return blkg;
+		*blkgp = blkg;
+		return 0;
 	}
 	rcu_read_unlock();
 
@@ -496,16 +499,16 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
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
-	return blkg;
 }
 
 static void blkg_destroy(struct blkcg_gq *blkg)
@@ -838,46 +841,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		goto fail_unlock;
 	}
 
-	blkg = blkg_lookup(blkcg, q);
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
 
@@ -2022,7 +1989,7 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	 * time, hold lock to create new blkg.
 	 */
 	mutex_lock(&q->blkcg_mutex);
-	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
+	blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk, GFP_NOIO, &blkg);
 	if (blkg)
 		blkg = blkg_lookup_tryget(blkg);
 	mutex_unlock(&q->blkcg_mutex);
-- 
2.51.0

