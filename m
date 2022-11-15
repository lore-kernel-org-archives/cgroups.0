From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/26] x86/sgx: Introduce RECLAIM_IN_PROGRESS flag for
 EPC pages
Date: Wed, 16 Nov 2022 01:42:42 +0200
Message-ID: <Y3Qj8sIzwU925DOw@kernel.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-7-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668555766;
        bh=ql4VR+JXhu364eSkc9NN3BGyg3p4NvWJIrWjWqfPrPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBQUhZQoYyb+8Zv73llLk1RJe6HknkFnFOwFLCmQj1+Lc68X/G0CjGODOKz21peMJ
         wISqY2zhFdF8pXrNsh+uYTiOY5YWr8SMdQINHK3cuGGqzXFVtp9derazEK+CxqzZXD
         /MKxLmzpe2ynEQTAbUqIOO6riu+jeOxUSrnYm9fL+2IZe1Kgz8Phzk9KvS8qWgXsGp
         e55lFIXSuisJ39e8uSf1mzmtCnUICrgYR3KzMkZ/9ACh9kjPG9mAqh1xaGsdMHBqW2
         Y7sDqwkdpigcw4P+TS5KMuMiGXr7gtwmIMTnYgGa21b97NUSthD6+9ut/dqmnVIoQn
         kbT28I9Z2nSzw==
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-7-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Nov 11, 2022 at 10:35:11AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Keep track of whether the EPC page is in the middle of being reclaimed
> and do not delete the page off the it's LRU if it has not yet finished

"off the it's LRU" ?

> being reclaimed.

I'm not sure how the description makes the change understandable.

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++-----
>  arch/x86/kernel/cpu/sgx/sgx.h  |  4 ++++
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 3b09433ffd85..8c451071fa91 100644
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
> @@ -508,7 +512,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags)
>  {
>  	spin_lock(&sgx_global_lru.lock);
> -	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> +	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIM_FLAGS);

Please, open code SGX_EPC_PAGE_RECLAIM_FLAGS. It only adds unnecassry
need to cross-reference to the header file.

Also, please describe the changes on how state flags are used before
and after this patch to the commit message.

>  	page->flags |= flags;
>  	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
>  		sgx_epc_push_reclaimable(&sgx_global_lru, page);
> @@ -532,7 +536,7 @@ int sgx_drop_epc_page(struct sgx_epc_page *page)
>  	spin_lock(&sgx_global_lru.lock);
>  	if (page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED) {
>  		/* The page is being reclaimed. */
> -		if (list_empty(&page->list)) {
> +		if (page->flags & SGX_EPC_PAGE_RECLAIM_IN_PROGRESS) {
>  			spin_unlock(&sgx_global_lru.lock);
>  			return -EBUSY;
>  		}
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 969606615211..04ca644928a8 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -30,6 +30,10 @@
>  #define SGX_EPC_PAGE_IS_FREE		BIT(1)
>  /* Pages allocated for KVM guest */
>  #define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
> +/* page flag to indicate reclaim is in progress */
> +#define SGX_EPC_PAGE_RECLAIM_IN_PROGRESS BIT(3)
> +#define SGX_EPC_PAGE_RECLAIM_FLAGS	(SGX_EPC_PAGE_RECLAIMER_TRACKED | \
> +					 SGX_EPC_PAGE_RECLAIM_IN_PROGRESS)
>  
>  struct sgx_epc_page {
>  	unsigned int section;
> -- 
> 2.37.3
> 

BR, Jarkko
