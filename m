From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 04/18] x86/sgx: Use sgx_epc_lru_lists for existing
 active page list
Date: Fri, 2 Dec 2022 13:43:52 -0800
Message-ID: <ad1bcb0f-661d-a701-2175-c8750d8af8d8@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-5-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670017455; x=1701553455;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zEGTLgU156UOzQQlahIl9CwmIKuBkFnhmeSW3FERkys=;
  b=iqmETKsoVlOcOh3OjFhWg+47kGFRGWGsSXvbC2+NwhhBGTkKsEpH8RKa
   EFfzjXUMu3xWjpAwNJ9gLHC0zz/wEfT3RPWEJWGQWQJOGUx8MRvUO/lJF
   YtjTJEa38vbm7HYmXuHNu6fsi5WoozgWEDQmtrtJ3G3uq9VY8LZJuSRdw
   XcUpalHTT5+tHbGgL+82W38vf3TKZcNwBWyQNjkT8N6bkUmRLroAtF7uc
   llT2vQQfkd/VgpvMpd53ZriUOWANJ4D7bmH5gVi8IWi001qOBXZSnMsL7
   FEGASX8bEBXjcYjw96cO1VqdOtl+NCFZ+3JrzCrI233WTrzMIUHH+OwBS
   A==;
Content-Language: en-US
In-Reply-To: <20221202183655.3767674-5-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> +	spin_lock(&sgx_global_lru.lock);
>  	for (i = 0; i < SGX_NR_TO_SCAN; i++) {
> -		if (list_empty(&sgx_active_page_list))
> +		epc_page = sgx_epc_pop_reclaimable(&sgx_global_lru);
> +		if (!epc_page)
>  			break;

One other nit about the structure of the patches: This introduced *both*
reclaimable and unreclaimable list_heads.  But, it has zero use for the
unreclaimable ones during the refactoring here.  I probably would have
left out the 'unreclaimable' bits for now.

BTW, this is a nice sign:

>  arch/x86/kernel/cpu/sgx/main.c | 39 +++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 20 deletions(-)


