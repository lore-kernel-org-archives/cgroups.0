From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 00/18] mm: memcontrol: charge swapin pages on instantiation
Date: Mon, 20 Apr 2020 18:11:08 -0400
Message-ID: <20200420221126.341272-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RujGPQ/aToLYsclK+dnkQViuIsABafgZ1mMvYzjDw+g=;
        b=W5pshhSfzWc52vhfUDfjZfdL/VdXS7EEmH4WjupWl3cqVRvkzHRdMif9qdTKIowIS8
         jtAAJQYEqixojOHZBAwYKYIBNXmiy8H0Znbn4GFingRmwQ/ryMs/wRbcV99z5DKszZwZ
         GbgekrRWQE4KOkzLdPImbNSlOrGNU8w67KZmcdmNmfQOQVhtUaPVQiBErlyrTzPIcazY
         BRDGb/AZnkYJcLUppRNHWkNHEhMfWC4TcYa+/yWj+QlRtp3A+M3prGSzj0ZLK2Nu+BF0
         flSMwNBRQYoSupuvRlDAnT/pL5UqpV/xfRbMu34r/69y9f8lmUPSyX8hJ2LF1Afg5ZiR
         aLhA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

This patch series reworks memcg to charge swapin pages directly at
swapin time, rather than at fault time, which may be much later, or
not happen at all.

The delayed charging scheme we have right now causes problems:

- Alex's per-cgroup lru_lock patches rely on pages that have been
  isolated from the LRU to have a stable page->mem_cgroup; otherwise
  the lock may change underneath him. Swapcache pages are charged only
  after they are added to the LRU, and charging doesn't follow the LRU
  isolation protocol.

- Joonsoo's anon workingset patches need a suitable LRU at the time
  the page enters the swap cache and displaces the non-resident
  info. But the correct LRU is only available after charging.

- It's a containment hole / DoS vector. Users can trigger arbitrarily
  large swap readahead using MADV_WILLNEED. The memory is never
  charged unless somebody actually touches it.

- It complicates the page->mem_cgroup stabilization rules

In order to charge pages directly at swapin time, the memcg code base
needs to be prepared, and several overdue cleanups become a necessity:

To charge pages at swapin time, we need to always have cgroup
ownership tracking of swap records. We also cannot rely on
page->mapping to tell apart page types at charge time, because that's
only set up during a page fault.

To eliminate the page->mapping dependency, memcg needs to ditch its
private page type counters (MEMCG_CACHE, MEMCG_RSS, NR_SHMEM) in favor
of the generic vmstat counters and accounting sites, such as
NR_FILE_PAGES, NR_ANON_MAPPED etc.

To switch to generic vmstat counters, the charge sequence must be
adjusted such that page->mem_cgroup is set up by the time these
counters are modified.

The series is structured as follows:

1. Bug fixes
2. Decoupling charging from rmap
3. Swap controller integration into memcg
4. Direct swapin charging

The patches survive a simple swapout->swapin test inside a virtual
machine. Because this is blocking two major patch sets, I'm sending
these out early and will continue testing in parallel to the review.

 include/linux/memcontrol.h |  53 +----
 include/linux/mm.h         |   4 +-
 include/linux/swap.h       |   6 +-
 init/Kconfig               |  17 +-
 kernel/events/uprobes.c    |  10 +-
 mm/filemap.c               |  43 ++---
 mm/huge_memory.c           |  45 ++---
 mm/khugepaged.c            |  25 +--
 mm/memcontrol.c            | 448 ++++++++++++++-----------------------------
 mm/memory.c                |  51 ++---
 mm/migrate.c               |  20 +-
 mm/rmap.c                  |  53 +++--
 mm/shmem.c                 | 117 +++++------
 mm/swap_cgroup.c           |   6 -
 mm/swap_state.c            |  89 +++++----
 mm/swapfile.c              |  25 +--
 mm/userfaultfd.c           |   5 +-
 17 files changed, 367 insertions(+), 650 deletions(-)


