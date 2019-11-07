From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 01/11] mm: vmscan: move inactive_list_is_low() swap check
 to the caller
Date: Wed, 6 Nov 2019 18:50:37 -0800
Message-ID: <CALvZod64t1OGuhrvB1QChUYvUs2yQF-qAi5F=gcntHN84rr=sQ@mail.gmail.com>
References: <20190603210746.15800-1-hannes@cmpxchg.org> <20190603210746.15800-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=10UEJHReRRkCxqogp9ovKAQzTbWMZb9ETtZvBc2w3vc=;
        b=n9PsUp0qLOLm3wGK6uOzCOXqKvmgPnWWAlsm+bH61fBp5I7s0DOeNJAHiWoawbMzlJ
         UBNhIcvRd60O+T2/7puYtioivkiGfDSKcW95AogUygR40udqSIvMMm1ctuaW1MbeH7B2
         nx2IDJ7a8R52fGrCK8GjN5xYz1k8FzHSiINa/nW+Xi1UOfMK1SSkhxWNO1O4WL4xNDy7
         YFx8ofRoa/3PuOrCSE4b/8D478nKxV63gjcYW8a5n1W00TtkmSSR/ERQeOS0FJhWDwpi
         MojGBQ5ILh+cI9z1z47DnjqqlWBvMytlSohM2JWKkAuA+it3n8s5M8f86M4QwUYvFHxv
         hJpw==
In-Reply-To: <20190603210746.15800-2-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Mon, Jun 3, 2019 at 3:05 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> inactive_list_is_low() should be about one thing: checking the ratio
> between inactive and active list. Kitchensink checks like the one for
> swap space makes the function hard to use and modify its
> callsites. Luckly, most callers already have an understanding of the
> swap situation, so it's easy to clean up.
>
> get_scan_count() has its own, memcg-aware swap check, and doesn't even
> get to the inactive_list_is_low() check on the anon list when there is
> no swap space available.
>
> shrink_list() is called on the results of get_scan_count(), so that
> check is redundant too.
>
> age_active_anon() has its own totalswap_pages check right before it
> checks the list proportions.
>
> The shrink_node_memcg() site is the only one that doesn't do its own
> swap check. Add it there.
>
> Then delete the swap check from inactive_list_is_low().
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>


> ---
>  mm/vmscan.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 84dcb651d05c..f396424850aa 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2165,13 +2165,6 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
>         unsigned long refaults;
>         unsigned long gb;
>
> -       /*
> -        * If we don't have swap space, anonymous page deactivation
> -        * is pointless.
> -        */
> -       if (!file && !total_swap_pages)
> -               return false;
> -
>         inactive = lruvec_lru_size(lruvec, inactive_lru, sc->reclaim_idx);
>         active = lruvec_lru_size(lruvec, active_lru, sc->reclaim_idx);
>
> @@ -2592,7 +2585,7 @@ static void shrink_node_memcg(struct pglist_data *pgdat, struct mem_cgroup *memc
>          * Even if we did not try to evict anon pages at all, we want to
>          * rebalance the anon lru active/inactive ratio.
>          */
> -       if (inactive_list_is_low(lruvec, false, sc, true))
> +       if (total_swap_pages && inactive_list_is_low(lruvec, false, sc, true))
>                 shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
>                                    sc, LRU_ACTIVE_ANON);
>  }
> --
> 2.21.0
>
