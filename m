From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/26] x86/sgx: Store struct sgx_encl when allocating new
 va pages
Date: Wed, 16 Nov 2022 01:31:24 +0200
Message-ID: <Y3QhTDq/lu1X1/g5@kernel.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-3-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668555087;
        bh=8hSFEfFc2rYU4y6JuixLrusmaPXNA/CwMC1ARhw96BI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AfOwB5CIlVBTg9sQigXECI7n5KcI25kdUheWvyHi3D+zD/JtR4AWcDs9wOiI3i0h0
         mRsn94x4zEw+zPMGdkFP7j14q2qdPFTG6YvCcpWzx/bxVppZSKQXFpWSYcUY5mv2NX
         f7JAnkh1R+bXV49JJFqZs5Yceyi5SMdlUonuhAKIGpQw1cVjpOVq9i+q76Y0Q5LoKy
         E6d8XXL4sdmn0VmrLFWEXUzmY1YPoVMY/1LOfHEhFeIW6fSmhGN9UkOS0D2Sky9f+E
         WoJI4qZEYsxvYyXfoAv6QEjarVN+yzGb6pnUQtSdfvwni244ssVexsxi3AIPsUtVhO
         2tjkH3YJgGMdg==
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-3-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Nov 11, 2022 at 10:35:07AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> When allocating new va pages, pass the struct sgx_encl of the enclave

"Version Array (VA) pages"

> that is allocating the page. sgx_alloc_epc_page() will store this
> value in the encl_owner field of the struct sgx_epc_page. In a later
> patch, version array pages will be placed in an unreclaimable queue,

"VA pages"

> and then when the cgroup max limit is reached and there are no more
> reclaimable pages and the enclave must be oom killed, all the
> va pages associated with that enclave can be uncharged and freed.

"VA pages"

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c  | 5 +++--
>  arch/x86/kernel/cpu/sgx/encl.h  | 2 +-
>  arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
>  arch/x86/kernel/cpu/sgx/sgx.h   | 2 ++
>  4 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index f40d64206ded..4eaf9d21e71b 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -1193,6 +1193,7 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
>  
>  /**
>   * sgx_alloc_va_page() - Allocate a Version Array (VA) page
> + * @encl:    The enclave that this page is allocated to.
>   * @reclaim: Reclaim EPC pages directly if none available. Enclave
>   *           mutex should not be held if this is set.
>   *
> @@ -1202,12 +1203,12 @@ void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr)
>   *   a VA page,
>   *   -errno otherwise
>   */
> -struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
> +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
>  {
>  	struct sgx_epc_page *epc_page;
>  	int ret;
>  
> -	epc_page = sgx_alloc_epc_page(NULL, reclaim);
> +	epc_page = sgx_alloc_epc_page(encl, reclaim);
>  	if (IS_ERR(epc_page))
>  		return ERR_CAST(epc_page);
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index f94ff14c9486..831d63f80f5a 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -116,7 +116,7 @@ struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
>  					  unsigned long offset,
>  					  u64 secinfo_flags);
>  void sgx_zap_enclave_ptes(struct sgx_encl *encl, unsigned long addr);
> -struct sgx_epc_page *sgx_alloc_va_page(bool reclaim);
> +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim);
>  unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
>  void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
>  bool sgx_va_page_full(struct sgx_va_page *va_page);
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index ebe79d60619f..9a1bb3c3211a 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -30,7 +30,7 @@ struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim)
>  		if (!va_page)
>  			return ERR_PTR(-ENOMEM);
>  
> -		va_page->epc_page = sgx_alloc_va_page(reclaim);
> +		va_page->epc_page = sgx_alloc_va_page(encl, reclaim);
>  		if (IS_ERR(va_page->epc_page)) {
>  			err = ERR_CAST(va_page->epc_page);
>  			kfree(va_page);
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index d16a8baa28d4..efb10eacd3aa 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -39,6 +39,8 @@ struct sgx_epc_page {
>  		struct sgx_encl_page *encl_owner;
>  		/* Use when SGX_EPC_PAGE_KVM_GUEST set in ->flags: */
>  		void __user *vepc_vaddr;
> +

Spurious newline.

> +		struct sgx_encl *encl;
>  	};
>  	struct list_head list;
>  };
> -- 
> 2.37.3
> 

BR, Jarkko
