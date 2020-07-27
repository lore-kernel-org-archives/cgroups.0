From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 00/21] per memcg lru lock
Date: Mon, 27 Jul 2020 13:40:31 +0800
Message-ID: <49d4f3bf-ccce-3c97-3a4c-f5cefe2d623a@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1595681998-19193-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org







A standard for new page isolation steps like the following:
1, get_page(); #pin the page avoid be free
2, TestClearPageLRU(); #serialize other isolation, also memcg change
3, spin_lock on lru_lock; #serialize lru list access
The step 2 could be optimzed/replaced in scenarios which page is unlikely
be accessed by others.



在 2020/7/25 下午8:59, Alex Shi 写道:
> The new version which bases on v5.8-rc6. It includes Hugh Dickins fix in 
> mm/swap.c and mm/mlock.c fix which Alexander Duyck pointed out, then
> removes 'mm/mlock: reorder isolation sequence during munlock' 
> 
> Hi Johanness & Hugh & Alexander & Willy,
> 
> Could you like to give a reviewed by since you address much of issue and
> give lots of suggestions! Many thanks!
> 
> Current lru_lock is one for each of node, pgdat->lru_lock, that guard for
> lru lists, but now we had moved the lru lists into memcg for long time. Still
> using per node lru_lock is clearly unscalable, pages on each of memcgs have
> to compete each others for a whole lru_lock. This patchset try to use per
> lruvec/memcg lru_lock to repleace per node lru lock to guard lru lists, make
> it scalable for memcgs and get performance gain.
> 
> Currently lru_lock still guards both lru list and page's lru bit, that's ok.
> but if we want to use specific lruvec lock on the page, we need to pin down
> the page's lruvec/memcg during locking. Just taking lruvec lock first may be
> undermined by the page's memcg charge/migration. To fix this problem, we could
> take out the page's lru bit clear and use it as pin down action to block the
> memcg changes. That's the reason for new atomic func TestClearPageLRU.
> So now isolating a page need both actions: TestClearPageLRU and hold the
> lru_lock.
> 
> The typical usage of this is isolate_migratepages_block() in compaction.c
> we have to take lru bit before lru lock, that serialized the page isolation
> in memcg page charge/migration which will change page's lruvec and new 
> lru_lock in it.
> 
> The above solution suggested by Johannes Weiner, and based on his new memcg 
> charge path, then have this patchset. (Hugh Dickins tested and contributed much
> code from compaction fix to general code polish, thanks a lot!).
> 
> The patchset includes 3 parts:
> 1, some code cleanup and minimum optimization as a preparation.
> 2, use TestCleanPageLRU as page isolation's precondition
> 3, replace per node lru_lock with per memcg per node lru_lock
> 
> Following Daniel Jordan's suggestion, I have run 208 'dd' with on 104
> containers on a 2s * 26cores * HT box with a modefied case:
> https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
> With this patchset, the readtwice performance increased about 80%
> in concurrent containers.
> 
> Thanks Hugh Dickins and Konstantin Khlebnikov, they both brought this
> idea 8 years ago, and others who give comments as well: Daniel Jordan, 
> Mel Gorman, Shakeel Butt, Matthew Wilcox etc.
> 
> Thanks for Testing support from Intel 0day and Rong Chen, Fengguang Wu,
> and Yun Wang. Hugh Dickins also shared his kbuild-swap case. Thanks!
> 
> 
> Alex Shi (19):
>   mm/vmscan: remove unnecessary lruvec adding
>   mm/page_idle: no unlikely double check for idle page counting
>   mm/compaction: correct the comments of compact_defer_shift
>   mm/compaction: rename compact_deferred as compact_should_defer
>   mm/thp: move lru_add_page_tail func to huge_memory.c
>   mm/thp: clean up lru_add_page_tail
>   mm/thp: remove code path which never got into
>   mm/thp: narrow lru locking
>   mm/memcg: add debug checking in lock_page_memcg
>   mm/swap: fold vm event PGROTATED into pagevec_move_tail_fn
>   mm/lru: move lru_lock holding in func lru_note_cost_page
>   mm/lru: move lock into lru_note_cost
>   mm/lru: introduce TestClearPageLRU
>   mm/compaction: do page isolation first in compaction
>   mm/thp: add tail pages into lru anyway in split_huge_page()
>   mm/swap: serialize memcg changes in pagevec_lru_move_fn
>   mm/lru: replace pgdat lru_lock with lruvec lock
>   mm/lru: introduce the relock_page_lruvec function
>   mm/pgdat: remove pgdat lru_lock
> 
> Hugh Dickins (2):
>   mm/vmscan: use relock for move_pages_to_lru
>   mm/lru: revise the comments of lru_lock
> 
>  Documentation/admin-guide/cgroup-v1/memcg_test.rst |  15 +-
>  Documentation/admin-guide/cgroup-v1/memory.rst     |  21 +--
>  Documentation/trace/events-kmem.rst                |   2 +-
>  Documentation/vm/unevictable-lru.rst               |  22 +--
>  include/linux/compaction.h                         |   4 +-
>  include/linux/memcontrol.h                         |  98 ++++++++++
>  include/linux/mm_types.h                           |   2 +-
>  include/linux/mmzone.h                             |   6 +-
>  include/linux/page-flags.h                         |   1 +
>  include/linux/swap.h                               |   4 +-
>  include/trace/events/compaction.h                  |   2 +-
>  mm/compaction.c                                    | 113 ++++++++----
>  mm/filemap.c                                       |   4 +-
>  mm/huge_memory.c                                   |  48 +++--
>  mm/memcontrol.c                                    |  71 ++++++-
>  mm/memory.c                                        |   3 -
>  mm/mlock.c                                         |  43 +++--
>  mm/mmzone.c                                        |   1 +
>  mm/page_alloc.c                                    |   1 -
>  mm/page_idle.c                                     |   8 -
>  mm/rmap.c                                          |   4 +-
>  mm/swap.c                                          | 203 ++++++++-------------
>  mm/swap_state.c                                    |   2 -
>  mm/vmscan.c                                        | 174 ++++++++++--------
>  mm/workingset.c                                    |   2 -
>  25 files changed, 510 insertions(+), 344 deletions(-)
> 
