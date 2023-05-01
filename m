From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/40] Memory allocation profiling
Date: Mon,  1 May 2023 09:54:10 -0700
Message-ID: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960107; x=1685552107;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rhc7v9a1uLQqVXD+LsRhZoVqkW3m5tSXn3Qy4JSVLy4=;
        b=IEVlqTozWZGbWgkZmckzilH6j94QhJZoZIuPp60mSUj0QVW0m+a9iMmfCAF4iEpfZD
         fEVgO/+vOkTtFhBvoHwlDMAL3hxDH/zLipyU3ktDF8+bB/itGjow8f+dbDn1CDMFDOyk
         cTiZv7/V3hTMTCajMzvTdbVUzBNML97dt0BYpiR6UOH9nLt1/l6QL7QOhPtZ51dB47eW
         B6R13UEA02ZiLSfNlDL/QxOcvfA6sC1wmjwPXFvrSUoT7FHGOeimYmfVTl3MVQzN5BdG
         VU1/9ubcznfSn4RmyJ2/Vw+B4mgfyn6L75+s8Kx83oYGWWn0RADQAOUF0mZI8SYEht0a
         Cq7g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

Memory allocation profiling infrastructure provides a low overhead
mechanism to make all kernel allocations in the system visible. It can be
used to monitor memory usage, track memory hotspots, detect memory leaks,
identify memory regressions.

To keep the overhead to the minimum, we record only allocation sizes for
every allocation in the codebase. With that information, if users are
interested in more detailed context for a specific allocation, they can
enable in-depth context tracking, which includes capturing the pid, tgid,
task name, allocation size, timestamp and call stack for every allocation
at the specified code location.

The data is exposed to the user space via a read-only debugfs file called
allocations. Usage example:

$ sort -hr /sys/kernel/debug/allocations|head
  153MiB     8599 mm/slub.c:1826 module:slub func:alloc_slab_page
 6.08MiB      49 mm/slab_common.c:950 module:slab_common func:_kmalloc_order
 5.09MiB     6335 mm/memcontrol.c:2814 module:memcontrol func:alloc_slab_obj_exts
 4.54MiB      78 mm/page_alloc.c:5777 module:page_alloc func:alloc_pages_exact
 1.32MiB      338 include/asm-generic/pgalloc.h:63 module:pgtable func:__pte_alloc_one
 1.16MiB      603 fs/xfs/xfs_log_priv.h:700 module:xfs func:xlog_kvmalloc
 1.00MiB      256 mm/swap_cgroup.c:48 module:swap_cgroup func:swap_cgroup_prepare
  734KiB     5380 fs/xfs/kmem.c:20 module:xfs func:kmem_alloc
  640KiB      160 kernel/rcu/tree.c:3184 module:tree func:fill_page_cache_func
  640KiB      160 drivers/char/virtio_console.c:452 module:virtio_console func:alloc_buf

For allocation context capture, a new debugfs file called allocations.ctx
is used to select which code location should capture allocation context
and to read captured context information. Usage example:

$ cd /sys/kernel/debug/
$ echo "file include/asm-generic/pgalloc.h line 63 enable" > allocations.ctx
$ cat allocations.ctx
  920KiB      230 include/asm-generic/pgalloc.h:63 module:pgtable func:__pte_alloc_one
    size: 4096
    pid: 1474
    tgid: 1474
    comm: bash
    ts: 175332940994
    call stack:
         pte_alloc_one+0xfe/0x130
         __pte_alloc+0x22/0xb0
         copy_page_range+0x842/0x1640
         dup_mm+0x42d/0x580
         copy_process+0xfb1/0x1ac0
         kernel_clone+0x92/0x3e0
         __do_sys_clone+0x66/0x90
         do_syscall_64+0x38/0x90
         entry_SYSCALL_64_after_hwframe+0x63/0xcd
...

Implementation utilizes a more generic concept of code tagging, introduced
as part of this patchset. Code tag is a structure identifying a specific
location in the source code which is generated at compile time and can be
embedded in an application-specific structure. A number of applications
for code tagging have been presented in the original RFC [1].
Code tagging uses the old trick of "define a special elf section for
objects of a given type so that we can iterate over them at runtime" and
creates a proper library for it. 

To profile memory allocations, we instrument page, slab and percpu
allocators to record total memory allocated in the associated code tag at
every allocation in the codebase. Every time an allocation is performed by
an instrumented allocator, the code tag at that location increments its
counter by allocation size. Every time the memory is freed the counter is
decremented. To decrement the counter upon freeing, allocated object needs
a reference to its code tag. Page allocators use page_ext to record this
reference while slab allocators use memcg_data (renamed into more generic
slabobj_ext) of the slab page.

Module allocations are accounted the same way as other kernel allocations.
Module loading and unloading is supported. If a module is unloaded while
one or more of its allocations is still not freed (rather rare condition),
its data section will be kept in memory to allow later code tag
referencing when the allocation is freed later on.

As part of this series we introduce several kernel configs:
CODE_TAGGING - to enable code tagging framework
CONFIG_MEM_ALLOC_PROFILING - to enable memory allocation profiling
CONFIG_MEM_ALLOC_PROFILING_DEBUG - to enable memory allocation profiling
validation
Note: CONFIG_MEM_ALLOC_PROFILING enables CONFIG_PAGE_EXTENSION to store
code tag reference in the page_ext object. 

nomem_profiling kernel command-line parameter is also provided to disable
the functionality and avoid the performance overhead.
Performance overhead:
To evaluate performance we implemented an in-kernel test executing
multiple get_free_page/free_page and kmalloc/kfree calls with allocation
sizes growing from 8 to 240 bytes with CPU frequency set to max and CPU
affinity set to a specific CPU to minimize the noise. Below is performance
comparison between the baseline kernel, profiling when enabled, profiling
when disabled (nomem_profiling=y) and (for comparison purposes) baseline
with CONFIG_MEMCG_KMEM enabled and allocations using __GFP_ACCOUNT:

			kmalloc			pgalloc
Baseline (6.3-rc7)	9.200s			31.050s
profiling disabled	9.800 (+6.52%)		32.600 (+4.99%)
profiling enabled	12.500 (+35.87%)	39.010 (+25.60%)
memcg_kmem enabled	41.400 (+350.00%)	70.600 (+127.38%)

[1] https://lore.kernel.org/all/20220830214919.53220-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Kent Overstreet (15):
  lib/string_helpers: Drop space in string_get_size's output
  scripts/kallysms: Always include __start and __stop symbols
  fs: Convert alloc_inode_sb() to a macro
  nodemask: Split out include/linux/nodemask_types.h
  prandom: Remove unused include
  lib/string.c: strsep_no_empty()
  Lazy percpu counters
  lib: code tagging query helper functions
  mm/slub: Mark slab_free_freelist_hook() __always_inline
  mempool: Hook up to memory allocation profiling
  timekeeping: Fix a circular include dependency
  mm: percpu: Introduce pcpuobj_ext
  mm: percpu: Add codetag reference into pcpuobj_ext
  arm64: Fix circular header dependency
  MAINTAINERS: Add entries for code tagging and memory allocation
    profiling

Suren Baghdasaryan (25):
  mm: introduce slabobj_ext to support slab object extensions
  mm: introduce __GFP_NO_OBJ_EXT flag to selectively prevent slabobj_ext
    creation
  mm/slab: introduce SLAB_NO_OBJ_EXT to avoid obj_ext creation
  mm: prevent slabobj_ext allocations for slabobj_ext and kmem_cache
    objects
  slab: objext: introduce objext_flags as extension to
    page_memcg_data_flags
  lib: code tagging framework
  lib: code tagging module support
  lib: prevent module unloading if memory is not freed
  lib: add allocation tagging support for memory allocation profiling
  lib: introduce support for page allocation tagging
  change alloc_pages name in dma_map_ops to avoid name conflicts
  mm: enable page allocation tagging
  mm/page_ext: enable early_page_ext when
    CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
  mm: create new codetag references during page splitting
  lib: add codetag reference into slabobj_ext
  mm/slab: add allocation accounting into slab allocation and free paths
  mm/slab: enable slab allocation tagging for kmalloc and friends
  mm: percpu: enable per-cpu allocation tagging
  move stack capture functionality into a separate function for reuse
  lib: code tagging context capture support
  lib: implement context capture support for tagged allocations
  lib: add memory allocations report in show_mem()
  codetag: debug: skip objext checking when it's for objext itself
  codetag: debug: mark codetags for reserved pages as empty
  codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext
    allocations

 .../admin-guide/kernel-parameters.txt         |   2 +
 MAINTAINERS                                   |  22 +
 arch/arm64/include/asm/spectre.h              |   4 +-
 arch/x86/kernel/amd_gart_64.c                 |   2 +-
 drivers/iommu/dma-iommu.c                     |   2 +-
 drivers/xen/grant-dma-ops.c                   |   2 +-
 drivers/xen/swiotlb-xen.c                     |   2 +-
 include/asm-generic/codetag.lds.h             |  14 +
 include/asm-generic/vmlinux.lds.h             |   3 +
 include/linux/alloc_tag.h                     | 161 ++++++
 include/linux/codetag.h                       | 159 ++++++
 include/linux/codetag_ctx.h                   |  48 ++
 include/linux/dma-map-ops.h                   |   2 +-
 include/linux/fs.h                            |   6 +-
 include/linux/gfp.h                           | 123 ++--
 include/linux/gfp_types.h                     |  12 +-
 include/linux/hrtimer.h                       |   2 +-
 include/linux/lazy-percpu-counter.h           | 102 ++++
 include/linux/memcontrol.h                    |  56 +-
 include/linux/mempool.h                       |  73 ++-
 include/linux/mm.h                            |   8 +
 include/linux/mm_types.h                      |   4 +-
 include/linux/nodemask.h                      |   2 +-
 include/linux/nodemask_types.h                |   9 +
 include/linux/page_ext.h                      |   1 -
 include/linux/pagemap.h                       |   9 +-
 include/linux/percpu.h                        |  19 +-
 include/linux/pgalloc_tag.h                   |  95 ++++
 include/linux/prandom.h                       |   1 -
 include/linux/sched.h                         |  32 +-
 include/linux/slab.h                          | 182 +++---
 include/linux/slab_def.h                      |   2 +-
 include/linux/slub_def.h                      |   4 +-
 include/linux/stackdepot.h                    |  16 +
 include/linux/string.h                        |   1 +
 include/linux/time_namespace.h                |   2 +
 init/Kconfig                                  |   4 +
 kernel/dma/mapping.c                          |   4 +-
 kernel/module/main.c                          |  25 +-
 lib/Kconfig                                   |   3 +
 lib/Kconfig.debug                             |  26 +
 lib/Makefile                                  |   5 +
 lib/alloc_tag.c                               | 464 +++++++++++++++
 lib/codetag.c                                 | 529 ++++++++++++++++++
 lib/lazy-percpu-counter.c                     | 127 +++++
 lib/show_mem.c                                |  15 +
 lib/stackdepot.c                              |  68 +++
 lib/string.c                                  |  19 +
 lib/string_helpers.c                          |   3 +-
 mm/compaction.c                               |   9 +-
 mm/filemap.c                                  |   6 +-
 mm/huge_memory.c                              |   2 +
 mm/kfence/core.c                              |  14 +-
 mm/kfence/kfence.h                            |   4 +-
 mm/memcontrol.c                               |  56 +-
 mm/mempolicy.c                                |  30 +-
 mm/mempool.c                                  |  28 +-
 mm/mm_init.c                                  |   1 +
 mm/page_alloc.c                               |  75 ++-
 mm/page_ext.c                                 |  21 +-
 mm/page_owner.c                               |  54 +-
 mm/percpu-internal.h                          |  26 +-
 mm/percpu.c                                   | 122 ++--
 mm/slab.c                                     |  22 +-
 mm/slab.h                                     | 224 ++++++--
 mm/slab_common.c                              |  95 +++-
 mm/slub.c                                     |  24 +-
 mm/util.c                                     |  10 +-
 scripts/kallsyms.c                            |  13 +
 scripts/module.lds.S                          |   7 +
 70 files changed, 2765 insertions(+), 554 deletions(-)
 create mode 100644 include/asm-generic/codetag.lds.h
 create mode 100644 include/linux/alloc_tag.h
 create mode 100644 include/linux/codetag.h
 create mode 100644 include/linux/codetag_ctx.h
 create mode 100644 include/linux/lazy-percpu-counter.h
 create mode 100644 include/linux/nodemask_types.h
 create mode 100644 include/linux/pgalloc_tag.h
 create mode 100644 lib/alloc_tag.c
 create mode 100644 lib/codetag.c
 create mode 100644 lib/lazy-percpu-counter.c

-- 
2.40.1.495.gc816e09b53d-goog

