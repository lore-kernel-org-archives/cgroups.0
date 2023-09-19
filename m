From: Nhat Pham <nphamcs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 0/2] workload-specific and memory pressure-driven zswap writeback
Date: Tue, 19 Sep 2023 10:14:45 -0700
Message-ID: <20230919171447.2712746-1-nphamcs@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695143688; x=1695748488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Va9ct3om+RUZ45gwrdFa1vNPGMkYE9KP43+unVd5xH8=;
        b=YbqAIZ2XvBpacIxOXb/34q1DD5JXDy4fT0RVThhCMoNJovljplytU8uG5O3ZaQiBAA
         h0rmWDCxLiBEfXugKLKppx7DzSaieb7xyeqbqJmyO2tBVc7tjlTM3jfEQhH6Pyej4v1H
         r+kfuefss6duWfUWfb8FRRYanp2S1SIHNDixeI+ALIwSsHwt3X9LzYc+WV95wXjBatHQ
         +VqiS36iF6856x8gcHxIiCJBvHN18GU85nbQfQaCmVnmHwn9qp78QzXZQkhgcbYej6Fy
         bmWtpumONRQRl+N+zAcYqTGUBr0azcnY/C3txNFZRl57PxbyRuEiTRLZ2DGnZNNHgBqS
         ORHg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cerasuolodomenico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ddstreet-EkmVulN54Sk@public.gmane.org, vitaly.wool-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-M8Ki61LpUEw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Changelog:
v2:
   * Fix loongarch compiler errors
   * Use pool stats instead of memcg stats when !CONFIG_MEMCG_KEM

There are currently several issues with zswap writeback:

1. There is only a single global LRU for zswap. This makes it impossible
   to perform worload-specific shrinking - an memcg under memory
   pressure cannot determine which pages in the pool it owns, and often
   ends up writing pages from other memcgs. This issue has been
   previously observed in practice and mitigated by simply disabling
   memcg-initiated shrinking:

   https://lore.kernel.org/all/20230530232435.3097106-1-nphamcs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/T/#u

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
 include/linux/memcontrol.h             |   6 +
 include/linux/mmzone.h                 |  14 +
 include/linux/zswap.h                  |   9 +
 mm/list_lru.c                          |  46 ++-
 mm/memcontrol.c                        |  33 ++
 mm/swap_state.c                        |  50 +++-
 mm/zswap.c                             | 397 ++++++++++++++++++++++---
 9 files changed, 548 insertions(+), 58 deletions(-)

-- 
2.34.1
