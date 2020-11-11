From: huang ying <huang.ying.caritas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v21 07/19] mm: page_idle_get_page() does not need lru_lock
Date: Wed, 11 Nov 2020 16:17:17 +0800
Message-ID: <CAC=cRTPYgD4qi=-dj=PY4804Y96k7fU065vLA8mNBmucZTnFSw@mail.gmail.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com> <1604566549-62481-8-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qyCZne5cZpLNOqDry4HVxqltreV+5uSXk934/wIueCQ=;
        b=LkrweCrNctWBJmZhOmVK1Rzbd5NVaaKQuUZ7ogoTkNLtcKS1qRptELkjFKxAoo/BW0
         P35onUOxdrqcVXzz35VtvWEvfj38Gdbm+Bdv/lwhCcDrizl6PzXh9JlZJrdPeYOs/ybe
         cwY7GQAwEF7/Mg2wY4aoFKT97vFprivkS5vVY4PuA8xcoo0iyfTevwWEIupadrC6yQQX
         spp3O5rZ/q1Wx4AE+znuA+rOIR+kZy1SYrJYXh7+Yk1TCx2/dj6tB0ZLia4HA+GPSsSW
         b5eXL06oey9MVpiBqb43EKDBlW5ai1A2WseVlAgbIFfOcDrT8Svl/de7lOLaM8arvWRP
         Vrng==
In-Reply-To: <1604566549-62481-8-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel test robot <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Nov 5, 2020 at 4:56 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> It is necessary for page_idle_get_page() to recheck PageLRU() after
> get_page_unless_zero(), but holding lru_lock around that serves no
> useful purpose, and adds to lru_lock contention: delete it.
>
> See https://lore.kernel.org/lkml/20150504031722.GA2768@blaptop for the
> discussion that led to lru_lock there; but __page_set_anon_rmap() now
> uses WRITE_ONCE(), and I see no other risk in page_idle_clear_pte_refs()
> using rmap_walk() (beyond the risk of racing PageAnon->PageKsm, mostly
> but not entirely prevented by page_count() check in ksm.c's
> write_protect_page(): that risk being shared with page_referenced() and
> not helped by lru_lock).
>
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/page_idle.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index 057c61df12db..64e5344a992c 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -32,19 +32,15 @@
>  static struct page *page_idle_get_page(unsigned long pfn)
>  {
>         struct page *page = pfn_to_online_page(pfn);
> -       pg_data_t *pgdat;
>
>         if (!page || !PageLRU(page) ||
>             !get_page_unless_zero(page))
>                 return NULL;
>
> -       pgdat = page_pgdat(page);
> -       spin_lock_irq(&pgdat->lru_lock);

get_page_unless_zero() is a full memory barrier.  But do we need a
compiler barrier here to prevent the compiler to cache PageLRU()
results here?  Otherwise looks OK to me,

Acked-by: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Best Regards,
Huang, Ying

>         if (unlikely(!PageLRU(page))) {
>                 put_page(page);
>                 page = NULL;
>         }
> -       spin_unlock_irq(&pgdat->lru_lock);
>         return page;
>  }
>
> --
> 1.8.3.1
>
>
