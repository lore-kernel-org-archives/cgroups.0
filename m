From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 19/32] hugepage: convert huge zero page shrinker to new shrinker API
Date: Sun, 14 Apr 2013 22:38:37 -0700
Message-ID: <xr93y5ck73qa.fsf@gthelen.mtv.corp.google.com>
References: <1365429659-22108-1-git-send-email-glommer@parallels.com>
	<1365429659-22108-20-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:message-id:user-agent
         :mime-version:content-type;
        bh=6/z7q+SJGPNZjFXnUecWotyrFvKvxNYW2PU7bZzvm8E=;
        b=Qy+7WX79kOFiscBhyyYwxmodgHnyDcgbi42+juQGlBMSclmnVgy7HQDIvjU3u+TE/r
         cy1rwvvKsdlmHhu47Z34leTQeB1d2BXLOzLktpMMGB9PgZa6JSCGON/mKIfwZKo69MyJ
         YeUT8f1kAv40y3BtNKYErOmEa7iT6ojCiWkFt4IeOARkPz9G5kZgXx0tf4QTErx+hk49
         jC7oBSNJSK4mp1pKN4ja2sAw63jQH0aWXdGF3buDw+uOJqrq9ZOLLfbNSq4V2Yh/uZoP
         rDOgHN3wONoP/n6XEUMmZhppxnXmXubLZXWTSPgxSGwx0JEJ7vQhY7z5NmvrMp6kwwt1
         QmRA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Shrinnker <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Apr 08 2013, Glauber Costa wrote:

> It consists of:
>
> * returning long instead of int
> * separating count from scan
> * returning the number of freed entities in scan
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> ---
>  mm/huge_memory.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e2f7f5aa..8bf43d3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -212,24 +212,30 @@ static void put_huge_zero_page(void)
>  	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
>  }
>  
> -static int shrink_huge_zero_page(struct shrinker *shrink,
> -		struct shrink_control *sc)
> +
> +static long shrink_huge_zero_page_count(struct shrinker *shrink,
> +					struct shrink_control *sc)
>  {
> -	if (!sc->nr_to_scan)
> -		/* we can free zero page only if last reference remains */
> -		return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
> +	/* we can free zero page only if last reference remains */
> +	return atomic_read(&huge_zero_refcount) == 1 ? HPAGE_PMD_NR : 0;
> +}
>  
> +static long shrink_huge_zero_page_scan(struct shrinker *shrink,
> +				       struct shrink_control *sc)
> +{
>  	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
>  		unsigned long zero_pfn = xchg(&huge_zero_pfn, 0);
>  		BUG_ON(zero_pfn == 0);
>  		__free_page(__pfn_to_page(zero_pfn));
> +		return HPAGE_PMD_NR;
>  	}
>  
>  	return 0;
>  }
>  
>  static struct shrinker huge_zero_page_shrinker = {
> -	.shrink = shrink_huge_zero_page,
> +	.scan_objects = shrink_huge_zero_page_scan,
> +	.count_objects = shrink_huge_zero_page_count,
>  	.seeks = DEFAULT_SEEKS,
>  };
