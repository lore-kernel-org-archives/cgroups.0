Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16504443E47
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 09:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515177; cv=none; b=Vgh5VEsGO8ccS/dsHbbNEEvLIcxurjst0FOXmzQCaUbjMN2kQVX1DRO7CT1Iew1CDo5DRbHhj6dLJ6VMaYR1F/HWiwa119MkJAvcj4VNZU6cb0AhJW9xqAkaZwPN02uhawIRk+oIh4DcqGtMDNGIA5RqoWSYt4ql3yLLxJGEOuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515177; c=relaxed/simple;
	bh=l/Ow3opJmMzhmqvzKXqorsr7GYrL7d+S+qdRXbzW95c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qrq5JqQGrau6xjecGAI474r8NWb4wcqN6T9MY96q+GMPBXAzOvLYhIbq7BwvV+gXRHOv1rQxmcWQ8uGiw01n10xcQDTw5I6a4cbE0alwmjS5cDYsHwT5iG65OyCMZl6/68WdHtjjo0atAtvxDLd0DIMn6/AAsdrA8h9sOUqDnrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a58wWKwg; arc=none smtp.client-ip=91.218.175.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a58wWKwg"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=l/Ow3opJmMzhmqvzKXqorsr7GYrL7d+S+qdRXbzW95c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788515172; v=1; x=1789119972;
 b=a58wWKwg8mGKUOXAGK3r67R8fcGl4gcyLW2rQhTxK7/SpiR9YtaInuDp8V6rpE+m/wKz+b19
 eaOWj3nsFVHJ+GyeB39dt18FJcyJJwCKDO66vuiK2xw3uAYuZPS9GOncohcIeeI0VgM699HJdsZ
 J+PwbVqiKrLRWL7sN0QjgFqo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5d1dfc6f5b4389c6;
	Fri, 04 Sep 2026 09:46:12 +0000
X-Mizu-Trace-ID: 5d1dfc6f5b4389c6
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v3 0/3] mm: workingset: fix the shadow node budget under MGLRU
Date: Fri,  4 Sep 2026 17:45:53 +0800
Message-ID: <cover.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hui Zhu <zhuhui@kylinos.cn>

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") broke the workingset shadow node budget under
MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
maintains, so count_shadow_nodes() sees the evictable LRU lists as
empty and the shadow shrinker reclaims eviction tokens almost as fast
as they are created, losing thrashing protection.

Patch 1 extends the dying-mcg stat redirection (previously cgroup v1
only) to all hierarchies, addressing the reparenting race that motivated
7404bd37cfbe.

Patch 2 then switches count_shadow_nodes() back to
lruvec_page_state_local(), which both classic LRU and MGLRU maintain.

Patch 3 recovers the performance.  Patch 1 added an unconditional
rcu_read_lock() to the stat update fast path; patch 3 checks
memcg_is_dying() first and takes the RCU lock only on the rare dying
path.

Changes since v2:
 - Reorder the series: the dying-memcg redirection now comes first and
   the switch back to lruvec_page_state_local() follows it, as
   requested.
 - Patch 1: add the Fixes and Cc stable tags and describe the
   user-visible impact of the bug, as requested.
 - Collect Shakeel's Acked-by.

Performance testing
===================

The test script and the raw results are available at [1].

Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
configuration, medians reported.  Workloads:

  w1-anon-churn: single-threaded anon fault/charge loop in a memcg
                 (MADV_DONTNEED + re-fault, no reclaim).  Every touch
                 is a real fault with charge and memcg stat updates,
                 so it stresses exactly the fast path patch 1 changes.
  w2-file-churn: file read loop under memory.high pressure
                 (reclaim-bound, noisier).
  w3-reparent:   reparent accounting sanity check.

w1-anon-churn (pages/s):

                 classic LRU          MGLRU
base             4393028              4377122
patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)

w2-file-churn (MB/s):

                 classic LRU          MGLRU
base             8277                 8226
patches 1-2      8226      (-0.6%)    8123      (-1.3%)
patches 1-3      8157      (-1.4%)    8294      (+0.8%)

w3-reparent passed on all kernels.

The small overhead visible with patches 1-2 comes from the redirection
added by patch 1; patch 3 brings w1 back to the base level in both LRU
configurations.  The remaining differences are within run-to-run noise.

[1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Changelog:
v3:
According to the comments of Shakeel, reorder the series per review,
add Fixes/Cc stable and the user-visible impact to patch 1.

Hui Zhu (3):
  mm: memcg: redirect stats updates of dying memcgs for all hierarchies
  mm: workingset: use lruvec_page_state_local() to count lru pages
  mm: memcg: skip the RCU lock when the memcg is not dying

 mm/memcontrol.c | 30 ++++++++++++------------------
 mm/workingset.c |  5 ++---
 2 files changed, 14 insertions(+), 21 deletions(-)

-- 
2.53.0

