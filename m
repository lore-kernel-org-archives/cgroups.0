From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/18] x86/sgx: Store struct sgx_encl when allocating
 new VA pages
Date: Fri, 2 Dec 2022 14:47:19 -0800
Message-ID: <8b7f6993-2135-a9f9-63c5-c9c6112ef676@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-3-kristen@linux.intel.com>
 <3a789b1c-4c70-158b-d764-daec141a5816@intel.com>
 <abfc00a2ab1d97f8081c696f78e2d0ced23902b4.camel@linux.intel.com>
 <2015ae96-5459-1f82-596b-f46af08ef766@intel.com>
 <Y4p9nKV+jpLnOVwD@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670021241; x=1701557241;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dkeEf5B8jsEg+YW2ca5IJz8BTxuatCkhH7aEzKzYhwA=;
  b=TRNbU7MVQUdwEggN+76jch2KRChrRRo3V3RX5kL7BIqKFJN9CldpjVbE
   l1TfsmWW0yDjZE28Vehc9QFZB39aW/A0TQCOb9kgXVlFZ1Kr2WfrcaKvY
   a5MlTrmdf3hFoLaNGPmbbsgQ+gK485IxmevJi5nI9D5O3Q/nVsp6fHBys
   qULMp1CnAq+ZuW36Q6EuXfLuMHITmqg/7tgIfcE8sPUyNe+dDG+bfNUIE
   eKGIYRkGpOjXTL8SebjLKsb4k3EmpICiNYuIYpgUc9zIM7msU0OD5XBHv
   NCvAFixpgW4GjjyLM4fjk4FdpNpjYInGC8e7m8ESclV6AX+mg4SfTjmcU
   Q==;
Content-Language: en-US
In-Reply-To: <Y4p9nKV+jpLnOVwD-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On 12/2/22 14:35, Sean Christopherson wrote:
>> That seems like it's going the other direction from what an OOM-kill
>> would need to do.
> Providing a backpointer from a VA page to its enclave allows OOM-killing the enclave
> if its cgroup is over the limit but there are no reclaimable pages for said cgroup
> (for SGX's definition of "reclaimable").  I.e. if all of an enclave's "regular"
> pages have been swapped out, the only thing left resident in the EPC will be the
> enclave's VA pages, which are not reclaimable in the kernel's current SGX
> implementation.

Ooooooooooooooooooooh.  I'm a dummy.


So, we've got a cgroup.  It's in OOM-kill mode and we're looking at the
*cgroup* LRU lists.  We've done everything we can to the enclave and
swapped everything out that we can.  All we're left with are these
crummy VA pages on the LRU (or equally crummy pages).  We want to
reclaim them but can't swap VA pages.  Our only recourse is to go to the
enclave and kill *it*.

Right now, we can easily find an enclave's VA pages and free them.  We
do that all the time when freeing whole enclaves.  But, what we can't
easily do is find an enclave given a VA page.

A reverse pointer from VA page back to enclave allows the VA page's
enclave to be located and efficiently killed.

Right?

Could we add that context to the changelog, please?
