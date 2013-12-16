From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v14 00/18] kmemcg shrinkers
Date: Mon, 16 Dec 2013 16:16:49 +0400
Message-ID: <cover.1387193771.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,

This is the 14th iteration of Glauber Costa's patch-set implementing slab
shrinking on memcg pressure. The main idea is to make the list_lru structure
used by most FS shrinkers per-memcg. When adding or removing an element from a
list_lru, we use the page information to figure out which memcg it belongs to
and relay it to the appropriate list. This allows scanning kmem objects
accounted to different memcgs independently.

Please note that this patch-set implements slab shrinking only when we hit the
user memory limit so that kmem allocations will still fail if we are below the
user memory limit, but close to the kmem limit. I am going to fix this in a
separate patch-set, but currently it is only worthwhile setting the kmem limit
to be greater than the user mem limit just to enable per-memcg slab accounting
and reclaim.

The patch-set is based on top of Linux-3.13-rc4 and organized as follows:
 - patches 1-11 prepare vmscan, memcontrol, list_lru to kmemcg reclaim;
 - patches 12, 13 implement the kmemcg reclaim core;
 - patch 14 makes the list_lru struct per-memcg and patch 15 marks the
   super_block shrinker as memcg-aware;
 - patches 16-18 slightly improve memcontrol behavior regarding mem reclaim.

Changes in v14:
 - do not change list_lru interface, introduce new shrink functions instead;
 - remove NUMA awareness from per-memcg LRUs;
 - improve synchronization between list_lru creation and kmemcg activation;
 - various small fixes/improvements and code cleanup.

Previous iterations of this patch-set can be found here:
 - https://lkml.org/lkml/2013/12/9/103 (v13)
 - https://lkml.org/lkml/2013/12/2/141 (v12)
 - https://lkml.org/lkml/2013/11/25/214 (v11)

Thanks.

Glauber Costa (7):
  memcg: make cache index determination more robust
  memcg: consolidate callers of memcg_cache_id
  memcg: move initialization to memcg creation
  vmscan: take at least one pass with shrinkers
  vmpressure: in-kernel notifications
  memcg: reap dead memcgs upon global memory pressure
  memcg: flush memcg items upon memcg destruction

Vladimir Davydov (11):
  memcg: make for_each_mem_cgroup macros public
  memcg: remove KMEM_ACCOUNTED_ACTIVATED flag
  memcg: rework memcg_update_kmem_limit synchronization
  list_lru, shrinkers: introduce list_lru_shrink_{count,walk}
  fs: consolidate {nr,free}_cached_objects args in shrink_control
  vmscan: move call to shrink_slab() to shrink_zones()
  vmscan: remove shrink_control arg from do_try_to_free_pages()
  vmscan: call NUMA-unaware shrinkers irrespective of nodemask
  vmscan: shrink slab on memcg pressure
  list_lru: add per-memcg lists
  fs: make shrinker memcg aware

 fs/dcache.c                |   14 +-
 fs/gfs2/quota.c            |    6 +-
 fs/inode.c                 |    7 +-
 fs/internal.h              |    7 +-
 fs/super.c                 |   34 ++-
 fs/xfs/xfs_buf.c           |    7 +-
 fs/xfs/xfs_qm.c            |    7 +-
 fs/xfs/xfs_super.c         |    7 +-
 include/linux/fs.h         |    6 +-
 include/linux/list_lru.h   |  112 +++++++--
 include/linux/memcontrol.h |   50 ++++
 include/linux/shrinker.h   |   10 +-
 include/linux/vmpressure.h |    5 +
 mm/list_lru.c              |  257 +++++++++++++++++--
 mm/memcontrol.c            |  584 ++++++++++++++++++++++++++++++++------------
 mm/vmpressure.c            |   53 +++-
 mm/vmscan.c                |  170 ++++++++-----
 17 files changed, 1017 insertions(+), 319 deletions(-)

-- 
1.7.10.4
