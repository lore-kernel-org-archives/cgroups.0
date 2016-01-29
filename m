From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v2 0/5] mm: workingset: per-cgroup thrash detection
Date: Fri, 29 Jan 2016 12:54:02 -0500
Message-ID: <1454090047-1790-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi,

this is v2 of the per-cgroup thrash detection patches, incorporating
Vladimir's feedback and review tags.

These patches tag the page cache radix tree eviction entries with the
memcg an evicted page belonged to, thus making per-cgroup LRU reclaim
work properly and be as adaptive to new cache workingsets as global
reclaim already is.

This should have been part of the original thrash detection patch
series, but was deferred due to the complexity of those patches.
Please consider merging this for v4.6.

Thanks,
Johannes

 fs/buffer.c                |  14 ++--
 fs/xfs/xfs_aops.c          |   8 +--
 include/linux/memcontrol.h |  72 +++++++++++++++----
 include/linux/mmzone.h     |  13 ++--
 mm/filemap.c               |  12 ++--
 mm/memcontrol.c            |  59 ++++------------
 mm/page-writeback.c        |  28 ++++----
 mm/rmap.c                  |   8 +--
 mm/truncate.c              |   6 +-
 mm/vmscan.c                |  26 +++----
 mm/workingset.c            | 160 +++++++++++++++++++++++++++++++++----------
 11 files changed, 256 insertions(+), 150 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
