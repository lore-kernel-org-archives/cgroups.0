Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53B83890FB;
	Wed, 24 Jun 2026 06:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283606; cv=none; b=LjxkdUDOOh8F+FhBWhgXB6d7I6Xyf9AaZVrvcvl5x/R9uGK6qAfu8WKjxsSh7mo3WFRerfQ+jRZlqQVO4CcTVMTDkHn2/5LlcsrNpSorpEcNFxp/EUvCjhbkLBArkhv2iyTyGAhcEzzDJRr9brUjORUKYdweftqYQ33uFxeQn40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283606; c=relaxed/simple;
	bh=Ja/8qk2obViHpjqjHP9sxrEleIKnXEnZLA8yRdcZkwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/hrIwUdIYnCydhdl3xwny+nmtIiNdCg7VomN1lyBdMZfPe6pdobUfjaEIxNTXYC+D98PMm4cJWvrJFenCzF35u0Crau5bJaXGD71EyYP+fwuwhzv0yfi9QyIqUnSfKO4yqkd05rQK1dr8j75ZG7LNSwciYoxP/7RpWJlBe9F+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0vqBuDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0vqBuDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B6F1F00A3D;
	Wed, 24 Jun 2026 06:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283605;
	bh=8ebiq0Q1Wa02CvLbMhLoZHxCysl5Fnhk4XPVbxOJu64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0vqBuDnmnbC9qgEdecQCTu2OCaD4zww5s4hjZmaV0z075/rMDw3TEt3UaOSKSsqA
	 EwZo9llt17UcOs1uVJbqgyLBn3c+qoXz7QVkDTlL3P69zDiiTElSiQ4ioU2Lq/uPxU
	 31F0eNuxnX44aHiP6p2HHffdNTf8u9EqgIcewJfIs+OR+gSN7hzUK0dehAVwkzEOPT
	 kUsTtugcP2rOd5YaNhw7SR5LL4ufw5JaFKrxwK4EEnjkG2Ox1iNINYbezVKZImXAKL
	 BpLzHhXcQYZBsdBGw3TLfOFwy3HhUwn8XWfG0HHLR2hmXe5Fyjzs2RbCUrt/Lpx1kE
	 W4fiP3qHdJ1pg==
From: Yu Kuai <yukuai@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] blk-cgroup: fix race between policy activation and blkg destruction
Date: Wed, 24 Jun 2026 14:46:23 +0800
Message-ID: <20260624064625.1743650-5-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260624064625.1743650-1-yukuai@kernel.org>
References: <20260624064625.1743650-1-yukuai@kernel.org>
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
index 7baccfb690fe..f7e788a7fe95 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1563,10 +1563,12 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
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
@@ -1625,10 +1627,11 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
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

