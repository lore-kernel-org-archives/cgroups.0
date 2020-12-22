From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/3] mm/memcg: remove rcu locking for lock_page_lruvec
 function series
Date: Mon, 21 Dec 2020 19:38:57 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2012211901580.1045@eggly.anvils>
References: <1608186532-81218-1-git-send-email-alex.shi@linux.alibaba.com> <1608186532-81218-2-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=mQRnP/VE3MNPubHtDGscBCYTtM3M8Hnq7UmsE7TsaOU=;
        b=aIf0pGKPSreq5IVVApVQmbb6IeRO6q0rWAZSyCbchKd3JzFF0dl9OPfFoHGNFNiHwF
         L+PGmSJ8KKPAvSREpdpX6LSXrbYNPfsG8FVdHbjA8LD/1ePrfwtDbx3AWnxEuINxSew3
         /G8z6kj9+V4oGzdjwzEy8MUC6hMWUMjOAvTi37ZruuJMuB+w38j3U49XOQ18xz5C7BVz
         wUZXDjqM9Gt/WugmBrxR3FkzKW14NzEwrqYBEZvE9HaWZrMRdAjZMSLqC75JVU3Rd9C8
         EcLCcFmN4/gMoHTqSqYVnXFo6AfOR/TIvdNCCQ3C5sK/AllRIAKhmLggrfk4onGmXCyA
         2+tg==
In-Reply-To: <1608186532-81218-2-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Alexander Duyck <alexander.duyck@gmail.com>, Hui Su <sh_def@163.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, 17 Dec 2020, Alex Shi wrote:

> The rcu_read_lock was used to block memcg destory, but with the detailed
> calling conditions, the memcg won't gone since the page is hold. So we
> don't need it now, let's remove them to save locking load in debugging.

"
lock_page_lruvec() and its variants used rcu_read_lock() with the
intention of safeguarding against the mem_cgroup being destroyed
concurrently; but so long as they are called under the specified
conditions (as they are), there is no way for the page's mem_cgroup
to be destroyed.  Delete the unnecessary rcu_read_lock() and _unlock().
"

This has little to do with a "locking load in debugging" - so what?
But everything to do with deleting bogosity, the sooner the better.

> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Hugh Dickins <hughd@google.com>

This really surprised me!  Nice change, but how on earth did we not
notice until now?  The rcu_read_lock() seems to have come in, without
explanation, somewhere between lru_lock v9 and v11 (I never saw v10); and
I guess I was so used to needing rcu_read_lock() in my own implementation,
that I was blind to its irrelevance in yours.  Cc'ing Alex Duyck, since
he was generally very alert to this kind of thing - be good to have his
Ack too.  Also Cc'ing Hui Su, who sent a similar but unexplained patch
just before yours.

> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/memcontrol.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e6b50d068b2f..98bbee1d2faf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1356,10 +1356,8 @@ struct lruvec *lock_page_lruvec(struct page *page)
>  	struct lruvec *lruvec;
>  	struct pglist_data *pgdat = page_pgdat(page);
>  
> -	rcu_read_lock();
>  	lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  	spin_lock(&lruvec->lru_lock);
> -	rcu_read_unlock();
>  
>  	lruvec_memcg_debug(lruvec, page);
>  
> @@ -1371,10 +1369,8 @@ struct lruvec *lock_page_lruvec_irq(struct page *page)
>  	struct lruvec *lruvec;
>  	struct pglist_data *pgdat = page_pgdat(page);
>  
> -	rcu_read_lock();
>  	lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  	spin_lock_irq(&lruvec->lru_lock);
> -	rcu_read_unlock();
>  
>  	lruvec_memcg_debug(lruvec, page);
>  
> @@ -1386,10 +1382,8 @@ struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *flags)
>  	struct lruvec *lruvec;
>  	struct pglist_data *pgdat = page_pgdat(page);
>  
> -	rcu_read_lock();
>  	lruvec = mem_cgroup_page_lruvec(page, pgdat);
>  	spin_lock_irqsave(&lruvec->lru_lock, *flags);
> -	rcu_read_unlock();
>  
>  	lruvec_memcg_debug(lruvec, page);
>  
> -- 
> 2.29.GIT
