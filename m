From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/18] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Fri, 2 Dec 2022 13:45:20 -0800
Message-ID: <746adf31-e70c-e32d-a35d-72d352af613b@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-2-kristen@linux.intel.com>
 <37de083d-a63b-b2ff-d00a-e890a1ba5eea@intel.com>
 <da690a45a36038399c63ddac8f0efed9872ec13e.camel@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670017522; x=1701553522;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f+JtP3YBSpbvSEOM6o4SFDk1XVrfF1sDpnt2nGAMCzw=;
  b=LKeXG9zKM2kRPWsXOBmdL133hb4AaMTPH/9JBpT1FbCTqubKjfYHEv6h
   J6cWBrscLuahh1GhOYAtmBLVR+hPM6JoSdHens8mfd5Eqzv1kdbkLXsYI
   JsAwuh9snxv0O7EX07gjfnL+XxKZTpFcWLkcCoSH/o5MWrsfyvFZHxXIs
   SNkQMWR+seDc5AU/U7/GXMW/sepadsCLz+VoBRaUB/xjfY5WHlTGouvzo
   +zgdF3x5huJDzqP7NQyxiJlb0D19cJjvOnFLIJDqZgTz2X7huU7GVKEBd
   lX4+kGu34THQwnoJxpQtKH7/qPfcshIH/u6hca1b70L7kk7c6sz9qcAZh
   g==;
Content-Language: en-US
In-Reply-To: <da690a45a36038399c63ddac8f0efed9872ec13e.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 13:37, Kristen Carlson Accardi wrote:
>>> +static void sgx_reclaim_pages(void)
>>> +{
>>> +       __sgx_reclaim_pages();
>>> +       cond_resched();
>>> +}
>> Why bother with the wrapper?  Can't we just put cond_resched() in the
>> existing sgx_reclaim_pages()?
> Because sgx_reclaim_direct() needs to call sgx_reclaim_pages() but not
> do the cond_resched(). It was this or add a boolean or something to let
> caller's opt out of the resched.

Is there a reason sgx_reclaim_direct() *can't* or shouldn't call
cond_resched()?
