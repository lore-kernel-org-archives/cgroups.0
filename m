Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795431223;
	b=h2LR3772kxLOsECt0SDScygiYGWifZI/PsND8PEI7Bf1PEuExtvv3uypuGq6Rt8Y1f4K
	 CajK/4OnCzh2PX8+gYZIcG3TKXnTzHDGvfBv8lMvokR/0mMENgshq4NA+1PMHh0eHsfOr
	 FJKKCyLaivNkrsskxmgqOpOMHTIcUxTAaVQofkdeK5474WFntLyEwt0harTGqmok0qs2Z
	 wCPvYh/JHvjSoyb2UQaRCASiKvn4+pKILyrT/x7MJHgelBm5MxNTffbB1oCSB10tJhAyX
	 Zt9o7h8NBDrAegpzHZbX0EtgD7KJslU8s2FRPs6mDOckWyHid0G4xChgGYJQFnykXdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795431223;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5Y6RrQPl3+RDc3EwpamkVIy6Oyhib7bCsIXwFSNt6so=;
	b=GxMMzAAOCPdtBmXJ4tjQa0lSL7lzZR+grDYZBvo9SN+jbr49y7anrkVf9HGAHWKNLr46
	 5UglOI+m8z8Y9OlDAtayOO/D+mAjHQS1/T9lpHMKDYLOHG3HXmMgvTrUMEcsD8MhDiLmi
	 Lpo5qUqqSZrk9RoR47FY6K+pdsJGkGuWYInjK6rnHP3jWJgL/389Lhyy9dHgVxFRFBY55
	 wKK+YQk863QfisQahYTZy3jY/E12cjvpD2HGUPiJa6Q2w/UasnfeT5gK6kqLcxSP7zCTV
	 ozEkT2mA3+GiyxZteWyBgdSCzVaLp/nEfEUXFAdHqtAvAJL4/P9v9DZ0kvbJGmx4Ikw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=q1ukNcPM;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8A5606A336;
	Mon, 23 Nov 2026 10:53:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB8A5606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=q1ukNcPM
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431219; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=5Y6RrQPl3+RDc3EwpamkVIy6Oyhib7bCsIXwFSNt6so=;
	b=q1ukNcPM0OGKSwWlwH5UW4Xk3ouZM92X7BES6rZIb5sHGZPqZ/mVND6ADBSmZ0xEEZnGOcG6rmUIQWKwvYhxCVv6x0SnDWve+1YFEV9MEMnl4AXybtJaAWcYS6C1KCrOI4Dkf94Bk6MHYnKXvaPEGDvJgVawdn8OG5nFu3ulGUA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJgze_1795431215;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJgze_1795431215 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:37 +0800
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
Subject: [PATCH v5 0/4] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Mon, 23 Nov 2026 18:53:30 +0800
Message-ID: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
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

With cgroup.memory=nokmem, the THP deferred split shrinker and the
zswap shrinker lose their memcg awareness because neither sets
SHRINKER_NONSLAB. When a cgroup hits its memory limit, these shrinkers
do not split its partially unmapped THPs or write back its zswap
entries.

Under nokmem, __list_lru_init() also disables per-memcg lists. Setting
SHRINKER_NONSLAB alone would leave all memcgs sharing one list per node
for each shrinker. Adding the first object to an empty list sets the
shrinker bit for its memcg. A second memcg can add objects without
setting its own bit, so reclaim in that memcg may skip the shrinker.
A scan for the first memcg can then reach objects belonging to both.

Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
list_lru"), THP had fully per-memcg deferred split queues embedded
in struct mem_cgroup, working independently of kmem accounting.
nokmem only opts out of kernel slab accounting; THPs and zswapped
pages are user memory and remain charged to their cgroups, so
per-memcg reclaim is still what these shrinkers want.

Patch 1 drops kmemcg_id and indexes non-root lists by the memory CSS
ID. The root memcg keeps index zero and uses the per-node list
directly. The lists are reparented when their memcg goes offline,
including under nokmem.

Patch 2 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patch 3 restores SHRINKER_NONSLAB on the THP deferred split shrinker.

Patch 4 sets the same flag on the zswap shrinker.

Slab-backed lrus (e.g. the superblock dentry/inode lrus) still fall
back to per-node lists under nokmem. The per-memcg lists for the two
shrinkers are allocated on demand.

With nokmem enabled, the test_memcontrol and test_zswap kselftests
showed no new failures compared with the unpatched kernel. When one of
two sibling cgroups exceeded memory.high, the patched kernel split THPs
and wrote back zswap entries only in that cgroup.

Changes in v5:
 - Rebase on mm-unstable (7d1a16abe4cc) as discussed with Andrew [7].
 - Fold v4 patches 1 and 2 [6] into patch 1. Use the memory CSS ID so
   that two generations of the memory controller on the same cgroup
   have distinct indices while both are alive.
 - Keep the memcg argument to the internal walk for the owner check
   on restart. Hold RCU from the XArray lookup until the walker takes
   a reference to an online CSS.

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
 - Patches 3-4 are unchanged from v1 [1] apart from review tags.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
[3] https://lore.kernel.org/lkml/20260910080722.3961351-1-qinyuntan@linux.alibaba.com/
[4] https://lore.kernel.org/lkml/arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F/
[5] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/
[6] https://lore.kernel.org/lkml/20261013031221.1997194-1-qinyuntan@linux.alibaba.com/
[7] https://lore.kernel.org/lkml/20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org/

Qinyun Tan (4):
  mm: list_lru: index per-memcg lists by memory CSS ID
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h | 16 -------------
 mm/huge_memory.c           |  3 ++-
 mm/list_lru.c              | 49 +++++++++++++++++++++++++-------------
 mm/memcontrol.c            | 45 +++++++---------------------------
 mm/zswap.c                 |  4 ++--
 5 files changed, 45 insertions(+), 72 deletions(-)

-- 
2.55.0

