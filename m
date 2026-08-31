Received: from mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3921C3D25AD
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 09:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169597; cv=none; b=G9iWwy/1JNbdBm49OugLllix/g/iZtEfHMBcgz8OhLZ4cfayeEZn4hBMvygV/jBVlzI9aJ8LJdd+W4cXGHxGjPhFAZXwcHDERIbrv2UrDr6X8FrnqBD+YWN9jkhO2djJBKOOeuipDSZDJ7ZjACOl+BQeRG1Pd1dZUjUzyAa/ayM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169597; c=relaxed/simple;
	bh=AF4DD4VVRvODeKZk9FQinottqHGc5UMNhNCLJuS+ivE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nDRA669dPfYagMQOKJys2412pmPKEab6gCaMhJdl17WqpaSegFZsevPnCNGeWYOPs0S1PxWL+NGUzzZWAgvfaxt9mKBQHv65WzT9Z5Olo8bRAqh9Ukq6X3ID8kBxCqAlj9wzdNRfaiW2vWSZcALiT90d7RA05n71N6VFleekAs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LVprdE3U; arc=none smtp.client-ip=95.215.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LVprdE3U"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AF4DD4VVRvODeKZk9FQinottqHGc5UMNhNCLJuS+ivE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788169592; v=1; x=1788774392;
 b=LVprdE3Ub8HO29yourlyTGlfgZbpOFAnHCkNfh7v77RZgWe+bRfXJGw8ujZhmy9rzG5HAduv
 4w1CWWR5yqy55Sqny5U3xmGEUxhKeY+NusZ3F73Tr7P3FHamp3KNBxfEEFr8lRa0OqMs+2BQOom
 3EhfzPJjhDd7GRJM71l4B7so=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 22025baba8b5f51b;
	Mon, 31 Aug 2026 09:46:32 +0000
X-Mizu-Trace-ID: 22025baba8b5f51b
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
Subject: [PATCH v2 0/3] mm: workingset: fix the shadow node budget under MGLRU
Date: Mon, 31 Aug 2026 17:46:08 +0800
Message-ID: <cover.1788169145.git.zhuhui@kylinos.cn>
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

Patch 1 switches count_shadow_nodes() back to lruvec_page_state_local(),
which both classic LRU and MGLRU maintain.

Patch 2 addresses the reparenting race that motivated 7404bd37cfbe:
patch 1 makes cgroup v2 read state_local as well, so extend the
dying-memcg stat redirection (previously cgroup v1 only) to all
hierarchies.

Patch 3 recovers the performance.  Patch 2 added an unconditional
rcu_read_lock() to the stat update fast path; patch 3 moves the dying
check out of the RCU read-side critical section so the lock is only
taken on the rare dying path.

Performance testing
===================

The test script and the raw results are available at [1].

Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
configuration, medians reported.  Workloads:

  w1-anon-churn: single-threaded anon fault/charge loop in a memcg
                 (MADV_DONTNEED + re-fault, no reclaim).  Every touch
                 is a real fault with charge and memcg stat updates,
                 so it stresses exactly the fast path patch 2 changes.
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

Patch 2 alone shows a small overhead, most visible under MGLRU (-0.6%
on w1); patch 3 brings w1 back to the base level in both LRU
configurations.  The remaining differences are within run-to-run
noise.

[1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Hui Zhu (3):
  mm: workingset: use lruvec_page_state_local() to count lru pages
  mm: memcg: redirect stats updates of dying memcgs for all hierarchies
  mm: memcg: skip the RCU lock when the memcg is not dying

 mm/memcontrol.c | 30 ++++++++++++------------------
 mm/workingset.c |  5 ++---
 2 files changed, 14 insertions(+), 21 deletions(-)

-- 
2.53.0

