From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v2 00/33] Separate struct slab from struct page
Date: Wed,  1 Dec 2021 19:14:37 +0100
Message-ID: <20211201181510.18784-1-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
 t=1638382515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
 bh=JudYALEd+vfrSbydk9WzA1a8Jbja5L0uMhSJtIDczwA=;
 b=UaIAD/rhRvykk/vdhz8EgwhBknGbHwV3ROKoan/VHmnMLq2d3F9E0nHpl84fbfjnDrF2jB
 vRCalgCkl6G8SSsqhjhAnCOauXho6h7TjGkiOqubtDxd4KvxmoncjPwnmFp3ytRgpC1LHU
 GtneAXQvWmNKW2BX5O7pCzpcZvMvxB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
 s=susede2_ed25519; t=1638382515;
 h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
 mime-version:mime-version: content-transfer-encoding:content-transfer-encoding;
 bh=JudYALEd+vfrSbydk9WzA1a8Jbja5L0uMhSJtIDczwA=;
 b=B9QhHHVarkGXSXnYR5XJI3OxatgPELHKl3z1mjSspeFn3QBIu3843VrZ+6nfE6068UqAWW
 nVtNpPgokA2RaWBg==
X-Developer-Signature: v=1; a=openpgp-sha256; l=6884; h=from:subject;
 bh=C9Y/49TsxB/E0akYUQmXh/Rw3x/uvjRHIGWgJWjz1iY=;
 b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBhp7tbz3TdAfpYMhghWpBPjpyNQELQnNXbCWvxjXXW
 V+khgIGJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYae7WwAKCRDgIcpz8YmpEL55B/
 0YVOB9lFU4Yo+9QGDna3BPOOTGFYoU+NhN1HU+HWaN4/METjmHzL6QTkZey7Vf/iUopoghro1cTifZ
 VJ0movi8ZzLs2CGqHCSXxycHOUjYhJga97oHj5g228ilwmOxRvwbltPZf/4Dq1GsHNPvA519rK17Mb
 FAtSBH05pG6994CDDcdJ87Ml2jM1WOYqIznymTYUQcDxcdqenLbyIZ6iYkLNZlWM6eHSMaZTuIZhJ4
 5EobcLpyHXjVaQh30br8NhlSFQwc2JsF/S1x4wdWfs7uLnGix90NeTfKlxxOoK5pScmDEnNMYULCHG
 qssJrZ/85aCJE+jQj+N/wBkMCp87Jl
X-Developer-Key: i=vbabka-AlSwsSmVLrQ@public.gmane.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Folks from non-slab subsystems are Cc'd only to patches affecting them, and
this cover letter.

Series also available in git, based on 5.16-rc3:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v2r2

The plan: as my SLUB PREEMPT_RT series in 5.15, I would prefer to go again with
the git pull request way of eventually merging this, as it's also not a small
series. I will thus reply to this mail with asking to include my branch in
linux-next.

As stated in the v1/RFC cover letter, I wouldn't mind to then continue with
maintaining a git tree for all slab patches in general. It was apparently
already done that way before, by Pekka:
https://lore.kernel.org/linux-mm/alpine.DEB.2.00.1107221108190.2996@tiger/

Changes from v1/RFC:
https://lore.kernel.org/all/20211116001628.24216-1-vbabka-AlSwsSmVLrQ@public.gmane.org/
- Added virt_to_folio() and folio_address() in the new Patch 1.
- Addressed feedback from Andrey Konovalov and Matthew Wilcox (Thanks!)
- Added Tested-by: Marco Elver for the KFENCE parts (Thanks!)

Previous version from Matthew Wilcox:
https://lore.kernel.org/all/20211004134650.4031813-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org/

LWN coverage of the above:
https://lwn.net/Articles/871982/

This is originally an offshoot of the folio work by Matthew. One of the more
complex parts of the struct page definition are the parts used by the slab
allocators. It would be good for the MM in general if struct slab were its own
data type, and it also helps to prevent tail pages from slipping in anywhere.
As Matthew requested in his proof of concept series, I have taken over the
development of this series, so it's a mix of patches from him (often modified
by me) and my own.

One big difference is the use of coccinelle to perform the relatively trivial
parts of the conversions automatically and at once, instead of a larger number
of smaller incremental reviewable steps. Thanks to Julia Lawall and Luis
Chamberlain for all their help!

Another notable difference is (based also on review feedback) I don't represent
with a struct slab the large kmalloc allocations which are not really a slab,
but use page allocator directly. When going from an object address to a struct
slab, the code tests first folio slab flag, and only if it's set it converts to
struct slab. This makes the struct slab type stronger.

Finally, although Matthew's version didn't use any of the folio work, the
initial support has been merged meanwhile so my version builds on top of it
where appropriate. This eliminates some of the redundant compound_head()
being performed e.g. when testing the slab flag.

To sum up, after this series, struct page fields used by slab allocators are
moved from struct page to a new struct slab, that uses the same physical
storage. The availability of the fields is further distinguished by the
selected slab allocator implementation. The advantages include:

- Similar to folios, if the slab is of order > 0, struct slab always is
  guaranteed to be the head page. Additionally it's guaranteed to be an actual
  slab page, not a large kmalloc. This removes uncertainty and potential for
  bugs.
- It's not possible to accidentally use fields of the slab implementation that's
  not configured.
- Other subsystems cannot use slab's fields in struct page anymore (some
  existing non-slab usages had to be adjusted in this series), so slab
  implementations have more freedom in rearranging them in the struct slab.

Matthew Wilcox (Oracle) (16):
  mm: Split slab into its own type
  mm: Add account_slab() and unaccount_slab()
  mm: Convert virt_to_cache() to use struct slab
  mm: Convert __ksize() to struct slab
  mm: Use struct slab in kmem_obj_info()
  mm: Convert check_heap_object() to use struct slab
  mm/slub: Convert detached_freelist to use a struct slab
  mm/slub: Convert kfree() to use a struct slab
  mm/slub: Convert print_page_info() to print_slab_info()
  mm/slub: Convert pfmemalloc_match() to take a struct slab
  mm/slob: Convert SLOB to use struct slab
  mm/kasan: Convert to struct folio and struct slab
  zsmalloc: Stop using slab fields in struct page
  bootmem: Use page->index instead of page->freelist
  iommu: Use put_pages_list
  mm: Remove slab from struct page

Vlastimil Babka (17):
  mm: add virt_to_folio() and folio_address()
  mm/slab: Dissolve slab_map_pages() in its caller
  mm/slub: Make object_err() static
  mm/slub: Convert __slab_lock() and __slab_unlock() to struct slab
  mm/slub: Convert alloc_slab_page() to return a struct slab
  mm/slub: Convert __free_slab() to use struct slab
  mm/slub: Convert most struct page to struct slab by spatch
  mm/slub: Finish struct page to struct slab conversion
  mm/slab: Convert kmem_getpages() and kmem_freepages() to struct slab
  mm/slab: Convert most struct page to struct slab by spatch
  mm/slab: Finish struct page to struct slab conversion
  mm: Convert struct page to struct slab in functions used by other
    subsystems
  mm/memcg: Convert slab objcgs from struct page to struct slab
  mm/kfence: Convert kfence_guarded_alloc() to struct slab
  mm/sl*b: Differentiate struct slab fields by sl*b implementations
  mm/slub: Simplify struct slab slabs field definition
  mm/slub: Define struct slab fields for CONFIG_SLUB_CPU_PARTIAL only
    when enabled

 arch/x86/mm/init_64.c          |    2 +-
 drivers/iommu/amd/io_pgtable.c |   59 +-
 drivers/iommu/dma-iommu.c      |   11 +-
 drivers/iommu/intel/iommu.c    |   89 +--
 include/linux/bootmem_info.h   |    2 +-
 include/linux/iommu.h          |    3 +-
 include/linux/kasan.h          |    9 +-
 include/linux/memcontrol.h     |   48 --
 include/linux/mm.h             |   12 +
 include/linux/mm_types.h       |   38 +-
 include/linux/page-flags.h     |   37 -
 include/linux/slab.h           |    8 -
 include/linux/slab_def.h       |   16 +-
 include/linux/slub_def.h       |   29 +-
 mm/bootmem_info.c              |    7 +-
 mm/kasan/common.c              |   27 +-
 mm/kasan/generic.c             |    8 +-
 mm/kasan/kasan.h               |    1 +
 mm/kasan/quarantine.c          |    2 +-
 mm/kasan/report.c              |   13 +-
 mm/kasan/report_tags.c         |   10 +-
 mm/kfence/core.c               |   17 +-
 mm/kfence/kfence_test.c        |    6 +-
 mm/memcontrol.c                |   43 +-
 mm/slab.c                      |  455 ++++++-------
 mm/slab.h                      |  322 ++++++++-
 mm/slab_common.c               |    8 +-
 mm/slob.c                      |   46 +-
 mm/slub.c                      | 1164 ++++++++++++++++----------------
 mm/sparse.c                    |    2 +-
 mm/usercopy.c                  |   13 +-
 mm/zsmalloc.c                  |   18 +-
 32 files changed, 1317 insertions(+), 1208 deletions(-)

-- 
2.33.1
