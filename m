From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 24/32] mm/pgdat: remove pgdat lru_lock
Date: Mon, 21 Sep 2020 22:53:09 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009212248350.6434@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-25-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=rj2KbrP8wDZHh7cva4yvY3TOcqZLJGweHnZrrr56Tas=;
        b=u+iUdxziFYUXXIs1aAqLKK5bC0JUncRoDRqo+fL11mZ37Ha6MX72UFkY+p4FBfLyxh
         zc00OHlQ+bY0vgqZB3XzRj+CyCwhquUofnrXhKsX1S9T4TGV313nL6TGQUrf9iB+4y0L
         qKilbf2LjFsSE+GBXwLaCPPWfaPIz+XwsVZW+erBJJJCxCyW0orCiGUR+rVyLV9p6ngN
         ruJWdxUGqQqpjFrm3baZ2BUfkIFeFHvnOlilwP0WSuWAvU/ObFzb1qIUAza1heNknuAp
         m/eSdALJmQq9lY6eqfsyysc0OvHuFaKfoqDoa1UnNwMlplj+jY2SFo43oDxYG3zQvblU
         7P5Q==
In-Reply-To: <1598273705-69124-25-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Mon, 24 Aug 2020, Alex Shi wrote:

> Now pgdat.lru_lock was replaced by lruvec lock. It's not used anymore.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

I don't take pleasure in spoiling your celebrations and ceremonies,
but I strongly agree with AlexD that this should simply be merged
into the big one, 20/32.  That can be ceremony enough.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> ---
>  include/linux/mmzone.h | 1 -
>  mm/page_alloc.c        | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index f0596e634863..0ed520954843 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -758,7 +758,6 @@ struct deferred_split {
>  
>  	/* Write-intensive fields used by page reclaim */
>  	ZONE_PADDING(_pad1_)
> -	spinlock_t		lru_lock;
>  
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>  	/*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fab5e97dc9ca..775120fcc869 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6733,7 +6733,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
>  	init_waitqueue_head(&pgdat->pfmemalloc_wait);
>  
>  	pgdat_page_ext_init(pgdat);
> -	spin_lock_init(&pgdat->lru_lock);
>  	lruvec_init(&pgdat->__lruvec);
>  }
>  
> -- 
> 1.8.3.1
