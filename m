Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A878141A79E;
	Fri, 24 Jul 2026 12:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896274; cv=none; b=Ia3760CXJuqc1lzvV71YLVSjEoNmoUnkxvKBkxSjAskbn5U37F0gf+4BR5IYEoZMrTXJqRBBdO7rloFUoyNo/iTq77DXHVLcPYCse7bvqHSVFGT5uXN4mrljI9waFdjfGEIrdWxsXrPZguqakyoezpYkxKYBIKzm5N8qkU822eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896274; c=relaxed/simple;
	bh=Bhh4RKmhEE1o3oSJX2ZhPK4McxffBUIvz5dtpvQ9UJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4ecBLaUwAnCubsXLbPYnaKMa7/XNxw+N1ri3OCVpAMbySCS0r35QFwDdeohxvU/e19fA58OG7XXJ7ZESpLphg/OpJXE/Lo5fdFKyBEF7sY+Edv2o0/x+AIbS1Hh6EN0iARMoNzt+4HchFDNcqu8hjqcxwnTuTKf2a5XHQ1Fd28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xc7dNm/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xc7dNm/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22B21F000E9;
	Fri, 24 Jul 2026 12:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896273;
	bh=rY9fJ2rABK9eGWUwMSDtclvDRjArug+aZ2r/keWOH14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xc7dNm/MyQ9zzmX5C78MhBCgx+QPJc2j1l5kPw7ncdBmn860tvAAUOuYtJu1bqGs1
	 zt/2v3NzhulQ6RfIzXHnAFKzQPGR07Sd2QYw/7NcgTRuG5JDve5A1mSUY6nZ6AsZc6
	 aTfyn4GeFAr/Api/gYLSbCCzN2YOr+iBktuFp3rTx6iBo/qomMcRchfI9lprwuz7VN
	 H7eFeOeFunRDzq+YG2D9yM/pvjdnSscATfEwvnUjzugcsYwdRJQVcHlOu7hiO2QtlG
	 ZSMUDr0UnB2hojv63jAUhu7J0jd6n3CUScRZJ3kqWhklP/lubEAf3TJufCJJwVY/Ts
	 QUSLh5sz7zuSg==
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
Subject: [RFC PATCH v2 4/8] blk-cgroup: remove blkg radix tree preloading
Date: Fri, 24 Jul 2026 20:30:33 +0800
Message-ID: <20260724123037.3004560-5-yukuai@kernel.org>
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

blkg creation is now serialized by q->blkcg_mutex and no longer runs
under q->queue_lock, and the next patch moves the blkg allocation itself
into blkg_create().  With the allocation no longer happening under
blkcg->lock, the radix_tree_preload() dance used to keep
radix_tree_insert() from sleeping while blkcg->lock is held is no longer
needed.

Remove the preload calls and the associated unwind path. This might
affect the nowait case when the first thread for blkcg and queue pair
to issue the first IO. However this is a super cold path, it's
impossible for a real world latency sensitive load to always create a
new blkcg, issue an io with nowait and then remove the blkcg.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 03e1d4d34921..8fdc42ab153b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -419,7 +419,6 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 			pol->pd_init_fn(blkg->pd[i]);
 	}
 
-	/* insert */
 	spin_lock_irq(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, disk->queue->id, blkg);
 	if (likely(!ret)) {
@@ -874,16 +873,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail_unlock;
 		}
 
-		if (radix_tree_preload(GFP_KERNEL)) {
-			blkg_free(new_blkg);
-			ret = -ENOMEM;
-			goto fail_unlock;
-		}
-
 		if (!blkcg_policy_enabled(q, pol)) {
 			blkg_free(new_blkg);
 			ret = -EOPNOTSUPP;
-			goto fail_preloaded;
+			goto fail_unlock;
 		}
 
 		rcu_read_lock();
@@ -895,12 +888,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			blkg = blkg_create(pos, disk, new_blkg);
 			if (IS_ERR(blkg)) {
 				ret = PTR_ERR(blkg);
-				goto fail_preloaded;
+				goto fail_unlock;
 			}
 		}
 
-		radix_tree_preload_end();
-
 		if (pos == blkcg)
 			goto success;
 	}
@@ -908,8 +899,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	ctx->blkg = blkg;
 	return 0;
 
-fail_preloaded:
-	radix_tree_preload_end();
 fail_unlock:
 	mutex_unlock(&q->blkcg_mutex);
 	/*
@@ -1447,7 +1436,6 @@ int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *new_blkg, *blkg;
-	bool preloaded;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
@@ -1465,8 +1453,6 @@ int blkcg_init_disk(struct gendisk *disk)
 	if (!new_blkg)
 		return -ENOMEM;
 
-	preloaded = !radix_tree_preload(GFP_KERNEL);
-
 	/* Make sure the root blkg exists. */
 	mutex_lock(&q->blkcg_mutex);
 	blkg = blkg_create(&blkcg_root, disk, new_blkg);
@@ -1474,16 +1460,12 @@ int blkcg_init_disk(struct gendisk *disk)
 		goto err_unlock;
 	q->root_blkg = blkg;
 
-	if (preloaded)
-		radix_tree_preload_end();
 	mutex_unlock(&q->blkcg_mutex);
 
 	return 0;
 
 err_unlock:
 	mutex_unlock(&q->blkcg_mutex);
-	if (preloaded)
-		radix_tree_preload_end();
 	return PTR_ERR(blkg);
 }
 
-- 
2.51.0

