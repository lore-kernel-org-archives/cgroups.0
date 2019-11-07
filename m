From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 08/11] mm: vmscan: harmonize writeback congestion tracking
 for nodes & memcgs
Date: Wed, 6 Nov 2019 18:52:06 -0800
Message-ID: <CALvZod6XVRbvaRk2_HoB-EQLCGm9e9FbPAhrpPOLiLU37g-xag@mail.gmail.com>
References: <20190603210746.15800-1-hannes@cmpxchg.org> <20190603210746.15800-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WAXXWA8L5ITD9neXsElL+Vjflm2Yh4OLeHgcVUxIxCw=;
        b=YvIaRGMJkMJ44J7UiBadMBvlgvPUpFKMUzAuIJZQVtlWJz5eIXoXJ2Ikj2W4c+jMOH
         zaE2k2WhuoQiCsceC7glsLNT1lDt95L1nEqOMlhS+QHrWzHd0FFVQhMKDamFdki/whBI
         xu/1GismT77URf9K3yYHircrmxBe2m/Cq+nmiunqDPbRPptHnsjQSEFsPQifpZ0HcOGw
         sDDvDmcEDn8omi18g1YxxUDbiOE2q9SLY5nB8UK0ybK/2f3IkbJJhWfej9lH0EUYK5Ms
         eZmbUUqYyAduzccRmJrs+3GNQBMra67O7vhpeZoXmHlUHZx3U2l+vMqQawdLobzVUN4W
         h9TA==
In-Reply-To: <20190603210746.15800-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Mon, Jun 3, 2019 at 3:04 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> The current writeback congestion tracking has separate flags for
> kswapd reclaim (node level) and cgroup limit reclaim (memcg-node
> level). This is unnecessarily complicated: the lruvec is an existing
> abstraction layer for that node-memcg intersection.
>
> Introduce lruvec->flags and LRUVEC_CONGESTED. Then track that at the
> reclaim root level, which is either the NUMA node for global reclaim,
> or the cgroup-node intersection for cgroup reclaim.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>


> ---
>  include/linux/memcontrol.h |  6 +--
>  include/linux/mmzone.h     | 11 ++++--
>  mm/vmscan.c                | 80 ++++++++++++--------------------------
>  3 files changed, 36 insertions(+), 61 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fc32cfaebf32..d33e09c51acc 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -144,9 +144,6 @@ struct mem_cgroup_per_node {
>         unsigned long           usage_in_excess;/* Set to the value by which */
>                                                 /* the soft limit is exceeded*/
>         bool                    on_tree;
> -       bool                    congested;      /* memcg has many dirty pages */
> -                                               /* backed by a congested BDI */
> -
>         struct mem_cgroup       *memcg;         /* Back pointer, we cannot */
>                                                 /* use container_of        */
>  };
> @@ -401,6 +398,9 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>                 goto out;
>         }
>
> +       if (!memcg)
> +               memcg = root_mem_cgroup;
> +
>         mz = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
>         lruvec = &mz->lruvec;
>  out:
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 95d63a395f40..b3ab64cf5619 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -293,6 +293,12 @@ struct zone_reclaim_stat {
>         unsigned long           recent_scanned[2];
>  };
>
> +enum lruvec_flags {
> +       LRUVEC_CONGESTED,               /* lruvec has many dirty pages
> +                                        * backed by a congested BDI
> +                                        */
> +};
> +
>  struct lruvec {
>         struct list_head                lists[NR_LRU_LISTS];
>         struct zone_reclaim_stat        reclaim_stat;
> @@ -300,6 +306,8 @@ struct lruvec {
>         atomic_long_t                   inactive_age;
>         /* Refaults at the time of last reclaim cycle */
>         unsigned long                   refaults;
> +       /* Various lruvec state flags (enum lruvec_flags) */
> +       unsigned long                   flags;
>  #ifdef CONFIG_MEMCG
>         struct pglist_data *pgdat;
>  #endif
> @@ -562,9 +570,6 @@ struct zone {
>  } ____cacheline_internodealigned_in_smp;
>
>  enum pgdat_flags {
> -       PGDAT_CONGESTED,                /* pgdat has many dirty pages backed by
> -                                        * a congested BDI
> -                                        */
>         PGDAT_DIRTY,                    /* reclaim scanning has recently found
>                                          * many dirty file pages at the tail
>                                          * of the LRU.
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ee79b39d0538..eb535c572733 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -267,29 +267,6 @@ static bool writeback_working(struct scan_control *sc)
>  #endif
>         return false;
>  }
> -
> -static void set_memcg_congestion(pg_data_t *pgdat,
> -                               struct mem_cgroup *memcg,
> -                               bool congested)
> -{
> -       struct mem_cgroup_per_node *mn;
> -
> -       if (!memcg)
> -               return;
> -
> -       mn = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
> -       WRITE_ONCE(mn->congested, congested);
> -}
> -
> -static bool memcg_congested(pg_data_t *pgdat,
> -                       struct mem_cgroup *memcg)
> -{
> -       struct mem_cgroup_per_node *mn;
> -
> -       mn = mem_cgroup_nodeinfo(memcg, pgdat->node_id);
> -       return READ_ONCE(mn->congested);
> -
> -}
>  #else
>  static bool cgroup_reclaim(struct scan_control *sc)
>  {
> @@ -300,18 +277,6 @@ static bool writeback_working(struct scan_control *sc)
>  {
>         return true;
>  }
> -
> -static inline void set_memcg_congestion(struct pglist_data *pgdat,
> -                               struct mem_cgroup *memcg, bool congested)
> -{
> -}
> -
> -static inline bool memcg_congested(struct pglist_data *pgdat,
> -                       struct mem_cgroup *memcg)
> -{
> -       return false;
> -
> -}
>  #endif
>
>  /*
> @@ -2659,12 +2624,6 @@ static inline bool should_continue_reclaim(struct pglist_data *pgdat,
>         return true;
>  }
>
> -static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
> -{
> -       return test_bit(PGDAT_CONGESTED, &pgdat->flags) ||
> -               (memcg && memcg_congested(pgdat, memcg));
> -}
> -
>  static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>  {
>         struct mem_cgroup *root = sc->target_mem_cgroup;
> @@ -2748,8 +2707,11 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>         struct reclaim_state *reclaim_state = current->reclaim_state;
>         struct mem_cgroup *root = sc->target_mem_cgroup;
>         unsigned long nr_reclaimed, nr_scanned;
> +       struct lruvec *target_lruvec;
>         bool reclaimable = false;
>
> +       target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
> +
>  again:
>         memset(&sc->nr, 0, sizeof(sc->nr));
>
> @@ -2792,14 +2754,6 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>                 if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
>                         set_bit(PGDAT_WRITEBACK, &pgdat->flags);
>
> -               /*
> -                * Tag a node as congested if all the dirty pages
> -                * scanned were backed by a congested BDI and
> -                * wait_iff_congested will stall.
> -                */
> -               if (sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
> -                       set_bit(PGDAT_CONGESTED, &pgdat->flags);
> -
>                 /* Allow kswapd to start writing pages during reclaim.*/
>                 if (sc->nr.unqueued_dirty == sc->nr.file_taken)
>                         set_bit(PGDAT_DIRTY, &pgdat->flags);
> @@ -2815,12 +2769,17 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>         }
>
>         /*
> +        * Tag a node/memcg as congested if all the dirty pages
> +        * scanned were backed by a congested BDI and
> +        * wait_iff_congested will stall.
> +        *
>          * Legacy memcg will stall in page writeback so avoid forcibly
>          * stalling in wait_iff_congested().
>          */
> -       if (cgroup_reclaim(sc) && writeback_working(sc) &&
> +       if ((current_is_kswapd() ||
> +            (cgroup_reclaim(sc) && writeback_working(sc))) &&
>             sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
> -               set_memcg_congestion(pgdat, root, true);
> +               set_bit(LRUVEC_CONGESTED, &target_lruvec->flags);
>
>         /*
>          * Stall direct reclaim for IO completions if underlying BDIs
> @@ -2828,8 +2787,9 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>          * starts encountering unqueued dirty pages or cycling through
>          * the LRU too quickly.
>          */
> -       if (!sc->hibernation_mode && !current_is_kswapd() &&
> -           current_may_throttle() && pgdat_memcg_congested(pgdat, root))
> +       if (!current_is_kswapd() && current_may_throttle() &&
> +           !sc->hibernation_mode &&
> +           test_bit(LRUVEC_CONGESTED, &target_lruvec->flags))
>                 wait_iff_congested(BLK_RW_ASYNC, HZ/10);
>
>         if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
> @@ -3043,8 +3003,16 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
>                 if (zone->zone_pgdat == last_pgdat)
>                         continue;
>                 last_pgdat = zone->zone_pgdat;
> +
>                 snapshot_refaults(sc->target_mem_cgroup, zone->zone_pgdat);
> -               set_memcg_congestion(last_pgdat, sc->target_mem_cgroup, false);
> +
> +               if (cgroup_reclaim(sc)) {
> +                       struct lruvec *lruvec;
> +
> +                       lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup,
> +                                                  zone->zone_pgdat);
> +                       clear_bit(LRUVEC_CONGESTED, &lruvec->flags);
> +               }
>         }
>
>         delayacct_freepages_end();
> @@ -3419,7 +3387,9 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int classzone_idx)
>  /* Clear pgdat state for congested, dirty or under writeback. */
>  static void clear_pgdat_congested(pg_data_t *pgdat)
>  {
> -       clear_bit(PGDAT_CONGESTED, &pgdat->flags);
> +       struct lruvec *lruvec = mem_cgroup_lruvec(NULL, pgdat);
> +
> +       clear_bit(LRUVEC_CONGESTED, &lruvec->flags);
>         clear_bit(PGDAT_DIRTY, &pgdat->flags);
>         clear_bit(PGDAT_WRITEBACK, &pgdat->flags);
>  }
> --
> 2.21.0
>
