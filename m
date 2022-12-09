From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 14/18] x86/sgx: Add EPC OOM path to forcefully
 reclaim EPC
Date: Fri, 09 Dec 2022 08:05:56 -0800
Message-ID: <cb5abce531c1b14118de419ba68c2a501b016873.camel@linux.intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
         <20221202183655.3767674-15-kristen@linux.intel.com>
         <Y5IBCOuF8X7jEK3+@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670601959; x=1702137959;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=XWRLIvNaPSbx3qgHOle8bZTzrcu0wd+pVGPi5uuTaLg=;
  b=Dx9A1LP4Rj3v31a86MkFcPaEXndEZ3bJeuWd/xZMw8foA+g2pK5lyz5p
   3b3qtM5ZMPz8j4I4cqo5O2xKt4cQclKM8vcfnFgvr9xwM3Ak3OrBbbtD/
   fBJpLEFmWsQ1YqrQ5B6AzrS6ekOI1XPU8/X+7bQ8qTYQxLIjnh+Y31502
   RGIqHNxUFjDmndfbdOn58pD8ZpjR064rV3nVNYb/bucsLE3YpBvMJWhwx
   KV9F5aBPxE1RSh4o4S6Py4ZBqhuzo37dJmtkmbJ+MnpqY30aE9/Roz0Zq
   6Xf58jz4dLmH5QQGrZW1lSj1vzgCdkvSt0p78jxwQqeMPNeEiQWknyxdu
   w==;
In-Reply-To: <Y5IBCOuF8X7jEK3+-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, 2022-12-08 at 15:21 +0000, Jarkko Sakkinen wrote:
> On Fri, Dec 02, 2022 at 10:36:50AM -0800, Kristen Carlson Accardi
> wrote:
> > From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >=20
> > Introduce the OOM path for killing an enclave with the reclaimer
> > is no longer able to reclaim enough EPC pages. Find a victim
> > enclave,
> > which will be an enclave with EPC pages remaining that are not
> > accessible to the reclaimer ("unreclaimable"). Once a victim is
> > identified, mark the enclave as OOM and zap the enclaves entire
> > page range. Release all the enclaves resources except for the
> > struct sgx_encl memory itself.
> >=20
> > Signed-off-by: Sean Christopherson
> > <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>=20
> Why this patch is dependent of all 13 patches before it?
>=20
> Looks like something that is orthogonal to cgroups and could be
> live by its own. At least it probably does not require all of
> those patches, or does it?
>=20
> Even without cgroups it would make sense to killing enclaves if
> reclaimer gets stuck.
>=20
> BR, Jarkko

It is dependent first of all of having the LRU struct with the
unreclaimable/reclaimable lists. Which means it requires storing the
enclave pointer in the page as well. It's dependent on knowing how many
pages are available, being able to ignore the age of a page etc. Right
now, without cgroups, sgx will be unable to allocate memory when an
enclave is created if it cannot reclaim enough memory from the existing
in use enclaves.

Aside from that though, I don't think that killing enclaves makes sense
outside the context of cgroup limits. Without cgroup limits, you have a
max number of EPC pages that you can have active at any one time. If an
enclave attempts to allocate a new page and the reclaimer can't free up
any, how would you decide whether it's ok to kill an entire enclave in
order to grant this other enclave the higher priority for getting a
page? With a cgroup limit, the system owner explicitly can decide what
the limits on usage will be, but without that, you'd have a situation
where one new enclave could kill others I would think. Better to just
have it the way it is - new page allocations fail if there are not free
pages, but you don't kill enclaves that already exist.

