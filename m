From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/4] mm: Make the logging a bit more consistent
Date: Thu,  3 Mar 2016 15:25:30 -0800
Message-ID: <cover.1457047399.git.joe@perches.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Joe Perches (4):
  mm: Convert pr_warning to pr_warn
  mm: Coalesce split strings
  mm: Convert printk(KERN_<LEVEL> to pr_<level>
  mm: percpu: Use pr_fmt to prefix output

 mm/backing-dev.c    |  4 +--
 mm/bootmem.c        |  7 ++---
 mm/dmapool.c        | 18 +++++-------
 mm/huge_memory.c    |  3 +-
 mm/hugetlb.c        |  9 +++---
 mm/internal.h       |  2 +-
 mm/kasan/report.c   |  6 ++--
 mm/kmemcheck.c      |  3 +-
 mm/kmemleak-test.c  |  2 +-
 mm/kmemleak.c       | 32 ++++++++++-----------
 mm/memblock.c       |  3 +-
 mm/memory-failure.c | 52 ++++++++++++++--------------------
 mm/memory.c         | 17 +++++------
 mm/memory_hotplug.c | 14 ++++-----
 mm/mempolicy.c      |  4 +--
 mm/mm_init.c        |  7 ++---
 mm/mmap.c           |  8 ++----
 mm/nobootmem.c      |  4 +--
 mm/oom_kill.c       |  3 +-
 mm/page_alloc.c     | 59 +++++++++++++++++---------------------
 mm/page_io.c        | 22 +++++++--------
 mm/page_owner.c     |  5 ++--
 mm/page_poison.c    |  4 +--
 mm/percpu-km.c      |  6 ++--
 mm/percpu.c         | 43 ++++++++++++++--------------
 mm/shmem.c          | 14 ++++-----
 mm/slab.c           | 81 ++++++++++++++++++++++-------------------------------
 mm/slab_common.c    | 12 ++++----
 mm/slub.c           | 19 ++++++-------
 mm/sparse-vmemmap.c |  8 +++---
 mm/sparse.c         | 21 ++++++--------
 mm/swap_cgroup.c    |  5 ++--
 mm/swapfile.c       |  3 +-
 mm/vmalloc.c        |  4 +--
 34 files changed, 219 insertions(+), 285 deletions(-)

-- 
2.6.3.368.gf34be46

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
