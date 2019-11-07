From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 07/11] mm: vmscan: split shrink_node() into node part and
 memcgs part
Date: Wed, 6 Nov 2019 18:51:59 -0800
Message-ID: <CALvZod7EFBD0SCoUFHacEtZqi7hcZ3S6FEZRmfJJORre3dxRtQ@mail.gmail.com>
References: <20190603210746.15800-1-hannes@cmpxchg.org> <20190603210746.15800-8-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrlsmiSp9MaTLUUYnVA3xTtIb+I1YUcCTslV0/OmSFI=;
        b=YWUaaCR128DURGqWr9aDknrAFS+YYlD99jyCFzrnkBJytTen48x97ZotJo5kZT3QYa
         ZjUE1oID3Dz3eEh0vpwgEwGeKs1IlCU141yRD3Ii3VpOrdmuUt1pXff6VBBrmPDXf5BR
         qXBM00zj3eBtlE8qYCpEysmNqZNhlKyUyCZKV/BxMWYzxoRprgj3lbp8NIAqz2rLFUpO
         z7KJKXpi8gtqrRNZgvaqQz1TR+YS3y5+HWIU9XjnZ22K3cvZzhrU+m8RD2I10tL57kPA
         EJd3iqWEZrVXgSl0eXR0vr+OCwqGyOaSN396/nYQDmw7ApNC7AemBk6nrILEpvaB45N8
         B34w==
In-Reply-To: <20190603210746.15800-8-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Mon, Jun 3, 2019 at 3:00 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> This function is getting long and unwieldy. The new shrink_node()
> handles the generic (node) reclaim aspects:
>   - global vmpressure notifications
>   - writeback and congestion throttling
>   - reclaim/compaction management
>   - kswapd giving up on unreclaimable nodes
>
> It then calls shrink_node_memcgs() which handles cgroup specifics:
>   - the cgroup tree traversal
>   - memory.low considerations
>   - per-cgroup slab shrinking callbacks
>   - per-cgroup vmpressure notifications
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>


> ---
>  mm/vmscan.c | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b85111474ee2..ee79b39d0538 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2665,24 +2665,15 @@ static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
>                 (memcg && memcg_congested(pgdat, memcg));
>  }
>
> -static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> +static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>  {
> -       struct reclaim_state *reclaim_state = current->reclaim_state;
>         struct mem_cgroup *root = sc->target_mem_cgroup;
>         struct mem_cgroup_reclaim_cookie reclaim = {
>                 .pgdat = pgdat,
>                 .priority = sc->priority,
>         };
> -       unsigned long nr_reclaimed, nr_scanned;
> -       bool reclaimable = false;
>         struct mem_cgroup *memcg;
>
> -again:
> -       memset(&sc->nr, 0, sizeof(sc->nr));
> -
> -       nr_reclaimed = sc->nr_reclaimed;
> -       nr_scanned = sc->nr_scanned;
> -
>         memcg = mem_cgroup_iter(root, NULL, &reclaim);
>         do {
>                 struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
> @@ -2750,6 +2741,22 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>                         break;
>                 }
>         } while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
> +}
> +
> +static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> +{
> +       struct reclaim_state *reclaim_state = current->reclaim_state;
> +       struct mem_cgroup *root = sc->target_mem_cgroup;
> +       unsigned long nr_reclaimed, nr_scanned;
> +       bool reclaimable = false;
> +
> +again:
> +       memset(&sc->nr, 0, sizeof(sc->nr));
> +
> +       nr_reclaimed = sc->nr_reclaimed;
> +       nr_scanned = sc->nr_scanned;
> +
> +       shrink_node_memcgs(pgdat, sc);
>
>         if (reclaim_state) {
>                 sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> @@ -2757,7 +2764,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>         }
>
>         /* Record the subtree's reclaim efficiency */
> -       vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> +       vmpressure(sc->gfp_mask, root, true,
>                    sc->nr_scanned - nr_scanned,
>                    sc->nr_reclaimed - nr_reclaimed);
>
> --
> 2.21.0
>
