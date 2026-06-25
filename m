Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B0434F492;
	Thu, 25 Jun 2026 02:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356272; cv=none; b=lRFsD52kKJqxndar/oGPXcUA1FzJwnNJhLKerioH0innCi5p+6YAIWfv9x5s3dyfC8ggVPtdkmVl+wJ5X2e6J5IAVSbsY3WTCJWU+WChzGAHvA7Hcc8imbvOxk56Q2Wwq0bVf69ol7n4GcGTSiQbXObKavmnlgRC5oIJg89TBrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356272; c=relaxed/simple;
	bh=TA/TuVVCMP/sD8QDUpiV/o38vQ8VDNXl8k1/pdHHkWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYnjr/+mjCiP8+Q/1F0tAXQt0VMd1leamFr8PhZ95l7oukg//gngKAAUb8+MqmGlOfoIac2HcP4WTmXHxxlI/Q+zJ6SqbqUrMOkKnod1M2TMKRlIzvJA0Q0vi/nJ7RMKt1YyuTrI4JeYOdfzS2fzJlnMy/8h30ZMEMjhnFH/kD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcTqED/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcTqED/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D411F000E9;
	Thu, 25 Jun 2026 02:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782356271;
	bh=WVh8gixDdQUhe8l+ek6jwwo/qhiOHYLnnqnQAVpDBrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcTqED/x21KJK+0SG+bGqI8uhI4Nmyo60YHl5NlaxIh6CjFFo1/hrRGJbY2VoHL2Q
	 8bsSlvgeH7yPJmQBI38umYbm2KMJ+cZ3nkwe46tql303Pe6OrsZ2Ii2/7tUqSblexF
	 5Ladp4vzjqFcGdazcozGC/uqsTxVxXp5zglq/QXQtf0cY+SC+jvHjBt4nrFnsTgqdG
	 zZ76F/2xs68zRY1domVjLsoRyaKTJadcVmWSQstoP6MmPraRWyUHc+/rKMobF85m4x
	 NUJ/+GHNXjUoTZnuYfyvrGXRCTQmyc+GFNAiQpftfriVNQ98uXLcpWiF18o2v1scpu
	 JUZg3iD8l6MWg==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Yu Kuai <yukuai@fygo.io>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] blk-cgroup: fix race between policy activation and blkg destruction
Date: Thu, 25 Jun 2026 10:57:37 +0800
Message-ID: <20260625025739.2459651-3-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260625025739.2459651-1-yukuai@kernel.org>
References: <20260625025739.2459651-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zheng Qixing <zhengqixing@huawei.com>

When switching an IO scheduler on a block device, blkcg_activate_policy()
allocates blkg_policy_data (pd) for all blkgs attached to the queue.
However, blkcg_activate_policy() may race with concurrent blkcg deletion,
leading to use-after-free and memory leak issues.

The use-after-free occurs in the following race:

T1 (blkcg_activate_policy):
  - Successfully allocates pd for blkg1 (loop0->queue, blkcgA)
  - Fails to allocate pd for blkg2 (loop0->queue, blkcgB)
  - Enters the enomem rollback path to release blkg1 resources

T2 (blkcg deletion):
  - blkcgA is deleted concurrently
  - blkg1 is freed via blkg_free_workfn()
  - blkg1->pd is freed

T1 (continued):
  - Rollback path accesses blkg1->pd->online after pd is freed
  - Triggers use-after-free

In addition, blkg_free_workfn() frees pd before removing the blkg from
q->blkg_list. This allows blkcg_activate_policy() to allocate a new pd
for a blkg that is being destroyed, leaving the newly allocated pd
unreachable when the blkg is finally freed.

Fix these races by extending blkcg_mutex coverage to serialize
blkcg_activate_policy() rollback and blkg destruction, ensuring pd
lifecycle is synchronized with blkg list visibility.

Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d22a43c545b6..fd1eed67924b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1564,10 +1564,12 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 	if (WARN_ON_ONCE(!pol->pd_alloc_fn || !pol->pd_free_fn))
 		return -EINVAL;
 
 	if (queue_is_mq(q))
 		memflags = blk_mq_freeze_queue(q);
+
+	mutex_lock(&q->blkcg_mutex);
 retry:
 	spin_lock_irq(&q->queue_lock);
 
 	/* blkg_list is pushed at the head, reverse walk to initialize parents first */
 	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
@@ -1626,10 +1628,11 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
 	spin_unlock_irq(&q->queue_lock);
 out:
+	mutex_unlock(&q->blkcg_mutex);
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q, memflags);
 	if (pinned_blkg)
 		blkg_put(pinned_blkg);
 	if (pd_prealloc)
-- 
2.51.0

