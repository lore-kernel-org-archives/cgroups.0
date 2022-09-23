From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 02/20] x86/sgx: Store EPC page owner as a 'void *' to
 handle multiple users
Date: Fri, 23 Sep 2022 15:49:20 +0300
Message-ID: <Yy2rUH7i05qEoOIx@kernel.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-3-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663937364;
        bh=jKlwvRhlqKpZTB/gIibghWfeoMWb/cK+eUxT5ZBJaPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MrhvdNPpP+JywPO2T9ln/RgYCZIbIzVq90Mx1nB2fOuCzGy1floh4sLu4wv+NoHNi
         z9HysZ2PnFFUWuZWeHR+IjcNrMaFx8irxsZO4x/aKeXQmRoZyElqN1GuxRhNgQQF8M
         EjnTOloP2xj2W/0uKhzMmth6nznNZIAw+Pb5iSOiAjRWCVf6gSzQGhdwh5AHZZ1mSx
         z63drz+QkBm3dm1tpmWhlMCY1QM1mpLroSEcE59NTY0jmxyHv8OUSfHvB0swyGyj7c
         FoFQFWicf4U0STOGrH8aLmr4G9/81GNq+Q4nroSPTl/oA4osU8REAgSRUWY3uQLrIF
         SnX/XMeHtavAw==
Content-Disposition: inline
In-Reply-To: <20220922171057.1236139-3-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 22, 2022 at 10:10:39AM -0700, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> A future patch will use the owner field for either a pointer to
> a struct sgx_encl, or a struct sgx_encl_page.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/cpu/sgx/sgx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
> index 0f2020653fba..5a7e858a8f98 100644
> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> @@ -33,7 +33,7 @@ struct sgx_epc_page {
>  	unsigned int section;
>  	u16 flags;
>  	u16 poison;
> -	struct sgx_encl_page *owner;
> +	void *owner;
>  	struct list_head list;
>  };
>  
> -- 
> 2.37.3
> 

Conflicts with https://lore.kernel.org/linux-sgx/20220920063948.3556917-1-zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/T/#m5c911085eb350df564db2c18e344ce036e269749

BR, Jarkko
