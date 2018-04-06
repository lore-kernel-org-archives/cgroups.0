From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm-vmscan-dont-mess-with-pgdat-flags-in-memcg-reclaim-v2-fix
Date: Fri, 6 Apr 2018 07:37:10 -0700
Message-ID: <CALvZod7bGjx-fUKZ15oVAkXkeneZjtoRFiUSpKSZ1U0DA_e1BA@mail.gmail.com>
References: <CALvZod7P7cE38fDrWd=0caA2J6ZOmSzEuLGQH9VSaagCbo5O+A@mail.gmail.com>
 <20180406135215.10057-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=7JxZvQx6456nUJZy4MVzB9VWXTy6wvWD7YBOifs2514=;
        b=Ob4P3P28a1vEZMEGFsOXrnN0iBfN+GaHd2iRCCcfIjnbyZx8g2/a28A5XnEA2PPvCJ
         J2HuR2ltvU0NWkX4U7uPuxNWUg4p+X3VvlC+6s1axqR18XWO8Trw7BZFYu6lGzmHNJeb
         Mf8Dwgp7nzRyAIjpBjoHghVNeSPoYr+VOs+mYKqhVsrthMzm0icTnJWD1bYuMuqb2OJr
         5mLm3zCeNaGGFoG6cRUIIWX0tvZIXkOWoPEJdS02h+rCmVzNkKEo0NgjqaK4oBKQlbDT
         dE6F8dM2NtiC49CeHn0YnAwkVkGN/G8UVw9PVw+hNLYa8sNULuXP5hI0Y9gdvnLFiHIB
         Agnw==
In-Reply-To: <20180406135215.10057-1-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Apr 6, 2018 at 6:52 AM, Andrey Ryabinin <aryabinin@virtuozzo.com> wrote:
> On 04/06/2018 05:13 AM, Shakeel Butt wrote:
>> Question: Should this 'flags' be per-node? Is it ok for a congested
>> memcg to call wait_iff_congested for all nodes?
>
> Indeed, congestion state should be pre-node. If memcg on node A is
> congested, there is no point is stalling memcg reclaim from node B.
>
> Make congestion state per-cgroup-per-node and record it in
> 'struct mem_cgroup_per_node'.
>
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> ---
>  include/linux/memcontrol.h |  5 +++--
>  mm/vmscan.c                | 39 +++++++++++++++++++++++++--------------
>  2 files changed, 28 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8b394bbf1c86..af9eed2e3e04 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -120,6 +120,9 @@ struct mem_cgroup_per_node {
>         unsigned long           usage_in_excess;/* Set to the value by which */
>                                                 /* the soft limit is exceeded*/
>         bool                    on_tree;
> +       bool                    congested;      /* memcg has many dirty pages */
> +                                               /* backed by a congested BDI */
> +
>         struct mem_cgroup       *memcg;         /* Back pointer, we cannot */
>                                                 /* use container_of        */
>  };
> @@ -189,8 +192,6 @@ struct mem_cgroup {
>         /* vmpressure notifications */
>         struct vmpressure vmpressure;
>
> -       unsigned long flags;
> -
>         /*
>          * Should the accounting and control be hierarchical, per subtree?
>          */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 99688299eba8..78214c899710 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -200,16 +200,27 @@ static bool sane_reclaim(struct scan_control *sc)
>         return false;
>  }
>
> -static void set_memcg_bit(enum pgdat_flags flag,
> -                       struct mem_cgroup *memcg)
> +static void set_memcg_congestion(pg_data_t *pgdat,
> +                               struct mem_cgroup *memcg,
> +                               bool congested)
>  {
> -       set_bit(flag, &memcg->flags);
> +       struct mem_cgroup_per_node *mz;
> +
> +       if (!memcg)
> +               return;
> +
> +       mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
> +       WRITE_ONCE(mz->congested, congested);
>  }
>
> -static int test_memcg_bit(enum pgdat_flags flag,
> +static bool memcg_congested(pg_data_t *pgdat,
>                         struct mem_cgroup *memcg)
>  {
> -       return test_bit(flag, &memcg->flags);
> +       struct mem_cgroup_per_node *mz;
> +
> +       mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
> +       return READ_ONCE(mz->congested);
> +
>  }
>  #else
>  static bool global_reclaim(struct scan_control *sc)
> @@ -222,15 +233,16 @@ static bool sane_reclaim(struct scan_control *sc)
>         return true;
>  }
>
> -static inline void set_memcg_bit(enum pgdat_flags flag,
> -                               struct mem_cgroup *memcg)
> +static inline void set_memcg_congestion(struct pglist_data *pgdat,
> +                               struct mem_cgroup *memcg, bool congested)
>  {
>  }
>
> -static inline int test_memcg_bit(enum pgdat_flags flag,
> -                               struct mem_cgroup *memcg)
> +static inline bool memcg_congested(struct pglist_data *pgdat,
> +                       struct mem_cgroup *memcg)
>  {
> -       return 0;
> +       return false;
> +
>  }
>  #endif
>
> @@ -2482,7 +2494,7 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>  static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
>  {
>         return test_bit(PGDAT_CONGESTED, &pgdat->flags) ||
> -               (memcg && test_memcg_bit(PGDAT_CONGESTED, memcg));
> +               (memcg && memcg_congested(pgdat, memcg));

I am wondering if we should check all ancestors for congestion as
well. Maybe a parallel memcg reclaimer might have set some ancestor of
this memcg to congested.

>  }
>
>  static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> @@ -2617,7 +2629,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>                  */
>                 if (!global_reclaim(sc) && sane_reclaim(sc) &&
>                     sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
> -                       set_memcg_bit(PGDAT_CONGESTED, root);
> +                       set_memcg_congestion(pgdat, root, true);
>
>                 /*
>                  * Stall direct reclaim for IO completions if underlying BDIs
> @@ -2844,6 +2856,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>                         continue;
>                 last_pgdat = zone->zone_pgdat;
>                 snapshot_refaults(sc->target_mem_cgroup, zone->zone_pgdat);
> +               set_memcg_congestion(last_pgdat, sc->target_mem_cgroup, false);
>         }
>
>         delayacct_freepages_end();
> @@ -3067,7 +3080,6 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
>          * the priority and make it zero.
>          */
>         shrink_node_memcg(pgdat, memcg, &sc, &lru_pages);
> -       clear_bit(PGDAT_CONGESTED, &memcg->flags);
>
>         trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
>
> @@ -3113,7 +3125,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>         noreclaim_flag = memalloc_noreclaim_save();
>         nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
>         memalloc_noreclaim_restore(noreclaim_flag);
> -       clear_bit(PGDAT_CONGESTED, &memcg->flags);
>
>         trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
>
> --
> 2.16.1
>
