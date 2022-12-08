From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 17/18] x86/sgx: Add support for misc cgroup controller
Date: Thu, 8 Dec 2022 15:30:11 +0000
Message-ID: <Y5IDA3J/6pF0sNIP@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-18-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670513415;
        bh=MelMEVFD640a+Eraf0URPWnvaMDa0Z6oybjpXa5D5hc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnVQZOJ62CX0VOaw1PmcOWmOm6h1WUzKfs7ZdYqK8aLvSoxfI4Jrtq8pfmDee8Hzi
         0Q/JUMD3tmTUR2o1q+oZ6Hf6okuKoSxfhfi5G6BT1Aeuc+VriI3e2OQiPDIZoizxb7
         vmNgrxQbhlx0eiGj6ntm6SNXU+HoGZM5g63+673r6J+Wey6jlBWnd3HV7eYk0bezrS
         Ant79PyU7hTD3pArNOac4+OdT1cnZlChjYu0lTUqfrxgh7woFKxBxzhtHxIicPw+rQ
         wrxQn77s2306xmO0v9hZ5jO5qvg+2IOjhF7Ve4hh6nt6QLnV0gCfE4E0yH/T4wQ3nQ
         a5GN6FemD+TAg==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-18-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Perhaps "x86/sgx: Limit process EPC usage with misc cgroup controller"?

Or something more to the point than "add support".

On Fri, Dec 02, 2022 at 10:36:53AM -0800, Kristen Carlson Accardi wrote:
  
>  /**
> - * sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
> + * __sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
>   * @nr_to_scan:		 Number of EPC pages to scan for reclaim
>   * @ignore_age:		 Reclaim a page even if it is young
> + * @epc_cg:		 EPC cgroup from which to reclaim
>   *
>   * Take a fixed number of pages from the head of the active page pool and
>   * reclaim them to the enclave's private shmem files. Skip the pages, which have
> @@ -336,7 +350,8 @@ void sgx_isolate_epc_pages(struct sgx_epc_lru_lists *lru, int *nr_to_scan,
>   * problematic as it would increase the lock contention too much, which would
>   * halt forward progress.
>   */
> -static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
> +static int __sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age,
> +			  struct sgx_epc_cgroup *epc_cg)
>  {
>  	struct sgx_backing backing[SGX_MAX_NR_TO_RECLAIM];
>  	struct sgx_epc_page *epc_page, *tmp;
> @@ -347,7 +362,15 @@ static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
>  	int i = 0;
>  	int ret;
>  
> -	sgx_isolate_epc_pages(&sgx_global_lru, &nr_to_scan, &iso);
> +        /*
> +         * If a specific cgroup is not being targetted, take from the global
> +         * list first, even when cgroups are enabled.  If there are
> +         * pages on the global LRU then they should get reclaimed asap.
> +         */
> +        if (!IS_ENABLED(CONFIG_CGROUP_SGX_EPC) || !epc_cg)
> +                sgx_isolate_epc_pages(&sgx_global_lru, &nr_to_scan, &iso);
> +
> +	sgx_epc_cgroup_isolate_pages(epc_cg, &nr_to_scan, &iso);
>  
>  	if (list_empty(&iso))
>  		return 0;
> @@ -397,25 +420,33 @@ static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
>  				     SGX_EPC_PAGE_ENCLAVE |
>  				     SGX_EPC_PAGE_VERSION_ARRAY);
>  
> +		if (epc_page->epc_cg) {
> +			sgx_epc_cgroup_uncharge(epc_page->epc_cg);
> +			epc_page->epc_cg = NULL;
> +		}
> +
>  		sgx_free_epc_page(epc_page);
>  	}
>  	return i;
>  }

I would consider changes to sgx_reclaim_epc_pages() as a separate patch,
perhaps squashing with the patch that does the export. And generally
separate from this patch all internal arch/x86/kernel/cpu/sgx changes,
and leave only cgroup bindings.

BR, Jarkko
