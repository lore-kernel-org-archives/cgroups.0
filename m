From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 03/20] x86/sgx: Track owning enclave in VA EPC pages
Date: Thu, 22 Sep 2022 11:55:38 -0700
Message-ID: <1adb03c8-1274-3898-0677-03015a1f5a5d@intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-4-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663873468; x=1695409468;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2g2t7Y1D2GeMdWECkMSTYsH2IHHAWTewLjokay44cUo=;
  b=lVUhM/67b/NktYH1cElTNNAcLmaHqBK/v7p2V0sqxRnVrjRpRbPHwWsy
   /INlP+y7iyhtCljW1R3+qTO/yixvewenkJLaxqBUmggseNVOdtIJME/KK
   8HX3WQ6yyGaz2nO1DftLiAZ1dY0AZx7VrLJXEEO5//6R3/K3QdLC6qYP5
   SYFRRyEgwYT6eGLYgfwYFqDQwHPUedm/I4V3vgsjJXUFGIjEW5Omm6bKc
   imca15LruESYQYaEACDmq+L7UUPtjNEEzaJc3F/IgYgnwwF/o5y0DeVk3
   bOX3l7+3PV+07V8mq986xxj3OHRhV3s/wLFnAXojh+sRrVLA8OAV22mwR
   Q==;
Content-Language: en-US
In-Reply-To: <20220922171057.1236139-4-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 9/22/22 10:10, Kristen Carlson Accardi wrote:
> -struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
> +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool reclaim)
>  {
>  	struct sgx_epc_page *epc_page;
>  	int ret;
> @@ -1218,6 +1219,8 @@ struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
>  		return ERR_PTR(-EFAULT);
>  	}
>  
> +	epc_page->owner = encl;
> +
>  	return epc_page;
>  }

BTW, is there a flag or any other way to tell to what kind of object
->owner points?
