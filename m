From: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Subject: [PATCH v2 00/13] Memcg Kernel Memory Tracking.
Date: Fri,  9 Mar 2012 12:39:03 -0800
Message-ID: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>

This is v2 of my kernel memory tracking patchset for memcg.

Lots of changes based on feedback from Glauber and Kamezawa.
In particular, I changed it to be opt-in instead of opt-out:
In order for a slab type to be tracked, it has to be marked with
SLAB_MEMCG_ACCT at kmem_cache_create() time.
Currently, only dentries and kmalloc are tracked.

Planned for v3:
 - Slub support.
 - Using a static_branch to remove overhead when no cgroups have been
   created.
 - Getting rid of kmem_cache_get_ref/drop_ref pair in kmem_cache_free.

Detailed change list from v1 (http://marc.info/?l=linux-mm&m=133038361014525):
 - Fixed misspelling in documentation.
 - Added flags field to struct mem_cgroup.
 - Moved independent_kmem_limit into flags.
 - Renamed kmem_bytes to kmem.
 - Divided consume_stock changes into two changes.
 - Fixed crash at boot when not every commit is applied.
 - Moved the new fields in kmem_cache into their own struct.
 - Got rid of SLAB_MEMCG slab flag.
 - Dropped accounting to root.
 - Added css_id into memcg slab name.
 - Changed memcg cache creation to always be deferred to workqueue.
 - Replaced bypass_bytes with overcharging the cgroup.
 - Got rid of #ifdef CONFIG_SLAB from memcontrol.c.
 - Got rid of __GFP_NOACCOUNT, changing to an opt-in model.
 - Remove kmem limit when turning off independent limit.
 - Moved the accounting of kmalloc to its own patch.
 - Removed useless parameters from memcg_create_kmem_cache().
 - Get a ref to the css when enqueing cache for creation.
 - increased MAX_KMEM_CACHE_TYPES to 400.

Suleiman Souhlal (13):
  memcg: Consolidate various flags into a single flags field.
  memcg: Kernel memory accounting infrastructure.
  memcg: Uncharge all kmem when deleting a cgroup.
  memcg: Make it possible to use the stock for more than one page.
  memcg: Reclaim when more than one page needed.
  slab: Add kmem_cache_gfp_flags() helper function.
  memcg: Slab accounting.
  memcg: Make dentry slab memory accounted in kernel memory accounting.
  memcg: Account for kmalloc in kernel memory accounting.
  memcg: Track all the memcg children of a kmem_cache.
  memcg: Handle bypassed kernel memory charges.
  memcg: Per-memcg memory.kmem.slabinfo file.
  memcg: Document kernel memory accounting.

 Documentation/cgroups/memory.txt |   44 +++-
 fs/dcache.c                      |    4 +-
 include/linux/memcontrol.h       |   30 ++-
 include/linux/slab.h             |   56 ++++
 include/linux/slab_def.h         |   79 +++++-
 include/linux/slob_def.h         |    6 +
 include/linux/slub_def.h         |    9 +
 init/Kconfig                     |    2 +-
 mm/memcontrol.c                  |  633 ++++++++++++++++++++++++++++++++++---
 mm/slab.c                        |  431 +++++++++++++++++++++++---
 10 files changed, 1183 insertions(+), 111 deletions(-)

-- Suleiman
