From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 05/18] x86/sgx: Track epc pages on reclaimable or
 unreclaimable lists
Date: Fri, 2 Dec 2022 14:13:19 -0800
Message-ID: <1dccd2ec-cad8-b9d2-d66b-aebad21cdb44@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-6-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670019200; x=1701555200;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Tc0Asi9Ns/Uw80N6VM1uFJ98uRlF+kEfqeF5kPM3m/M=;
  b=n02GLvs84dzVV6fFBHSt2M5wLkwPLNR6SSwh9B1xW7w14Ax+WEt+wqAh
   lmbVakgBmrEty0YacXH7iQzP6DqaFlcLBWOHuELkwaCz7DxsWIPsuKufy
   kFrV0KJv/JyqdONyTEjUZavVmRbl1b4lKgIrhFT8q6SI3gMpNEHtdjdNW
   7Zs6FrxJzsPeREjUO4k545q4C7sulnLExzjp0M8uNDVgm4qh+gYG0o+e/
   oEVAXoETJUmR+Q6kqV1hoSE6QVEh4SWIdEKEdH/HTgUnhgcdPHqRQ54N0
   e7bzmvoIt+ZiDtqubYshBp255YWu4a4jVqi0C+58oKDsglfX1Kl9uWF4+
   g==;
Content-Language: en-US
In-Reply-To: <20221202183655.3767674-6-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> Replace functions sgx_mark_page_reclaimable() and
> sgx_unmark_page_reclaimable() with sgx_record_epc_page() and
> sgx_drop_epc_page(). sgx_record_epc_page() wil add the epc_page
> to the correct "reclaimable" or "unreclaimable" list in the
> sgx_epc_lru_lists struct. sgx_drop_epc_page() will delete the page
> from the LRU list. Tracking pages that are not tracked by
> the reclaimer in the sgx_epc_lru_lists "unreclaimable" list allows
> an OOM event to cause all the pages in use by an enclave to be freed,
> regardless of whether they were reclaimable pages or not.

This might be more a comment about Sean's stuff, but could you please
start using paragraphs in these changelogs?

Also, on the content, I really prefer that patches start off talking in
English as much as possible and not just talk about the code.

	Right now, SGX has a single LRU list.  The code is transitioning
	over to use multiple LRU lists.

I'd also prefer that _this_ patch do the:

> -	sgx_mark_page_reclaimable(entry->epc_page);
> +	sgx_record_epc_page(entry->epc_page, SGX_EPC_PAGE_RECLAIMER_TRACKED);

bits and then *another* patch do the unreclaimable side.  This patch
could be a straight replacement which is easy to audit.  The
unreclaimable one needs more thought.

I also think this ends up looking a bit weird:

> -	sgx_epc_push_reclaimable(&sgx_global_lru, page);
> +	WARN_ON(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
> +	page->flags |= flags;
> +	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
> +		sgx_epc_push_reclaimable(&sgx_global_lru, page);
> +	else
> +		sgx_epc_push_unreclaimable(&sgx_global_lru, page);
>  	spin_unlock(&sgx_global_lru.lock);
>  }

I think that would be better with a single "push" helper and then let
the callers specify the list:

	if (flags & SGX_EPC_PAGE_RECLAIMER_TRACKED)
		sgx_lru_push(&sgx_global_lru.reclaimable, page);
	else
		sgx_lru_push(&sgx_global_lru.unreclaimable, page);
