From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 02/18] x86/sgx: Store struct sgx_encl when allocating
 new VA pages
Date: Fri, 2 Dec 2022 13:35:58 -0800
Message-ID: <3a789b1c-4c70-158b-d764-daec141a5816@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-3-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670016960; x=1701552960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jbDqvFAgp4MnB8B6YQ5sRiaoj/wEsc4ByhyQ4FcZagQ=;
  b=V57rmamKXdp95ydSpJ/UyI6ToOS3DFrg1O4Vwta/3Ev19FACW6+tdp4y
   bEbEq3wgrfzAzaeT3UgbbzNfDAdMhYGWy/BLNzOdn6dkIWiXF5Ob+fpFI
   99sJK7/QqgqaTp2CkXxoR33wbFeb1hsCMCfmW/XIX7KSWsaC8DKEPqU7k
   +ag0BpP9V52jpD3UvQbCqUvV046TWptD6PhpmkM3S3Pw7FZWVMFaQ2bqr
   L1LuVfNa9T+mnfO5QfIUQ5ZNMCiQHNv/Tn4SK6607lWtpOnQMaMkKIWlU
   LEkbadXKjA4z8/P3TO6Ydfz8ee3uv7Gri46cYOMh1RAn3bY3KWhACJ3zk
   A==;
Content-Language: en-US
In-Reply-To: <20221202183655.3767674-3-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> When allocating new Version Array (VA) pages, pass the struct sgx_encl
> of the enclave that is allocating the page. sgx_alloc_epc_page() will
> store this value in the encl_owner field of the struct sgx_epc_page. In
> a later patch, VA pages will be placed in an unreclaimable queue,
> and then when the cgroup max limit is reached and there are no more
> reclaimable pages and the enclave must be oom killed, all the
> VA pages associated with that enclave can be uncharged and freed.

What does this have to do with the 'encl' that is being passed, though?

In other words, why is this new sgx_epc_page-to-encl mapping needed for
VA pages now, but it wasn't before?
