Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8922F4ACC98
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 17:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788371016; cv=none; b=fk4iWPbiiu7GpQJSgdjyFpLwPnDYkXt8moZdpPmVOHx2Q008hTE0ttuazIvIGEJw2hUAulDiKP61/vpO8bZgl0Do1qL7R+gpYK92kXOs20c/kxCQvcY0m2FH/0ZrcxPGGn6nXj5VDmvqW0X0h9+yag1zYkNlsO3ntnIAkdRDIhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788371016; c=relaxed/simple;
	bh=dbMEz1JHYuKrPhG1IXsUKT9HXwJuTLvgviFN/ZwRb6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PfYxIv//7ko02/Dro24Z86iQBvvArOGwl4XhJHNLTTNh0yI0ere9jbaZzgOh1SFs0ZJTvMErTOPgMeqhWaNBjt4TG8OTiY932rZusbHNkGKYMwKWHnZxoA/pnLZCZYrbT9JbfNCSn2XMtGbhryhQzgXc6p1ZBb1HPnaxgytUezg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qGWHhZGb; arc=none smtp.client-ip=95.215.58.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qGWHhZGb"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dbMEz1JHYuKrPhG1IXsUKT9HXwJuTLvgviFN/ZwRb6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371012; v=1; x=1788975812;
 b=qGWHhZGbo2LzF3DO9kknlbs2X7qXCisREyuW9CQd7bP8d3CaOC4JILczONwcc8cfmEUdOubm
 lU5cKr90f5wQMLnBnpPnFPe8oFECbh1PO0qMWgpIMAmhBC/VwDGXD30J/XGwYaxEwaMlwkABzTN
 sPNY0OCSpEuAXfEMY+LgfGfc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 65786b149d393ad8;
	Wed, 02 Sep 2026 17:43:22 +0000
X-Mizu-Trace-ID: 65786b149d393ad8
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] memcg: remove the v1 soft limit
Date: Wed,  2 Sep 2026 10:43:03 -0700
Message-ID: <20260902174311.1772372-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The v1 soft limit was deprecated in v6.12 by commit 569c4f62d84a ("memcg:
initiate deprecation of v1 soft limit") and nobody has reported depending
on it in the ~21 months since. memory.low and memory.min in v2 have
covered the same ground for far longer.

The knob has since been made inert by "memcg: make the v1 soft limit knob
inert", already queued in mm-hotfixes as a backportable fix for a syzbot
report [1]. Nothing can enter the soft limit rbtree anymore, so this
series just deletes the machinery that is now dead: the reclaim pass in
kswapd and direct reclaim, mem_cgroup_shrink_node() and its tracepoints,
the per-node rbtree, lru_gen_soft_reclaim() and the MEMCG_LRU_HEAD op, the
per-node tree fields, mem_cgroup->soft_limit, and finally the v1 event
ratelimiting which is now down to a single target.

memory.soft_limit_in_bytes itself is untouched: writes stay ignored and
reads keep returning the maximum value.

Changes since v1 [2]:
- Dropped "memcg: make the v1 soft limit knob inert" (1/9 in v1), which is
  already queued in mm-hotfixes, making this an 8-patch series.
- Collected the acks and review tags. No code changes.

Sashiko's v1 review [3] asked whether the softlimit tracepoints,
lru_gen_soft_reclaim(), the per-node tree fields and the
MEM_CGROUP_TARGET_SOFTLIMIT ratelimiting could go too. They all can and
they all do, in patches 3/8, 5/8, 6/8 and 8/8 of this same series.

[1] https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
[2] https://lore.kernel.org/all/20260811203203.3456029-1-shakeel.butt@linux.dev/
[3] https://sashiko.dev/#/patchset/20260811203203.3456029-1-shakeel.butt@linux.dev

Shakeel Butt (8):
  memcg: remove v1 soft limit reclaim
  memcg: remove mem_cgroup_shrink_node()
  memcg: remove the soft limit reclaim tracepoints
  memcg: remove the soft limit rbtree
  memcg: remove lru_gen_soft_reclaim()
  memcg: remove the per-node soft limit tree fields
  memcg: remove mem_cgroup->soft_limit
  memcg: simplify v1 event ratelimiting

 include/linux/memcontrol.h    |  27 ---
 include/linux/mmzone.h        |  30 +--
 include/trace/events/vmscan.h |  14 --
 mm/internal.h                 |   4 -
 mm/memcontrol-v1.c            | 392 ++--------------------------------
 mm/memcontrol-v1.h            |  12 +-
 mm/memcontrol.c               |   7 +-
 mm/vmscan.c                   |  96 +--------
 8 files changed, 34 insertions(+), 548 deletions(-)

-- 
2.53.0-Meta

