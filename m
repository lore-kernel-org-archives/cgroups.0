From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: fix inactive list balancing between NUMA nodes and cgroups
Date: Mon, 15 Apr 2019 18:57:41 -0700
Message-ID: <CALvZod57YYGJHBvMpbdmysuDPzdEAsv+JM5tK8Qfxgrsb=T-pw@mail.gmail.com>
References: <20190412144438.2645-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9Z6Efxstusl8bv0MPNQb6LsZw7PMuW4dqsK1aSDA8tk=;
        b=YHW3wCZMxdYPK+4h1+oUGGxChwMSC5UqBLlitvvx0/DbVrle74k8U2OlBXa+KWJ1cW
         DvGK3mm6RyFUnDwHlC6h2kn81UGUFXJ8dUnGKfGwhWg30UbuBoXBjC/KLKsqD/OXKq42
         vj98QNVSYVGWXlk6kcQIIjzsKVdfhlPGSRimNgCWS/3P8mmmA3xlcEYzDMKENzzZur61
         4b8Q3K8aPOEDxVMrY+cxSX666388la0JfJjHtJHUTh/WGNXa8mUXjkHOz5f//qMP1Jcz
         xSmb/lGZhTLgR96/d7ZIlxXJGWX2QM8wJgX600T2u9mwbYm1QWdpJdOw63ty7ilRJ79q
         YxWQ==
In-Reply-To: <20190412144438.2645-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Fri, Apr 12, 2019 at 7:44 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> During !CONFIG_CGROUP reclaim, we expand the inactive list size if
> it's thrashing on the node that is about to be reclaimed. But when
> cgroups are enabled, we suddenly ignore the node scope and use the
> cgroup scope only. The result is that pressure bleeds between NUMA
> nodes depending on whether cgroups are merely compiled into Linux.
> This behavioral difference is unexpected and undesirable.
>
> When the refault adaptivity of the inactive list was first introduced,
> there were no statistics at the lruvec level - the intersection of
> node and memcg - so it was better than nothing.
>
> But now that we have that infrastructure, use lruvec_page_state() to
> make the list balancing decision always NUMA aware.
>
> Fixes: 2a2e48854d70 ("mm: vmscan: fix IO/refault regression in cache workingset transition")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

> ---
>  mm/vmscan.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 347c9b3b29ac..c9f8afe61ae3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2138,7 +2138,6 @@ static void shrink_active_list(unsigned long nr_to_scan,
>   *   10TB     320        32GB
>   */
>  static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
> -                                struct mem_cgroup *memcg,
>                                  struct scan_control *sc, bool actual_reclaim)
>  {
>         enum lru_list active_lru = file * LRU_FILE + LRU_ACTIVE;
> @@ -2159,16 +2158,12 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
>         inactive = lruvec_lru_size(lruvec, inactive_lru, sc->reclaim_idx);
>         active = lruvec_lru_size(lruvec, active_lru, sc->reclaim_idx);
>
> -       if (memcg)
> -               refaults = memcg_page_state(memcg, WORKINGSET_ACTIVATE);
> -       else
> -               refaults = node_page_state(pgdat, WORKINGSET_ACTIVATE);
> -
>         /*
>          * When refaults are being observed, it means a new workingset
>          * is being established. Disable active list protection to get
>          * rid of the stale workingset quickly.
>          */
> +       refaults = lruvec_page_state(lruvec, WORKINGSET_ACTIVATE);
>         if (file && actual_reclaim && lruvec->refaults != refaults) {
>                 inactive_ratio = 0;
>         } else {
> @@ -2189,12 +2184,10 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
>  }
>
>  static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
> -                                struct lruvec *lruvec, struct mem_cgroup *memcg,
> -                                struct scan_control *sc)
> +                                struct lruvec *lruvec, struct scan_control *sc)
>  {
>         if (is_active_lru(lru)) {
> -               if (inactive_list_is_low(lruvec, is_file_lru(lru),
> -                                        memcg, sc, true))
> +               if (inactive_list_is_low(lruvec, is_file_lru(lru), sc, true))
>                         shrink_active_list(nr_to_scan, lruvec, sc, lru);
>                 return 0;
>         }
> @@ -2293,7 +2286,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
>                          * anonymous pages on the LRU in eligible zones.
>                          * Otherwise, the small LRU gets thrashed.
>                          */
> -                       if (!inactive_list_is_low(lruvec, false, memcg, sc, false) &&
> +                       if (!inactive_list_is_low(lruvec, false, sc, false) &&
>                             lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, sc->reclaim_idx)
>                                         >> sc->priority) {
>                                 scan_balance = SCAN_ANON;
> @@ -2311,7 +2304,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
>          * lruvec even if it has plenty of old anonymous pages unless the
>          * system is under heavy pressure.
>          */
> -       if (!inactive_list_is_low(lruvec, true, memcg, sc, false) &&
> +       if (!inactive_list_is_low(lruvec, true, sc, false) &&
>             lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, sc->reclaim_idx) >> sc->priority) {
>                 scan_balance = SCAN_FILE;
>                 goto out;
> @@ -2515,7 +2508,7 @@ static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memc
>                                 nr[lru] -= nr_to_scan;
>
>                                 nr_reclaimed += shrink_list(lru, nr_to_scan,
> -                                                           lruvec, memcg, sc);
> +                                                           lruvec, sc);
>                         }
>                 }
>
> @@ -2582,7 +2575,7 @@ static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memc
>          * Even if we did not try to evict anon pages at all, we want to
>          * rebalance the anon lru active/inactive ratio.
>          */
> -       if (inactive_list_is_low(lruvec, false, memcg, sc, true))
> +       if (inactive_list_is_low(lruvec, false, sc, true))
>                 shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
>                                    sc, LRU_ACTIVE_ANON);
>  }
> @@ -2985,12 +2978,8 @@ static void snapshot_refaults(struct mem_cgroup *root_memcg, pg_data_t *pgdat)
>                 unsigned long refaults;
>                 struct lruvec *lruvec;
>
> -               if (memcg)
> -                       refaults = memcg_page_state(memcg, WORKINGSET_ACTIVATE);
> -               else
> -                       refaults = node_page_state(pgdat, WORKINGSET_ACTIVATE);
> -
>                 lruvec = mem_cgroup_lruvec(pgdat, memcg);
> +               refaults = lruvec_page_state_local(lruvec, WORKINGSET_ACTIVATE);
>                 lruvec->refaults = refaults;
>         } while ((memcg = mem_cgroup_iter(root_memcg, memcg, NULL)));
>  }
> @@ -3346,7 +3335,7 @@ static void age_active_anon(struct pglist_data *pgdat,
>         do {
>                 struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, memcg);
>
> -               if (inactive_list_is_low(lruvec, false, memcg, sc, true))
> +               if (inactive_list_is_low(lruvec, false, sc, true))
>                         shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
>                                            sc, LRU_ACTIVE_ANON);
>
> --
> 2.21.0
>
