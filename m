Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746435C6B9;
	Tue, 13 Oct 2026 03:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791861150; cv=none; b=Luz6Th+E2+o4K7okx17BsxRCqSoRdTqg9pDwZPCdFBV2xOBrbYYVIKmno/8nuXHUzr6SgruXlI9hLXYONcb9M0tBSvmk72pITXn5X/GTNe+RX2dA5HJMIwG4AGq9t4uSbyPycGFlcsUzEEMkkB4x0cHsFDlHvW9/PDZoq+AJC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791861150; c=relaxed/simple;
	bh=VXL3asNLi0xoDi6dxYZJcCsXKlBhFzgnhKK+5b9Yfr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cHIr0SjXKuqghTQxyiTRsWzmXC7ikTG8t/Vw3AnUBWQ4x2SklQR3/AiM0IjsfLWdW9WyLfgzlQym826wYHkJzphXe2pWIUfqivfe8MFEN7BG5fUqWyncBMftddNmWmaW6ZFGzpG/kbFOMi1fDALhyqt0Z5/bgsuUqkUBz84xI3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=MyEFSOgA; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="MyEFSOgA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791861145; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=hlzmYIV8LpHzzL0P6N9e/k7OXLBUw21KQOWVEEg7vNo=;
	b=MyEFSOgAAD6zcQ44IvZFnycIuXUZGhDqhZUdSxvU8HOEg4MPw1538XAx4BdBsAipMlpw/46MeZXf3Od50aa3Xp34cFTiagog2A+CvuleUb5XqM+4Re6aDXM13BiXdjJKVzl4kkVJpSbDkNSh+jYabhWBrdDRktdzcMinkSAfVR8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XCkEjbj_1791861142;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCkEjbj_1791861142 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 11:12:23 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 0/5] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Tue, 13 Oct 2026 11:12:16 +0800
Message-ID: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
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

Patch 1 passes the xarray index directly to the list_lru walker and
drops the reverse memcg lookup that v3 still performed between the
xarray iteration and the walk.  That lookup was the cause of the
boot hang reported against v3 [3]: after the keys were switched to
cgroup IDs, the walker kept resolving them as private memcg IDs, so
the global drain kept skipping non-empty per-memcg sublists and
shrink_dcache_sb() could loop forever.  Passing the index directly
also removes the temporary css reference from the walk.

Patch 2 drops the kmemcg_id copy, which is only assigned when kmem
accounting is enabled, and indexes the list_lru xarray with
mem_cgroup_id() instead, so the index works independently of kmem
accounting.  The list_lru plumbing passes memcg pointers now, and
memcg_online_kmem()/memcg_offline_kmem() are inlined into the css
online/offline hooks.  It also drops the nokmem early return from
the offline path so these lrus are reparented on offline.

Patch 3 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patches 4 and 5 restore/add SHRINKER_NONSLAB on the THP deferred
split shrinker and the zswap shrinker.

The savings of nokmem are preserved: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to per-node lists, and
the per-memcg lists are only allocated when a memcg actually holds
such objects.

Changes in v4:
 - Fix the boot hang reported by Kairui against v3 [3]: the walker
   no longer reverse-resolves the xarray keys; the index is passed
   directly through the internal walk path (new patch 1, split out
   as a preparation so patch 2 remains a pure key switch).
 - Drop the kmemcg_id member from memcg_struct_check() along with
   the field removal, as pointed out by Gregory Price [4].
 - Otherwise unchanged from v3.

Changes in v3:
 - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
   instead of the private memcg ID, whose lifetime only covers
   online groups, and pass memcg pointers through the list_lru
   plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
   the css online/offline hooks (patch 1 as numbered in v3, per
   Johannes's review of v2 [5]).
 - Describe in the THP patch's changelog why fafaeceb89a5 dropped
   SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
   original discussion [5].
 - Collected review tags: Johannes's Reviewed-by on patches 2-4,
   Nhat's and Yosry's Acked-by on patch 4 (numbering as in v3).

Changes in v2:
 - Keep the list_lrus behind the two shrinkers per-memcg under
   nokmem, so the shrinker bits are set for the right memcgs and
   scans stay scoped to the target cgroup's objects (patches 1-2
   as numbered in v2, new; addresses Sashiko's review of v1 [2]).
 - Patches 3-4 unchanged from v1; collected the review tags.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
[3] https://lore.kernel.org/lkml/20260910080722.3961351-1-qinyuntan@linux.alibaba.com/
[4] https://lore.kernel.org/lkml/arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F/
[5] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/

Qinyun Tan (5):
  mm: list_lru: pass the memcg index directly to the walker
  mm: memcontrol: drop kmemcg_id and use mem_cgroup_id() for list_lru
    indexing
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h |  16 ------
 mm/huge_memory.c           |   3 +-
 mm/list_lru.c             | 114 +++++++++++++++++++++----------------
 mm/memcontrol.c            |  45 +++------------
 mm/zswap.c                 |   4 +-
 5 files changed, 77 insertions(+), 105 deletions(-)

-- 
2.43.7
