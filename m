From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 03/18] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Thu, 08 Dec 2022 10:03:04 -0800
Message-ID: <08a420401b2fb539f37cbf21a0ded6bf8c68c72b.camel@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
         <20221202183655.3767674-4-kristen@linux.intel.com>
         <Y5IDXF+6GmURxbYF@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670522609; x=1702058609;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=a5QVaJCW+1KfH+RIxcXb6CC8DOjg9E8IGIEr6DurHN4=;
  b=GZuGOMlkP+zF9wHo7SHVTokw/nl48YpRT0CYYAXRoIrdfryA9SkNIcX6
   kpiwtN+tR82YC6fGzonfqI081wmtM2D4i6lIxKyxi7eh79gH1Pw7Uqdwm
   dp96rdTbLgAxN18Dx3xYpD29uc5C2sH03I8lLNAfD2tp4e0jNfH851NXk
   BA2Ls5d8Nu5DMSeybuvpKFfWlVPnp56giV1T17hFcoGN5XE4SZsjnCBcP
   gWPEA1kqBrjwJnAuMMjwRog7UHvimecZBHcK7/7Qs16QYWi9d0l31bCgQ
   imqijagBcvfKFLmeaiBGQudyLz44uZNd+EUasJdv0nKe0cqxlizaDiiT0
   Q==;
In-Reply-To: <Y5IDXF+6GmURxbYF-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, 2022-12-08 at 15:31 +0000, Jarkko Sakkinen wrote:
> On Fri, Dec 02, 2022 at 10:36:39AM -0800, Kristen Carlson Accardi
> wrote:
> > Introduce a data structure to wrap the existing reclaimable list
> > and its spinlock in a struct to minimize the code changes needed
> > to handle multiple LRUs as well as reclaimable and non-reclaimable
> > lists, both of which will be introduced and used by SGX EPC
> > cgroups.
> >=20
> > Signed-off-by: Sean Christopherson
> > <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0arch/x86/kernel/cpu/sgx/sgx.h | 65
> > +++++++++++++++++++++++++++++++++++
> > =C2=A01 file changed, 65 insertions(+)
> >=20
> > diff --git a/arch/x86/kernel/cpu/sgx/sgx.h
> > b/arch/x86/kernel/cpu/sgx/sgx.h
> > index 39cb15a8abcb..5e6d88438fae 100644
> > --- a/arch/x86/kernel/cpu/sgx/sgx.h
> > +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> > @@ -90,6 +90,71 @@ static inline void *sgx_get_epc_virt_addr(struct
> > sgx_epc_page *page)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return section->virt_ad=
dr + index * PAGE_SIZE;
> > =C2=A0}
> > =C2=A0
> > +/*
> > + * This data structure wraps a list of reclaimable EPC pages, and
> > a list of
> > + * non-reclaimable EPC pages and is used to implement a LRU policy
> > during
> > + * reclamation.
> > + */
> > +struct sgx_epc_lru_lists {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spinlock_t lock;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct list_head reclaimable=
;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct list_head unreclaimab=
le;
> > +};
> =C2=A0
> Why this is named like this, and not sgx_epc_global_rcu? Are there
> any other use cases?
>=20
> BR, Jarkko

Yes, there are other use cases that are introduced in the other
patches. This structure is used to in the cgroup struct to hold cgroup
specific LRUs.

