From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/18] x86/sgx: Store struct sgx_encl when allocating
 new VA pages
Date: Fri, 2 Dec 2022 13:48:32 -0800
Message-ID: <2015ae96-5459-1f82-596b-f46af08ef766@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-3-kristen@linux.intel.com>
 <3a789b1c-4c70-158b-d764-daec141a5816@intel.com>
 <abfc00a2ab1d97f8081c696f78e2d0ced23902b4.camel@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670017714; x=1701553714;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EDfBXWfAHYVtwU57hMCKCO16uMM3c78FeY5S9PDvlJ4=;
  b=nBHCTjZNwGgHAkuxZ7mFZGwruzY4bIZl2iBPjmSh77HsBpNSaoJPIV0u
   6D6U4Z8Sftjq7a1BySK7s9PfoPIEv7uzcQLLRyzUWel7s+rX1vJSG2fQE
   GqiYY1Ltrag1onaq1uZc2nuwhpQFOzcClnyDOAPEDyXegpq0U7LHmcPrc
   HmGUpijWhlcCmFZUD5bT1kdexPsBsnKJ6DGztXv/kyMrD2g6r2LLlzvuM
   Du32wsJssbjV/y7Z+IQasE9irR5RyvR+M9+Jh03KzNCDM6uP3YT1VmdrU
   ZyItSACFsJSaw4ZQMPsRnhrFh64/l3cUYQs/FbJZEd9GU076BfSC5bVsj
   g==;
Content-Language: en-US
In-Reply-To: <abfc00a2ab1d97f8081c696f78e2d0ced23902b4.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 13:40, Kristen Carlson Accardi wrote:
> On Fri, 2022-12-02 at 13:35 -0800, Dave Hansen wrote:
>> On 12/2/22 10:36, Kristen Carlson Accardi wrote:
>>> When allocating new Version Array (VA) pages, pass the struct
>>> sgx_encl
>>> of the enclave that is allocating the page. sgx_alloc_epc_page()
>>> will
>>> store this value in the encl_owner field of the struct
>>> sgx_epc_page. In
>>> a later patch, VA pages will be placed in an unreclaimable queue,
>>> and then when the cgroup max limit is reached and there are no more
>>> reclaimable pages and the enclave must be oom killed, all the
>>> VA pages associated with that enclave can be uncharged and freed.
>> What does this have to do with the 'encl' that is being passed,
>> though?
>>
>> In other words, why is this new sgx_epc_page-to-encl mapping needed
>> for
>> VA pages now, but it wasn't before?
> When we OOM kill an enclave, we want to get rid of all the associated
> VA pages too. Prior to this patch, there wasn't a way to easily get the
> VA pages associated with an enclave.

Given an enclave, we have encl->va_pages to look up all the VA pages.
Also, this patch's code allows you to go from a va page to an enclave.
That seems like it's going the other direction from what an OOM-kill
would need to do.
