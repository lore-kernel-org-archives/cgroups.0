From: Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/2] mm: multi-gen LRU: working set extensions
Date: Wed, 14 Dec 2022 14:51:21 -0800
Message-ID: <20221214225123.2770216-1-yuanchu@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nWNYEkPGu4xeEk865eL9sMmuW2qvvMiYdO6LZIHyaa0=;
        b=myX2b9usISZoaAY5lU77WMryQ3aiX1kl/4FYrRRu2anLDBwXSbsBolikYQkFrE5uPw
         lKs2zBenkmqM7nk4VAPKqxphYh/C85VVm75JcjKuqBNO7N+RCTdsu9AKHgx8EHirHk0T
         w2r7juJ9kckYckm1i+vB7kURLm7hD2ScKtVQmsSW++IEbyOuNS0oIEenv3GT7xAIZGOX
         ggQX/lJ0VWmWQKS79OFshXSdsQBIsO8T5XlIfMQRtVy0cVtOKlhsA0DnGU5/gGbBUU/V
         Sl08VGAI9QDRgV8KEgh9sUbJzjvAOu6YVO6tvrm43b8SdqxmfkyWf4RSUf6hEhzEtctS
         GUpw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuanchu Xie <yuanchu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Introduce a way of monitoring the working set of a workload, per page
type and per NUMA node, with granularity in minutes. It has page-level
granularity and minimal memory overhead by building on the
Multi-generational LRU framework, which already has most of the
infrastructure and is just missing a useful interface.

MGLRU organizes pages in generations, where an older generation contains
colder pages, and aging promotes the recently used pages into the young
generation and creates a new one. The working set size is how much
memory an application needs to keep working, the amount of "hot" memory
that's frequently used. The only missing pieces between MGLRU
generations and working set estimation are a consistent aging cadence
and an interface; we introduce the two additions.

Periodic aging
======
MGLRU Aging is currently driven by reclaim, so the amount of time
between generations is non-deterministic. With memcgs being aged
regularly, MGLRU generations become time-based working set information.

- memory.periodic_aging: a new root-level only file in cgroupfs
Writing to memory.periodic_aging sets the aging interval and opts into
periodic aging.
- kold: a new kthread that ages memcgs based on the set aging interval.

Page idle age stats
======
- memory.page_idle_age: we group pages into idle age ranges, and present
  the number of pages per node per pagetype in each range. This
  aggregates the time information from MGLRU generations hierarchically.

Use case: proactive reclaimer
======
The proactive reclaimer sets the aging interval, and periodically reads
the page idle age stats, forming a working set estimation, which it then
calculates an amount to write to memory.reclaim.

With the page idle age stats, a proactive reclaimer could calculate a
precise amount of memory to reclaim without continuously probing and
inducing reclaim.

A proactive reclaimer that uses a similar interface is used in the
Google data centers.

Use case: workload introspection
======
A workload may use the working set estimates to adjust application
behavior as needed, e.g. preemptively killing some of its workers to
avoid its working set thrashing, or dropping caches to fit within a
limit.
It can also be valuable to application developers, who can benefit from
an out-of-the-box overview of the application's usage behaviors.

TODO List
======
- selftests
- a userspace demonstrator combining periodic aging, page idle age
  stats, memory.reclaim, and/or PSI

Open questions
======
- MGLRU aging mechanism has a flag called force_scan. With
  force_scan=false, invoking MGLRU aging when an lruvec has a maximum
  number of generations does not actually perform aging.
  However, with force_scan=true, MGLRU moves the pages in the oldest
  generation to the second oldest generation. The force_scan=true flag
  also disables some optimizations in MGLRU's page table walks.
  The current patch sets force_scan=true, so that periodic aging would
  work without a proactive reclaimer evicting the oldest generation.

- The page idle age format uses a fixed set of time ranges in seconds.
  I have considered having it be based on the aging interval, or just
  compiling the raw timestamps.
  With the age ranges based on the aging interval, a memcg that's
  undergoing memcg reclaim might have its generations in the 10
  seconds range, and a much longer aging interval would obscure this
  fact.
  The raw timestamps from MGLRU could lead to a very large file when
  aggregated hierarchically.

Yuanchu Xie (2):
  mm: multi-gen LRU: periodic aging
  mm: multi-gen LRU: cgroup working set stats

 include/linux/kold.h   |  44 ++++++++++
 include/linux/mmzone.h |   4 +-
 mm/Makefile            |   3 +
 mm/kold.c              | 150 ++++++++++++++++++++++++++++++++
 mm/memcontrol.c        | 188 +++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c            |  35 +++++++-
 6 files changed, 422 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/kold.h
 create mode 100644 mm/kold.c

-- 
2.39.0.314.g84b9a713c41-goog

