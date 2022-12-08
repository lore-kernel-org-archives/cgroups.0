From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/18] x86/sgx: Allow reclaiming up to 32 pages, but
 scan 16 by default
Date: Thu, 8 Dec 2022 09:26:32 +0000
Message-ID: <Y5GtyM92jE5/UJT3@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-9-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670491596;
        bh=TNqJerM9UR1fg07xX3h23a2j69g0XEpwAAYXPgA4ZEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s6CZZHIqy2xxLR3jpTBP+mtBdBxj+rY6+ATpzcxHIKjvPsU3xfYS23x1cuKm0NQk+
         e968/2VYe1r14ryWx5aHvjSKkXQ4zjUGk7Hgtk/Hzv8hDAuO+++M1V1bQydOn6A/N0
         2W/r+n3CWFatZLQsHsAuP4sjEd2PJlz+jkd6B62gzFpcAeYYBeoKWUqbWjvfnZ1ni7
         yF2MmE2sGvH57azEdUviynHwYkog9ABiYbMYnpbBLFPbzauFUeeOsRoXkF+ATDOjY/
         aDptE0IvKxRc/b5rhT68YTFEMuVzo7jJ4aXGihkgIMomwPzb5CTZeY/8KO3gUGZwM9
         zquRZ/oh754XQ==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-9-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:44AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Modify sgx_reclaim_pages() to take a parameter that specifies the
> number of pages to scan for reclaiming. Specify a max value of
> 32, but scan 16 in the usual case. This allows the number of pages
> sgx_reclaim_pages() scans to be specified by the caller, and adjusted
> in future patches.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 83aaf5cea7b9..f201ca85212f 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -18,6 +18,8 @@
>  #include "encl.h"
>  #include "encls.h"
>  
> +#define SGX_MAX_NR_TO_RECLAIM	32

SGX_NR_TO_SCAN_MAX

BR, Jarkko
