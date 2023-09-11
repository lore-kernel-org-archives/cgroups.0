From: Nhat Pham <nphamcs@gmail.com>
Subject: [PATCH 0/2] workload-specific and memory pressure-driven zswap writeback
Date: Mon, 11 Sep 2023 09:40:22 -0700
Message-ID: <20230911164024.2541401-1-nphamcs@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694450425; x=1695055225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7dUHQDB4Hx3nVk2JA0BFztp/V0stKrR8xG6ZBM2hfeU=;
        b=HIsBfoT5AAzUOsamF3QtCn7eQcOVUxpYT8pHhzwO0dFI5q2ib5/NxTlZtokp+6eVNq
         +trZbvBHFvVBcDZS37J5bCL/m8rSFoOseCsVUQYlAxWHgd7KJMcJbAXh/RoNf4sziHsG
         n0TV7jCTgXsJO01VjQXF5l2d53TmBieQYj5QgDm9kDUx5NkY2EG+03VY46ZewKrGESx7
         9HOGpDu3b6ZpSYZyfqp53JXS0DmVvawByeZWwvFbcPWrnQGHhELxCL2TYddS8q6JIhTB
         rt522JFTpf0H8U/uwx8A4aUFDDy3Us0QaCwsnBvsH6sSe5vd5WP39tBshCBnpG3LjPrg
         OfoQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, cerasuolodomenico@gmail.com, yosryahmed@google.com, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

There are currently several issues with zswap writeback:

1. There is only a single global LRU for zswap. This makes it impossible
   to perform worload-specific shrinking - an memcg under memory
   pressure cannot determine which pages in the pool it owns, and often
   ends up writing pages from other memcgs. This issue has been
   previously observed in practice and mitigated by simply disabling
   memcg-initiated shrinking:

   https://lore.kernel.org/all/20230530232435.3097106-1-nphamcs@gmail.com/T/#u

  But this solution leaves a lot to be desired, as we still do not have an
  avenue for an memcg to free up its own memory locked up in zswap.

2. We only shrink the zswap pool when the user-defined limit is hit.
   This means that if we set the limit too high, cold data that are
   unlikely to be used again will reside in the pool, wasting precious
   memory. It is hard to predict how much zswap space will be needed
   ahead of time, as this depends on the workload (specifically, on
   factors such as memory access patterns and compressibility of the
   memory pages).

This patch series solves these issues by separating the global zswap
LRU into per-memcg and per-NUMA LRUs, and performs workload-specific
(i.e memcg- and NUMA-aware) zswap writeback under memory pressure. The
new shrinker does not have any parameter that must be tuned by the
user, and can be opted in or out on a per-memcg basis.

On a benchmark that we have run:

(without the shrinker)
real -- mean: 153.27s, median: 153.199s
sys -- mean: 541.652s, median: 541.903s
user -- mean: 4384.9673999999995s, median: 4385.471s

(with the shrinker)
real -- mean: 151.4956s, median: 151.456s
sys -- mean: 461.14639999999997s, median: 465.656s
user -- mean: 4384.7118s, median: 4384.675s

We observed a 14-15% reduction in kernel CPU time, which translated to
over 1% reduction in real time.

On another benchmark, where there was a lot more cold memory residing in
zswap, we observed even more pronounced gains:

(without the shrinker)
real -- mean: 157.52519999999998s, median: 157.281s
sys -- mean: 769.3082s, median: 780.545s
user -- mean: 4378.1622s, median: 4378.286s

(with the shrinker)
real -- mean: 152.9608s, median: 152.845s
sys -- mean: 517.4446s, median: 506.749s
user -- mean: 4387.694s, median: 4387.935s

Here, we saw around 32-35% reduction in kernel CPU time, which
translated to 2.8% reduction in real time. These results confirm our
hypothesis that the shrinker is more helpful the more cold memory we
have.

Domenico Cerasuolo (1):
  zswap: make shrinking memcg-aware

Nhat Pham (1):
  zswap: shrinks zswap pool based on memory pressure

 Documentation/admin-guide/mm/zswap.rst |  12 +
 include/linux/list_lru.h               |  39 +++
 include/linux/memcontrol.h             |   1 +
 include/linux/mmzone.h                 |  14 +
 include/linux/zswap.h                  |   9 +
 mm/list_lru.c                          |  46 ++-
 mm/memcontrol.c                        |  33 +++
 mm/swap_state.c                        |  50 +++-
 mm/zswap.c                             | 369 ++++++++++++++++++++++---
 9 files changed, 518 insertions(+), 55 deletions(-)

-- 
2.34.1
