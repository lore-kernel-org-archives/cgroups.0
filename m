From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 06/18] x86/sgx: Introduce RECLAIM_IN_PROGRESS flag for
 EPC pages
Date: Thu, 8 Dec 2022 15:46:21 +0000
Message-ID: <Y5IGzbNxOBkRoaRx@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-7-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670514385;
        bh=05rF6alqZ9n0FU7nrg3W/B/DQ0ox7mpQjwDMeBQNWu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EDR/lD98d5MJ6Ho6a/oOYnc99oHhwIRQNwcRpJS97Dc4sNSWV4p07+6En9RUph/5v
         UUw6vv830ShbRT72jXcuXG/qzVpaP1rK8WJaq5BkLwjGj0mkoofJYoXaolShBxbszO
         g1uYfpyJUbZub2rQtxLMf7tgN7fIanYyX8RGW0B0jqzjp5roweJIumZFgevHsOgweq
         yxZWvBOjeQNFqT1x0Uum4mGkyZEJpgI4uDD6oOCz+Q8p/KDDT0/2a04gfAJvHjJYMa
         zot+veLxvvlkGCEcT4PyO5WZ1O8aW8GcFk369hN3/1pP6Hu+6LvbFLtNwFT8rcd1Jf
         nU9eXNZXWLr7Q==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-7-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:42AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> When selecting pages to be reclaimed from the page pool (sgx_global_lru),
> the list of reclaimable pages is walked, and any page that is both
> reclaimable and not in the process of being freed is added to a list of
> potential candidates to be reclaimed. After that, this separate list is
> further examined and may or may not ultimately be reclaimed. In order
> to prevent this page from being removed from the sgx_epc_lru_lists
> struct in a separate thread by sgx_drop_epc_page(), keep track of
> whether the EPC page is in the middle of being reclaimed with
> the addtion of a RECLAIM_IN_PROGRESS flag, and do not delete the page
> off the LRU in sgx_drop_epc_page() if it has not yet finished being
> reclaimed.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 15 ++++++++++-----
>  arch/x86/kernel/cpu/sgx/sgx.h  |  2 ++
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index ecd7f8e704cc..bad72498b0a7 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -305,13 +305,15 @@ static void __sgx_reclaim_pages(void)
>  
>  		encl_page = epc_page->encl_owner;
>  
> -		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0)
> +		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
> +			epc_page->flags |= SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
>  			chunk[cnt++] = epc_page;
> -		else
> +		} else {
>  			/* The owner is freeing the page. No need to add the
>  			 * page back to the list of reclaimable pages.
>  			 */
>  			epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> +		}
>  	}
>  	spin_unlock(&sgx_global_lru.lock);
>  
> @@ -337,6 +339,7 @@ static void __sgx_reclaim_pages(void)
>  
>  skip:
>  		spin_lock(&sgx_global_lru.lock);
> +		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIM_IN_PROGRESS;
>  		sgx_epc_push_reclaimable(&sgx_global_lru, epc_page);
>  		spin_unlock(&sgx_global_lru.lock);
>  
> @@ -360,7 +363,8 @@ static void __sgx_reclaim_pages(void)
>  		sgx_reclaimer_write(epc_page, &backing[i]);
>  
>  		kref_put(&encl_page->encl->refcount, sgx_encl_release);
> -		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
> +		epc_page->flags &= ~(SGX_EPC_PAGE_RECLAIMER_TRACKED |
> +				     SGX_EPC_PAGE_RECLAIM_IN_PROGRESS);
>  
>  		sgx_free_epc_page(epc_page);
>  	}
> @@ -508,7 +512,8 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
>  {
>  	spin_lock(&sgx_global_lru.lock);
> -	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> +	WARN_ON(page->flags & (SGX_EPC_PAGE_RECLAIMER_TRACKED |
> +			       SGX_EPC_PAGE_RECLAIM_IN_PROGRESS));
>  	page->flags |= flags;
>  	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
>  		sgx_epc_push_reclaimable(&sgx_global_lru, page);
> @@ -532,7 +537,7 @@ int sgx_drop_epc_page(struct sgx_epc_page *page)
>  	spin_lock(&sgx_global_lru.lock);
>  	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
>  		/* The page is being reclaimed. */
> -		if (list_empty(&page->list)) {
> +		if (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS) {
>  			spin_unlock(&sgx_global_lru.lock);
>  			return -EBUSY;
>  		}
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index ba4338b7303f..37d66bc6ca27 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -30,6 +30,8 @@
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
>  /* Pages allocated for KVM guest */
>  #define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
> +/* page flag to indicate reclaim is in progress */
> +#define SGX_EPC_PAGE_RECLAIM_IN_PROGRESS BIT(3)
>  
>  struct sgx_epc_page {
>  	unsigned int section;
> -- 
> 2.38.1
> 

I would create:

enum sgx_epc_state {    
        SGX_EPC_STATE_READY = 0,
        SGX_EPC_STATE_RECLAIMER_TRACKED = 1,
        SGX_EPC_STATE_RECLAIM_IN_PROGRESS = 2,
};

I.e. not a bitmask because page should have only one state at
a time for any of this to make any sense. We have an FSM,
right?

And then allocate 2 upper bits to store this information from
flags.

And probably would make sense to have inline helper functions
to setting and getting the state that does the bitshifting and
masking shenanigangs.

This would be a patch prepending this.

In this patch you should then describe in the context of FSM
how EPC page moves between these states. With that knowledge
we can then reflect the actual code change.

The point is not to get right but more like a mindset that we
can discuss right or wrong in thee first place so just do your
best but don't stress too much.

BR, Jarkko
