From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 13 May 2021 16:07:07 +1000
Message-ID: <YJzCC18cQDdKMR6p@yekko>
References: <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com>
 <YIol9p3z8BTWFRh8@yekko>
 <20210503160530.GL1370958@nvidia.com>
 <YJDFj+sAv41JRIo4@yekko>
 <20210504181537.GC1370958@nvidia.com>
 <7e5c2276-ca1c-a8af-c15f-72a7c83c8bfa@ozlabs.ru>
 <20210505163902.GG1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Mf++rjztzZShRAS"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1620886032;
        bh=EDbwQxFNCJJrrEgHzT5gGi+1oWXpdmyJr1eJ+NUQ4bM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kWqsHMbOiAyxwLod+Rqt4KhSwB2oo0bV5TchI5WxvF3IL2lqztrJrQv615kgKUDnS
         rvOjRZCfVWenSYZrOWPrRga+vGFG2OWEIfQgUnlH6IFYpycIGoxJyhVRhtXU4RZ9Gc
         02pKAkrH9LTvDiy9LdpyASoaGfwW0N2RNDDTSEfE=
Content-Disposition: inline
In-Reply-To: <20210505163902.GG1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj@in>


--/Mf++rjztzZShRAS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 05, 2021 at 01:39:02PM -0300, Jason Gunthorpe wrote:
> On Wed, May 05, 2021 at 02:28:53PM +1000, Alexey Kardashevskiy wrote:
>=20
> > This is a good feature in general when let's say there is a linux suppo=
rted
> > device which has a proprietary device firmware update tool which only e=
xists
> > as an x86 binary and your hardware is not x86 - running qemu + vfio in =
full
> > emulation would provide a way to run the tool to update a physical devi=
ce.
>=20
> That specific use case doesn't really need a vIOMMU though, does it?

Possibly not, but the mechanics needed to do vIOMMU on different host
IOMMU aren't really different from what you need for a no-vIOMMU
guest.  With a vIOMMU you need to map guest IOVA space into the host
IOVA space.  With no no-vIOMMU you need to map guest physical
addresses into the host IOVA space.  In either case the GPA/gIOVA to
userspace and userspace to HPA mappings are basically arbitrary.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/Mf++rjztzZShRAS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCcwgsACgkQbDjKyiDZ
s5JqLg/+Px9hBLz/IZ8N6Bl1BLwug0BbIEk1xxrBhtyubIdEbf6AuAkqa0HnxcSm
EgS1KJ0eOe3yLUKaLskepCJDojbuqFYnLf1VTv3Uu0zp5AP8ggKQgfokxUVJdhpR
aWMVjwOFAoUatYTP2umFN2ZfUsSxe/FsTkdTiAVApqn4AdTSlbGBvK+C4D7WPzZy
5rjVhgLfaQWJDGrTnhqCr4PJoz0z1FpOhzYXtpHR+u+d9BgDe2yj1gEFzICDk+UV
67QOqTNxWi1gSQ6uVa+xmB+xY0RZ7+x+fwObNBHrGWuFKJzwbf6aCQIprqEY5mro
9KAR0kP3LkywUN+rZjWQun9pXQdu/JWjZPtmdbm4rw+kIJEDdMk9TrOohOpjxUot
7vSoLVklFyMbnL84I3i7CELRxpkvtXaBd5VdGkEObg5nCcY8Fci8yLmhjOLXviGU
iNmRCaiZikT+JKvnwiG7qIILT3DCA92Y+AiQYayPkmujhlmzxpFkyAM1Igh7EIfe
a4O/U8qm61xxoTZhe+cbM11cIfiux8FwcxUrq54D1DCZstQ60IP/FaA4CQGSiBwm
55RNfJf+KFN9HG9hxH8BZYEGRtCYMuDfTjFdM0DaYHI8Rjv3X9MO4vuSI1tkoiQd
kW7n1QyP2QKMzSHCJlE56aSa9T6HTtUetOuO3vAxirN9Z5/042I=
=S/vm
-----END PGP SIGNATURE-----

--/Mf++rjztzZShRAS--
