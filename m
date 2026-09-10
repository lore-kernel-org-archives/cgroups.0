Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA5441612A;
	Thu, 10 Sep 2026 08:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027656; cv=none; b=oV2rv2AK9AxT9wlwtmrLR1J5OahgxRsK/KnhjCrRogsqNycmFpF6zmrtARGmKUixWnq3uq2kvkTPNl6Lkcx3t7LGUSRTZqEo0Pv9V8+Zcyj+N+PiSmCRZ2+CPaXg0yng+oP4ebfwsylg9qtoq9ky+zfzOuLFC3Eo13OPWLX5/uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027656; c=relaxed/simple;
	bh=3+vesp5kBdBexjM4Ik/g66EKgcNzW2drl17So5O+UqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJtUcdEt66SUI7drp7SXW9NOSS6YqQ/F4kC4SzasTY2ycpLGLXx2AQiefkGo/AsPSl0jXRCGmXz5QEtc8H/TD+kXX1xXS8VNBnttE6CAuitYFP2WiLsr7EoMtMfQG3Ux9YU6bmxI30d5/dvpfWPrq2g6lu3GRABDf4s7cd6yIig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W7Yh0Rq3; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W7Yh0Rq3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027650; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=odM12/YIoq0YjT8DIJyO3FoSw5OF0hQ5pi5E6fmeHeU=;
	b=W7Yh0Rq3QS6NKtwwVN2NGXlqCU72+3oXOrzsrzBpiKmO9S+ToKqrzZzMyWpR+NGw3ehhoHeHpmrn3wg/L9g/icHElEaf4L1UlFxOKvRZIkVfFvd9JAkWDEGvIMGQxU+doB/OKrZrIHlL9CkkwnLq3hBCmWhrihvyjouzsbqYZqw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I.Y_1789027647;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I.Y_1789027647 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:28 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v3 2/4] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Thu, 10 Sep 2026 16:07:20 +0800
Message-ID: <20260910080722.3961351-3-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
into per-node lists.  That is fine for slab objects, which are not
charged per memcg without kmem accounting.  But a lru backed by a
SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
zswap entries, holds user memory, which is charged regardless of
nokmem.  Collapsing such an lru loses the per-memcg view of its
objects.  Reclaim can no longer target just the cgroup under pressure.

Keep such lrus memcg aware under nokmem when their backing shrinker is
registered SHRINKER_NONSLAB.

This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to the per-node lists,
and the per-memcg lists are allocated only when a memcg actually holds
such objects.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 9241d17de4388..d20faa6de6c02 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -672,7 +672,9 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() ||
+	    (mem_cgroup_kmem_disabled() &&
+	     (!shrinker || !(shrinker->flags & SHRINKER_NONSLAB))))
 		memcg_aware = false;
 #endif
 
-- 
2.43.7

