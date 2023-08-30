From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v3 0/4] memcg: non-unified flushing for userspace stats
Date: Wed, 30 Aug 2023 17:53:31 +0000
Message-ID: <20230830175335.1536008-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693418018; x=1694022818; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qn85V7xkChNZBzxdpkci4eOIaMaLPSl7wYjvXs+DpjY=;
        b=vkOP3ZnFKkRZ3TacZtGaMg3vM75xZc7q+8eOc/oojVwBS7QwaUgW8JOlUfPgM9PPAB
         5dJAinETPRWHSJPR0Rb9J8uVH1lv8JYvhQmYNmJ1vmUdiUiCbMwWXs8sOTdlN64Hgxhg
         6GTyATw8L3Ocd5MEMmU6P2ti3i9622QF9I/AEOm6O6MnDN/23kfGFKcf1QP75o24hCv+
         Jj80MuQl2nq3f357Fhn+B+vrLkTu0ggtS6jFv7jnrXHXRJYdACawL+XZtexJiSa1LHTL
         /a2gJ9EZ5X3GHxrgAIiZtAuKOmZQmVy1qN/yx55pSwOlHsDzVs8+LDRyF91j9PT6FHV3
         nT1g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Most memcg flushing contexts using "unified" flushing, where only one
flusher is allowed at a time (others skip), and all flushers need to
flush the entire tree. This works well with high concurrency, which
mostly comes from in-kernel flushers (e.g. reclaim, refault, ..).

For userspace reads, unified flushing leads to non-deterministic stats
staleness and reading cost. This series clarifies and documents the
differences between unified and non-unified flushing (patches 1 & 2),
then opts userspace reads out of unified flushing (patch 3).

This patch series is a follow up on the discussion in [1]. That was a
patch that proposed that userspace reads wait for ongoing unified
flushers to complete before returning. There were concerns about the
latency that this introduces to userspace reads, especially with ongoing
reports of expensive stat reads even with unified flushing. Hence, this
series follows a different approach, by opting userspace reads out of
unified flushing completely. The cost of userspace reads are now
determinstic, and depend on the size of the subtree being read. This
should fix both the *sometimes* expensive reads (due to flushing the
entire tree) and occasional staless (due to skipping flushing).

I attempted to remove unified flushing completely, but noticed that
in-kernel flushers with high concurrency (e.g. hundreds of concurrent
reclaimers). This sort of concurrency is not expected from userspace
reads. More details about testing and some numbers in the last patch's
changelog.

v2 -> v3:
- Renamed stats_flush_ongoing to stats_unified_flush_ongoing in patch 1
  for more clarity.
- Added a mutex for flushes by userspace readers to guard the internal
  globla rstat lock from being hogged by userspace readers as suggested
  by Tejun Heo and Waiman Long.
- Fixed a bug in v2, where patch 4 also opted mem_cgroup_wb_stats() out
  of unified flushing by mistake. mem_cgroup_wb_stats() is not for
  userspace reading.

v2: https://lore.kernel.org/lkml/20230828233319.340712-1-yosryahmed@google.com/

Yosry Ahmed (4):
  mm: memcg: properly name and document unified stats flushing
  mm: memcg: add a helper for non-unified stats flushing
  mm: memcg: let non-unified root stats flushes help unified flushes
  mm: memcg: use non-unified stats flushing for userspace reads

 include/linux/memcontrol.h |   8 +--
 mm/memcontrol.c            | 106 +++++++++++++++++++++++++++----------
 mm/vmscan.c                |   2 +-
 mm/workingset.c            |   4 +-
 4 files changed, 85 insertions(+), 35 deletions(-)

-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

