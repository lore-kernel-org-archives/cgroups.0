From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 03/18] x86/sgx: Add sgx_epc_lru_lists to encapsulate
 LRU lists
Date: Thu, 14 Sep 2023 09:13:13 -0700
Message-ID: <7c418047-dd0b-76e9-dcfd-f00c76eeae46@intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-4-haitao.huang@linux.intel.com>
 <851f9b3043732c17cd8f86a77ccee0b7c6caa22f.camel@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694707995; x=1726243995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=esb42FKt68BhUbXDb04GFC6pySSzSlbs9XWMViBbL70=;
  b=Kn1fxF/Sa+wYzUbqmOtDHI7sdnB5SCzYPPqLCXBlTXzSS3bJxqWUXMHk
   pMBVF9nRgVFJ45R08u8jOcIljXB6V6BdOmY1GvRk2c0/w6Sc7vjzmDDFQ
   yM5P5bI67naE+dgSoGmEgQu9cO8IYphUG6t7P6MnN6Bguu/pt78uFdRax
   jfuWWzLdSCj92TbRtzIA3YxVQhLuNvLpBESP3QMKdWa40aSW4MhSvCXoR
   qSr2oalFZ5Qn7CXFG8sRl7RdXwdqe2zpB4ASNDgmQyFg/aVG4XvIVM07e
   RiHAWFkSiG+h990s7jBfjj4OkqLNCO/t0iFQiOGUzRFnsqslnxt7AOWtx
   Q==;
Content-Language: en-US
In-Reply-To: <851f9b3043732c17cd8f86a77ccee0b7c6caa22f.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Huang, Kai" <kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Mehta, Sohil" <sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "Li, Zhiquan1" <zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Christopherson,, Sean" <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Zhang, Bo" <zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

On 9/14/23 03:31, Huang, Kai wrote:
>> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> You don't need 'Cc:' Sean if the patch has Sean's SoB.

It is a SoB for Sean's @intel address and cc's his @google address.

It is fine.
