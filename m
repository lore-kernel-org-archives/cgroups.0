From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/5] mm: workingset: per-cgroup thrash detection
Date: Tue, 26 Jan 2016 16:00:01 -0500
Message-ID: <1453842006-29265-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi,

these patches make the workingset code cgroup-aware, so that page
reclaim works properly when using the cgroup memory controller. More
details in the 5/5 changelog.

This should have been part of the original thrash detection patches,
but those were already too complex. So here we go.

Thanks,
Johannes

 fs/buffer.c                |  14 ++--
 fs/xfs/xfs_aops.c          |   8 +--
 include/linux/memcontrol.h |  55 ++++++++++++++--
 include/linux/mmzone.h     |  11 ++--
 include/linux/swap.h       |   1 +
 mm/filemap.c               |  12 ++--
 mm/memcontrol.c            |  59 ++++-------------
 mm/page-writeback.c        |  28 ++++----
 mm/rmap.c                  |   8 +--
 mm/truncate.c              |   6 +-
 mm/vmscan.c                |  26 ++++----
 mm/workingset.c            | 151 ++++++++++++++++++++++++++++++++-----------
 12 files changed, 236 insertions(+), 143 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
