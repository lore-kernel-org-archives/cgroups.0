From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/18] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Thu, 8 Dec 2022 15:31:40 +0000
Message-ID: <Y5IDXF+6GmURxbYF@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-4-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670513504;
        bh=WZTPhqweYb/o6ohDAJocfkA2T1w/HsjxsO2NnvlkgdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kscGXX+bagLK+Geq93D1CijqPItQ/7f7ftpfSh/tZtfprhKu5Q2x0/FeeQuT7yuac
         j8wTZVA47CE//1Xy7LszG7CNWIXF4LrXf3GUUfQ021xIK5P2m56u9aXHuel30JK+lU
         rJBOrA/6o1BN8bqjjMtDEZ+BPC+M/2r2DCYLTOACAugpWB6CcKO+AQS4CJUmDX5FOv
         0+rGZv3NADk+PapxLVsWnEFWTp1fZvf6Lyt3Czf9sYo6A0ARdrDVY/TM5KZSZ733E/
         UYG1/FXw5pUGZzTt6n23kKFkpHEsUjeDI5c1Vau7JU6QqTBwYwGwiVNFev4a7/RvzR
         NIh65xjOZciPA==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-4-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:39AM -0800, Kristen Carlson Accardi wrote:
> Introduce a data structure to wrap the existing reclaimable list
> and its spinlock in a struct to minimize the code changes needed
> to handle multiple LRUs as well as reclaimable and non-reclaimable
> lists, both of which will be introduced and used by SGX EPC cgroups.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h | 65 +++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 39cb15a8abcb..5e6d88438fae 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -90,6 +90,71 @@ static inline void *sgx_get_epc_virt_addr(struct sgx_epc_page *page)
>  	return section->virt_addr + index * PAGE_SIZE;
>  }
>  
> +/*
> + * This data structure wraps a list of reclaimable EPC pages, and a list of
> + * non-reclaimable EPC pages and is used to implement a LRU policy during
> + * reclamation.
> + */
> +struct sgx_epc_lru_lists {
> +	spinlock_t lock;
> +	struct list_head reclaimable;
> +	struct list_head unreclaimable;
> +};
 
Why this is named like this, and not sgx_epc_global_rcu? Are there
any other use cases?

BR, Jarkko
