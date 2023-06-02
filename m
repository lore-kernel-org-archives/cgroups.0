From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH net-next v5 0/3] sock: Improve condition on sockmem pressure
Date: Fri,  2 Jun 2023 16:11:32 +0800
Message-ID: <20230602081135.75424-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685693510; x=1688285510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nur6fiyrastSwwCwpQExcSI9pgOK9W9Z+VV8HK2n14M=;
        b=VVYcn4qb4m4BBjjU1OqbWu9isMdf6dKAQt2DkTglCHPvT5kgJVRIAYh30oCaKj34fT
         C/2s8l3IhGKbfYwf7kXNJcabKl6BG/7QQ2hKcuBWjZcC/NBx+GpHv970DZGlf0rqirKJ
         D7n8YrNlKMnqxA1ke34M7zxmxn4C9+Qn0Z5Hc3rawR6y92QnyALiE5Yc8tkDeRFvI93a
         Yv/ppH0/JDtd+mLbEt017F6Y4eBJdF5dPvivP1GVpuI4HO/uXLzpAqUICkWCBvvM4Vsx
         /gcD8XRUNsy/QAoL/V149OOwIo2UjOQNsVuTAdbQhfCzP1ZHlfT9tMv5Qgk3yAD2Y06G
         Ap+Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Simon Horman <simon.horman-JqlR5BE4aJhWk0Htik3J/w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Currently the memcg's status is also accounted into the socket's
memory pressure to alleviate the memcg's memstall. But there are
still cases that can be improved. Please check the patches for
detailed info.

Tested on Intel Xeon(R) Platinum 8260, a dual socket machine
containing 2 NUMA nodes each of which has 24C/48T. All the benchmarks
are done inside a separate 5-level depth memcg in a clean host.
Below shows the result of tbench4 and netperf:

tbench4 Throughput (misleading but traditional)
                            baseline               patchset
Hmean     1        357.14 (   0.00%)      360.31 *   0.89%*
Hmean     2        716.66 (   0.00%)      724.57 *   1.10%*
Hmean     4       1408.82 (   0.00%)     1424.31 *   1.10%*
Hmean     8       2826.02 (   0.00%)     2832.64 *   0.23%*
Hmean     16      5413.68 (   0.00%)     5347.72 *  -1.22%*
Hmean     32      8692.74 (   0.00%)     8684.26 (  -0.10%)
Hmean     64     10180.12 (   0.00%)    10377.41 *   1.94%*
Hmean     128    22905.53 (   0.00%)    22959.73 *   0.24%*
Hmean     256    22935.78 (   0.00%)    23103.81 *   0.73%*
Hmean     384    22605.36 (   0.00%)    22747.53 *   0.63%*

netperf-udp
                                   baseline               patchset
Hmean     send-64         278.42 (   0.00%)      277.05 (  -0.49%)
Hmean     send-128        552.18 (   0.00%)      553.51 (   0.24%)
Hmean     send-256       1096.38 (   0.00%)     1095.84 (  -0.05%)
Hmean     send-1024      4102.79 (   0.00%)     4086.06 (  -0.41%)
Hmean     send-2048      7727.20 (   0.00%)     7769.95 (   0.55%)
Hmean     send-3312     11927.57 (   0.00%)    11966.36 (   0.33%)
Hmean     send-4096     14218.54 (   0.00%)    14193.51 (  -0.18%)
Hmean     send-8192     23903.60 (   0.00%)    24205.35 *   1.26%*
Hmean     send-16384    39600.11 (   0.00%)    39372.47 (  -0.57%)
Hmean     recv-64         278.42 (   0.00%)      277.05 (  -0.49%)
Hmean     recv-128        552.18 (   0.00%)      553.51 (   0.24%)
Hmean     recv-256       1096.38 (   0.00%)     1095.84 (  -0.05%)
Hmean     recv-1024      4102.79 (   0.00%)     4086.06 (  -0.41%)
Hmean     recv-2048      7727.19 (   0.00%)     7769.94 (   0.55%)
Hmean     recv-3312     11927.57 (   0.00%)    11966.36 (   0.33%)
Hmean     recv-4096     14218.45 (   0.00%)    14193.50 (  -0.18%)
Hmean     recv-8192     23903.45 (   0.00%)    24205.21 *   1.26%*
Hmean     recv-16384    39599.53 (   0.00%)    39372.28 (  -0.57%)

netperf-tcp
                              baseline               patchset
Hmean     64        1756.32 (   0.00%)     1808.43 *   2.97%*
Hmean     128       3393.47 (   0.00%)     3421.99 *   0.84%*
Hmean     256       6464.04 (   0.00%)     6459.72 (  -0.07%)
Hmean     1024     19050.99 (   0.00%)    19036.21 (  -0.08%)
Hmean     2048     26107.88 (   0.00%)    26185.44 (   0.30%)
Hmean     3312     30770.77 (   0.00%)    30834.78 (   0.21%)
Hmean     4096     32523.50 (   0.00%)    32609.77 (   0.27%)
Hmean     8192     40180.74 (   0.00%)    39632.41 *  -1.36%*
Hmean     16384    46117.02 (   0.00%)    46259.69 (   0.31%)

Seems no obvious regression.

v5:
  - As Paolo pointed out, the cleanup paired with the patch that
    removed in v4 should also be removed.

v4:
  - Per Shakeel's suggestion, removed the patch that suppresses
    allocation under net-memcg pressure to avoid further keeping
    the senders waiting if SACKed segments get dropped from the
    OFO queue.

v3:
  - Fixed some coding style issues pointed out by Simon
  - Fold dependency into memcg pressure func to improve readability

v2:
  - Splited into several patches and modified commit log for
    better readability.
  - Make memcg's pressure consideration function-wide in
    __sk_mem_raise_allocated().

v1: https://lore.kernel.org/lkml/20230506085903.96133-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
v2: https://lore.kernel.org/lkml/20230522070122.6727-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
v3: https://lore.kernel.org/lkml/20230523094652.49411-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
v4: https://lore.kernel.org/lkml/20230530114011.13368-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/

Abel Wu (3):
  net-memcg: Fold dependency into memcg pressure cond
  sock: Always take memcg pressure into consideration
  sock: Fix misuse of sk_under_memory_pressure()

 include/linux/memcontrol.h |  2 ++
 include/net/sock.h         | 14 ++++++++------
 include/net/tcp.h          |  3 +--
 net/core/sock.c            |  2 +-
 4 files changed, 12 insertions(+), 9 deletions(-)

-- 
2.37.3

