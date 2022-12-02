From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 01/18] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Fri, 02 Dec 2022 13:37:05 -0800
Message-ID: <da690a45a36038399c63ddac8f0efed9872ec13e.camel@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
         <20221202183655.3767674-2-kristen@linux.intel.com>
         <37de083d-a63b-b2ff-d00a-e890a1ba5eea@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670017028; x=1701553028;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=DguheD/f9S21J80UEfRyncUNc3fn53UTu3Kx4IOdBY8=;
  b=G79X/5G63TmqnfKDquhvGQOrH8AipiyBITvvHcsPWJdPDZTvjz77IBxy
   U0eEKzzpOTY2BuH8E2/yXGcZxWDcUqBngNn7Dziy3wgZ0CiGsZLkxdqpj
   M8a9UdLNpRvwhfelKiSm45ikQFl18gyGfyvj/CPABLk9mVC8YKti5AjGy
   sR6TJrVm2RWXxuiNJvioh624PdT51llIauxU6KaZ97TtjfaG6bonhI2ps
   vvbZEc475NIkYoGmIdI4W3gIxKElIwTHivRDndo3VVOnenSQNsylw+ctu
   vHI8LH7xHJ/m7BVdmiOBFBOC0lPPBVIafxlwHb+f7Ul/sktERMF4L7mDT
   Q==;
In-Reply-To: <37de083d-a63b-b2ff-d00a-e890a1ba5eea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, 2022-12-02 at 13:33 -0800, Dave Hansen wrote:
> On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> > From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > In order to avoid repetition of cond_resched() in ksgxd() and
> > sgx_alloc_epc_page(), move the invocation of post-reclaim
> > cond_resched()
> > inside sgx_reclaim_pages(). Except in the case of
> > sgx_reclaim_direct(),
> > sgx_reclaim_pages() is always called in a loop and is always
> > followed
> > by a call to cond_resched().=C2=A0 This will hold true for the EPC
> > cgroup
> > as well, which adds even more calls to sgx_reclaim_pages() and thus
> > cond_resched(). Calls to sgx_reclaim_direct() may be performance
> > sensitive. Allow sgx_reclaim_direct() to avoid the cond_resched()
> > call by moving the original sgx_reclaim_pages() call to
> > __sgx_reclaim_pages() and then have sgx_reclaim_pages() become a
> > wrapper around that call with a cond_resched().
> >=20
> > Signed-off-by: Sean Christopherson
> > <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0arch/x86/kernel/cpu/sgx/main.c | 17 +++++++++++------
> > =C2=A01 file changed, 11 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c
> > b/arch/x86/kernel/cpu/sgx/main.c
> > index 160c8dbee0ab..ffce6fc70a1f 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -287,7 +287,7 @@ static void sgx_reclaimer_write(struct
> > sgx_epc_page *epc_page,
> > =C2=A0 * problematic as it would increase the lock contention too much,
> > which would
> > =C2=A0 * halt forward progress.
> > =C2=A0 */
> > -static void sgx_reclaim_pages(void)
> > +static void __sgx_reclaim_pages(void)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sgx_epc_page *ch=
unk[SGX_NR_TO_SCAN];
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sgx_backing back=
ing[SGX_NR_TO_SCAN];
> > @@ -369,6 +369,12 @@ static void sgx_reclaim_pages(void)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0}
> > =C2=A0
> > +static void sgx_reclaim_pages(void)
> > +{
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__sgx_reclaim_pages();
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cond_resched();
> > +}
>=20
> Why bother with the wrapper?=C2=A0 Can't we just put cond_resched() in th=
e
> existing sgx_reclaim_pages()?

Because sgx_reclaim_direct() needs to call sgx_reclaim_pages() but not
do the cond_resched(). It was this or add a boolean or something to let
caller's opt out of the resched.

