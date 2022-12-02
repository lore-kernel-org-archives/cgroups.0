From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 06/18] x86/sgx: Introduce RECLAIM_IN_PROGRESS flag for
 EPC pages
Date: Fri, 2 Dec 2022 14:15:27 -0800
Message-ID: <371249f3-88b6-0bb0-ac69-0cf28f006da0@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-7-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670019329; x=1701555329;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=92uGNmRJkAcu57w2u9eAhtAlnFIYwslsgNeTh2w/P8s=;
  b=jHYIrC2FZXxCgEPS1UltEJXS9yJAr0ZpaAdvHjE3MjfGj2Bu0+CVP6ME
   0E1U037CNfNzFk0uEM+unJrrODtH4dsb01Xr6wrAHwxdsIPa/tlUl6HHl
   y+5VxM+QWkTiTweAODveTjxgmL7tLYODYQOdCuTsvtXXHcfZQHshZFqD9
   Scmw+kZodetL7Of5MukXd5TN30N90QS+6E2EIIZQeykgJe24maEkJ8jjM
   DbfFk2DunMv8vJlwBiAacZLtoOMt9Wgzz3O0NbrHqt85RZizrbHmruBAT
   AIIgjZs2fMAL23Dx8uE0qkcGfuN4fpDl/aR+Y1Hq5hkeh4Nv5PootzT6K
   g==;
Content-Language: en-US
In-Reply-To: <20221202183655.3767674-7-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> When selecting pages to be reclaimed from the page pool (sgx_global_lru),
> the list of reclaimable pages is walked, and any page that is both
> reclaimable and not in the process of being freed is added to a list of
> potential candidates to be reclaimed. After that, this separate list is
> further examined and may or may not ultimately be reclaimed. In order
> to prevent this page from being removed from the sgx_epc_lru_lists
> struct in a separate thread by sgx_drop_epc_page(), keep track of
> whether the EPC page is in the middle of being reclaimed with
> the addtion of a RECLAIM_IN_PROGRESS flag, and do not delete the page
> off the LRU in sgx_drop_epc_page() if it has not yet finished being
> reclaimed.

This never really comes out and tells us what problem is being addressed.
