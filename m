Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1C84B0499
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134064; cv=none; b=s31DaotmtHG7Y60mc1nsLOOcnNZbrnrieNZHmOe5ML3p8NJauc1aLy40OTSMacWFH/3sr8x6Rhv1ltdxaIbh4AforxcoF5G8ijXM6GVXbygt2ksNqJjNGvhFep02Ks8O6q4w/ZKFZjDaUmvUyj6AjYTgc9fq/Kp5B9W4qAuL4WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134064; c=relaxed/simple;
	bh=8i0hsx0TSbLR3kbsNtK4vWzlrLSN3t46a2fxMsKiud0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DV+FF4MaukYeAj2knbeQA5/UrX+YK8qHs4WQex0t3i1iRWOWeiS9JovhhO3aWumLJBvrWlcyaUz3/RlG3qFhE+CHNv/IZT3VIlEN+WXbHk4Gphcp3MOMlpmrbZjQ/W9AwrNWrz+fBn5z+nD7yLGGxnh8Nld+f5YfAoj2O5odatE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+rvQC8B; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+rvQC8B"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-448b69cfc6dso3573400fac.3
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134060; x=1786738860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OG7Zox/EULKY3yZgjkLir0Fh0uNyC4YIaQWO7jxGtO8=;
        b=W+rvQC8BTGyd7H7d//gfWVcjGaWx7rSfioXgh3YHj6vXf0m7e2Ll/zb69zSelWvgSD
         8D8pSg64bu0MoMG2LiqM0VRlfXwQ7v1hS4pPX6P251bCGnfd9+D6f0WBm05/usMzRvtE
         gPVg5NlTqMXkhlszpZJnDuMPMWgT8GOjpGu9tPTugQfD/SyCDqbWWB24ZOHCiTlZgV+z
         raEUyzXvDFj3YFiSfYFD2kBOBNL7rCTnQomLukd+ss4xdn7+MfwPWLgyvKZdl/yoZz3g
         rtbC3VJ0ecg3CaNDe32J/exIA/d46wc4REckWlKPi6U+1Cr3hWzf9bpbxJgZuOyrM276
         QrXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134060; x=1786738860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OG7Zox/EULKY3yZgjkLir0Fh0uNyC4YIaQWO7jxGtO8=;
        b=Mwl54PVzNVevQ/9hLtq/xzqV1PV86ZOQPBxbxavrikeNCdbwxk7d/cPHr9UDmravYB
         oGsZezqOUbbRZNkqO7h2/eO3avX2mHCSee4gY7NfleWE0n93cKjao3+RLDYYjhyGvDLk
         EM2dcF39s/w+scE4cRzv203ln8B+xXohXeWio4RwnbX9xRap3XGszwnoodYbIBWVDHJM
         AJ1+KJlTWm9azbkiROCdcGFF0DPEuiKil1UxMaD42xSftVNo0ayNp2XmwA4b4uazDESQ
         I4xj+bA07iswp67DJme+iIT3xG4wN3PEtNxaQU4bZdzG1zqtoHFy7bZk531jaq/JeXU3
         jKTg==
X-Forwarded-Encrypted: i=1; AHgh+Rocq+7XthREt86zGu6f3uShDeKE/zhTrAKgVbgsT2+GDi7/cMwym/yUNqudE8aizeG09Mkl+Ry5@vger.kernel.org
X-Gm-Message-State: AOJu0YxNvMhodokSLgh2BU+q29lIRKQIptfhjw/pecFnX1OreY+vb1ZU
	T9NBS0FT8JsNol0o5uoM+SIQtt46VKYuNwUrtHt2yiS7UlKqWooJ4HHK
X-Gm-Gg: AR+sD10GtkRJDGS7I7tJ0v8jODvnegpabeQu5QgDjHRoSOEs3269LJgfhg9aq+50RCR
	kqLANYf6T9WouOapXnO7LxSBlmzWeZV4kqg07Ma7BTNy/dECuKAD5jIwMnmcFBgJHyQnh0CxO2h
	lJ5vNBXbebNKC+KPy+VekLGf+yIkfvwAPiv/5bABPy2wfJSWW/7oLMyOFd9riDC7H7iM/Vs2dEL
	D0muXKRTqr1DvN0Q1Hfh9O0l4luuOQR0abD+eCJw7CM50JyVjjtkw6GGkHXx0aFTtv18tTTPeBJ
	2FYjGhqMGAghNWVzcPdkBtRI3XlxyqllXEElxlKOHZr8Wi4T7u7LzdYvPscFv10al5oqaeItzUf
	YhDD2lzUoRI1yw+gmED8xFBzQXiqDMRk9IZP/SLmALFnPrXPQOaMZYa0kKs64SLvLPDqGKklNZ1
	aTRLrdlMLDieAjU5KYkFIDy0peUrf2zyZAIeMH62vQ8V1Yu5l19h9vCLRHzJK3TSSCBXxOjxukN
	Hdb3BWZzo4BExwQPA==
X-Received: by 2002:a05:6820:8cc:b0:6aa:d97f:4564 with SMTP id 006d021491bc7-6b042151708mr1639179eaf.28.1786134060230;
        Fri, 07 Aug 2026 13:21:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:d::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1d793c9sm2788490fac.9.2026.08.07.13.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:20:59 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 00/14] Introduce tiered memcg limits
Date: Fri,  7 Aug 2026 13:20:43 -0700
Message-ID: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

INTRODUCTION
============
On machines serving multiple workloads whose memory is isolated with the
memory cgroup controller, it is currently impossible to enforce a fair
distribution of memory placement. memory.{max, high} bounds a cgroup's
total footprint but says nothing about where that memory resides, so a
cgroup that starts first can occupy all of a fast tier, while latecomers
are pushed out to slower tiers.

On systems with tiered memory (e.g. HBM, DRAM, CXL, PMEM, etc.),
memory placement directly maps to performance, meaning memory and
performance isolation breaks down on tiered systems; well-behaved
workloads using less memory than their memcg limits may still hurt other
workloads' performance by hogging more than their "fair share" of memory
on fast tiers. Performance then depends on workload-external factors,
like which other workloads are present on the system and what order they
were launched in.

However, ensuring fairness in memory placement is not free; ensuring
fair memory placement can mean underutilizing fast tiers, entering
reclaim earlier to proactively prevent overconsuming on fast tiers,
and host-level hotness inversion. On lightly-loaded systems, it means
that reclaim happens on fast tiers, even if no other workloads compete
for that memory. For some workloads, this tradeoff can be worth taking
to ensure higher run-to-run consistency and isolation from
noisy neighbors (see USECASES).

Introduce tiered memcg limits, which establish memory limits per-tier
that scale with memcg limits and the system's per-tier capacity.

MECHANISM
=========
memory.{min, low, high, max} are partitioned across the system's memory
tiers in proportion to the tiers' share of the total memory.
For instance, on a two-tier system with 75% of its memory in tier 0:
  - a cgroup with memory.max = 100G has a 75G tier 0 max limit
  - a cgroup with memory.low = 40G has 30G of tier 0 protection

Enforcement limits (high / max) are enforced in five ways:
  - At allocation time, a cgroup's allocation will try to serve a page
    from a tier where it still has headroom.
  - At try_charge_memcg time, a folio that lands on an exhausted tier
    anyways (because of __GFP_THISNODE, mempolicy, or memory pressure)
    triggers targeted reclaim restricted to that tier's nodes.
  - In the background, a tier pushed over its tiered memcg limit by page
    migration or folio replacement gets reclaimed by the memory.high
    worker.
  - Migration (promotion / demotion) now performs a try_charge on
    cross-tier migrations, and will attempt to reclaim the destination
    tier if it breaches the limits.
  - In addition, promotions are ratelimited when they are attempted on
    exhausted memcg tiers.

A few details about the enforcement:
  - Allocation time steering is best-effort and yields to explicit
    allocation requests, like mempolicy, cpusets, and allocations that
    request a specific node (promotion / demotion). If that allocation
    were to push the memcg tier over its limit, enforcement happens at
    charge time.
  - Tier max can be exceeded by demotions, which may force charge
    since they can't (and should not) trigger recursive reclaim.
  - As of this time, the mechanism is completely transparent to the
    user. Booting the system with the "cgroup.memory=tiered_limits"
    boot parameter will enable the feature, with no other interfaces.
  - There are no behavioral or performance effects on systems without
    the boot parameter, since all of the hooks are gated behind a static
    branch that compiles to a no-op. However, there are allocations and
    static variables that we must define unconditionally
    (even though they are not used).
  - Tiered memcg limits are a v2-only feature. A warning is emitted if a
    cgroup v1 user attempts to use tiered memcg limits.

USECASES
========
As mentioned in the introduction, some users may prefer to trade off
total throughput for reduced run-to-run variance:
  - VM hosting services that must provide the maximal performance
    guarantee for any workload present on a host.
  - Database workloads that want to minimize the maximum latency for
    queries hosted on the host.
  - Hosts running memory-isolated sharded workloads that block progress
    until the last shard terminates.
  - Any workload that wants to minimize variance, as a means to gather
    measurable gains in performance over time.

RFC QUESTIONS
=============
  - Should we OOM when we fail to allocate on a given tier?
  - What kinds of observability (if any) do we want?
  - What kinds of user interfaces (if any) do we want?

TESTING
=======
All the tests were run on a 1TB 2-tier 316 CPU machine, with
750G DRAM and 250G CXL. The first benchmark runs 12 containers on the
host, where each container runs an identical pointer-chasing task in a
loop. Each container is 80GB, so DRAM is overcommitted:
    (80GB * 12 = 960GB > 750GB)
I ran 8 trials and aggregated the data. When 50% of the pointers
are kept hot, these are the results:

Mean DRAM usage across the 12 workloads:
+---------+----------+--------+
|         | Untiered | Tiered |
+---------+----------+--------+
| min     | 43.09    | 51.25  |
| max     | 68.54    | 53.03  |
| max/min | 1.59x    | 1.03x  |
+---------+----------+--------+

Mean CXL usage across the 12 workloads:
+---------+----------+--------+
|         | Untiered | Tiered |
+---------+----------+--------+
| min     | 3.05     | 13.98  |
| max     | 21.65    | 14.87  |
| max/min | 7.10x    | 1.06x  |
+---------+----------+--------+

For the tiered system, the deviance from max to min DRAM and CXL usage
is quite low across workloads. What is interesting is that for untiered
systems, there is up to a 7x difference between the cgroup using the
most CXL and the least CXL; there's a clear inequality in how the
resource gets allocated.

This gets reflected in the distribution of the job completion times of
the 12 workloads as well.

Job completion time (s)
+-----------+----------+--------+-------+
|           | Untiered | Tiered | Delta |
+-----------+----------+--------+-------+
| min       |    260.1 |  276.5 | +6.3% |
| mean      |    274.4 |  290.0 | +5.7% |
| max       |    315.0 |  302.6 | -3.9% |
| max - min |     54.9 |   26.1 | -52%  |
+-----------+----------+--------+-------+

SERIES OVERVIEW
===============
Commits 1-3 are preparatory patches. We introduce the new boot
parameter, refactor try_charge_memcg() to make the following charges
easier to follow, and cache frequently-used values like the
node <-> tier mapping.

Commits 4-5 allocate the new per-memcg-tier page_counters for tracking
and set their limits according to the standard memcg limits.

Commits 6-10 track per-tier charges, and introduce the protection and
enforcement mechanisms for min/low/high/max. 

Commits 11-13 further enforce the migration (promotion / demotion) paths
and ensure that we do not introduce unnecessary churn by reclaiming
earlier. 

Commit 14 steers allocations so that we do not accidentally introduce
zone_reclaim_mode-like behavior and immediately reclaim after allocating
on exhausted memcg tiers.

FUTURE WORK
===========
I am currently working on another series [1], which pushes the memcg
cached charges (stock) to the page_counter level, meaning each tier can
manage its own independent stock. This should increase the performance
and simplicity of the code much more.

CHANGELOG
=========
v2 --> v3
- N tier support, instead of toptier vs. rest enforcement
- Max enforcement
- Migration enforcement
- Page allocator steering for exhausted tiers
- Promotion fastpath restriction & throttling

[1] https://lore.kernel.org/all/20260623180124.868655-1-joshua.hahnjy@gmail.com/

Joshua Hahn (14):
  mm/memcontrol: Introduce cgroup.memory=tiered_limits boot parameter
  mm/memcontrol: Refactor page_counter charging in try_charge_memcg
  mm/memory-tiers: Introduce a mapping from nid to tier_slot
  mm/memcontrol: Allocate per-tier page_counters
  mm/memcontrol: Set tier limits proportional to memory limits
  mm/vmscan, memcontrol: Add nodemask to try_to_free_mem_cgroup_pages
  mm/memcontrol: Charge/uncharge tiered memory to mem_cgroup
  mm/memcontrol: Make memory.low and memory.min tier-aware
  mm/memcontrol: Make memory.high tier-aware
  mm/memcontrol: Make memory.max tier-aware
  mm/memcontrol, migrate: Transfer tier charge on migration
  mm/memcontrol: Kick async reclaim on migration and folio replacement
  mm/memcontrol, sched/numa: Gate NUMA promotions into memcg tiers
  mm/page_alloc: steer allocations away from exhausted memory tiers

 include/linux/memcontrol.h   |  75 ++++-
 include/linux/memory-tiers.h |  24 ++
 kernel/sched/fair.c          |   3 +-
 mm/internal.h                |   3 +-
 mm/memcontrol-v1.c           |   5 +-
 mm/memcontrol.c              | 528 ++++++++++++++++++++++++++++++++---
 mm/memory-tiers.c            | 110 +++++++-
 mm/migrate.c                 |  30 +-
 mm/page_alloc.c              |  19 +-
 mm/vmscan.c                  |  25 +-
 10 files changed, 753 insertions(+), 69 deletions(-)


base-commit: 7b25c83e4711038989b5b08a8977fb68468c854e
-- 
2.53.0-Meta

