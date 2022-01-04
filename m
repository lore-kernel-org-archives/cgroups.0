From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH v4 00/32] Separate struct slab from struct page
Date: Tue,  4 Jan 2022 01:10:14 +0100
Message-ID: <20220104001046.12263-1-vbabka@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641255052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=UXaf9uC0yYgj8UoQwGZWBVf6JmBt0lJxsQgnWsQtcO0=;
        b=n8krX/PrPub0SVsre8/SLQeYX7KXQf8NLCLV+ubPTYlNtzwfTORfM69IFQNUzPIw96r+Po
        tqSOOJN8G1pRG530VEH8zjbtcFeAmXqAd4Plfgm0l0vDsd0KmiO+RgECWLaM8rG+P84tnk
        grdo1L2ebGheuMHUt2WmsNiU/JyCh6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641255052;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=UXaf9uC0yYgj8UoQwGZWBVf6JmBt0lJxsQgnWsQtcO0=;
        b=qOgAdn94Q/fmsGBLoCURpJT9EZ0mYFI07sEPdvOZS5/ZZqjR9DuZMgdTvudMcROeKLTkuj
        kxJEAne9s3HcrXDg==
X-Developer-Signature: v=1; a=openpgp-sha256; l=6877; h=from:subject; bh=eOU73DU2R3hiX6ZTz0IVJqWoxCtxeG917wETQZKQato=; b=owEBbQGS/pANAwAIAeAhynPxiakQAcsmYgBh05Bpj4k8YTH2hlMn7F5iXTAu0XxQ385rOPwcQkTF VOpOIdaJATMEAAEIAB0WIQSNS5MBqTXjGL5IXszgIcpz8YmpEAUCYdOQaQAKCRDgIcpz8YmpEK41B/ 91il7ZCibzyFB9paEVEvC5Hoh3WWOJx5XAPHsslQF7ojSGH2mztLJnOahhjZpSC+AzQbu0BrhbbGK9 sv3Y/MSnYu13NrbzAlUEDB6Unya8GQ3H5u4zGdTVtcOmjMpQ5djzk/YCPIRMm4UeMNM4kR6LVIx6RY Cdh4UCrVVVlqMnMKaPVCb9Wx07ghgYwhJezqttD5RYhS68vnoeAaPkmT1/pFOQHvbyz62Z3COZS8/K NxSbN1iLkyVrx4i6zmlbwE//4MVVFxF4PXTidKHDhuZzrEQGsQIjkHJn9ZhnpndCVdAN5voaK04IpF HdSm1x5ApsAOXQg9lB4o6ipOG9FNT8
X-Developer-Key: i=vbabka-AlSwsSmVLrQ@public.gmane.org; a=openpgp; fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrey Konovalov <andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Julia Lawall <julia.lawall-MZpvjPyXg2s@public.gmane.org>, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mi

Folks from non-slab subsystems are Cc'd only to patches affecting them, and
this cover letter.

Series also available in git, based on 5.16-rc6:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slab-struct_slab-v4r2

The plan is to submit as pull request, the previous versions have been
in linux-next since v2 early December. This v4 was in linux-next since
Dec 22:
https://lore.kernel.org/all/f3a83708-3f3c-a634-7bee-dcfcaaa7f36e-AlSwsSmVLrQ@public.gmane.org/
I planned to post it on mailing list for any final review in January, so
this is it. Added only reviewed/tested tags from Hyeonggon Yoo
meahwhile.

Changes from v3:
https://lore.kernel.org/all/4c3dfdfa-2e19-a9a7-7945-3d75bc87ca05-AlSwsSmVLrQ@public.gmane.org/
- rebase to 5.16-rc6 to avoid a conflict with mainline
- collect acks/reviews/tested-by from Johannes, Roman, Hyeonggon Yoo -
thanks!
- in patch "mm/slub: Convert detached_freelist to use a struct slab"
renamed free_nonslab_page() to free_large_kmalloc() and use folio there,
as suggested by Roman
- in "mm/memcg: Convert slab objcgs from struct page to struct slab"
change one caller of slab_objcgs_check() to slab_objcgs() as suggested
by Johannes, realize the other caller should be also changed, and remove
slab_objcgs_check() completely.

Initial version from Matthew Wilcox:
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

Hyeonggon Yoo (1):
  mm/slob: Remove unnecessary page_mapcount_reset() function call

Matthew Wilcox (Oracle) (14):
  mm: Split slab into its own type
  mm: Convert [un]account_slab_page() to struct slab
  mm: Convert virt_to_cache() to use struct slab
  mm: Convert __ksize() to struct slab
  mm: Use struct slab in kmem_obj_info()
  mm: Convert check_heap_object() to use struct slab
  mm/slub: Convert detached_freelist to use a struct slab
  mm/slub: Convert kfree() to use a struct slab
  mm/slub: Convert print_page_info() to print_slab_info()
  mm/slub: Convert pfmemalloc_match() to take a struct slab
  mm/slob: Convert SLOB to use struct slab and struct folio
  mm/kasan: Convert to struct folio and struct slab
  zsmalloc: Stop using slab fields in struct page
  bootmem: Use page->index instead of page->freelist

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

 arch/x86/mm/init_64.c        |    2 +-
 include/linux/bootmem_info.h |    2 +-
 include/linux/kasan.h        |    9 +-
 include/linux/memcontrol.h   |   48 --
 include/linux/mm.h           |   12 +
 include/linux/mm_types.h     |   10 +-
 include/linux/slab.h         |    8 -
 include/linux/slab_def.h     |   16 +-
 include/linux/slub_def.h     |   29 +-
 mm/bootmem_info.c            |    7 +-
 mm/kasan/common.c            |   27 +-
 mm/kasan/generic.c           |    8 +-
 mm/kasan/kasan.h             |    1 +
 mm/kasan/quarantine.c        |    2 +-
 mm/kasan/report.c            |   13 +-
 mm/kasan/report_tags.c       |   10 +-
 mm/kfence/core.c             |   17 +-
 mm/kfence/kfence_test.c      |    6 +-
 mm/memcontrol.c              |   47 +-
 mm/slab.c                    |  456 +++++++------
 mm/slab.h                    |  305 +++++++--
 mm/slab_common.c             |   14 +-
 mm/slob.c                    |   62 +-
 mm/slub.c                    | 1177 +++++++++++++++++-----------------
 mm/sparse.c                  |    2 +-
 mm/usercopy.c                |   13 +-
 mm/zsmalloc.c                |   18 +-
 27 files changed, 1263 insertions(+), 1058 deletions(-)

-- 
2.34.1

