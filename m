From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 4 May 2021 13:54:55 +1000
Message-ID: <YJDFj+sAv41JRIo4@yekko>
References: <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com>
 <YIol9p3z8BTWFRh8@yekko>
 <20210503160530.GL1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XJz7RUBFhCVAE36r"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1620101897;
        bh=GF4kY9gVsGuwV9dXBjYISsLPpgjK/7dHag6l9MAWxKg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FFVVpB9WNCZN/OHDK7EFnFAqgxNmT0o6j8dz6VB4dGaDgHpoypxvLCGbts5YHK+rc
         /0GWhCoUlX/gdFz9pMVsCPN56Kbv7o9hKTFl972XyyuWKzbIa3TPAw6YsykdDcjnop
         Pv6BeZTFIqQGE9whKr7bxNbIOfV+YYaDGYHwm4S8=
Content-Disposition: inline
In-Reply-To: <20210503160530.GL1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--XJz7RUBFhCVAE36r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 03, 2021 at 01:05:30PM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 29, 2021 at 01:20:22PM +1000, David Gibson wrote:
> > > There is a certain appeal to having some
> > > 'PPC_TCE_CREATE_SPECIAL_IOASID' entry point that has a wack of extra
> > > information like windows that can be optionally called by the viommu
> > > driver and it remains well defined and described.
> >=20
> > Windows really aren't ppc specific.  They're absolutely there on x86
> > and everything else as well - it's just that people are used to having
> > a window at 0..<something largish> that you can often get away with
> > treating it sloppily.
>=20
> My point is this detailed control seems to go on to more than just
> windows. As you say the vIOMMU is emulating specific HW that needs to
> have kernel interfaces to match it exactly.

It's really not that bad.  The case of emulating the PAPR vIOMMU on
something else is relatively easy, because all updates to the IO page
tables go through hypercalls.  So, as long as the backend IOMMU can
map all the IOVAs that the guest IOMMU can, then qemu's implementation
of those hypercalls just needs to put an equivalent mapping in the
backend, which it can do with a generic VFIO_DMA_MAP.

vIOMMUs with page tables in guest memory are harder, but only really
in the usual ways that a vIOMMU of that type is harder (needs cache
mode or whatever).  At whatever point you need to shadow from the
guest IO page tables to the host backend, you can again do that with
generic maps, as long as the backend supports the necessary IOVAs, and
has an IO page size that's equal to or a submultiple of the vIOMMU
page size.

> I'm remarking that trying to unify every HW IOMMU implementation that
> ever has/will exist into a generic API complete enough to allow the
> vIOMMU to be created is likely to result in an API too complicated to
> understand..

Maybe not every one, but I think we can get a pretty wide range with a
reasonable interface.  Explicitly handling IOVA windows does most of
it.  And we kind of need to handle that anyway to expose what ranges
the IOMMU is capable of translating anyway.  I think making handling
valid IOVA windows explicit makes things simpler than having
per-backend-family interfaces to expose the limits of their
translation ranges, which is what's likely to happen without it.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--XJz7RUBFhCVAE36r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCQxY0ACgkQbDjKyiDZ
s5Ja1Q//brgY0BJodmvSW7+qUlkQBKlmerMDnujEgNgBr6cbpA9hN6ywQDlkXit7
xrznyLqBx16060E9F6DQqk1aaAj2+iePxmT97vs7MUHmvuXHgTlmU6T6DDC84ICk
cCIfpXsB5R+pDv0JD/j91cPQBZF1Afnf0KhRLpzjcNKgBoFWi23pAYx3E32nPVtb
1UeflnMCMdr/rHfQR9/GoJ5FP/QYvqppU7351C0yFKbI5k0Pg7RvO41pejcNKE2W
q4wmfrzPA9/7G+JtQr03lGXLVy4+xN0UPsRtxkhQtaX+YNKBVL3qb+oO4XeCf7zw
Zw5vw6Ai8reTK948BEe+S+WJZHHAYBw54ztv7P35XFjR3/avEEPWgSIrba6fAeRZ
0E+RWhYL4c09hGpbJk6FiwTan+2a7EgB90ZuanWFtJ8HCFOFSDI3IRoLVU7k7JLC
IQD7LGmsqWzhMf3FtAK++FiVeWu+NpMPGGBx3XXfSl7kWXzf9CUJRFHLv+wPK0vc
Fln92Fj3HBM3D7keiZ85teYT6G5SacTcmtJTHTfsqqmVlTdVCconk7/y0wQhMDt5
TAfzd8YH0dq6toDJqOZzqZKwGmgaYe9HviiRWa5+C6Y3QJ0dBBN6cUKKZhTKeicd
ifZUPO7PC9KjomC7UWcx6g/pN7eNPSZR2YR+Lb0hATzgCVDkcUg=
=OhAa
-----END PGP SIGNATURE-----

--XJz7RUBFhCVAE36r--
