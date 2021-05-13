From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 13 May 2021 15:48:19 +1000
Message-ID: <YJy9o8uEZs42/qDM@yekko>
References: <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
 <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box>
 <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ArI7kS42Lc+0E4RS"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1620886032;
        bh=Mzje6I+4XJ3y6Iby/DAYOwVFavVRAAtc7j9XmkVCAVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fP8u4nZiemlt/gTVvVqI6DnRAk7mDCvbaRIlDJrKeD5SvLwwmy+GW6TfJFQ2/gSHB
         EqigWrZpgStjiMYr1jY37zqkpZhEn9oghhaM+wAfRTSiOW9d+b6/s2r17OOjmh2koT
         YjPtcV1K73vL8uyeJRjiE+vbeFX1lv+Y/RkyWHWk=
Content-Disposition: inline
In-Reply-To: <20210503161518.GM1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


--ArI7kS42Lc+0E4RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 03, 2021 at 01:15:18PM -0300, Jason Gunthorpe wrote:
> On Thu, Apr 29, 2021 at 01:04:05PM +1000, David Gibson wrote:
> > Again, I don't know enough about VDPA to make sense of that.  Are we
> > essentially talking non-PCI virtual devices here?  In which case you
> > could define the VDPA "bus" to always have one-device groups.
>=20
> It is much worse than that.
>=20
> What these non-PCI devices need is for the kernel driver to be part of
> the IOMMU group of the underlying PCI device but tell VFIO land that
> "groups don't matter"

I don't really see a semantic distinction between "always one-device
groups" and "groups don't matter".  Really the only way you can afford
to not care about groups is if they're singletons.

> Today mdev tries to fake this by using singleton iommu groups, but it
> is really horrible and direcly hacks up the VFIO IOMMU code to
> understand these special cases. Intel was proposing more special
> hacking in the VFIO IOMMU code to extend this to PASID.

At this stage I don't really understand why that would end up so
horrible.

> When we get to a /dev/ioasid this is all nonsense. The kernel device
> driver is going to have to tell drivers/iommu exactly what kind of
> ioasid it can accept, be it a PASID inside a kernel owned group, a SW
> emulated 'mdev' ioasid, or whatever.
>=20
> In these cases the "group" idea has become a fiction that just creates
> a pain.

I don't see how the group is a fiction in this instance.  You can
still have devices that can't be isolated, therefore you can have
non-singleton groups.

> "Just reorganize VDPA to do something insane with the driver
> core so we can create a dummy group to satisfy an unnecessary uAPI
> restriction" is not a very compelling argument.
>=20
> So if the nonsensical groups goes away for PASID/mdev, where does it
> leave the uAPI in other cases?
>=20
> > I don't think simplified-but-wrong is a good goal.  The thing about
> > groups is that if they're there, you can't just "not care" about them,
> > they affect you whether you like it or not.
>=20
> You really can. If one thing claims the group then all the other group
> devices become locked out.

Aside: I'm primarily using "group" to mean the underlying hardware
unit, not the vfio construct on top of it, I'm not sure that's been
clear throughout.

So.. your model assumes that every device has a safe quiescent state
where it won't do any harm until poked, whether its group is
currently kernel owned, or owned by a userspace that doesn't know
anything about it.

At minimum this does mean that in order to use one device in the group
you must have permission to use *all* the devices in the group -
otherwise you may be able to operate a device you don't have
permission to by DMAing to its registers from a device you do have
permission to.

Whatever scripts are managing ownership of devices also need to know
about groups, because they need to put all the devices into that
quiescent state before the group can change ownership.

> The main point to understand is that groups are NOT an application
> restriction! It is a whole system restriction that the operator needs
> to understand and deal with. This is why things like dpdk don't care
> about the group at all - there is nothing they can do with the
> information.
>=20
> If the operator says to run dpdk on a specific device then the
> operator is the one that has to deal with all the other devices in the
> group getting locked out.

Ok, I think I see your point there.

> At best the application can make it more obvious that the operator is
> doing something dangerous, but the current kernel API doesn't seem to
> really support that either.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--ArI7kS42Lc+0E4RS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCcvaAACgkQbDjKyiDZ
s5L5IRAAg97CW+pGNxknG14IgrfUjPSBK7pDccMXtD7eVUa3BEynUYKrHHTYj7q/
EzRpFRjsIwkC8NT7lBlsCrZIL/sS1LD+zveqDYNaBIs46681UKlg5enXxZoEcTGi
WRUmWMgXhOnhrVQMB/G1TZLanViDvzHpBau0ALyX0buvg1bpkvToX7AiKvqNzv07
IKaeG23DeXI9o2M0Jh6v5UFDLA90LktEqtxsvfbqQPYY+JJWtdV3WBcYOKsHe3j4
ZFfIqOlBOsGA27BWZQucmyxtFjQfNbCB9QQO28MAcOs+A1fIwtRi4ZVNuBEQos38
3cN5riTTE4+p63WU4kEWiP3nTX3irEKQD3W5aMy1Yk8STxgBwuL5FerquBssnV4i
h362Q9JPTadeDOX1sVmDFM2Ms/WLh1fG2zGvRtOwsTwCYhWoDAziz8BYLWoHFCYY
y3DctIOZxQaK5NZjiABNbxW9y14zFWzq9aqAfyb06Cz/rDgkSBMAclfD4/DOF7ic
s0gPcVm/xFk7d4KvOD8u3tf9Q4Uk2s3jcJmXmblPF88nAjSknZj3o4/H7o1feD9x
ym2WSkkHYfC2Yq+FFCNyeXNDUQVH7PUA5DfcAaV8jygtdNo/edcZNI2pKwuRxVyU
KL0RtZY77wWQF88q+iSxIjeVgRbBxSslOVSXH40O0aJsO8+cNAQ=
=S7A7
-----END PGP SIGNATURE-----

--ArI7kS42Lc+0E4RS--
