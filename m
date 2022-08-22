From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] memcg: optimizatize charge codepath
Date: Mon, 22 Aug 2022 00:17:34 +0000
Message-ID: <20220822001737.4120417-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=eVYfwZxwoaftgj4urkXWqJfl1yf2BkP0ai3v6afDBzY=;
        b=M1l5wTrPM/Bn69v9qPWUy2ze89j/C2QhgC3uGWDIOLN0WzyTcSLHJG+RMJMatiXqzX
         27XcKNJabca81sRVdeO2CT1uL6V3eUrxJu8cAS5kLO6npO5tc6V6+FSswOr5rvF6RaE5
         NnZaglMI2t5Fcdxoo3js4AEbpcjU5+NawpoYbCoq0mblDVlFiOzpAKZf/doM3EvCHCLx
         4Q3+m22Td0kDdin0LFVj23XqtyJX1saMxHUxHMwrnzPDoQvY1ZsDuHKa9Kh07T/Mylwk
         qX7Y7PhcDJVc31z1kgWb/ztxtLAbJS62kPbXsESgW/3GkZHCTfqGGUoWHVPWeD15A1hl
         kqqA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Recently Linux networking stack has moved from a very old per socket
pre-charge caching to per-cpu caching to avoid pre-charge fragmentation
and unwarranted OOMs. One impact of this change is that for network
traffic workloads, memcg charging codepath can become a bottleneck. The
kernel test robot has also reported this regression. This patch series
tries to improve the memcg charging for such workloads.

This patch series implement three optimizations:
(A) Reduce atomic ops in page counter update path.
(B) Change layout of struct page_counter to eliminate false sharing
    between usage and high.
(C) Increase the memcg charge batch to 64.

To evaluate the impact of these optimizations, on a 72 CPUs machine, we
ran the following workload in root memcg and then compared with scenario
where the workload is run in a three level of cgroup hierarchy with top
level having min and low setup appropriately.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
1. root memcg		21694.8
2. 6.0-rc1		10482.7 (-51.6%)
3. 6.0-rc1 + (A)	14542.5 (-32.9%)
4. 6.0-rc1 + (B)	12413.7 (-42.7%)
5. 6.0-rc1 + (C)	17063.7 (-21.3%)
6. 6.0-rc1 + (A+B+C)	20120.3 (-7.2%)

With all three optimizations, the memcg overhead of this workload has
been reduced from 51.6% to just 7.2%.

Shakeel Butt (3):
  mm: page_counter: remove unneeded atomic ops for low/min
  mm: page_counter: rearrange struct page_counter fields
  memcg: increase MEMCG_CHARGE_BATCH to 64

 include/linux/memcontrol.h   |  7 ++++---
 include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
 mm/page_counter.c            | 13 ++++++-------
 3 files changed, 33 insertions(+), 21 deletions(-)

-- 
2.37.1.595.g718a3a8f04-goog

