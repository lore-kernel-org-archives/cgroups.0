From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH v2 0/6] zswap: accounting & cgroup control
Date: Tue, 10 May 2022 11:28:41 -0400
Message-ID: <20220510152847.230957-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FOe0QpIsq707T7oDbRf/pCSk/0RB38He1yJY5ChwDp8=;
        b=aIpZsyJf5arHu4Vr+y4gUngRQHnYs8ayU/4r6iHRz9x7KLZYtVJa7rzJAZVGmnN4Z3
         fYqgefyNWghW0QllgfeEfAYaJuJVbjjrbIfAvLTM4KICsEiX8VT2m1BDJ8eqgfANQddd
         1SS/KGzOfRACH29I2AkLAFUy9+7ibARRraCxVzuWayfHm0AhiyPNOL5p7+fFQSkziMaw
         BZjovDcs3K6cvmWvNL+GRHlhtldCWF65/b1GyAeIX0vlNUFoIWQUAfKs9JOeCPMCv7SX
         fy8df3gGpt6SG3JJ1yFO8DlhdGXLeMqt/Rawi0Dv+Z0qXe4nlEgaBobxeUeHzK86LEh/
         NJoA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Changelog

- Refresh and update meminfo documentation (Andrew)
- Discussions around stat sharing opportunities with zram. But agreed
  that zswap is a cache and zram a backend that could theoretically be
  stacked, so they need to be understandable separately. (Minchan)

Overview

Zswap can consume nearly a quarter of RAM in the default
configuration, yet it's neither listed in /proc/meminfo, nor is it
accounted and manageable on a per-cgroup basis.

This makes reasoning about the memory situation on a host in general
rather difficult. On shared/cgrouped hosts, the consequences are
worse. First, workloads can escape memory containment and cause
resource priority inversions: a lo-pri group can fill the global zswap
pool and force a hi-pri group out to disk. Second, not all workloads
benefit from zswap equally. Some even suffer when memory contents
compress poorly, and are better off going to disk swap directly. On a
host with mixed workloads, it's currently not possible to enable zswap
for one workload but not for the other.

This series implements the missing global accounting as well as cgroup
tracking & control for zswap backing memory:

- Patch 1 refreshes the very out-of-date meminfo documentation in
  Documentation/filesystems/proc.rst.

- Patches 2-4 clean up related and adjacent options in Kconfig. Not
  actual dependencies, just things I noticed during development.

- Patch 5 adds meminfo and vmstat coverage for zswap consumption and
  activity.

- Patch 6 implements per-cgroup tracking & control of zswap memory.

Based on v5.18-rc4-mmots-2022-04-26-19-34-5-g5e1fdb02de7a.

 Documentation/admin-guide/cgroup-v2.rst |  21 ++
 Documentation/filesystems/proc.rst      | 161 +++++----
 drivers/block/zram/Kconfig              |   3 +-
 fs/proc/meminfo.c                       |   7 +
 include/linux/memcontrol.h              |  54 +++
 include/linux/swap.h                    |   5 +
 include/linux/vm_event_item.h           |   4 +
 init/Kconfig                            | 123 -------
 mm/Kconfig                              | 523 +++++++++++++++++++-----------
 mm/memcontrol.c                         | 196 ++++++++++-
 mm/vmstat.c                             |   4 +
 mm/zswap.c                              |  50 ++-
 12 files changed, 753 insertions(+), 398 deletions(-)


