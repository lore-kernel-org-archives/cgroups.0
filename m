Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BEA3655C7;
	Sun,  2 Aug 2026 11:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785669947; cv=none; b=AwZLACykDYDNaPvVuDh3zyDZZJnXqgwJnvkkshJ61rJsAga+tsm55Tl1hPmgB0wW7lDN44VxtN/9iOnK+K1KVo4twbC0uVJkZq8aOAYWZGqw8XIrOaboKCUmJx/IukQmasSJ4brksy4cOMHz81dtgIgKURRtfhwpNS5/FkRGYns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785669947; c=relaxed/simple;
	bh=2UTzKqgDdno6vcTrIhtaC5W6GsAEgwiO/gdu5cNmrlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgFWYfhThCCm7jR3PSiXN0jc3nGLUNBijzpAvCvxQimRlH+xPhCtjcolVnPOxRO4N7PMe1OuyxjatKWwmb7vzdq/6ZVAElh+wng1P5/r2ssl3DvUlZTDmRpdwIFCQ/KcLdeQC4mpvLea2HMLBbjxo2WCjwIrWCwdSj3Jtucx9rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=axpWoho+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="axpWoho+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C520E1F00A3A;
	Sun,  2 Aug 2026 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785669945;
	bh=v0L+TiAxcy/6VWLByx/spXZdJvdVONE9HQS+Bjch3BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axpWoho+EZLZlpnjQaVnqOhbFzfQ3qg94REMzMTvfBrJxftnXuZKyrnrBz42Z10o0
	 WwDg5iTCwAANupu7cPWSMrKVJKdtH+/bS5rXc9sxA5leTBWosqKOhOgxCEKBoqxAj7
	 Ydogc1jotqq0fL0+HV68TyuvQL/pdz+jqI5KrpnEwcNRgb+dxkF6+ZiA3QfvIuR8VJ
	 FuxepamamQ4ounu6jJrI77jzjiZ6/rXKSdQ50ML0dx2uL/8vhthKfWLF9VsnvH0lVX
	 xh/88230h7Nn67sarSAjwakv8ofwJQIHvBwsvi3qwv8QTc2bURv52PQtgqmn2Nu62d
	 lWyW+ROvSK9gw==
From: Yu Kuai <yukuai@kernel.org>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhengqixing@huawei.com,
	hch@lst.de,
	yizhou.tang@shopee.com,
	yukuai@fygo.io,
	nilay@linux.ibm.com
Subject: [PATCH v4 2/4] blk-cgroup: fix race between policy activation and blkg destruction
Date: Sun,  2 Aug 2026 19:25:18 +0800
Message-ID: <20260802112525.3933753-3-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802112525.3933753-1-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org>
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
index eb0cfb10b859..047bb42c282b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1566,6 +1566,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 	if (queue_is_mq(q))
 		memflags = blk_mq_freeze_queue(q);
+
+	mutex_lock(&q->blkcg_mutex);
 retry:
 	spin_lock_irq(&q->queue_lock);
 
@@ -1628,6 +1630,7 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 	spin_unlock_irq(&q->queue_lock);
 out:
+	mutex_unlock(&q->blkcg_mutex);
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q, memflags);
 	if (pinned_blkg)
-- 
2.51.0

