From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 29 Apr 2021 13:20:22 +1000
Message-ID: <YIol9p3z8BTWFRh8@yekko>
References: <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VnpCiNDu5ri/I2+C"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1619669893;
        bh=CG0C1TtA2qTxavaiVAaS4f+9gUTbGNBMGx1ubjdyJ4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FUk8ozxaSPoOFI5vFuUiW8LWW08MXqMNOqVJsKKJJki3yNWJx2/aaXJ78/2tlg8xn
         ZNPGggQaTjc4DHHiTSrWSvtyYTsKBc04Rnj12XujF07YobhtvaHzq/ULiRcwvfW0hE
         S0z6xcIcW9nJNujpxOgM0GT5u5BHhoUZJSXimg7w=
Content-Disposition: inline
In-Reply-To: <20210429002149.GZ1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--VnpCiNDu5ri/I2+C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 09:21:49PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 28, 2021 at 11:23:39AM +1000, David Gibson wrote:
>=20
> > Yes.  My proposed model for a unified interface would be that when you
> > create a new container/IOASID, *no* IOVAs are valid.
>=20
> Hurm, it is quite tricky. All IOMMUs seem to have a dead zone around
> the MSI window, so negotiating this all in a general way is not going
> to be a very simple API.
>=20
> To be general it would be nicer to say something like 'I need XXGB of
> IOVA space' 'I need 32 bit IOVA space' etc and have the kernel return
> ranges that sum up to at least that big. Then the kernel can do its
> all its optimizations.

Ah, yes, sorry.  We do need an API that lets the kernel make more of
the decisions too.  For userspace drivers it would generally be
sufficient to just ask for XXX size of IOVA space wherever you can get
it.  Handling guests requires more precision.  So, maybe a request
interface with a bunch of hint variables and a matching set of
MAP_FIXED-like flags to assert which ones aren't negotiable.

> I guess you are going to say that the qemu PPC vIOMMU driver needs
> more exact control..

*Every* vIOMMU driver needs more exact control.  The guest drivers
will expect to program the guest devices with IOVAs matching the guest
platform's IOMMU model.  Therefore the backing host IOMMU has to be
programmed to respond to those IOVAs.  If it can't be, there's no way
around it, and you want to fail out early.  With this model that will
happen when qemu (say) requests the host IOMMU window(s) to match the
guest's expected IOVA ranges.

Actually, come to that even guests without a vIOMMU need more exact
control: they'll expect IOVA to match GPA, so if your host IOMMU can't
be set up translate the full range of GPAs, again, you're out of luck.

The only reason x86 has been able to ignore this is that the
assumption has been that all IOMMUs can translate IOVAs from 0..<a big
enough number for any reasonable RAM size>.  Once you really start to
look at what the limits are, you need the exact window control I'm
describing.

> > I expect we'd need some kind of query operation to expose limitations
> > on the number of windows, addresses for them, available pagesizes etc.
>=20
> Is page size an assumption that hugetlbfs will always be used for backing
> memory or something?

So for TCEs (and maybe other IOMMUs out there), the IO page tables are
independent of the CPU page tables.  They don't have the same format,
and they don't necessarily have the same page size.  In the case of a
bare metal kernel working in physical addresses they can use that TCE
page size however they like.  For userspace you get another layer of
complexity.  Essentially to implement things correctly the backing
IOMMU needs to have a page size granularity that's the minimum of
whatever granularity the userspace or guest driver expects and the
host page size backing the memory.

> > > As an ideal, only things like the HW specific qemu vIOMMU driver
> > > should be reaching for all the special stuff.
> >=20
> > I'm hoping we can even avoid that, usually.  With the explicitly
> > created windows model I propose above, it should be able to: qemu will
> > create the windows according to the IOVA windows the guest platform
> > expects to see and they either will or won't work on the host platform
> > IOMMU.  If they do, generic maps/unmaps should be sufficient.  If they
> > don't well, the host IOMMU simply cannot emulate the vIOMMU so you're
> > out of luck anyway.
>=20
> It is not just P9 that has special stuff, and this whole area of PASID
> seems to be quite different on every platform
>=20
> If things fit very naturally and generally then maybe, but I've been
> down this road before of trying to make a general description of a
> group of very special HW. It ended in tears after 10 years when nobody
> could understand the "general" API after it was Frankenstein'd up with
> special cases for everything. Cautionary tale
>=20
> There is a certain appeal to having some
> 'PPC_TCE_CREATE_SPECIAL_IOASID' entry point that has a wack of extra
> information like windows that can be optionally called by the viommu
> driver and it remains well defined and described.

Windows really aren't ppc specific.  They're absolutely there on x86
and everything else as well - it's just that people are used to having
a window at 0..<something largish> that you can often get away with
treating it sloppily.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--VnpCiNDu5ri/I2+C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCKJfQACgkQbDjKyiDZ
s5LJkw//bITy91FckatPRCEx8u5jctT/DbzHeYnr8pGEugv3JmhVq72mk2XGwuHB
svC41OVYOD8PC7hX52SQ3PGA+3fNIYvPwALynj2wLlSI7ce79J+NGuREB+7cgB1K
GoOWrzuWf23tFL16G7OhY88nothHY7vUWjil4FWrBZVKxj7vnQZ7SZmlasiDN46m
V9FwTCfu1Mbv8r+FqgTnytjio5wVIxQSfEhIbbevpbyeCZmcvFT4PQfpKiyrM9hp
oRGJibDfILmgCsM20Pj33rNqPcL42Xk/bEllzKnTitoSIcfYBQAUHKjrv3QfPb3d
dR/C8E/jEADfIHvfCLdM3IX9CouAwzcQv+TWg9YDydPKawB9F+3tEEwZj9rH/IOk
12d1AxSNv9ruQ4VLkXqbIANcxAau5iuk2pgd8Gm45MmICvSEtNKCpfHkOCsfgREf
WUAb3vn95RuxSLXJTtEU6SOk4lBzLjFl4tjv7nCZ5ikAz6EQnjEuN0jybXqNC9dX
xdBeT+6Tjq0l8NQxekOv0b1/3ReLenR+MAKsYL1y2OkVVgUiMrBSNtwc3nMqE2ZH
WkBzXWyTy/it2/gR7fesmmvpEFNTaovXfHPkApuHBbX45rABjiLD/vh+j/i1lkTL
WvUcE7BSx27vbWtRfWXHgjrHIfgGe1yIjG3ogwx8sBd5nLSXoC0=
=R90G
-----END PGP SIGNATURE-----

--VnpCiNDu5ri/I2+C--
