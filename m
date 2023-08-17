From: Mikko Ylinen <mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 22/28] Docs/x86/sgx: Add description for cgroup support
Date: Thu, 17 Aug 2023 18:18:06 +0300
Message-ID: <ZN46Lj8Ctde+QyPD@himmelriiki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-23-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692285506; x=1723821506;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QMgQfXBYJt0EBpimhe5IYAhnYAqWB+WrvTqlDZfpL3w=;
  b=FOLHCzY3pqHfPw2gmRK+O3Lzov+/8YKK3aZ/6R9TCqoWH8bQ478XQ+Uz
   HeYOWsogLVCVdw3tRKI1XeKK0h7LeHL/hPFkHmNfRxxwp0dzxbOynEAbA
   zNsIdXg+zepLcmOEy7DQourD1ju7VsbZFwu8Q1DaPHoU/Z5MWjZahW6BJ
   e+xlnCPRPIVKxaw7txxLWIENZvXb4R5At6JyF/eZsxdEbPnTpcyXoocXQ
   q/OOzuZWxZItscNvI8mAdv7xH2wNjfjrISQBrAF8CKW8XxrUjqXnyqyaB
   VzpS5w2vcY0LQmEpgeKtqN9nM69rqbtqwzVybq0zgfAFKRc2yasiKdZu5
   Q==;
Content-Disposition: inline
In-Reply-To: <20230712230202.47929-23-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed, Jul 12, 2023 at 04:01:56PM -0700, Haitao Huang wrote:
> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Add initial documentation of how to regulate the distribution of
> SGX Enclave Page Cache (EPC) memory via the Miscellaneous cgroup
> controller.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/arch/x86/sgx.rst | 77 ++++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/Documentation/arch/x86/sgx.rst b/Documentation/arch/x86/sgx.rst
> index 2bcbffacbed5..f6ca5594dcf2 100644
> --- a/Documentation/arch/x86/sgx.rst
> +++ b/Documentation/arch/x86/sgx.rst
> @@ -300,3 +300,80 @@ to expected failures and handle them as follows:
>     first call.  It indicates a bug in the kernel or the userspace client
>     if any of the second round of ``SGX_IOC_VEPC_REMOVE_ALL`` calls has
>     a return code other than 0.
> +
> +
> +Cgroup Support
> +==============
> +
> +The "sgx_epc" resource within the Miscellaneous cgroup controller regulates
> +distribution of SGX EPC memory, which is a subset of system RAM that
> +is used to provide SGX-enabled applications with protected memory,
> +and is otherwise inaccessible, i.e. shows up as reserved in
> +/proc/iomem and cannot be read/written outside of an SGX enclave.
> +
> +Although current systems implement EPC by stealing memory from RAM,
> +for all intents and purposes the EPC is independent from normal system
> +memory, e.g. must be reserved at boot from RAM and cannot be converted
> +between EPC and normal memory while the system is running.  The EPC is
> +managed by the SGX subsystem and is not accounted by the memory
> +controller.  Note that this is true only for EPC memory itself, i.e.
> +normal memory allocations related to SGX and EPC memory, e.g. the
> +backing memory for evicted EPC pages, are accounted, limited and
> +protected by the memory controller.
> +
> +Much like normal system memory, EPC memory can be overcommitted via
> +virtual memory techniques and pages can be swapped out of the EPC
> +to their backing store (normal system memory allocated via shmem).
> +The SGX EPC subsystem is analogous to the memory subsytem, and
> +it implements limit and protection models for EPC memory.
> +
> +SGX EPC Interface Files
> +-----------------------
> +
> +For a generic description of the Miscellaneous controller interface
> +files, please see Documentation/admin-guide/cgroup-v2.rst
> +
> +All SGX EPC memory amounts are in bytes unless explicitly stated
> +otherwise.  If a value which is not PAGE_SIZE aligned is written,
> +the actual value used by the controller will be rounded down to
> +the closest PAGE_SIZE multiple.
> +
> +  misc.capacity
> +        A read-only flat-keyed file shown only in the root cgroup.
> +        The sgx_epc resource will show the total amount of EPC
> +        memory available on the platform.
> +
> +  misc.current
> +        A read-only flat-keyed file shown in the non-root cgroups.
> +        The sgx_epc resource will show the current active EPC memory
> +        usage of the cgroup and its descendants. EPC pages that are
> +        swapped out to backing RAM are not included in the current count.
> +
> +  misc.max
> +        A read-write single value file which exists on non-root
> +        cgroups. The sgx_epc resource will show the EPC usage
> +        hard limit. The default is "max".
> +
> +        If a cgroup's EPC usage reaches this limit, EPC allocations,
> +        e.g. for page fault handling, will be blocked until EPC can
> +        be reclaimed from the cgroup.  If EPC cannot be reclaimed in
> +        a timely manner, reclaim will be forced, e.g. by ignoring LRU.

Document the behavior when reclaim cannot happen, e.g., for the vEPC
pages when a VMM tries to allocate more than misc.max.

> +
> +  misc.events
> +	A read-write flat-keyed file which exists on non-root cgroups.
> +	Writes to the file reset the event counters to zero.  A value
> +	change in this file generates a file modified event.
> +
> +	  max
> +		The number of times the cgroup has triggered a reclaim
> +		due to its EPC usage approaching (or exceeding) its max
> +		EPC boundary.
> +
> +Migration
> +---------
> +
> +Once an EPC page is charged to a cgroup (during allocation), it
> +remains charged to the original cgroup until the page is released
> +or reclaimed.  Migrating a process to a different cgroup doesn't
> +move the EPC charges that it incurred while in the previous cgroup
> +to its new cgroup.
> -- 
> 2.25.1
> 
