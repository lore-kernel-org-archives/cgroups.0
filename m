From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] mm: memcg/slab: Fix objcg pointer array handling problem
Date: Tue,  4 May 2021 09:23:48 -0400
Message-ID: <20210504132350.4693-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620134680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=w1fOeXoOxkv4q7kPVArjLqc2Z8NlzwfSU/aJlxE6T/s=;
        b=HoHJtsDLaD0C5UgP4WT5VdbJiUlMctOoALNmNAIWXhy0I2lXCLhYGql1vDC5LaTqCiFZ0v
        T9FT4UKBuPa3FEjOyu5YpHUFLocxrvvVanpXzHbzxBIHhbYNxuy7lxKkgkg0sbg7sGVu0r
        ALmxguUBkcSkHVjDbVqcDfO2xnZUvJY=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

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

Waiman Long (2):
  mm: memcg/slab: Properly set up gfp flags for objcg pointer array
  mm: memcg/slab: Create a new set of kmalloc-cg-<n> caches

 include/linux/slab.h | 15 +++++++++++++++
 mm/memcontrol.c      |  8 ++++++++
 mm/slab.h            |  1 -
 mm/slab_common.c     | 23 +++++++++++++++--------
 4 files changed, 38 insertions(+), 9 deletions(-)

-- 
2.18.1

