From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Wed, 24 Nov 2021 15:57:58 +0000
Message-ID: <YZ5hBtWPBpHDWzE4@casper.infradead.org>
References: <20211124151915.GA6163@haolee.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MhRaQX30y19nymtN7XiLLZlWbPS4SbobGvSOfL7Qrks=; b=VWcQqruxbm2TEfSiEDvRf8EWp9
        i4YG+LkmraO3TfeifQvSRMDp6DVtjo6NuwHNNm7w9mmMhrdT3SoBe/tWe9brqTvQCZ7jZUs6T0ucc
        vX+aljEB/gNCEfxEjmrvv1+l395R0ThnB3iMrTAWrRMm3oTJnw94MzsSCTYF9QVeUI0p6A/2fLGBO
        61/8h4OIX0YlAYL8ybhL7MGaTNJuJM7ANRwGzp6TSshTFLDK40NOPz8IxvN54L3X/2lH89qqxL/rZ
        30wTPCtMr9Af5wOwli4O35Aca/Kgj0bE4wh2bXS9hHoU4/Dprs+kxcoVXS5U3v6/S6uE50Fiff0EE
        TAzAkjEA==;
Content-Disposition: inline
In-Reply-To: <20211124151915.GA6163-09FY7RZCRvthl2p70BpVqQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 24, 2021 at 03:19:15PM +0000, Hao Lee wrote:
> When several tasks are terminated simultaneously, lots of pages will be
> released, which can cause severe spinlock contention. Other tasks which
> are running on the same core will be seriously affected. We can yield
> cpu to fix this problem.

The realtime people will eat you alive for this suggestion.

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
