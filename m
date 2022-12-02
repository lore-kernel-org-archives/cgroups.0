From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/18] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Fri, 2 Dec 2022 13:33:22 -0800
Message-ID: <37de083d-a63b-b2ff-d00a-e890a1ba5eea@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-2-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670016805; x=1701552805;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HPqLdDybmZPcnhCw3eM3MCT0TLoOmh7Opn14IuT92aU=;
  b=ETWSnJPTOjljH/AP/Vth+YIoHhxED1thu4gVbM2nn7N7la9689YyWcM9
   vRfzWBjCUfw37XAS5VpArVHCbXOFms+E/yuSpId2dWCVdKq7tiO8HhdVs
   +sgn/2VwGUBCZsnfYmtLMttgEw2+pxRa3n39YY9NunWUUq2Es3+K8TDmH
   0vSNgLa7BeMMpIPW5/74896/HYVZf3lrNJ0cgvcKYXz6NzM4j82eO9Py6
   0XNz73KVc7UVmYMiQfl73LBvCeqMkBMIjS+yKuIUPJ2U8L3cI3aM11F4H
   JoNiLj2wnbxnaIPT3ff0zKO6R6hJ1iTJ32e1DirZVBZd8Mz8//yqpnbJD
   Q==;
Content-Language: en-US
In-Reply-To: <20221202183655.3767674-2-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> In order to avoid repetition of cond_resched() in ksgxd() and
> sgx_alloc_epc_page(), move the invocation of post-reclaim cond_resched()
> inside sgx_reclaim_pages(). Except in the case of sgx_reclaim_direct(),
> sgx_reclaim_pages() is always called in a loop and is always followed
> by a call to cond_resched().  This will hold true for the EPC cgroup
> as well, which adds even more calls to sgx_reclaim_pages() and thus
> cond_resched(). Calls to sgx_reclaim_direct() may be performance
> sensitive. Allow sgx_reclaim_direct() to avoid the cond_resched()
> call by moving the original sgx_reclaim_pages() call to
> __sgx_reclaim_pages() and then have sgx_reclaim_pages() become a
> wrapper around that call with a cond_resched().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 160c8dbee0ab..ffce6fc70a1f 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -287,7 +287,7 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
>   * problematic as it would increase the lock contention too much, which would
>   * halt forward progress.
>   */
> -static void sgx_reclaim_pages(void)
> +static void __sgx_reclaim_pages(void)
>  {
>  	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
>  	struct sgx_backing backing[SGX_NR_TO_SCAN];
> @@ -369,6 +369,12 @@ static void sgx_reclaim_pages(void)
>  	}
>  }
>  
> +static void sgx_reclaim_pages(void)
> +{
> +	__sgx_reclaim_pages();
> +	cond_resched();
> +}

Why bother with the wrapper?  Can't we just put cond_resched() in the
existing sgx_reclaim_pages()?
