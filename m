From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 02/18] x86/sgx: Store struct sgx_encl when allocating
 new VA pages
Date: Fri, 02 Dec 2022 13:40:26 -0800
Message-ID: <abfc00a2ab1d97f8081c696f78e2d0ced23902b4.camel@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
         <20221202183655.3767674-3-kristen@linux.intel.com>
         <3a789b1c-4c70-158b-d764-daec141a5816@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670017230; x=1701553230;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NuDVEcz+ZwrxpvyK1gNkgUCJxIW8h0yVGClVY+eE7s8=;
  b=T8Kd0PqA/x5Ex0q76P7Dk4IGJsKrWS0chB9dPU2MzD03rr0xga3o6/jX
   +il7IaGjLQ0aGSBMMhPsK3WFw8e9mUa7pU56knff+3227LhdcR8pKJ4M7
   yw+axMA6JMJsgSaBfN06+yp+/JQw8bWDF+SZD0l1BmBtLKL/BCr+gI5yN
   P3dq18srfRSnvsAov1IxYh7hSjD1Mn+CQrIc9L7ywHzPjrehpigcg6Yhy
   aPlmOs+eWCRV1CyT4jgnG0impu+yNf1jIKJNAdciFxhw1HDidxQ/Dna4m
   bFD9GszPkQWizhLrOxR06D1DtPS4kZp4jv/Qq/EPKb0vc+bSCXM2d8WCy
   Q==;
In-Reply-To: <3a789b1c-4c70-158b-d764-daec141a5816-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, 2022-12-02 at 13:35 -0800, Dave Hansen wrote:
> On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> > When allocating new Version Array (VA) pages, pass the struct
> > sgx_encl
> > of the enclave that is allocating the page. sgx_alloc_epc_page()
> > will
> > store this value in the encl_owner field of the struct
> > sgx_epc_page. In
> > a later patch, VA pages will be placed in an unreclaimable queue,
> > and then when the cgroup max limit is reached and there are no more
> > reclaimable pages and the enclave must be oom killed, all the
> > VA pages associated with that enclave can be uncharged and freed.
>=20
> What does this have to do with the 'encl' that is being passed,
> though?
>=20
> In other words, why is this new sgx_epc_page-to-encl mapping needed
> for
> VA pages now, but it wasn't before?

When we OOM kill an enclave, we want to get rid of all the associated
VA pages too. Prior to this patch, there wasn't a way to easily get the
VA pages associated with an enclave.


