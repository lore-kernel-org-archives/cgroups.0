From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 04/18] x86/sgx: Use sgx_epc_lru_lists for existing
 active page list
Date: Fri, 02 Dec 2022 13:51:10 -0800
Message-ID: <d17c270bcbf631736d52b762dad8a6758d7dc951.camel@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
         <20221202183655.3767674-5-kristen@linux.intel.com>
         <ad1bcb0f-661d-a701-2175-c8750d8af8d8@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670017874; x=1701553874;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9f5KbostxEAV+RFNf4XG1ooSo6jjgGnVqXRgip8PujU=;
  b=cowQvwtRqxGF4Xhh04eCkEpfUl6emsRYD7OiGf1GWdJnyp+qwN+87jIs
   dRu6S418crjqxm1hVaAnPMgZK2LzfZWTs6RjqL0RXhJmmIl2X8fb5cUzU
   I+LC0Wk3HO0I5evZqkZ66EBl3iUiNwRIagKZ7UAbNCVSvJe5ByeA5DLEv
   ylKhZ97LRPjtKFJhc9GR/+tIJBFMzg5xmGd3b2QF07jHpDAQf038rLBuh
   77XC5/4PsYFYAte+z5+EftrvJ/Ivi6PmyRsJzelwPNQlcUc6klWSguR8K
   JnYET/eJfAbe9QSeNX+7QT1AXol199Jc88f7v/76loR37YIiA610ztbJ9
   Q==;
In-Reply-To: <ad1bcb0f-661d-a701-2175-c8750d8af8d8-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, 2022-12-02 at 13:43 -0800, Dave Hansen wrote:
> On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock(&sgx_global_lru.lo=
ck);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < SGX_N=
R_TO_SCAN; i++) {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (list_empty(&sgx_active_page_list))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0epc_page =3D
> > sgx_epc_pop_reclaimable(&sgx_global_lru);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (!epc_page)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
break;
>=20
> One other nit about the structure of the patches: This introduced
> *both*
> reclaimable and unreclaimable list_heads.=C2=A0 But, it has zero use for
> the
> unreclaimable ones during the refactoring here.=C2=A0 I probably would
> have
> left out the 'unreclaimable' bits for now.

I know - and originally the addition of unreclaimable was added later,
but when I posted the RFC I felt there was some misunderstanding about
what this data structure was and how it would be used because the
addition of the unreclaimable bits came later. So I stuck both lists in
one so it'd be a better view of what the data structure would look
like.

>=20
> BTW, this is a nice sign:
>=20
> > =C2=A0arch/x86/kernel/cpu/sgx/main.c | 39 +++++++++++++++++------------=
-
> > ----
> > =C2=A01 file changed, 19 insertions(+), 20 deletions(-)
>=20
>=20

