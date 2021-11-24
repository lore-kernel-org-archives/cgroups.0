From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Wed, 24 Nov 2021 17:31:57 +0100
Message-ID: <YZ5o/VmU59evp65J@dhcp22.suse.cz>
References: <20211124151915.GA6163@haolee.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637771518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Zlxw+Rp7HNPM08yf9RQ2otAy6kMKKm82h1DuizBhVs=;
        b=kvlaZyAZtdO4xGJaVhlIbgldeZDe8dWDxYpweto04dNhK1HokcngfkMFYHnNhQ1FIoqcKY
        czfjxXpIhR8yBj9ho9sTua3vCySoFNJoVI4oj93jjj75cASczmfdA3axwSPaU9Hnz5d/Ed
        nRrVTk/DxaqY6WuhTRi4RMh5BmMNbTY=
Content-Disposition: inline
In-Reply-To: <20211124151915.GA6163-09FY7RZCRvthl2p70BpVqQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 24-11-21 15:19:15, Hao Lee wrote:
> When several tasks are terminated simultaneously, lots of pages will be
> released, which can cause severe spinlock contention. Other tasks which
> are running on the same core will be seriously affected. We can yield
> cpu to fix this problem.

How does this actually address the problem? You are effectivelly losing
fairness completely. We do batch currently so no single task should be
able to monopolize the cpu for too long. Why this is not sufficient?

> diff --git a/mm/swap.c b/mm/swap.c
> index e8c9dc6d0377..91850d51a5a5 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -960,8 +960,14 @@ void release_pages(struct page **pages, int nr)
>  		if (PageLRU(page)) {
>  			struct lruvec *prev_lruvec = lruvec;
>  
> -			lruvec = folio_lruvec_relock_irqsave(folio, lruvec,
> +retry:
> +			lruvec = folio_lruvec_tryrelock_irqsave(folio, lruvec,
>  									&flags);
> +			if (!lruvec) {
> +				cond_resched();
> +				goto retry;
> +			}
> +
>  			if (prev_lruvec != lruvec)
>  				lock_batch = 0;
>  
> -- 
> 2.31.1

-- 
Michal Hocko
SUSE Labs
