From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v9 00/21] per lruvec lru_lock for memcg
Date: Mon,  2 Mar 2020 19:00:10 +0800
Message-ID: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Hi all,

This patchset mainly includes 3 parts:
1, some code cleanup and minimum optimization as a preparation.
2, use TestCleanPageLRU as page isolation's precondition
3, replace per node lru_lock with per memcg per node lru_lock

The keypoint of this patchset is moving lru_lock into lruvec, give a 
lru_lock for each of lruvec, thus bring a lru_lock for each of memcg 
per node. So on a large node machine, each of memcg don't suffer from
per node pgdat->lru_lock waiting. They could go fast with their self
lru_lock now.

Since lruvec belongs to each memcg, the critical point is to keep
page's memcg stable, so we take PageLRU as its isolation's precondition.
Thanks for Johannes Weiner help and suggestion!

Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
containers on a 2s * 26cores * HT box with a modefied case:
  https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice

With this patchset, the readtwice performance increased about 80%
in concurrent containers.

Thanks Hugh Dickins and Konstantin Khlebnikov, they both brought this
idea 8 years ago, and others who give comments as well: Daniel Jordan, 
Mel Gorman, Shakeel Butt, Matthew Wilcox etc.

Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
and Yun Wang.

v9,
  a, use TestCleanPageLRU as page isolation's precondition, that
     resolved the page's memcg stable problem, Thanks Johannes Weiner!
  b, few more code clean up patches

v8,
  a, redo lock_page_lru cleanup as Konstantin Khlebnikov suggested.
  b, fix a bug in lruvec_memcg_debug, reported by Hugh Dickins

...

v1: initial version, aim testing show 5% performance increase on a 16 threads box.

Alex Shi (19):
  mm/vmscan: remove unnecessary lruvec adding
  mm/memcg: fold lock_page_lru into commit_charge
  mm/page_idle: no unlikely double check for idle page counting
  mm/thp: move lru_add_page_tail func to huge_memory.c
  mm/thp: clean up lru_add_page_tail
  mm/thp: narrow lru locking
  mm/lru: introduce TestClearPageLRU
  mm/lru: add page isolation precondition in __isolate_lru_page
  mm/mlock: ClearPageLRU before get lru lock in munlock page isolation
  mm/lru: take PageLRU first in moving page between lru lists
  mm/memcg: move SetPageLRU out of lru_lock in commit_charge
  mm/mlock: clean up __munlock_isolate_lru_page
  mm/lru: replace pgdat lru_lock with lruvec lock
  mm/lru: introduce the relock_page_lruvec function
  mm/mlock: optimize munlock_pagevec by relocking
  mm/swap: only change the lru_lock iff page's lruvec is different
  mm/pgdat: remove pgdat lru_lock
  mm/lru: add debug checking for page memcg moving
  mm/memcg: add debug checking in lock_page_memcg

Hugh Dickins (1):
  mm/lru: revise the comments of lru_lock

 Documentation/admin-guide/cgroup-v1/memcg_test.rst |  15 +-
 Documentation/admin-guide/cgroup-v1/memory.rst     |   8 +-
 Documentation/trace/events-kmem.rst                |   2 +-
 Documentation/vm/unevictable-lru.rst               |  22 +--
 include/linux/memcontrol.h                         |  77 ++++++++++
 include/linux/mm_types.h                           |   2 +-
 include/linux/mmzone.h                             |   5 +-
 include/linux/page-flags.h                         |   1 +
 include/linux/swap.h                               |   6 +-
 mm/compaction.c                                    |  78 ++++++----
 mm/filemap.c                                       |   4 +-
 mm/huge_memory.c                                   |  54 +++++--
 mm/memcontrol.c                                    | 110 +++++++++-----
 mm/mlock.c                                         |  88 ++++++-----
 mm/mmzone.c                                        |   1 +
 mm/page_alloc.c                                    |   1 -
 mm/page_idle.c                                     |   8 -
 mm/rmap.c                                          |   2 +-
 mm/swap.c                                          | 160 +++++++-------------
 mm/vmscan.c                                        | 163 +++++++++++----------
 20 files changed, 446 insertions(+), 361 deletions(-)

-- 
1.8.3.1

