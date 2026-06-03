Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7982BF3D7;
	Wed,  3 Jun 2026 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780493284; cv=none; b=NdB+cDim3GsaA08pIXzUHmE56hBU8PVBKhfjT6wjnfQ/jKCKJP8ANZTRyej/ZbDFNP9bl1ddp70HiFLelmBJ8uCnNoS4lZe6fVfvc+KnRkHkQK2E3HsZjoWE7p2AspDWMIzOFf0fm2DAaQ2Vsu9vJRUA6tDukCQ0XrvoukdKcUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780493284; c=relaxed/simple;
	bh=DV5af5X718xoAVaNjNhLUMh+khHMwVhtHnaYJ0sE5Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obpGrXTyQGSspyVyCL7G3hmg+RaQIHvi5SlVR43oQIHobvpUjtbw79E6U8owLVVVSah6o21K0e4+hkghRFwlPZWC9WGlv8grOIk4uNXbrpKu4j65LB3F8PBszX0T0KxOUMLgQq7AV6fgGFJ4h1sBANsg2hOtxP9X3avGlyxZfak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2451F00893;
	Wed,  3 Jun 2026 13:28:00 +0000 (UTC)
From: Yu Kuai <yukuai@fygo.io>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] blk-cgroup: fix race between policy activation and blkg destruction
Date: Wed,  3 Jun 2026 21:27:43 +0800
Message-ID: <441c79b7ae6a9c64a28c45d61a0c4fe5ebabb0a6.1780492756.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780492756.git.yukuai@fygo.io>
References: <cover.1780492756.git.yukuai@fygo.io>
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
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a98a22e06fd1..007dfc4f9c59 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1612,10 +1612,12 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
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
@@ -1674,10 +1676,11 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
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

