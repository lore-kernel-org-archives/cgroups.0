From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 00/19 V2] mm: memcontrol: charge swapin pages on instantiation
Date: Fri,  8 May 2020 14:30:47 -0400
Message-ID: <20200508183105.225460-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tzWVqUZtLwqxtxfWgFUyBr2nPkF3oxF3sVG4yWWQyv0=;
        b=Es4bHoTBFJW5deY/BPRm1w9FSHwlvLmnWbWr+JMeXV7lwHag/PJFMjSaaSHRkttda9
         ZBGMCqHHpexqozMp7joxpOR/FUBqY4fzUJeehlqLgHU0RSat1rj9Q+Xtcmcvp/Xucdmv
         EnHLzezIGvS2TdqxgQDzPqk6rWL/2RluSz8ZmEOU+wRKHuUmU8j/94jtvQvm3nrbytof
         CdDhhdVB5sBwTOP033+p/Ezivg7PnuZbXkMxxaA96tDTehDT8E1FkIS2v56S5APkj/yu
         qL5aCzZbbv0Y8ZY71fsPZmTIfK34i9XIhBcwDrRYYPwGqqTYiLOaoXXXHrj+OeSpZIhe
         IWgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Joonsoo Kim <js1304@gmail.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

This patch series reworks memcg to charge swapin pages directly at
swapin time, rather than at fault time, which may be much later, or
not happen at all.

Changes in version 2:
- prevent double charges on pre-allocated hugepages in khugepaged
- leave shmem swapcache when charging fails to avoid double IO (Joonsoo)
- fix temporary accounting bug by switching rmap<->commit (Joonsoo)
- fix double swap charge bug in cgroup1/cgroup2 code gating
- simplify swapin error checking (Joonsoo)
- mm: memcontrol: document the new swap control behavior (Alex)
- review tags

The delayed swapin charging scheme we have right now causes problems:

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

Based on v5.7-rc3-mmots-2020-05-01-20-14.

 Documentation/admin-guide/cgroup-v1/memory.rst |  19 +-
 include/linux/memcontrol.h                     |  53 +--
 include/linux/mm.h                             |   4 +-
 include/linux/swap.h                           |   6 +-
 init/Kconfig                                   |  17 +-
 kernel/events/uprobes.c                        |  10 +-
 mm/filemap.c                                   |  43 +--
 mm/huge_memory.c                               |  13 +-
 mm/khugepaged.c                                |  29 +-
 mm/memcontrol.c                                | 449 +++++++----------------
 mm/memory.c                                    |  51 +--
 mm/migrate.c                                   |  20 +-
 mm/rmap.c                                      |  53 +--
 mm/shmem.c                                     | 108 +++---
 mm/swap_cgroup.c                               |   6 -
 mm/swap_state.c                                |  89 ++---
 mm/swapfile.c                                  |  25 +-
 mm/userfaultfd.c                               |   5 +-
 18 files changed, 367 insertions(+), 633 deletions(-)
