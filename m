From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 01/18] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Fri, 02 Dec 2022 14:17:33 -0800
Message-ID: <307b43aa5908c489913110287044e611f574db0a.camel@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
         <20221202183655.3767674-2-kristen@linux.intel.com>
         <37de083d-a63b-b2ff-d00a-e890a1ba5eea@intel.com>
         <da690a45a36038399c63ddac8f0efed9872ec13e.camel@linux.intel.com>
         <746adf31-e70c-e32d-a35d-72d352af613b@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670019457; x=1701555457;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=woJvw+26RYRp5fwYNc0dyE37E+dcjcSWCS7ZFowb7NY=;
  b=X2xtfO+TIVNNuxP1SyuVsbQa+6NVlQvN3eVgHqY5D5392IFpqYHUBTnq
   MlbfPlwtXm3BMmGv7RkzSqBhD+cO6P9l0ppJHtSkHzQwcLg6u35ucIFVy
   WkES56pdMBhl9AN0E3KKCNQEoaCUv8IKYSykDJEEKItlYyF/T4ItxsEL7
   iImSSVD+W0QKTA44E1tu0KEWkygp2rFEpiW9AaViADhwOmmYAQLpkhGno
   mMBULPjPYKW8c2GgflXmDItYj83HGtlbCKDQGBlGlUEdVKk8mlh4Jjd0d
   jZhR2t7+ohKNk/pe+E9VJrbcuOO4H7MKssECUXhF013IeB1c/UT5m0fs9
   w==;
In-Reply-To: <746adf31-e70c-e32d-a35d-72d352af613b-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, 2022-12-02 at 13:45 -0800, Dave Hansen wrote:
> On 12/2/22 13:37, Kristen Carlson Accardi wrote:
> > > > +static void sgx_reclaim_pages(void)
> > > > +{
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__sgx_reclaim_pages();
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cond_resched();
> > > > +}
> > > Why bother with the wrapper?=C2=A0 Can't we just put cond_resched() i=
n
> > > the
> > > existing sgx_reclaim_pages()?
> > Because sgx_reclaim_direct() needs to call sgx_reclaim_pages() but
> > not
> > do the cond_resched(). It was this or add a boolean or something to
> > let
> > caller's opt out of the resched.
>=20
> Is there a reason sgx_reclaim_direct() *can't* or shouldn't call
> cond_resched()?

Yes, it is due to performance concerns. It is explained most succinctly
by Reinette here:

https://lore.kernel.org/linux-sgx/a4eb5ab0-bf83-17a4-8bc0-a90aaf438a8e@inte=
l.com/

