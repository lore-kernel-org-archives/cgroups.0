Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA83F3C5855;
	Thu, 10 Sep 2026 08:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027654; cv=none; b=U38xwOmnpLWXq+n55aG578JD/UGxGq7iWOaCfTcne2JzIHWuWoloXOAYXrAwhRspwC6pum42YPKhWSPnGgKwoxNG/iNeFvypX0Luya8fNqwy7eACUrxXA6lvwraW0vYE3O7fS5in6tjbhvkStR4lX8ijk7use965en69FjR2LLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027654; c=relaxed/simple;
	bh=DoJbIybIvZ769dqvFn5ydwr3F935xUW7bzM2D9qfdIA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m6tfxkcIcUUpAd8zHDb8tQGHGLiKm/EaNSUxixOeMNAWpbk2/mqHBwnujhte5ryI6iPfPfu0JwULke26EnHFtSPfIxPA/3htpW9Wsda8staF4+qGwbrE9P7KiqSsKpKEmi78VhDfky+dAUqRPLNvwHL7snCHtX53z0LSUezj3vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MnuBhlUs; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MnuBhlUs"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027647; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=vs/fzTE/mrTKphlkA+LD1zojb3NEuHfTJzjqRzU7CnY=;
	b=MnuBhlUsJWqn6sDlvB0zEfFQAgk+URNQ0j2hEjbN3uZGOp4wfiGR6L6ffo+AnZpMltRCYfZbvHPA49oJ4NV+ASuOL5qVuvyquKwaEpeG4/g8pN5NiNdlDuU9bkyKa2soSbs8Q6ZqyT6AgDVyNw9ln8xGk2j0aet9rrsHNTNgAIs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I-Z_1789027643;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I-Z_1789027643 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:25 +0800
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
Subject: [PATCH v3 0/4] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Thu, 10 Sep 2026 16:07:18 +0800
Message-ID: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
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
accounting is enabled, and indexes the list_lru xarray with
mem_cgroup_id() instead, so the index works independently of kmem
accounting.  The list_lru plumbing passes memcg pointers now, and
memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
online/offline hooks.  It also drops the nokmem early return from
the offline path so these lrus are reparented on offline.

Patch 2 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patches 3 and 4 restore/add SHRINKER_NONSLAB on the THP deferred
split shrinker and the zswap shrinker.

The savings of nokmem are preserved: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to per-node lists, and
the per-memcg lists are only allocated when a memcg actually holds
such objects.

Changes in v3:
 - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
   instead of the private memcg ID, whose lifetime only covers
   online groups, and pass memcg pointers through the list_lru
   plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
   the css online/offline hooks (patch 1, per Johannes's review of
   v2 [3]).
 - Describe in patch 3's changelog why fafaeceb89a5 dropped
   SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
   original discussion [3].
 - Collected review tags: Johannes's Reviewed-by on patches 2-4,
   Nhat's and Yosry's Acked-by on patch 4.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
[3] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/

Qinyun Tan (4):
  mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru
    indexing
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h | 15 -------------
 mm/huge_memory.c           |  3 ++-
 mm/list_lru.c              | 31 ++++++++++++++-------------
 mm/memcontrol.c            | 43 +++++++-------------------------------
 mm/zswap.c                 |  4 ++--
 5 files changed, 29 insertions(+), 67 deletions(-)

-- 
2.43.7

