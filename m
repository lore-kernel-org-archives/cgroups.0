From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 12/18] x86/sgx: Expose sgx_reclaim_pages() for use by
 EPC cgroup
Date: Thu, 8 Dec 2022 09:46:26 +0000
Message-ID: <Y5GyckFSARH9ANUt@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-13-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670492790;
        bh=dpBeJVLLnt/wb7IR1Gd04VZ2UovV0cnf+pFYvVnTkNk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RaublSEi40KBKPk2OWsAjhjg4ekec+LxdJ+pqFwjmSC3bBAuRQA4IjFuEjWzjDCCK
         pjqQUIXjhphrgtZKoT+KSCgFIop8EKdQJqlZi4akY7Y2W/GhVX2EYu1iV/rWbuCFuK
         nqR9fMgIrVyn34c3R5sYkMe4Nb2Z/5YJTVmhrOUXuZqSR/XwpXx5JDO3G/LNKov2e9
         4SP9aFKp8l96zdcb5cYZdFQOBE0/IbLCss9So4ZsVt4EPTibKG8cmQzxNmgdXg549X
         d1N0HNr/yFzJgD8zVhSUByJoLHTaEu/iB2hzKMLy0TF3Pwd9jJ5b7GV+X8nCiSN9P6
         6ubn8NQOulBFQ==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-13-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:48AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Expose the top-level reclaim function as sgx_reclaim_epc_pages() for use
> by the upcoming EPC cgroup, which will initiate reclaim to enforce
> changes to high/max limits.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 7 ++++---
>  arch/x86/kernel/cpu/sgx/sgx.h  | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 96399e2016a8..c947b4ae06f3 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -281,6 +281,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>  
>  /**
>   * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
> + * sgx_reclaim_epc_pages() - Reclaim EPC pages from the consumers
>   * @nr_to_scan:		 Number of EPC pages to scan for reclaim
>   * @ignore_age:		 Reclaim a page even if it is young
>   *
> @@ -385,7 +386,7 @@ static int __sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
>  	return i;
>  }
>  
> -static int sgx_reclaim_pages(int nr_to_scan, bool ignore_age)
> +int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age)
>  {
>  	int ret;
>  
> @@ -441,7 +442,7 @@ static int ksgxd(void *p)
>  				     sgx_should_reclaim(SGX_NR_HIGH_PAGES));
>  
>  		if (sgx_should_reclaim(SGX_NR_HIGH_PAGES))
> -			sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
> +			sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
>  	}
>  
>  	return 0;
> @@ -624,7 +625,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
>  			break;
>  		}
>  
> -		sgx_reclaim_pages(SGX_NR_TO_SCAN, false);
> +		sgx_reclaim_epc_pages(SGX_NR_TO_SCAN, false);
>  	}
>  
>  	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index ec8d567cd975..ce859331ddf5 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -206,6 +206,7 @@ void sgx_reclaim_direct(void);
>  void sgx_record_epc_page(struct sgx_epc_page *page, unsigned long flags);
>  int sgx_drop_epc_page(struct sgx_epc_page *page);
>  struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
> +int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age);
>  
>  void sgx_ipi_cb(void *info);
>  
> -- 
> 2.38.1
> 

Unless, there is a risk of name collision, I think this rename is
just adding unnecessary convolution to the patch set.

I would revert the rename part, and just export.

BR, Jarkko
