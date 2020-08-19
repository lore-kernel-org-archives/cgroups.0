From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH v2 3/5] mm: Add explicit page decrement in exception
 path for isolate_lru_pages
Date: Wed, 19 Aug 2020 15:50:50 +0800
Message-ID: <cc993d93-a5af-dd29-19f4-176ba86000e1@linux.alibaba.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042722.23414.2654.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200819042722.23414.2654.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org



在 2020/8/19 下午12:27, Alexander Duyck 写道:
> From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> In isolate_lru_pages we have an exception path where if we call
> get_page_unless_zero and that succeeds, but TestClearPageLRU fails we call
> put_page. Normally this would be problematic but due to the way that the
> calls are ordered and the fact that we are holding the LRU lock we know
> that the caller must be holding another reference for the page. Since we
> can assume that we can replace the put_page with a call to
> put_page_testzero contained within a WARN_ON. By doing this we should see
> if we ever leak a page as a result of the reference count somehow hitting
> zero when it shouldn't, and can avoid the overhead and confusion of using
> the full put_page call.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  mm/vmscan.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5bc0c2322043..3ebe3f9b653b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1688,10 +1688,13 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>  
>  			if (!TestClearPageLRU(page)) {
>  				/*
> -				 * This page may in other isolation path,
> -				 * but we still hold lru_lock.
> +				 * This page is being isolated in another
> +				 * thread, but we still hold lru_lock. The
> +				 * other thread must be holding a reference
> +				 * to the page so this should never hit a
> +				 * reference count of 0.
>  				 */
> -				put_page(page);
> +				WARN_ON(put_page_testzero(page));

seems WARN_ON is always enabled.

Reviewed-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

>  				goto busy;
>  			}
>  
> 
