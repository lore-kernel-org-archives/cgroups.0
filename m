From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 0/3] mm: memcg/slab: Fix objcg pointer array handling problem
Date: Wed,  5 May 2021 16:06:07 -0400
Message-ID: <20210505200610.13943-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620245199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=JUmGq2wlaOeze3MXhpw6Yda3Y4YIjTKC44x0gDwnWr8=;
        b=BRvbfE4NJaCRq2Eg2RlHMirR/wrFOsXAaMnUXM/Zm8lO1RzgiahgTDTGcHiC1c3YEk9yuJ
        i044HOpMLuV+fz78uH9lrz9To1Vwubq7XH48HPQiTt3S7qpbsbeHeg6DJmzZrM7GZJ3ash
        6nR2VYN0kpV0DIU9DpuO5S9gjnCMwSs=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Waiman Long <longman@redhat.com>

 v4:
  - Incorporate suggestions from others like setting SLAB_ACCOUNT for
    KMALLOC_CGROUP caches into patch 2.
  - Add a new patch 3 to disable caches merging for KMALLOC_NORMAL caches
    as suggested by Roman.

 v3:
  - Update patch 2 commit log and rework kmalloc_type() to make it easier
    to read.

 v2:
  - Take suggestion from Vlastimil to use a new set of kmalloc-cg-* to
    handle the objcg pointer array allocation and freeing problems.

Since the merging of the new slab memory controller in v5.9,
the page structure stores a pointer to objcg pointer array for
slab pages. When the slab has no used objects, it can be freed in
free_slab() which will call kfree() to free the objcg pointer array in
memcg_alloc_page_obj_cgroups(). If it happens that the objcg pointer
array is the last used object in its slab, that slab may then be freed
which may caused kfree() to be called again.

With the right workload, the slab cache may be set up in a way that
allows the recursive kfree() calling loop to nest deep enough to
cause a kernel stack overflow and panic the system. In fact, we have
a reproducer that can cause kernel stack overflow on a s390 system
involving kmalloc-rcl-256 and kmalloc-rcl-128 slabs with the following
kfree() loop recursively called 74 times:

  [  285.520739]  [<000000000ec432fc>] kfree+0x4bc/0x560
  [  285.520740]  [<000000000ec43466>] __free_slab+0xc6/0x228
  [  285.520741]  [<000000000ec41fc2>] __slab_free+0x3c2/0x3e0
  [  285.520742]  [<000000000ec432fc>] kfree+0x4bc/0x560
					:
While investigating this issue, I also found an issue on the allocation
side. If the objcg pointer array happen to come from the same slab or
a circular dependency linkage is formed with multiple slabs, those
affected slabs can never be freed again.

This patch series addresses these two issues by introducing a new
set of kmalloc-cg-<n> caches split from kmalloc-<n> caches. The new
set will only contain non-reclaimable and non-dma objects that are
accounted in memory cgroups whereas the old set are now for unaccounted
objects only. By making this split, all the objcg pointer arrays will
come from the kmalloc-<n> caches, but those caches will never hold any
objcg pointer array. As a result, deeply nested kfree() call and the
unfreeable slab problems are now gone.

Waiman Long (3):
  mm: memcg/slab: Properly set up gfp flags for objcg pointer array
  mm: memcg/slab: Create a new set of kmalloc-cg-<n> caches
  mm: memcg/slab: Disable cache merging for KMALLOC_NORMAL caches

 include/linux/slab.h | 41 ++++++++++++++++++++++++++++++++---------
 mm/memcontrol.c      |  8 ++++++++
 mm/slab.h            |  1 -
 mm/slab_common.c     | 32 ++++++++++++++++++++++++--------
 4 files changed, 64 insertions(+), 18 deletions(-)

-- 
2.18.1

