From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 27 May 2021 14:58:30 +1000
Message-ID: <YK8m9jNuvEzlXWlu@yekko>
References: <YIizNdbA0+LYwQbI@yekko.fritz.box>
 <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rKeY89V0ifZRRhP6"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1622099541;
        bh=/Vk6QIsfClarCnHuWF3h00g/TTHnE4TtoS0mH61nSvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PBJfr7UYZPAGjibTLx3tnWLHnRpaUShxpkGQgtqAMqSU1cRDoZa5GzhsXCRFM76n6
         /2dBtWmxbyYYr4V+CxP4PSVzAwF4AD4T2TGF1pIXK0c44UNAZyDsnE8zGdVBo4KZpb
         3ivmm4aCrXG/e3Jm6+/nRQqIJ3rfH7ZWRNAOeov4=
Content-Disposition: inline
In-Reply-To: <20210525195257.GG1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj@i>


--rKeY89V0ifZRRhP6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2021 at 04:52:57PM -0300, Jason Gunthorpe wrote:
> On Wed, May 26, 2021 at 12:56:30AM +0530, Kirti Wankhede wrote:
>=20
> > 2. iommu backed mdev devices for SRIOV where mdev device is created per
> > VF (mdev device =3D=3D VF device) then that mdev device has same iommu
> > protection scope as VF associated to it.=20
>=20
> This doesn't require, and certainly shouldn't create, a fake group.

It's only fake if you start with a narrow view of what a group is.  A
group is a set of devices (in the kernel sense of "device", not
necessarily the hardware sense) which can't be isolated from each
other.  The mdev device is a kernel device, and if working as intended
it can be isolated from everything else, and is therefore in an
absolute bona fide group of its own.

> Only the VF's real IOMMU group should be used to model an iommu domain
> linked to a VF. Injecting fake groups that are proxies for real groups
> only opens the possibility of security problems like David is
> concerned with.

It's not a proxy for a real group, it's a group of its own.  If you
discover that (due to a hardware bug, for example) the mdev is *not*
properly isolated from its parent PCI device, then both the mdev
virtual device *and* the physical PCI device are in the same group.
Groups including devices of different types and on different buses
were considered from the start, and are precedented, if rare.

> Max's series approaches this properly by fully linking the struct
> pci_device of the VF throughout the entire VFIO scheme, including the
> group and container, while still allowing override of various VFIO
> operations.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--rKeY89V0ifZRRhP6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCvJvYACgkQbDjKyiDZ
s5IEqBAAp3p5NH8nnJVVcGSVZxbNrLeTTJqPwhNtEEsveVKJd5BmHf3EvT4BqqnK
rXisyd2ygrY8fO1DiLJOa/WM6FDA05WD0XkqyDJ2XUFAOEHpyY0EesSw7CqSl1zz
V2dbprWQAD9nJoPG/fidBsmuYEwpxjvptttrf1yEgFe+isfJLdalJbA+k/kfZOdd
F4BL6+mtySC2DoKnQqoDQYCsXrSNzsYgv6SDbj4W7izUuOqYFADN7qawINcxAEBa
I43JXW3Dhx3aLzL0JeEjFf2j/f1YMQo/RfkfLg9OWuHdsF+SF8+5lcikGWtjBZKT
pC443P1CHOmJkW0TMr9Pz2lHJfjlcTaIq35qpaEP23tKmS60FDoLIvWPlFJYidaz
tWDNMtMmS8UbcyzF868ZJiRc94+A8RTFFW7hSmHQoqLnxMqNnUoyOKrZ2ehaqg+j
JjbsxFq37+jun2Fb2BxwPg+F2jFQmaw7l6FCdhePKc/h/HeCRPpZ+jTqF6AEqdU1
KrET9bw9TE3euBNQK62gJNfdIdrkBelfcUjKluxCWamoHFeJBEnBKbqGR4wn0Jqg
QucFQtoKZyEIXVKFtK0Pedz46dzxc5iH1hj+eIAGLw92/SIjWzVYEp6vCZYHxNSk
VQFvdHTLJJ8vRVhLGJlo5Ji4EX+jgb9i7eIufxgqD+SxhzOoRvo=
=ygK9
-----END PGP SIGNATURE-----

--rKeY89V0ifZRRhP6--
