From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4] mm: vmscan: try to reclaim swapcache pages if no swap space
Date: Tue, 29 Aug 2023 08:23:26 -0700
Message-ID: <CAJD7tkZafahYbBs9=HNy4QtFZ4aGTcECvvCt3bQgXaNPUYTOUg@mail.gmail.com>
References: <20230829024104.1505530-1-liushixin2@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693322644; x=1693927444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzpeAN+lW4lnuBFNUjzlUToZyZ1j5VVEVY/cQHQ5ISc=;
        b=gIE3+SeS9PGKpT7rHq/JaVxbPSQT8MNUMqvNMDjfmBJkWClm8pxZEEus8ath0clxxY
         v0sG1eoTpATDr8wnSTJHdDt32hjCxxYssPG3uDxo8GXbb/lk7yWjOyD6W2BHwgkraplS
         NMkTyX4NTdbJGWYq+AtvH18Sz2tJjsnU9z6Elc0l/08bcgwWVX7Jun62QgZ8m5iDEzIH
         thlbFbsGE1j0hn9Pzcgcuee2TBw0rxH6Q+KtsTJObb0Y10jVsmC5bm5oLmoep+J6cBr0
         DF1Gnz5j1cqnyHU74KNEL4mvlxCt8bxGU3QdninJauuDTzsZDGPXFRkVcGO5uy7TB5UW
         qMLA==
In-Reply-To: <20230829024104.1505530-1-liushixin2@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Liu Shixin <liushixin2@huawei.com>
Cc: Huang Ying <ying.huang@intel.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Mon, Aug 28, 2023 at 6:46=E2=80=AFPM Liu Shixin <liushixin2@huawei.com> =
wrote:
>
> When spaces of swap devices are exhausted, only file pages can be reclaim=
ed.
> But there are still some swapcache pages in anon lru list. This can lead
> to a premature out-of-memory.
>
> The problem is found with such step:
>
>  Firstly, set a 9MB disk swap space, then create a cgroup with 10MB
>  memory limit, then runs an program to allocates about 15MB memory.
>
> The problem occurs occasionally, which may need about 100 times.

The reproducer I used in v2 reproduces this very reliably and simply,
could you link to it instead?

https://lore.kernel.org/lkml/CAJD7tkZAfgncV+KbKr36=3DeDzMnT=3D9dZOT0dpMWcur=
HLr6Do+GA@mail.gmail.com/

>
> Fix it by checking number of swapcache pages in can_reclaim_anon_pages().
> If the number is not zero, return true either. Moreover, add a new bit
> swapcache_only in struct scan_control to skip isolating anon pages that
> are not swapcache when only swapcache pages can be reclaimed to accelerat=
e
> reclaim efficiency.
>
> Link: https://lore.kernel.org/linux-mm/14e15f31-f3d3-4169-8ed9-fb36e57cf5=
78@huawei.com/
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> Tested-by: Yosry Ahmed <yosryahmed@google.com>

Usually people add the difference from the previous version to make it
easy to know what changed.

I still prefer to add NR_SWAPCACHE to memcg1_stats. Anyway, the code
looks good to me. With the updated reproducer link feel free to add:

Reviewed-by: Yosry Ahmed <yosryahmed@google.com>

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
> index 1080209a568b..e73e2df8828d 100644
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
