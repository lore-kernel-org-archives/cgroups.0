From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v3 0/4] Change the return value for page isolation functions
Date: Wed, 15 Feb 2023 18:39:33 +0800
Message-ID: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Now the page isolation functions did not return a boolean to indicate
success or not, instead it will return a negative error when failed
to isolate a page. So below code used in most places seem a boolean
success/failure thing, which can confuse people whether the isolation
is successful.

if (folio_isolate_lru(folio))
        continue;

Moreover the page isolation functions only return 0 or -EBUSY, and
most users did not care about the negative error except for few users,
thus we can convert all page isolation functions to return a boolean
value, which can remove the confusion to make code more clear.

No functional changes intended in this patch series.

Changes from v2:
 - Add a new boolean 'isolated' variable for functions that require the
 negative error value.
 - Keep the same return value logic in do_migrate_range(), that means it
 will return -EBUSY if all pages are failed to be isolated.
 - Collect Acked-by and Reviewed-by tags. Thanks David and SeongJae.

Changes from v1:
 - Convert all isolation functions to return bool.

Baolin Wang (4):
  mm: change to return bool for folio_isolate_lru()
  mm: change to return bool for isolate_lru_page()
  mm: hugetlb: change to return bool for isolate_hugetlb()
  mm: change to return bool for isolate_movable_page()

 include/linux/hugetlb.h |  6 +++---
 include/linux/migrate.h |  6 +++---
 mm/compaction.c         |  2 +-
 mm/damon/paddr.c        |  2 +-
 mm/folio-compat.c       |  4 ++--
 mm/gup.c                |  2 +-
 mm/hugetlb.c            | 13 ++++++++-----
 mm/internal.h           |  4 ++--
 mm/khugepaged.c         |  4 ++--
 mm/madvise.c            |  4 ++--
 mm/memcontrol.c         |  4 ++--
 mm/memory-failure.c     | 10 +++++-----
 mm/memory_hotplug.c     |  8 +++++---
 mm/mempolicy.c          |  4 ++--
 mm/migrate.c            | 20 +++++++++++---------
 mm/migrate_device.c     |  2 +-
 mm/vmscan.c             | 10 +++++-----
 17 files changed, 56 insertions(+), 49 deletions(-)

-- 
2.27.0

