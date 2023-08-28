From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3] mm: vmscan: try to reclaim swapcache pages if no swap space
Date: Mon, 28 Aug 2023 10:34:05 -0700
Message-ID: <CAJD7tka1tYs6v8nEq3xKpvgXMywz_FUz0TF_cTvzZ86J8L3SRQ@mail.gmail.com>
References: <20230826034401.640861-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693244081; x=1693848881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/hj4zAJGTB+R9zOcfvDXuXZl9jn964RzT9PqzJAHP0=;
        b=WsUalkF2WJkUXm1iyLayE+cKxReFkBrRh13idRWzabm5RlUS3+llbD48GNuWbXOn6t
         m79Y5p3vy/j2ej5wSdbTU+RbeLlXG/TtgvC2/4b3d9MNF4P+auj1xkKh1nECoyo2GjlP
         AiquHhh7ECeNSmHYAyZyX5hjm28PFYD9BMIU8VPi/jb5h+bl6wWiwmMYTEBhm/CF5qsA
         nBuBFz12D51f2rwaBPuJhtTAb14y7VSjx2IZ9gTHei44RAOwaZD0pSar7GYubwwlfJDJ
         A+Ubk0r+am8VuaiZvIOysukbCejD2iiz124Vc3u+LfUCpFr9JMKN1MSWolcnDzE5cHZu
         aDDA==
In-Reply-To: <20230826034401.640861-1-liushixin2@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Liu Shixin <liushixin2@huawei.com>
Cc: Huang Ying <ying.huang@intel.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri, Aug 25, 2023 at 7:49=E2=80=AFPM Liu Shixin <liushixin2@huawei.com> =
wrote:
>
> When spaces of swap devices are exhausted, only file pages can be reclaim=
ed.
> But there are still some swapcache pages in anon lru list. This can lead
> to a premature out-of-memory.
>
> This problem can be fixed by checking number of swapcache pages in
> can_reclaim_anon_pages().
>
> Add a new bit swapcache_only in struct scan_control to skip isolating ano=
n
> pages that are not in the swap cache when only swap cache can be reclaime=
d.
>
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>

I can confirm that with the reproducer I posted on v2 this patch fixes
the problem, feel free to add:

Tested-by: Yosry Ahmed <yosryahmed@google.com>

The code LGTM. I personally prefer that we add NR_SWAPCACHE to
memcg1_stats, so that it's obvious that it is used by cgroup v1 code,
but perhaps maintainers have opinions against that.

> ---
>  include/linux/swap.h |  6 ++++++
>  mm/memcontrol.c      |  8 ++++++++
>  mm/vmscan.c          | 29 +++++++++++++++++++++++++++--
>  3 files changed, 41 insertions(+), 2 deletions(-)
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
> index e8ca4bdcb03c..c465829db92b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7567,6 +7567,14 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgrou=
p *memcg)
>         return nr_swap_pages;
>  }
>
> +long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
> +{
> +       if (mem_cgroup_disabled())
> +               return total_swapcache_pages();
> +
> +       return memcg_page_state(memcg, NR_SWAPCACHE);
> +}
> +
>  bool mem_cgroup_swap_full(struct folio *folio)
>  {
>         struct mem_cgroup *memcg;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7c33c5b653ef..5cb4adf6642b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -137,6 +137,9 @@ struct scan_control {
>         /* Always discard instead of demoting to lower tier memory */
>         unsigned int no_demotion:1;
>
> +       /* Swap space is exhausted, only reclaim swapcache for anon LRU *=
/
> +       unsigned int swapcache_only:1;
> +
>         /* Allocation order */
>         s8 order;
>
> @@ -613,10 +616,20 @@ static inline bool can_reclaim_anon_pages(struct me=
m_cgroup *memcg,
>                  */
>                 if (get_nr_swap_pages() > 0)
>                         return true;
> +               /* Is there any swapcache pages to reclaim? */
> +               if (total_swapcache_pages() > 0) {
> +                       sc->swapcache_only =3D 1;
> +                       return true;
> +               }
>         } else {
>                 /* Is the memcg below its swap limit? */
>                 if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
>                         return true;
> +               /* Is there any swapcache pages in memcg to reclaim? */
> +               if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
> +                       sc->swapcache_only =3D 1;
> +                       return true;
> +               }
>         }
>
>         /*
> @@ -2280,6 +2293,19 @@ static bool skip_cma(struct folio *folio, struct s=
can_control *sc)
>  }
>  #endif
>
> +static bool skip_isolate(struct folio *folio, struct scan_control *sc,
> +                        enum lru_list lru)
> +{
> +       if (folio_zonenum(folio) > sc->reclaim_idx)
> +               return true;
> +       if (skip_cma(folio, sc))
> +               return true;
> +       if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
> +           !folio_test_swapcache(folio)))
> +               return true;
> +       return false;
> +}
> +
>  /*
>   * Isolating page from the lruvec to fill in @dst list by nr_to_scan tim=
es.
>   *
> @@ -2326,8 +2352,7 @@ static unsigned long isolate_lru_folios(unsigned lo=
ng nr_to_scan,
>                 nr_pages =3D folio_nr_pages(folio);
>                 total_scan +=3D nr_pages;
>
> -               if (folio_zonenum(folio) > sc->reclaim_idx ||
> -                               skip_cma(folio, sc)) {
> +               if (skip_isolate(folio, sc, lru)) {
>                         nr_skipped[folio_zonenum(folio)] +=3D nr_pages;
>                         move_to =3D &folios_skipped;
>                         goto move;
> --
> 2.25.1
>
