From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v3 00/16] slab accounting for memcg
Date: Tue, 18 Sep 2012 18:11:54 +0400
Message-ID: <1347977530-29755-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This is a followup to the previous kmem series. I divided them logically
so it gets easier for reviewers. But I believe they are ready to be merged
together (although we can do a two-pass merge if people would prefer)

Throwaway git tree found at:

	git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git kmemcg-slab

There are mostly bugfixes since last submission.

For a detailed explanation about this series, please refer to my previous post
(Subj: [PATCH v3 00/13] kmem controller for memcg.)


Glauber Costa (16):
  slab/slub: struct memcg_params
  slub: use free_page instead of put_page for freeing kmalloc
    allocation
  slab: Ignore the cflgs bit in cache creation
  provide a common place for initcall processing in kmem_cache
  consider a memcg parameter in kmem_create_cache
  memcg: infrastructure to match an allocation to the right cache
  memcg: skip memcg kmem allocations in specified code regions
  slab: allow enable_cpu_cache to use preset values for its tunables
  sl[au]b: always get the cache from its page in kfree
  sl[au]b: Allocate objects from memcg cache
  memcg: destroy memcg caches
  memcg/sl[au]b Track all the memcg children of a kmem_cache.
  slab: slab-specific propagation changes.
  slub: slub-specific propagation changes.
  memcg/sl[au]b: shrink dead caches
  Add documentation about the kmem controller

 Documentation/cgroups/memory.txt |  73 ++++++-
 include/linux/memcontrol.h       |  60 ++++++
 include/linux/sched.h            |   1 +
 include/linux/slab.h             |  23 +++
 include/linux/slab_def.h         |   4 +
 include/linux/slub_def.h         |  18 +-
 init/Kconfig                     |   2 +-
 mm/memcontrol.c                  | 403 +++++++++++++++++++++++++++++++++++++++
 mm/slab.c                        |  70 ++++++-
 mm/slab.h                        |  72 ++++++-
 mm/slab_common.c                 |  85 ++++++++-
 mm/slob.c                        |   5 +
 mm/slub.c                        |  54 ++++--
 13 files changed, 829 insertions(+), 41 deletions(-)

-- 
1.7.11.4
