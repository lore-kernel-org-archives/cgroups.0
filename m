From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 0/5] zswap: cgroup accounting & control
Date: Wed, 27 Apr 2022 12:00:11 -0400
Message-ID: <20220427160016.144237-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9GL3COHv0leHgkc2xj8IFg2MOsyvROczlu9iqFQTi6c=;
        b=EyNosu86WZBzUC9jjE+BB/6+rRUePVNB5D6ZLweYK0cFIUWcYSagiZotbV3kGhvIlS
         aSvmf4EfGitZgrEkXNDGgBgiz1HC8zvbqhEgPDUnOPd4hguA+FT8asyo6S3j5oDYIoGo
         8i8blQjc96SokqKzFW3yhgqj9t2hCvOPMNnicEa5sb4XEiaLxO8ipgY23jPrzflTCMCj
         e/QXaswu/EhhZnxUl3ooWdUkmRJ2DPmY42IUXuA03tcMHr/j8BJn49Zny7U2+x5RZUMc
         5GK7mdC+N0Gj6dvbpJN0oMAU2pAmBPbv0TW1TyQBbPT7Db08uuswrZhBl7kJzgp+QWcy
         Qw3w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Zswap backing memory is currently not tracked (and limited) on a
per-cgroup basis. As a result, workloads can escape their memory
containment and cause resource priority inversions on a shared host.
E.g. a lo-pri group fills the global zswap pool and forces a hi-pri
group out to disk.

Also, zswap doesn't benefit all workloads equally. Some even suffer
when memory contents compress poorly, and are better off going to disk
swap directly. On a host with mixed workloads, it's currently not
possible to enable zswap for one workload but not for the other.

This series implements missing cgroup awareness and control for zswap
to address both issues.

More details on interface and implementation in patch 5.

Patches 1-3 clean up related and adjacent options in Kconfig. Not
dependencies, just things I noticed during development.

Based on v5.18-rc4-mmots-2022-04-26-19-34-5-g5e1fdb02de7a.

 Documentation/admin-guide/cgroup-v2.rst |  21 ++
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
 11 files changed, 648 insertions(+), 342 deletions(-)


