Received: from mta0.migadu.com (out-135.mta0.migadu.com [91.218.175.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5181838C2B8
	for <cgroups@vger.kernel.org>; Fri, 11 Sep 2026 08:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113678; cv=none; b=SQXd79OQIy1odQsIDklRhfeFa3yGsRBLLOfqK4KWLWja2Qsd0c3/HQqz5ok2GSpn6W0KDCTzl4uHhZO35ei5IfylOKd7xkB30ExD3xMLvJGz8hcqrXB+lZncPaQjpv5Y0FHUo4rLL1OH81nXdyxtNbr6UeGFX9VDYoRHPy862gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113678; c=relaxed/simple;
	bh=OKkfFQ/5u1ZQ06ulHO9rwS0KYJDTzNO4EMxRVAB2baU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=phUv3tGBmFLGDATQlBuXND6dL1Ic836Aw/A9H1B3gOQLg47vcr/ZHDjJB4rqmFOPPip3WPZHqhSY7dVRJ8Xe+3aBxrWEm07N2UKHm9Y7god0FIMYh/thuAuXilw+fCC7v7pc31K7g2p/XEPek/BGUwL8muYs4VLv95HE+LxzUoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dHNE8/Cn; arc=none smtp.client-ip=91.218.175.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dHNE8/Cn"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OKkfFQ/5u1ZQ06ulHO9rwS0KYJDTzNO4EMxRVAB2baU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113672; v=1; x=1789718472;
 b=dHNE8/Cny96RhIuRk/dZscC6RK6INg30/jQLti7Lei1AJuy3BkbEVjfLE+F5Gw/I2SWdpQhq
 D4UAFvpHdAy3eIi9Cjq4HkZUL/uR+B38NyhGzoTkzUscVomIsRZUSK7CSdcE5Lp3LY1buxd5D6w
 SUEORgoSuF2ywt4EskN09jm4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id bcd983cb8d37cc8f;
	Fri, 11 Sep 2026 08:01:12 +0000
X-Mizu-Trace-ID: bcd983cb8d37cc8f
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
Subject: [PATCH v5 0/4] mm: workingset: fix the shadow node budget under MGLRU
Date: Fri, 11 Sep 2026 16:00:47 +0800
Message-ID: <cover.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
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

Patch 4 closes an accounting gap that patch 2 makes visible: on cgroup
v2, reparent_state_local() never moves the dying memcg's
non-hierarchical lruvec stats to the parent, so the parent receives
the uncharges without the matching charges and its state_local
underflows.  Patch 4 reparents those stats, mirroring cgroup v1.

Performance testing
===================

The test script and the raw results are available at [1].

Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
configuration, medians reported.  Workloads:

  w1-anon-churn: single-threaded anon fault/charge loop in a memcg
                 (MADV_DONTNEED + re-fault, no reclaim).  Every touch
                 is a real fault with charge and memcg stat updates,
                 so it stresses exactly the fast path patch 1 changes.
                 This is the meaningful signal: it is not reclaim-bound,
                 so the small fast-path overhead is not drowned out.
  w2-file-churn: file read loop under memory.high pressure
                 (reclaim-bound; the differences below are within
                 run-to-run noise and are shown for completeness only).
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
configurations.  The w2-file-churn differences are within run-to-run
noise: that workload is reclaim-bound and too noisy to expose the small
fast-path overhead, so w1-anon-churn is the meaningful signal.  Patch 4
only touches the memcg offline path and is not exercised by these
workloads.

[1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Changelog:
v5:
According to the comments of Andrew, clarify the performance testing
section: the w2-file-churn differences are within run-to-run noise;
w1-anon-churn is the meaningful signal.
v4:
According to the comments of Andrew, Fix "follow-up patch" to
"preceding patch" in the commit message to match the reordered series.
According to the comments of Sashiko, add patch 4 to reparent the
non-hierarchical lruvec stats on cgroup v2 to fixing the state_local
underflow.
v3:
According to the comments of Shakeel, reorder the series per review,
add Fixes/Cc stable and the user-visible impact to patch 1.

Hui Zhu (4):
  mm: memcg: redirect stats updates of dying memcgs for all hierarchies
  mm: workingset: use lruvec_page_state_local() to count lru pages
  mm: memcg: skip the RCU lock when the memcg is not dying
  mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2

 mm/memcontrol-v1.h |  5 ++--
 mm/memcontrol.c    | 72 +++++++++++++++++++++++++---------------------
 mm/workingset.c    |  5 ++--
 3 files changed, 45 insertions(+), 37 deletions(-)

-- 
2.43.0

