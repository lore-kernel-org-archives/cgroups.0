Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC133242B2;
	Sat,  4 Jul 2026 19:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783194876; cv=none; b=jIcVZeK06EP3wHQpm9ZBKAyXqQ44sY58E7m8oHlOO7jmbHAKDyN7iN56qWFgVHkvSRqjyEXU4MZkbUxVfyMzI6rl5LgtGrD2h+SYpQCH1u9NSL50YV2zHcmLPl0Q/I7oa6DF7dpn/wrid3rp9zlh33fQXBlTpr7OXQcHH5qrQVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783194876; c=relaxed/simple;
	bh=nUb73tmtNfsE/TNvf7Rbdy58ipEgZXVqk4S7MB9fmHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1pVW/Z2wskdE/bqRzs89f15OCg1aAmGPyIt6qgxfQyGJh4N8ogM7xMNMQBbmJ00WHUq+HyVfwZJ4IXY32xZJQUZgQ5rE5eqBwqnQx1Ta+wpDKtyozpdBMqNj+FNB7z9u7i0QpVAHxr+U+tEcX43u9Ih5FfenV7aGsxRP6nbJW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhTkm8uU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhTkm8uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5B41F000E9;
	Sat,  4 Jul 2026 19:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783194875;
	bh=ek99CdRP9XOBvBl51kk4zcMLTBONOw6ugzRQ5ls0qAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhTkm8uUfl1OgWxnILixlz+38xh0XlfbUWFmbA8XWx3LNrmOzVBR2MQuBtRGI+Vq+
	 CiX0igj9jR7CZ1B7iiSeTfp5YnWVqZeY7Csev+A+/dzYwMZHqso5icmoBQfoVXgTFm
	 +4qiU/jhVS4hfncPVzB27onFj6PvGQ1/qO17AWBMlz9X9nuzxfshQJuV6Zf5bidW3M
	 b4sBbIJ4JHttejZW7pU2JUnOhfZBz6IAZPmJUzVbxsBk29MFmmKb8bpuauFeoyVO2I
	 d0/f2PCAITZOEm6NDfnKcAqVaWSVYwbwBDCFGKKoqerIu+cEaqyUOY/ya+9QnYnvuh
	 +0wG66P5W+5yw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alasdair Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>,
	Yu Kuai <yukuai@fygo.io>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org
Subject: [RFC PATCH v1 15/17] blk-cgroup: remove blkg radix tree preloading
Date: Sun,  5 Jul 2026 03:51:22 +0800
Message-ID: <20260704195124.1375075-16-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260704195124.1375075-1-yukuai@kernel.org>
References: <20260704195124.1375075-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

blkg creation is now serialized by q->blkcg_mutex and no longer runs
under q->queue_lock.  The radix tree is initialized with GFP_NOWAIT, so
radix_tree_insert() cannot sleep while blkcg->lock is held and the old
preload dance is no longer needed.

Remove the preload calls and the associated unwind path.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 71313bb3c4f3..b99ab8d67798 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -420,7 +420,6 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 			pol->pd_init_fn(blkg->pd[i]);
 	}
 
-	/* insert */
 	spin_lock_irq(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, disk->queue->id, blkg);
 	if (likely(!ret)) {
@@ -875,16 +874,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
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
@@ -896,12 +889,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
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
@@ -909,8 +900,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	ctx->blkg = blkg;
 	return 0;
 
-fail_preloaded:
-	radix_tree_preload_end();
 fail_unlock:
 	mutex_unlock(&q->blkcg_mutex);
 	/*
@@ -1448,7 +1437,6 @@ int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *new_blkg, *blkg;
-	bool preloaded;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
@@ -1466,8 +1454,6 @@ int blkcg_init_disk(struct gendisk *disk)
 	if (!new_blkg)
 		return -ENOMEM;
 
-	preloaded = !radix_tree_preload(GFP_KERNEL);
-
 	/* Make sure the root blkg exists. */
 	mutex_lock(&q->blkcg_mutex);
 	blkg = blkg_create(&blkcg_root, disk, new_blkg);
@@ -1475,16 +1461,12 @@ int blkcg_init_disk(struct gendisk *disk)
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

