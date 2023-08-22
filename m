From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v2] mm: vmscan: reclaim anon pages if there are swapcache pages
Date: Tue, 22 Aug 2023 09:35:44 -0700
Message-ID: <CAJD7tkZkYsopuqGH_Lo=kE4=HO33wmvK6mXhuq4p_KZ6pYuXtw@mail.gmail.com>
References: <20230822024901.2412520-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692722181; x=1693326981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1Og0p3YsszYT5eyrrRdHLABJeyVk3h/09oUuO+tzhE=;
        b=gDjUEyD73IAB7rXmTKqH6+glsZKCHbYebuG08TAomJFqxwmRCh9mwKKlMjNA+7IOQK
         HhueFesfKUdocFF9KJVJRMPyUYh5+s60/hD8HTL5/EayDayVWBwRX7w15bEpxAjBr1D+
         RlTqPsiABd8hN+dvwvSfoI2h0YMFhNtNF2RD4k39TRNWx1WbdsQ9FYVQiKuN9xYEy0Ki
         OzyzDs3rl7ChWcjUEvNH23dcUPRg2tzRqIGMjnoZnOIOhhClLW/dEwZ3JT8crBXDCAEe
         WGwU/VxQgVxOK4zS1x8A30TV4dtbZW/lV1r49ZmXV88m9Nj/DEG2P6+6XnrufjLIz9ev
         hArQ==
In-Reply-To: <20230822024901.2412520-1-liushixin2@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Liu Shixin <liushixin2@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Mon, Aug 21, 2023 at 6:54=E2=80=AFPM Liu Shixin <liushixin2@huawei.com> =
wrote:
>
> When spaces of swap devices are exhausted, only file pages can be reclaim=
ed.
> But there are still some swapcache pages in anon lru list. This can lead
> to a premature out-of-memory.
>
> This problem can be fixed by checking number of swapcache pages in
> can_reclaim_anon_pages(). For memcg v2, there are swapcache stat that can
> be used directly. For memcg v1, use total_swapcache_pages() instead, whic=
h
> may not accurate but can solve the problem.

Interesting find. I wonder if we really don't have any handling of
this situation.

>
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
>  include/linux/swap.h |  6 ++++++
>  mm/memcontrol.c      |  8 ++++++++
>  mm/vmscan.c          | 12 ++++++++----
>  3 files changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 456546443f1f..0318e918bfa4 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -669,6 +669,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry=
_t entry, unsigned int nr_p
>  }
>
>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
> +extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg);
>  extern bool mem_cgroup_swap_full(struct folio *folio);
>  #else
>  static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t e=
ntry)
> @@ -691,6 +692,11 @@ static inline long mem_cgroup_get_nr_swap_pages(stru=
ct mem_cgroup *memcg)
>         return get_nr_swap_pages();
>  }
>
> +static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *=
memcg)
> +{
> +       return total_swapcache_pages();
> +}
> +
>  static inline bool mem_cgroup_swap_full(struct folio *folio)
>  {
>         return vm_swap_full();
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e8ca4bdcb03c..3e578f41023e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7567,6 +7567,14 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgrou=
p *memcg)
>         return nr_swap_pages;
>  }
>
> +long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
> +{
> +       if (mem_cgroup_disabled() || do_memsw_account())
> +               return total_swapcache_pages();
> +
> +       return memcg_page_state(memcg, NR_SWAPCACHE);
> +}

Is there a reason why we cannot use NR_SWAPCACHE for cgroup v1? Isn't
that being maintained regardless of cgroup version? It is not exposed
in cgroup v1's memory.stat, but I don't think there is a reason we
can't do that -- if only to document that it is being used with cgroup
v1.


> +
>  bool mem_cgroup_swap_full(struct folio *folio)
>  {
>         struct mem_cgroup *memcg;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7c33c5b653ef..bcb6279cbae7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -609,13 +609,17 @@ static inline bool can_reclaim_anon_pages(struct me=
m_cgroup *memcg,
>         if (memcg =3D=3D NULL) {
>                 /*
>                  * For non-memcg reclaim, is there
> -                * space in any swap device?
> +                * space in any swap device or swapcache pages?
>                  */
> -               if (get_nr_swap_pages() > 0)
> +               if (get_nr_swap_pages() + total_swapcache_pages() > 0)
>                         return true;
>         } else {
> -               /* Is the memcg below its swap limit? */
> -               if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
> +               /*
> +                * Is the memcg below its swap limit or is there swapcach=
e
> +                * pages can be freed?
> +                */
> +               if (mem_cgroup_get_nr_swap_pages(memcg) +
> +                   mem_cgroup_get_nr_swapcache_pages(memcg) > 0)
>                         return true;
>         }

I wonder if it would be more efficient to set a bit in struct
scan_control if we only are out of swap spaces but have swap cache
pages, and only isolate anon pages that are in the swap cache, instead
of isolating random anon pages. We may end up isolating pages that are
not in the swap cache for a few iterations and wasting cycles.


>
> --
> 2.25.1
>
