From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v4 7/7] mm: fix /proc/kpagecgroup interface for slab pages
Date: Tue, 14 May 2019 17:16:19 -0700
Message-ID: <CALvZod5sPsvUCLS1Ud0sW=n+UoJb=DR5LbmMJKRhUeUoi+=64w@mail.gmail.com>
References: <20190514213940.2405198-1-guro@fb.com> <20190514213940.2405198-8-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n6UubTu1HxL5JVqa4cIS4IiqN2UOsI0+Vavy5s5bkSQ=;
        b=Ii41x4BPQ69+lEiDQCtrEuc+lF56MxJAe2Nu9E3XbvbR4rUAzOZNAXuAlZRNS6P1H0
         g1yyCvGfKBvZs2+YsXBIRXAAt9TKkYkQT8esPIAPxIMrzkMFFDmkcCGxuibr51tDIoEf
         hOvtu0p5Qti7QFT1qMeD2cxKaHTYxfMIvR16MTXd+gcnStMT2TE8onV6SNVb465wsnXH
         wJp8kOMWTtX8IzL1/yOc8GesomdBPegBNpb3c6rVynA4KMxgNmF6NSTnPBOPUCewSG7b
         unooTfA0p8UWmIEaIJ3dtmy1DpodFr7a94oCGmib2FAfj7Xgdla1FlVXjyqxjZB9wq8E
         /Ang==
In-Reply-To: <20190514213940.2405198-8-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Christoph Lameter <cl@linux.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>

From: Roman Gushchin <guro@fb.com>
Date: Tue, May 14, 2019 at 2:54 PM
To: Andrew Morton, Shakeel Butt
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
<kernel-team@fb.com>, Johannes Weiner, Michal Hocko, Rik van Riel,
Christoph Lameter, Vladimir Davydov, <cgroups@vger.kernel.org>, Roman
Gushchin

> Switching to an indirect scheme of getting mem_cgroup pointer for
> !root slab pages broke /proc/kpagecgroup interface for them.
>
> Let's fix it by learning page_cgroup_ino() how to get memcg
> pointer for slab pages.
>
> Reported-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

> ---
>  mm/memcontrol.c  |  5 ++++-
>  mm/slab.h        | 25 +++++++++++++++++++++++++
>  mm/slab_common.c |  1 +
>  3 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0655639433ed..9b2413c2e9ea 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -494,7 +494,10 @@ ino_t page_cgroup_ino(struct page *page)
>         unsigned long ino = 0;
>
>         rcu_read_lock();
> -       memcg = READ_ONCE(page->mem_cgroup);
> +       if (PageHead(page) && PageSlab(page))
> +               memcg = memcg_from_slab_page(page);
> +       else
> +               memcg = READ_ONCE(page->mem_cgroup);
>         while (memcg && !(memcg->css.flags & CSS_ONLINE))
>                 memcg = parent_mem_cgroup(memcg);
>         if (memcg)
> diff --git a/mm/slab.h b/mm/slab.h
> index 7ba50e526d82..50fa534c0fc0 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -256,6 +256,26 @@ static inline struct kmem_cache *memcg_root_cache(struct kmem_cache *s)
>         return s->memcg_params.root_cache;
>  }
>
> +/*
> + * Expects a pointer to a slab page. Please note, that PageSlab() check
> + * isn't sufficient, as it returns true also for tail compound slab pages,
> + * which do not have slab_cache pointer set.
> + * So this function assumes that the page can pass PageHead() and PageSlab()
> + * checks.
> + */
> +static inline struct mem_cgroup *memcg_from_slab_page(struct page *page)
> +{
> +       struct kmem_cache *s;
> +
> +       WARN_ON_ONCE(!rcu_read_lock_held());
> +
> +       s = READ_ONCE(page->slab_cache);
> +       if (s && !is_root_cache(s))
> +               return rcu_dereference(s->memcg_params.memcg);
> +
> +       return NULL;
> +}
> +
>  /*
>   * Charge the slab page belonging to the non-root kmem_cache.
>   * Can be called for non-root kmem_caches only.
> @@ -353,6 +373,11 @@ static inline struct kmem_cache *memcg_root_cache(struct kmem_cache *s)
>         return s;
>  }
>
> +static inline struct mem_cgroup *memcg_from_slab_page(struct page *page)
> +{
> +       return NULL;
> +}
> +
>  static inline int memcg_charge_slab(struct page *page, gfp_t gfp, int order,
>                                     struct kmem_cache *s)
>  {
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 354762394162..9d2a3d6245dc 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -254,6 +254,7 @@ static void memcg_unlink_cache(struct kmem_cache *s)
>                 list_del(&s->memcg_params.kmem_caches_node);
>                 mem_cgroup_put(rcu_dereference_protected(s->memcg_params.memcg,
>                         lockdep_is_held(&slab_mutex)));
> +               rcu_assign_pointer(s->memcg_params.memcg, NULL);
>         }
>  }
>  #else
> --
> 2.20.1
>
