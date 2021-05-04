From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] mm: memcg/slab: Properly set up gfp flags for
 objcg pointer array
Date: Tue, 4 May 2021 12:37:18 -0700
Message-ID: <CALvZod438=YKZtV0qckoaMkdL1seu5PiLnvPPQyRzA0S60-TpQ@mail.gmail.com>
References: <20210504132350.4693-1-longman@redhat.com> <20210504132350.4693-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=btYsPAMNSGmXffsSk7+VR60HmUlYSHIt+oz7jjLh4E8=;
        b=qm3h49sUOH2s6tvF7KNhGDE1XdJRjRppqoGSbXNvcIvjPgsmygPRL+Huz/bo6LwJJk
         /0FRs5hMe3DuFnhdCHSW6+PF81z+rW7Yt1/7pBaFsY8xruoFVGCDcCF3ric6+eGNMf26
         QJi7EdjlGvaBNdL89o5778YfWQd2Lkstsx85AT0wSngk1QGxewfEqdZBOCTYlqRsu9jH
         X9EGZsayyWCKd39XPQumXqjjs0V/gicwgCK+mb4TGO6nhk+gLJK9zX6SjCWoDh5tJOWU
         viTvPxRimjGbUel53oqUg7BoKFeJM8s4RDOXTvYSemwmre0bTiaM5Gf4FCkfmH0nKTmb
         m5Dg==
In-Reply-To: <20210504132350.4693-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, May 4, 2021 at 6:24 AM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Since the merging of the new slab memory controller in v5.9, the page
> structure may store a pointer to obj_cgroup pointer array for slab pages.
> Currently, only the __GFP_ACCOUNT bit is masked off. However, the array
> is not readily reclaimable and doesn't need to come from the DMA buffer.
> So those GFP bits should be masked off as well.
>
> Do the flag bit clearing at memcg_alloc_page_obj_cgroups() to make sure
> that it is consistently applied no matter where it is called.
>
> Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 8 ++++++++
>  mm/slab.h       | 1 -
>  2 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c100265dc393..5e3b4f23b830 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2863,6 +2863,13 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
>  }
>
>  #ifdef CONFIG_MEMCG_KMEM
> +/*
> + * The allocated objcg pointers array is not accounted directly.
> + * Moreover, it should not come from DMA buffer and is not readily
> + * reclaimable. So those GFP bits should be masked off.
> + */
> +#define OBJCGS_CLEAR_MASK      (__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)

What about __GFP_DMA32? Does it matter? It seems like DMA32 requests
go to normal caches.

> +
>  int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>                                  gfp_t gfp, bool new_page)
>  {
> @@ -2870,6 +2877,7 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>         unsigned long memcg_data;
>         void *vec;
>
> +       gfp &= ~OBJCGS_CLEAR_MASK;
>         vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
>                            page_to_nid(page));
>         if (!vec)
> diff --git a/mm/slab.h b/mm/slab.h
> index 18c1927cd196..b3294712a686 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -309,7 +309,6 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
>         if (!memcg_kmem_enabled() || !objcg)
>                 return;
>
> -       flags &= ~__GFP_ACCOUNT;
>         for (i = 0; i < size; i++) {
>                 if (likely(p[i])) {
>                         page = virt_to_head_page(p[i]);
> --
> 2.18.1
>
