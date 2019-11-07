From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 06/11] mm: vmscan: turn shrink_node_memcg() into shrink_lruvec()
Date: Wed, 6 Nov 2019 18:51:51 -0800
Message-ID: <CALvZod4fCXrNd+uruEu6J3mjzRgHuK4Mu++fp-dH63Pfb11VHw@mail.gmail.com>
References: <20190603210746.15800-1-hannes@cmpxchg.org> <20190603210746.15800-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kDdLz2dgz8WJIiGMPPdO9wrz/4A63qBVRe550gS0EUs=;
        b=bG2hARxlz9n/7uJUPESjTyuodO57X2/iCCk60Vl5V8zXwbQnnPstUSNKmrtIQ5HD3k
         epZTCMPvKmhpCHIOmLmmlN/MNEojn488H/JwDjSelciE6M0ds2/v36CNQWAstLIldGen
         L0DzEVJup+j3Tk55B4PcGE0F0HlfLIi4E0wiXL41BtXNYZrPkrjuvibgOL0Y6/dRh3WF
         +0rP/IgC9qirNn+Ftu0BchZ64hVBMeLUbHzslk/uENviWfrpjvxFzhdKdp4FOcVLDEXy
         429yPE0Hjjq6iNirVRV20WqQ6yzYriGgRi3YjwVIcs5bOxjI5WlCIPsk6RuvQfTmRL3t
         pfBQ==
In-Reply-To: <20190603210746.15800-7-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Mon, Jun 3, 2019 at 3:07 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> A lruvec holds LRU pages owned by a certain NUMA node and cgroup.
> Instead of awkwardly passing around a combination of a pgdat and a
> memcg pointer, pass down the lruvec as soon as we can look it up.
>
> Nested callers that need to access node or cgroup properties can look
> them them up if necessary, but there are only a few cases.

*them

>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>


> ---
>  mm/vmscan.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 304974481146..b85111474ee2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2210,9 +2210,10 @@ enum scan_balance {
>   * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
>   * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
>   */
> -static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
> -                          struct scan_control *sc, unsigned long *nr)
> +static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
> +                          unsigned long *nr)
>  {
> +       struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>         int swappiness = mem_cgroup_swappiness(memcg);
>         struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
>         u64 fraction[2];
> @@ -2460,13 +2461,8 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
>         }
>  }
>
> -/*
> - * This is a basic per-node page freer.  Used by both kswapd and direct reclaim.
> - */
> -static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memcg,
> -                             struct scan_control *sc)
> +static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -       struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
>         unsigned long nr[NR_LRU_LISTS];
>         unsigned long targets[NR_LRU_LISTS];
>         unsigned long nr_to_scan;
> @@ -2476,7 +2472,7 @@ static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memc
>         struct blk_plug plug;
>         bool scan_adjusted;
>
> -       get_scan_count(lruvec, memcg, sc, nr);
> +       get_scan_count(lruvec, sc, nr);
>
>         /* Record the original scan target for proportional adjustments later */
>         memcpy(targets, nr, sizeof(nr));
> @@ -2689,6 +2685,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>
>         memcg = mem_cgroup_iter(root, NULL, &reclaim);
>         do {
> +               struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
>                 unsigned long reclaimed;
>                 unsigned long scanned;
>
> @@ -2725,7 +2722,8 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>
>                 reclaimed = sc->nr_reclaimed;
>                 scanned = sc->nr_scanned;
> -               shrink_node_memcg(pgdat, memcg, sc);
> +
> +               shrink_lruvec(lruvec, sc);
>
>                 if (sc->may_shrinkslab) {
>                         shrink_slab(sc->gfp_mask, pgdat->node_id,
> @@ -3243,6 +3241,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
>                                                 pg_data_t *pgdat,
>                                                 unsigned long *nr_scanned)
>  {
> +       struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
>         struct scan_control sc = {
>                 .nr_to_reclaim = SWAP_CLUSTER_MAX,
>                 .target_mem_cgroup = memcg,
> @@ -3268,7 +3267,7 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
>          * will pick up pages from other mem cgroup's as well. We hack
>          * the priority and make it zero.
>          */
> -       shrink_node_memcg(pgdat, memcg, &sc);
> +       shrink_lruvec(lruvec, &sc);
>
>         trace_mm_vmscan_memcg_softlimit_reclaim_end(
>                                         cgroup_ino(memcg->css.cgroup),
> --
> 2.21.0
>
