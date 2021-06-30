From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH v3 00/18] Folio conversion of memcg
Date: Wed, 30 Jun 2021 05:00:16 +0100
Message-ID: <20210630040034.1155892-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=H55xh5V+oHUYRXdg7je8cyh7ajXB8JcmTsj7ZvoBfcc=; b=VkugjUnYwnT8jLypOv8A1Ln+V/
        J//Nq0lYkLXx52J2+WEN6cSvPIY1sY/q1Qjq7Y+y/eQ9RWv0FovaBQmOjaE1kwNGJyc+E6BpfGext
        55e9UWOYQctGBZTK7kPeUl1NUnrWs5vtsCt/LjVxIJhZTyt8kSN5iAFAenePRULX8nY7eAIsFXVn/
        VUASdirBJ8n0NHCXucK6x+g6QMF8/A2AfJ4bNCF5qzrwLVfKzATQ+d2pljaxZfRYNeF4ulNef8vxL
        GLLkYB0smy0U8EIrZWDXAiGnwpwHExeDEpBkonDL1X72PHNIe3pKJEQKeu4LTaEFvDOn05YkqtGlT
        oJ7sXmAw==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

After Michel's comments on "Folio-enabling the page cache", I thought it
best to split out the memcg patches from the rest of the page cache folio
patches and redo them to focus on correctness (ie always passing a folio).

This is fundamentally for review rather than application.  I've rebased
on Linus' current tree, which includes the recent patchbomb from akpm.
That upstream version won't boot on any system I have available, and I'm
not comfortable asking for patches to be applied unless I can actually
try them.  That said, these patches were fine on top of 5.13.

There are still a few functions which take pages, but they rely on other
conversions happening first, which in turn rely on this set of patches,
so I think this is a good place to stop, with the understanding that
there will be more patches later.

Some of the commit logs may be garbled ... I haven't fully taken into
account all of Muchun's recent rework.  All of this work is visible in
context in a git tree here:
https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/folio

Matthew Wilcox (Oracle) (18):
  mm: Add folio_nid()
  mm/memcg: Remove 'page' parameter to mem_cgroup_charge_statistics()
  mm/memcg: Use the node id in mem_cgroup_update_tree()
  mm/memcg: Remove soft_limit_tree_node()
  mm/memcg: Convert memcg_check_events to take a node ID
  mm/memcg: Add folio_memcg() and related functions
  mm/memcg: Convert commit_charge() to take a folio
  mm/memcg: Convert mem_cgroup_charge() to take a folio
  mm/memcg: Convert uncharge_page() to uncharge_folio()
  mm/memcg: Convert mem_cgroup_uncharge() to take a folio
  mm/memcg: Convert mem_cgroup_migrate() to take folios
  mm/memcg: Convert mem_cgroup_track_foreign_dirty_slowpath() to folio
  mm/memcg: Add folio_memcg_lock() and folio_memcg_unlock()
  mm/memcg: Convert mem_cgroup_move_account() to use a folio
  mm/memcg: Add mem_cgroup_folio_lruvec()
  mm/memcg: Add folio_lruvec_lock() and similar functions
  mm/memcg: Add folio_lruvec_relock_irq() and
    folio_lruvec_relock_irqsave()
  mm/workingset: Convert workingset_activation to take a folio

 include/linux/memcontrol.h       | 249 +++++++++++++++----------
 include/linux/mm.h               |   5 +
 include/linux/swap.h             |   2 +-
 include/trace/events/writeback.h |   8 +-
 kernel/events/uprobes.c          |   3 +-
 mm/compaction.c                  |   2 +-
 mm/filemap.c                     |   8 +-
 mm/huge_memory.c                 |   2 +-
 mm/khugepaged.c                  |   8 +-
 mm/ksm.c                         |   3 +-
 mm/memcontrol.c                  | 311 +++++++++++++++----------------
 mm/memory-failure.c              |   2 +-
 mm/memory.c                      |   9 +-
 mm/memremap.c                    |   2 +-
 mm/migrate.c                     |   6 +-
 mm/page_alloc.c                  |   2 +-
 mm/shmem.c                       |   7 +-
 mm/swap.c                        |   4 +-
 mm/userfaultfd.c                 |   2 +-
 mm/vmscan.c                      |   2 +-
 mm/workingset.c                  |  10 +-
 21 files changed, 355 insertions(+), 292 deletions(-)

-- 
2.30.2

