Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793870563;
	b=r+SOzqUmWwrEuqCrgb3b3SwQQya34ZRrV14ehEBVNdhFL5Nf2ZQqbEZcflccr+GfJnr+
	 dHMYpcK6B4c6ch1tnebra9FgUUvRhDfG0UQJrQQXgsaXtxVxt3E2FYSyphTb9B8mSTfOV
	 obw10FLr+2yI+k4u3qZnIM7xwZ1DS1/YnyL+nmAoe6WrbEyUV5WXgbqIic4WKxYkeFdR/
	 u31e0xI5JR4zZsoLQnbAM9KlA/9NJ3nZqggYUvtiZ0H5CNT7LPwHcFC8ma+XrkPZbL73/
	 5GnVmMMRF5O68xPBwUmsGpsjpB5j+8XYgU2ZH+5079eq7mOhNFx6xRCO+AH6GWidPLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793870563;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=UWmb9HUpIQPQz6k2PGeMG/U7KreRlMRXLm0OBejdgFU=;
	b=Bydw1tW1TWVmXJGYlXSTkO61uafgDPMe/dxtIcdDW33YdVVtzbX0/dcV0OmcjCSHNdVM
	 kwF7UuIxcTsofeMuix//mzGui2QpwLieV83ugRsWHwlnuvbAT4PYrzw6PztlGQqF95KuY
	 BVrRyoI73dqAlpWHjS0eRyCASc+VKQw8vSmnbG2qp1jD953yMFTPkBLtAG0a6tj3LXkER
	 9d6BPFCNcPg+Rz1mWnaa7tKpOtBSSo7ipu0uHQNkptlUmcK1pN5xh9FzSlSKqrD7rJbwJ
	 8OkKSTEtCf/eJKbuduUUgVycWjbBuxbMJC4OPg3Bav6wOVVqJzTPQr+aQYPt51F8F+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KN81Oltm;
	arc=none smtp.remote-ip=115.124.30.111
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C95606A31B;
	Thu,  5 Nov 2026 09:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C95606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=KN81Oltm
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870557; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=UWmb9HUpIQPQz6k2PGeMG/U7KreRlMRXLm0OBejdgFU=;
	b=KN81Oltm2Terq6mHB0ZDn3JUUA6KjjAZNhrmt6Qk1pSttBittWJEZhhXlg1lTEbpnDyar8Yz6c5c5uvc+hWisnclaRah6uX4KnMEBmJorKtypfzn8/z9btS75ObdRagHpqYyfMWOuRvqOsIjSe4BNviL+lJn15Lr+ilaNP/o7oE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-.B_1793870554;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-.B_1793870554 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:36 +0800
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
Subject: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Thu,  5 Nov 2026 17:22:28 +0800
Message-ID: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Resend: the original v4 went unanswered while reviewers were busy
with merge-window fixes, and Andrew suggested sending it again now
that the window has closed.  No changes of any kind since v4.

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
 - Describe in the THP patch's changelog why the list_lru conversion
   dropped SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
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
