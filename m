Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489D46AA9C;
	Mon,  7 Sep 2026 11:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788778881; cv=none; b=bi4wfMUAo+DXojCIFRwIHKyONMNi5nXpqniks9MJ0AVEf4y9H6HomjrkHResIMdCWaRD7hxWqIq2eP3jZvJ4uIGrhc86bTfq8zG6Nhhs4dadkm+TeR5pe9Z2BU09ThJbpCqH4cqY10n+IhpV73N/hk0meATs2fuHnyESa/W5Gjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788778881; c=relaxed/simple;
	bh=0HILOA9S6qfQr25g217vDM/WBy58yERkxKGLrjHyRBw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t0xG1EbOb4MGV3eo+GtNms3q986i1Q6SOmL7pdY122o34Ppgqm/pQlECYLQdavJdLFqJb1L/poBlLPvXyDE2Gp01UZY8WWTo4qopxRgf8q1RKLP5//5zN0km2/TC6IOBHErCaTC2ix+QhkqYbi0jsQxN80a94AzmbPxW0XtCjrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=rHrdjI3Z; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="rHrdjI3Z"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788778876; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=fOZgTIi+9CkjJIkHZ5qDJVF7Cb2c4YKm1mdHlDBaqAs=;
	b=rHrdjI3ZXCI1hwddQCoiR8SzGXc1jwSkBJZriTIaSadr2V1fDgKvjgPMQRi4fPS7vy9Jn/Lc1bc9iIBzJYpF7CcQeldnFOqzMa3Wo/L+J6prSUkD619Cq5g8kMy2Qb+d66hlzdRMLTg7+BHZj3mTkAyuLfoK3QgU0HrWoGn3lSk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XATsvzD_1788778872;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XATsvzD_1788778872 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 19:01:14 +0800
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
Subject: [PATCH v2 0/4] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Mon,  7 Sep 2026 19:01:07 +0800
Message-ID: <20260907110111.2286932-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With cgroup.memory=nokmem, the THP deferred split shrinker and the
zswap shrinker are degraded in two ways.

First, both shrinkers are missing the SHRINKER_NONSLAB flag, so
shrinker_memcg_alloc() demotes them to non-memcg-aware shrinkers:
limit-induced reclaim of a cgroup neither splits its partially
unmapped THPs nor writes back its zswapped pages.  v1 of this series
[1] restored the flag to fix that.

However, as Sashiko's review of v1 pointed out [2], the flag alone
is not enough.  __list_lru_init() also collapses every list_lru into
per-node lists under nokmem, so even with the flag restored, the
objects of all cgroups share one list per node: the per-memcg
shrinker bit is only set for whichever memcg happens to repopulate
the empty list, so pressure in other cgroups may not even trigger
the scan, and when it does, the scan walks everyone's objects.

Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
list_lru"), THP had fully per-memcg deferred split queues embedded
in struct mem_cgroup, working independently of kmem accounting.
nokmem only opts out of kernel slab accounting; THPs and zswapped
pages are user memory and remain charged to their cgroups, so
per-memcg reclaim is still what these shrinkers want.

This series keeps list_lrus backed by SHRINKER_NONSLAB shrinkers
memcg aware under nokmem:

Patch 1 drops the kmemcg_id copy, which is only assigned when kmem
accounting is enabled, and derives the list_lru xarray index from
the memcg ID directly, so the index works independently of kmem
accounting.  It also drops the nokmem early return from
memcg_offline_kmem() so these lrus are reparented on offline.

Patch 2 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patches 3 and 4 restore/add SHRINKER_NONSLAB on the THP deferred
split shrinker and the zswap shrinker, unchanged from v1.

The savings of nokmem are preserved: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to per-node lists, and
the per-memcg lists are only allocated when a memcg actually holds
such objects.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com

Changes in v2:
 - Keep the list_lrus behind the two shrinkers per-memcg under
   nokmem, so the shrinker bits are set for the right memcgs and
   scans stay scoped to the target cgroup's objects (patches 1-2,
   new; addresses Sashiko's review of v1).
 - Patches 3-4 unchanged from v1; collected the review tags.

Qinyun Tan (4):
  mm: memcontrol: drop kmemcg_id and use the memcg ID for list_lru
    indexing
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h |  8 +++++---
 mm/huge_memory.c           |  3 ++-
 mm/list_lru.c              | 14 ++++++++------
 mm/memcontrol.c            |  6 ------
 mm/zswap.c                 |  4 ++--
 5 files changed, 17 insertions(+), 18 deletions(-)

-- 
2.43.7

