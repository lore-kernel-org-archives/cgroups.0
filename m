From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v13b 00/18] Convert memcg to folios
Date: Mon, 12 Jul 2021 20:45:33 +0100
Message-ID: <20210712194551.91920-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=wwdrck5Fily6lPwjQUBToAYdwTywQY0VRUiJqbTmhYI=; b=gckufHXDZ6EM5AbS966R3VxzGf
        vM6swRTH6vXT/P6DDAnP+jQ9Vizm50brt37dGCL8uZmFMQZOcEruLPBQKMHy61RdM6vSmd5k1JeZG
        wNP8Ck1uvqhv/RnZpxIyRT74j7KDg5iL/TZv1b7mSMzg4IKZAbSlmtkKBNuSxYK8XTPnQgEDRbeMV
        k3OFl9LUGMeduzR1SJD8Hxti71jYu8XFO89x+4Q5wt9SbWsyA/Q5LSxzW7Qqb97uOw6ApD/NjcBCu
        o4YRsmIpTWKI3h8HLUHhkhEEi3LFMaKv3fpTUdP1AAPTdpE1N/i3Y96Z6ZM0Eu5AGNgmwXTYHK+/a
        TF598fqw==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

This is the part of the v13 patch series which deals with converting
(most of) the memcg interfaces to work with folios instead of pages.
A few interfaces are not changed due to having exclusively or many
users which are not going to be converted to folios soon.  Eventually,
all memcg interfaces should be converted to folios as all accounting of
memory is done on and with the head page.

A few of these patches ran into trouble with the build bots, and those
problems have been corrected.  I imagine that posting this as a patch
series independently of v13a will cause the build bots to report errors
as I don't know how to tell them that this series depends on that series.

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
  mm/memcg: Add folio_lruvec()
  mm/memcg: Add folio_lruvec_lock() and similar functions
  mm/memcg: Add folio_lruvec_relock_irq() and
    folio_lruvec_relock_irqsave()
  mm/workingset: Convert workingset_activation to take a folio

 include/linux/memcontrol.h       | 223 ++++++++++++---------
 include/linux/mm.h               |   5 +
 include/linux/swap.h             |   2 +-
 include/trace/events/writeback.h |   8 +-
 kernel/events/uprobes.c          |   3 +-
 mm/compaction.c                  |   4 +-
 mm/filemap.c                     |   8 +-
 mm/huge_memory.c                 |   7 +-
 mm/khugepaged.c                  |   8 +-
 mm/ksm.c                         |   3 +-
 mm/memcontrol.c                  | 323 +++++++++++++++----------------
 mm/memory-failure.c              |   2 +-
 mm/memory.c                      |   9 +-
 mm/memremap.c                    |   2 +-
 mm/migrate.c                     |   6 +-
 mm/mlock.c                       |   3 +-
 mm/page_alloc.c                  |   2 +-
 mm/rmap.c                        |   2 +-
 mm/shmem.c                       |   7 +-
 mm/swap.c                        |  26 ++-
 mm/userfaultfd.c                 |   2 +-
 mm/vmscan.c                      |   8 +-
 mm/workingset.c                  |  10 +-
 23 files changed, 358 insertions(+), 315 deletions(-)

-- 
2.30.2

