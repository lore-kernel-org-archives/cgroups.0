From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 03/20] x86/sgx: Track owning enclave in VA EPC pages
Date: Thu, 22 Sep 2022 13:04:06 -0700
Message-ID: <f031ac1bd6b16509f1d714cd65e6b017f054940c.camel@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
         <20220922171057.1236139-4-kristen@linux.intel.com>
         <1adb03c8-1274-3898-0677-03015a1f5a5d@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663877049; x=1695413049;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=snMZXlvHgnKICyfiYSRp0+L0NsQopjCdJqHUvJECElM=;
  b=OhzPvIpT5wHKRKXAKyl96v8ABN6NTEQxwXxklkxeay6UEUXluO6k0SjB
   xGo28551Ni9gwkqZPnYqEjT1ibOKmBFc1Y12mzgkBcHjv5MvzLmmBEGeF
   8IFZm18l91EMW38Xhz3hXwy4EcEIUpayRSjVaHc5Z+1EGiNUB0wa0WJPW
   1jWVw7lD9Enc8RIuZRc7WhylGhXLMUzQgEI9rXTRvfCDlURDDXYD2G3ZF
   hdaMv/jbQOG3jlWe68w2yv9klpx8W79oq+cqgAuJUJuhQixBeXTHB4KBo
   +pf867bS3pJir3Xg/etJAzWNQZ/hA7hGh7nJoEsBvEjf9yCoBc949AOvy
   w==;
In-Reply-To: <1adb03c8-1274-3898-0677-03015a1f5a5d-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, 2022-09-22 at 11:55 -0700, Dave Hansen wrote:
> On 9/22/22 10:10, Kristen Carlson Accardi wrote:
> > -struct sgx_epc_page *sgx_alloc_va_page(bool reclaim)
> > +struct sgx_epc_page *sgx_alloc_va_page(struct sgx_encl *encl, bool
> > reclaim)
> > =C2=A0{
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sgx_epc_page *ep=
c_page;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret;
> > @@ -1218,6 +1219,8 @@ struct sgx_epc_page *sgx_alloc_va_page(bool
> > reclaim)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return ERR_PTR(-EFAULT);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> > =C2=A0
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0epc_page->owner =3D encl;
> > +
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return epc_page;
> > =C2=A0}
>=20
> BTW, is there a flag or any other way to tell to what kind of object
> ->owner points?

The owner will only be an sgx_encl type if it is a va page, so to tell
what kind of object owner is, you look at the epc page flags - like
this:
        if (epc_page->flags & SGX_EPC_PAGE_ENCLAVE)
                encl =3D ((struct sgx_encl_page *)epc_page->owner)->encl;
        else if (epc_page->flags & SGX_EPC_PAGE_VERSION_ARRAY)
                encl =3D epc_page->owner;
...


