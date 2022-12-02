From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 03/18] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Fri, 2 Dec 2022 13:39:42 -0800
Message-ID: <cfdfd5df-9b5d-f4c1-91fe-e0443819fa7e@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-4-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670017184; x=1701553184;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=x3lQwjwLht49M/jM4Z/ZUC2yG9PXyBbEO1YpDGLZO68=;
  b=Nn4+NRSNTy0rVF8PpJEIqUxtTiGeYmhuMIjRfJQXYHN+BCEtwZe0da/Q
   JntlgbJwaI81aibynFCw/GL7p6ZrXY/ocJWnCwNj16qLTqLNdSjQ36EKO
   1+dNMUCbFj8n5aVdV1ToBMi3cnWo2rgvGK5nKf5AiBNR0GFcx3V3yw0io
   i+B8iQm31V0pChiJwDk2RAHVdJTkXvHwsP8V0P/vxecObkPpWhQrp5ssD
   gBxeva1uQNXjMXdHK/72q9Jy2FaJb2DS4fyor+fyOSUGP6S9Y0BvnAI27
   POv4QfO+x3SpNTCMZB/zahVRb3sYVIsL4op+M44XrXPW1gQBO7BpVexuQ
   Q==;
Content-Language: en-US
In-Reply-To: <20221202183655.3767674-4-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> Introduce a data structure to wrap the existing reclaimable list
> and its spinlock in a struct to minimize the code changes needed
> to handle multiple LRUs as well as reclaimable and non-reclaimable
> lists, both of which will be introduced and used by SGX EPC cgroups.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Tiny nits: Let's also allude to the fact that this doesn't do anything
with the new helpers or structures for now.

I also think it's probably a sane idea to mention that the core VM also
has parallel LRU lists for cgroups.

> +static inline struct sgx_epc_page *
> +sgx_epc_pop_reclaimable(struct sgx_epc_lru_lists *lrus)
> +{
> +	return __sgx_epc_page_list_pop(&(lrus)->reclaimable);
> +}

Are those '(lrus)' parenthesis doing anything useful?
