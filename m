Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490953DA7E6
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 06:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010709; cv=none; b=W8IC3mTZljejb1ewAy0a6QLjjlyidZ/jRC2t0xeAKDpabaOBffJLKBCzzea5LtuIGxQqh41ZB80Gdxa4duiI6VrhmKthm13/jikfgQCfixzGmamI1eF2rk3wGoyZro37/hzVwzQwmAMARAeHQRktGkGRVD78rHlxb7HvfaYFWL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010709; c=relaxed/simple;
	bh=p7ZGe7ovr6Fnp+xJqMj+SXZ7ZkuYYQUS1ExBdGpuXYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DTCz2dF8UusOehne4mjxZxeAC9japz8mrMOEZ0pZCIsdXwXYMVS8a5eBOCIpxJzjkq5JgeR5wFbSZzAlYmtjVsQM2+rwO411Pv1LuJAVk/udBY6T6/8tceZwe/rLrhGxKd1CXcR+gSzDIonbRUy5GUwfTm7L0gf/ZtY7W8nE0AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GEebQZjY; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GEebQZjY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784010695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uX8GOm2Y6bu+4/Uc+uJ+m9Biszo7L7ChblxvTzcX6kg=;
	b=GEebQZjY+R6uOyuJp7bWgNjQdi6sRvq8r8FRuB5PiK0T4/+6hvADZQwQMB35XC8NKuM0G3
	eMdUfx6zGrD32Hhx0eWlZJTUOyh1DGvjzQBJr1QmBIsy233DvAt8MWPji+NE1nHBxuBju7
	a5qfj8/OCFZ9xpvdnxu/7Wp/uXvNczk=
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	boris@bur.io,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] blk-cgroup: avoid 32-bit overflow in root io.stat byte accounting
Date: Tue, 14 Jul 2026 14:31:18 +0800
Message-ID: <20260714063118.1153083-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

blkcg_fill_root_iostats() converts per-CPU sector counts to bytes with

    tmp.bytes[BLKG_IOSTAT_READ] += cpu_dkstats->sectors[STAT_READ] << 9;

but disk_stats.sectors is `unsigned long`, and the shift is carried out in
that type before the result is promoted to the u64 accumulator.  On 32-bit
kernels (unsigned long is 32 bits) this wraps, so once a per-CPU counter
reaches 2**23 sectors (~4 GiB) the computed byte count is wrong, corrupting
the root cgroup's io.stat.

Every other sector->byte conversion in the tree casts to a wide type first
((loff_t)sectors << SECTOR_SHIFT in bdev.c, (u64)max_sectors << SECTOR_SHIFT
in blk-settings.c); do the same here.

Fixes: ef45fe470e1e5 ("blk-cgroup: show global disk stats in root cgroup io.stat")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d2a1f5903f24..a778aa9d2bb9 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1112,11 +1112,11 @@ static void blkcg_fill_root_iostats(void)
 				cpu_dkstats->ios[STAT_DISCARD];
 			// convert sectors to bytes
 			tmp.bytes[BLKG_IOSTAT_READ] +=
-				cpu_dkstats->sectors[STAT_READ] << 9;
+				(u64)cpu_dkstats->sectors[STAT_READ] << SECTOR_SHIFT;
 			tmp.bytes[BLKG_IOSTAT_WRITE] +=
-				cpu_dkstats->sectors[STAT_WRITE] << 9;
+				(u64)cpu_dkstats->sectors[STAT_WRITE] << SECTOR_SHIFT;
 			tmp.bytes[BLKG_IOSTAT_DISCARD] +=
-				cpu_dkstats->sectors[STAT_DISCARD] << 9;
+				(u64)cpu_dkstats->sectors[STAT_DISCARD] << SECTOR_SHIFT;
 		}
 
 		flags = u64_stats_update_begin_irqsave(&blkg->iostat.sync);
-- 
2.43.0

