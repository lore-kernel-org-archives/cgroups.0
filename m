From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v21 00/19] per memcg lru lock
Date: Thu,  5 Nov 2020 16:55:30 +0800
Message-ID: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This version rebase on next/master 20201104, with much of Johannes's
Acks and some changes according to Johannes comments. And add a new patch
v21-0006-mm-rmap-stop-store-reordering-issue-on-page-mapp.patch to support
v21-0007.

This patchset followed 2 memcg VM_WARN_ON_ONCE_PAGE patches which were
added to -mm tree yesterday.
 
Many thanks for line by line review by Hugh Dickins, Alexander Duyck and
Johannes Weiner.

So now this patchset includes 3 parts:
1, some code cleanup and minimum optimization as a preparation. 
2, use TestCleanPageLRU as page isolation's precondition.
3, replace per node lru_lock with per memcg per node lru_lock.

Current lru_lock is one for each of node, pgdat->lru_lock, that guard for
lru lists, but now we had moved the lru lists into memcg for long time. Still
using per node lru_lock is clearly unscalable, pages on each of memcgs have
to compete each others for a whole lru_lock. This patchset try to use per
lruvec/memcg lru_lock to repleace per node lru lock to guard lru lists, make
it scalable for memcgs and get performance gain.

Currently lru_lock still guards both lru list and page's lru bit, that's ok.
but if we want to use specific lruvec lock on the page, we need to pin down
the page's lruvec/memcg during locking. Just taking lruvec lock first may be
undermined by the page's memcg charge/migration. To fix this problem, we could
take out the page's lru bit clear and use it as pin down action to block the
memcg changes. That's the reason for new atomic func TestClearPageLRU.
So now isolating a page need both actions: TestClearPageLRU and hold the
lru_lock.

The typical usage of this is isolate_migratepages_block() in compaction.c
we have to take lru bit before lru lock, that serialized the page isolation
in memcg page charge/migration which will change page's lruvec and new 
lru_lock in it.

The above solution suggested by Johannes Weiner, and based on his new memcg 
charge path, then have this patchset. (Hugh Dickins tested and contributed much
code from compaction fix to general code polish, thanks a lot!).

Daniel Jordan's testing show 62% improvement on modified readtwice case
on his 2P * 10 core * 2 HT broadwell box on v18, which has no much different
with this v20.
https://lore.kernel.org/lkml/20200915165807.kpp7uhiw7l3loofu-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/

Thanks Hugh Dickins and Konstantin Khlebnikov, they both brought this
idea 8 years ago, and others who give comments as well: Daniel Jordan, 
Mel Gorman, Shakeel Butt, Matthew Wilcox, Alexander Duyck etc.

Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
and Yun Wang. Hugh Dickins also shared his kbuild-swap case. Thanks!


Alex Shi (16):
  mm/thp: move lru_add_page_tail func to huge_memory.c
  mm/thp: use head for head page in lru_add_page_tail
  mm/thp: Simplify lru_add_page_tail()
  mm/thp: narrow lru locking
  mm/vmscan: remove unnecessary lruvec adding
  mm/rmap: stop store reordering issue on page->mapping
  mm/memcg: add debug checking in lock_page_memcg
  mm/swap.c: fold vm event PGROTATED into pagevec_move_tail_fn
  mm/lru: move lock into lru_note_cost
  mm/vmscan: remove lruvec reget in move_pages_to_lru
  mm/mlock: remove lru_lock on TestClearPageMlocked
  mm/mlock: remove __munlock_isolate_lru_page
  mm/lru: introduce TestClearPageLRU
  mm/compaction: do page isolation first in compaction
  mm/swap.c: serialize memcg changes in pagevec_lru_move_fn
  mm/lru: replace pgdat lru_lock with lruvec lock

Alexander Duyck (1):
  mm/lru: introduce the relock_page_lruvec function

Hugh Dickins (2):
  mm: page_idle_get_page() does not need lru_lock
  mm/lru: revise the comments of lru_lock

 Documentation/admin-guide/cgroup-v1/memcg_test.rst |  15 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |  21 +--
 Documentation/trace/events-kmem.rst                |   2 +-
 Documentation/vm/unevictable-lru.rst               |  22 +--
 include/linux/memcontrol.h                         | 110 +++++++++++
 include/linux/mm_types.h                           |   2 +-
 include/linux/mmzone.h                             |   6 +-
 include/linux/page-flags.h                         |   1 +
 include/linux/swap.h                               |   4 +-
 mm/compaction.c                                    |  94 +++++++---
 mm/filemap.c                                       |   4 +-
 mm/huge_memory.c                                   |  45 +++--
 mm/memcontrol.c                                    |  79 +++++++-
 mm/mlock.c                                         |  63 ++-----
 mm/mmzone.c                                        |   1 +
 mm/page_alloc.c                                    |   1 -
 mm/page_idle.c                                     |   4 -
 mm/rmap.c                                          |  11 +-
 mm/swap.c                                          | 208 ++++++++-------------
 mm/vmscan.c                                        | 207 ++++++++++----------
 mm/workingset.c                                    |   2 -
 21 files changed, 530 insertions(+), 372 deletions(-)

-- 
1.8.3.1

