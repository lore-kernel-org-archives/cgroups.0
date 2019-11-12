From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v2 0/8] per lruvec lru_lock for memcg
Date: Tue, 12 Nov 2019 22:06:20 +0800
Message-ID: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: alex.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com

Hi all,

This patchset move lru_lock into lruvec, give a lru_lock for each of
lruvec, thus bring a lru_lock for each of memcg per node.

According to Daniel Jordan's suggestion, I run 64 'dd' with on 32
containers on my 2s* 8 core * HT box with the modefied case:
  https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice

With this change above lru_lock censitive testing improved 17% with multiple
containers scenario. And no performance lose w/o mem_cgroup.

Thanks Hugh Dickins and Konstantin Khlebnikov, they both bring the same idea
7 years ago. I don't know why they didn't go further, but according to my 
testing, and google internal usage. This feathre is clearly benefit
multi-container user.

So I like to introduce it here.

v2: bypass a performance regression bug and fix some function issues

---
 Documentation/admin-guide/cgroup-v1/memcg_test.rst | 15 +++------------
 Documentation/admin-guide/cgroup-v1/memory.rst     |  6 +++---
 Documentation/trace/events-kmem.rst                |  2 +-
 Documentation/vm/unevictable-lru.rst               | 22 ++++++++--------------
 include/linux/memcontrol.h                         | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h                           |  2 +-
 include/linux/mmzone.h                             |  7 +++++--
 mm/compaction.c                                    | 62 ++++++++++++++++++++++++++++++++++++++++++--------------------
 mm/filemap.c                                       |  4 ++--
 mm/huge_memory.c                                   | 16 ++++++----------
 mm/memcontrol.c                                    | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 mm/mlock.c                                         | 27 ++++++++++++++-------------
 mm/mmzone.c                                        |  1 +
 mm/page_alloc.c                                    |  1 -
 mm/page_idle.c                                     |  5 +++--
 mm/rmap.c                                          |  2 +-
 mm/swap.c                                          | 77 +++++++++++++++++++++++++++++++----------------------------------------------
 mm/vmscan.c                                        | 74 ++++++++++++++++++++++++++++++++++++++------------------------------------
 18 files changed, 277 insertions(+), 177 deletions(-)


[PATCH v2 1/8] mm/lru: add per lruvec lock for memcg
[PATCH v2 2/8] mm/lruvec: add irqsave flags into lruvec struct
[PATCH v2 3/8] mm/lru: replace pgdat lru_lock with lruvec lock
[PATCH v2 4/8] mm/lru: only change the lru_lock iff page's lruvec is
[PATCH v2 5/8] mm/pgdat: remove pgdat lru_lock
[PATCH v2 6/8] mm/lru: remove rcu_read_lock to fix performance
[PATCH v2 7/8] mm/lru: likely enhancement
[PATCH v2 8/8] mm/lru: revise the comments of lru_lock
