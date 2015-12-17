From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 0/7] Add swap accounting to cgroup2
Date: Thu, 17 Dec 2015 15:29:53 +0300
Message-ID: <cover.1450352791.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

This is v2 of the patch set introducing swap accounting to cgroup2. For
a detailed description and rationale please see patches 1 and 7.

v1 can be found here: https://lwn.net/Articles/667472/

v2 mostly addresses comments by Johannes. For the detailed changelog,
see individual patches.

Thanks,

Vladimir Davydov (7):
  mm: memcontrol: charge swap to cgroup2
  mm: vmscan: pass memcg to get_scan_count()
  mm: memcontrol: replace mem_cgroup_lruvec_online with
    mem_cgroup_online
  swap.h: move memcg related stuff to the end of the file
  mm: vmscan: do not scan anon pages if memcg swap limit is hit
  mm: free swap cache aggressively if memcg swap is full
  Documentation: cgroup: add memory.swap.{current,max} description

 Documentation/cgroup.txt   |  33 ++++++++++
 include/linux/memcontrol.h |  28 ++++-----
 include/linux/swap.h       |  76 ++++++++++++++--------
 mm/memcontrol.c            | 154 ++++++++++++++++++++++++++++++++++++++++++---
 mm/memory.c                |   3 +-
 mm/shmem.c                 |   4 ++
 mm/swap_state.c            |   5 ++
 mm/swapfile.c              |   6 +-
 mm/vmscan.c                |  26 ++++----
 9 files changed, 265 insertions(+), 70 deletions(-)

-- 
2.1.4
