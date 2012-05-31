From: Konrad Rzeszutek Wilk <konrad-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -V7 01/14] hugetlb: rename max_hstate to
 hugetlb_max_hstate
Date: Wed, 30 May 2012 20:48:40 -0400
Message-ID: <20120531004838.GC401@localhost.localdomain>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rgWt1kKFaMdYfa/+wHE462ySzQf0msmUo+9DHoyILy8=;
        b=UzQ0ULDRB3Z6TP2D3h8zPYcQ2BPTSbG4EF2CIIHpwHDCLDIk71TXsWtLGDXitSIqXn
         JViAHg5sK9g6l6RYo5p5K3MmKTL2HSDknv0fB+qwKkBeeKJOWYen3tCJx0ONMfogIfD9
         0o6De0QXb63NM2nCx/tdBx92xa93WAWdFPGnfhq71Qus4Fepi96ycdW3GXoA//3MMCP8
         iQo2ZZNB6U1lQlKS7Zmkqd7iE5skbDK3uF02Qt5CHk0lsN0UAVTPYWIt+CDgB0YAiwYL
         QEEJQzgffDA+Penj4yVyQufLfGtxh4i6kIwiZKpvaa45P0IMH9WsfnX9Xb7IIUCV8/gG
         cnSw==
Content-Disposition: inline
In-Reply-To: <1338388739-22919-2-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, May 30, 2012 at 08:08:46PM +0530, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Rename max_hstate to hugetlb_max_hstate.  We will be using this from other
> subsystems like hugetlb controller in later patches.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Acked-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Your SOB needs to be the last thing.

> ---
>  mm/hugetlb.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 285a81e..e07d4cd 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -34,7 +34,7 @@ const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
>  static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
>  unsigned long hugepages_treat_as_movable;
>  
> -static int max_hstate;
> +static int hugetlb_max_hstate;
>  unsigned int default_hstate_idx;
>  struct hstate hstates[HUGE_MAX_HSTATE];
>  
> @@ -46,7 +46,7 @@ static unsigned long __initdata default_hstate_max_huge_pages;
>  static unsigned long __initdata default_hstate_size;
>  
>  #define for_each_hstate(h) \
> -	for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
> +	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
>  
>  /*
>   * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
> @@ -1897,9 +1897,9 @@ void __init hugetlb_add_hstate(unsigned order)
>  		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
>  		return;
>  	}
> -	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
> +	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>  	BUG_ON(order == 0);
> -	h = &hstates[max_hstate++];
> +	h = &hstates[hugetlb_max_hstate++];
>  	h->order = order;
>  	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
>  	h->nr_huge_pages = 0;
> @@ -1920,10 +1920,10 @@ static int __init hugetlb_nrpages_setup(char *s)
>  	static unsigned long *last_mhp;
>  
>  	/*
> -	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
> +	 * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter yet,
>  	 * so this hugepages= parameter goes to the "default hstate".
>  	 */
> -	if (!max_hstate)
> +	if (!hugetlb_max_hstate)
>  		mhp = &default_hstate_max_huge_pages;
>  	else
>  		mhp = &parsed_hstate->max_huge_pages;
> @@ -1942,7 +1942,7 @@ static int __init hugetlb_nrpages_setup(char *s)
>  	 * But we need to allocate >= MAX_ORDER hstates here early to still
>  	 * use the bootmem allocator.
>  	 */
> -	if (max_hstate && parsed_hstate->order >= MAX_ORDER)
> +	if (hugetlb_max_hstate && parsed_hstate->order >= MAX_ORDER)
>  		hugetlb_hstate_alloc_pages(parsed_hstate);
>  
>  	last_mhp = mhp;
> -- 
> 1.7.10
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
