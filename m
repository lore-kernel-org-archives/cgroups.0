From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 24 May 2021 17:56:05 +1000
Message-ID: <YKtcFdW9U2+iW4cM@yekko>
References: <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com>
 <YIol9p3z8BTWFRh8@yekko>
 <20210503160530.GL1370958@nvidia.com>
 <YJDFj+sAv41JRIo4@yekko>
 <20210504181537.GC1370958@nvidia.com>
 <7e5c2276-ca1c-a8af-c15f-72a7c83c8bfa@ozlabs.ru>
 <20210505163902.GG1370958@nvidia.com>
 <YJzCC18cQDdKMR6p@yekko>
 <20210513135030.GF1002214@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qdaYK/TYh/pdg5Us"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1621842970;
        bh=C/hH2K1GEBPadXoSrKk7V2ObPasOjkp3z+Am5C3tgTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SlkI23zR6q71HmYnJJ3f9KWdOEkVnA6VgflwcXorCZ+xSlbOn80eH8qqkj1bGiDwr
         KC9B7UJXnzhSsKRs2ic63ipbacchSoGdi4E458+5M7iaEJIuB0k7HuIOJAPxbDK6pB
         dK2O+tSql9Eour4tx4hSxxkcAjj0iCOHwEc2IDJA=
Content-Disposition: inline
In-Reply-To: <20210513135030.GF1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj@in>


--qdaYK/TYh/pdg5Us
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 13, 2021 at 10:50:30AM -0300, Jason Gunthorpe wrote:
> On Thu, May 13, 2021 at 04:07:07PM +1000, David Gibson wrote:
> > On Wed, May 05, 2021 at 01:39:02PM -0300, Jason Gunthorpe wrote:
> > > On Wed, May 05, 2021 at 02:28:53PM +1000, Alexey Kardashevskiy wrote:
> > >=20
> > > > This is a good feature in general when let's say there is a linux s=
upported
> > > > device which has a proprietary device firmware update tool which on=
ly exists
> > > > as an x86 binary and your hardware is not x86 - running qemu + vfio=
 in full
> > > > emulation would provide a way to run the tool to update a physical =
device.
> > >=20
> > > That specific use case doesn't really need a vIOMMU though, does it?
> >=20
> > Possibly not, but the mechanics needed to do vIOMMU on different host
> > IOMMU aren't really different from what you need for a no-vIOMMU
> > guest. =20
>=20
> For very simple vIOMMUs this might be true, but this new features of nest=
ing
> PASID, migration, etc, etc all make the vIOMMU complicated and
> emuluating it completely alot harder.

Well, sure, emulating a complex vIOMMU is complex. But "very simple
vIOMMUs" covers the vast majority of currently deployed hardware, and
several are already emulated by qemu.

> Stuffing a vfio-pci into a guest and creating a physical map using a
> single IOASID is comparably trivial.

Note that for PAPR (POWER guest) systems this is not an option: the
PAPR platform *always* has a vIOMMU.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--qdaYK/TYh/pdg5Us
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCrXBUACgkQbDjKyiDZ
s5IBMw/6AomCVLmh/8hoxD3OLa7DsF2qksrpcbo5JXuotCrUKLd+NER23oRbTekN
8HQ/YKfUWhmFlGh9NeBcjjUjkm/ru1HFa3vbGfQIrVWxabmQX9vQSjKDc/qvQlKB
ApOyT0PNJuHFy8rZNB7vrpd9zP9xhV1gKLk5nxmmPHeITxA2ZLrZSlfMkRhIG5vP
3xpnCB8KoycgXBsYbLCi50o11TxhVlYWoujMA/I69mLgfqFoxTy3+zz99RtEEnY9
Nqf3jnnpL+5tCu8gBZD2actRlu0jrnXU6nyYleOy89Sr2ZjrOM73cfrkrJjhuTa6
hdQVhb8XgS1HQPiELvT2WCVVQkfAG1ss0HcPi2Wt+JvVnxeQ4kNixS8ZNwh/X9/Q
lMVqY0OsG8Gz38XftHA3oj20IyAKeVYfXkQJLougTadA3/ydrOELNB169PPHtggT
qtgvOFogrmYKJyaGQaQvWIWmHd63OYqVxycbu2fimxeuM4kMxgU5ERWo6caXHLz+
bZfdkrRUW1vCGoMfjqpjG4OgDhnLwz4PUfy7tKdh6Ek4TGe0OUHYxcMcJI28AIii
jnapbsmXzLYgsyHou+UYRwtLPrIOjOpRh3eDRzfRDtI1HQBWG1RBKkJdqUf1r5FW
r45iEZaQ+AdySJsDkfCc7+SDhLx4AO8z6RuoKgukxPR6E5D8Z9c=
=GQEt
-----END PGP SIGNATURE-----

--qdaYK/TYh/pdg5Us--
