From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 02/20] x86/sgx: Store EPC page owner as a 'void *' to
 handle multiple users
Date: Thu, 22 Sep 2022 11:54:18 -0700
Message-ID: <3b0e70bb-6e9d-d5da-8e96-d9a813d5ab3f@intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-3-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663872858; x=1695408858;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=18DSOnaBqd0/z4y1LvXCXFY/s8ZUIoakuUNkf0L236A=;
  b=RXKX73PXaFsIleHDlFNSkERG6zoBIGaGwZycBAmgmkaQyJU1Srb2mfBZ
   uC/KV3p6IVkeofFrHmI3QRm6mjLvYGnyG0LedQvaNXnEr3OP63nw311HT
   +lj8FcB0Azl5CfDcBpOWr/Qx3zqndoCdXONaCx2irxY2vhsG52oFAyVhn
   H3IhjkRQdSTyzkYSRSYEk6sJpomGhifeD2nrun/0YCCYXI+gpaazkQxFd
   SBOErP4KObz2ks7VNWGTRWQoMUR5w5FrS2UhmBhqqUDpvuKgmuzZ2/h1d
   aV/8NTFStq3LADqB2n3zMiwPSZOsjMqZGSZ04a7rD6sHvlNIc1t1xCSXb
   Q==;
Content-Language: en-US
In-Reply-To: <20220922171057.1236139-3-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 9/22/22 10:10, Kristen Carlson Accardi wrote:
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

We normally handle these with a union.  I'd probably do something like
this instead:

-	struct sgx_encl_page *owner;
+	union owner {
+		struct sgx_encl	     *o_encl;
+		struct sgx_encl_page *o_page;
+	}
