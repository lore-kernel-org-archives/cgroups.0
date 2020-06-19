From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v13 00/18] per memcg lru lock
Date: Fri, 19 Jun 2020 16:33:38 +0800
Message-ID: <1592555636-115095-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This is a new version which bases on linux-next, merged much suggestion
from Hugh Dickins, from compaction fix to less TestClearPageLRU and
comments reverse etc. Thank a lot, Hugh!

Johannes Weiner has suggested:
"So here is a crazy idea that may be worth exploring:

Right now, pgdat->lru_lock protects both PageLRU *and* the lruvec's
linked list.

Can we make PageLRU atomic and use it to stabilize the lru_lock
instead, and then use the lru_lock only serialize list operations?
..."

With new memcg charge path and this solution, we could isolate
LRU pages to exclusive visit them in compaction, page migration, reclaim,
memcg move_accunt, huge page split etc scenarios while keeping pages' 
memcg stable. Then possible to change per node lru locking to per memcg
lru locking. As to pagevec_lru_move_fn funcs, it would be safe to let
pages remain on lru list, lru lock could guard them for list integrity.

The patchset includes 3 parts:
1, some code cleanup and minimum optimization as a preparation.
2, use TestCleanPageLRU as page isolation's precondition
3, replace per node lru_lock with per memcg per node lru_lock

The 3rd part moves per node lru_lock into lruvec, thus bring a lru_lock for
each of memcg per node. So on a large machine, each of memcg don't
have to suffer from per node pgdat->lru_lock competition. They could go
fast with their self lru_lock

Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
containers on a 2s * 26cores * HT box with a modefied case:
https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice

With this patchset, the readtwice performance increased about 80%
in concurrent containers.

Thanks Hugh Dickins and Konstantin Khlebnikov, they both brought this
idea 8 years ago, and others who give comments as well: Daniel Jordan, 
Mel Gorman, Shakeel Butt, Matthew Wilcox etc.

Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
and Yun Wang. Hugh Dickins also shared his kbuild-swap case. Thanks!

Alex Shi (16):
  mm/vmscan: remove unnecessary lruvec adding
  mm/page_idle: no unlikely double check for idle page counting
  mm/compaction: correct the comments of compact_defer_shift
  mm/compaction: rename compact_deferred as compact_should_defer
  mm/thp: move lru_add_page_tail func to huge_memory.c
  mm/thp: clean up lru_add_page_tail
  mm/thp: narrow lru locking
  mm/memcg: add debug checking in lock_page_memcg
  mm/swap: fold vm event PGROTATED into pagevec_move_tail_fn
  mm/lru: introduce TestClearPageLRU
  mm/compaction: do page isolation first in compaction
  mm/mlock: reorder isolation sequence during munlock
  mm/swap: serialize memcg changes during pagevec_lru_move_fn
  mm/lru: replace pgdat lru_lock with lruvec lock
  mm/lru: introduce the relock_page_lruvec function
  mm/pgdat: remove pgdat lru_lock

Hugh Dickins (2):
  mm/vmscan: use relock for move_pages_to_lru
  mm/lru: revise the comments of lru_lock

 Documentation/admin-guide/cgroup-v1/memcg_test.rst |  15 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |  21 ++-
 Documentation/trace/events-kmem.rst                |   2 +-
 Documentation/vm/unevictable-lru.rst               |  22 +--
 include/linux/compaction.h                         |   4 +-
 include/linux/memcontrol.h                         |  95 +++++++++++
 include/linux/mm_types.h                           |   2 +-
 include/linux/mmzone.h                             |   6 +-
 include/linux/page-flags.h                         |   1 +
 include/linux/swap.h                               |   4 +-
 include/trace/events/compaction.h                  |   2 +-
 mm/compaction.c                                    | 113 ++++++++-----
 mm/filemap.c                                       |   4 +-
 mm/huge_memory.c                                   |  54 +++++--
 mm/memcontrol.c                                    |  56 ++++++-
 mm/mlock.c                                         |  93 +++++------
 mm/mmzone.c                                        |   1 +
 mm/page_alloc.c                                    |   1 -
 mm/page_idle.c                                     |   8 -
 mm/rmap.c                                          |   4 +-
 mm/swap.c                                          | 175 +++++++--------------
 mm/swap_state.c                                    |   5 +-
 mm/vmscan.c                                        | 165 ++++++++++---------
 mm/workingset.c                                    |   4 +-
 24 files changed, 500 insertions(+), 357 deletions(-)

-- 
1.8.3.1

