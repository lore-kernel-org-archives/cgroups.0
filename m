From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 0/3] mm: memcontrol: simplify page->mem_cgroup pinning
Date: Fri, 29 Jan 2016 18:19:30 -0500
Message-ID: <1454109573-29235-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

This simplifies the way page->mem_cgroup is pinned. After this series,
lock_page_memcg() is simpler to use, and only necessary if the page is
neither isolated from the LRU nor fully locked.

 fs/buffer.c                | 18 ++++++++---------
 fs/xfs/xfs_aops.c          |  7 +++----
 include/linux/memcontrol.h | 46 ++++++++++++++++++++++---------------------
 include/linux/mm.h         | 14 ++-----------
 include/linux/pagemap.h    |  3 +--
 mm/filemap.c               | 21 ++++++--------------
 mm/memcontrol.c            | 36 +++++++++++++++------------------
 mm/migrate.c               | 14 +++++++------
 mm/page-writeback.c        | 47 ++++++++++++++++++--------------------------
 mm/rmap.c                  | 16 ++++++---------
 mm/shmem.c                 |  2 +-
 mm/truncate.c              |  6 +-----
 mm/vmscan.c                |  7 +------
 mm/workingset.c            |  9 ++++-----
 14 files changed, 100 insertions(+), 146 deletions(-)
