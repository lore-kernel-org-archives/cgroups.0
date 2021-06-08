From: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 8 Jun 2021 10:44:31 +1000
Message-ID: <YL69b0UuDm72QbDO@yekko>
References: <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com>
 <YK8m9jNuvEzlXWlu@yekko>
 <20210527184847.GI1002214@nvidia.com>
 <YLWxlZC4AXJPOngB@yekko>
 <20210601125712.GA4157739@nvidia.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NNPfhi/moTf9NG6z"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623119148;
        bh=BfDwkutWpzapXBdIlZKGNCG1leAlzqjIngBn196F5gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m1SLTyqUMO4+KhHYOxfVORgnMrOWsONeaA45MhiKtfSW8JDg45KNm6nR41R+oEiev
         UlDmkCGDDWzHqD0YCPPjl83zOA9/iVA686sdbop727n8xMpdGwDWxrVblu6PmAfATa
         Tey4MXyubvyWNP6C93VgQYXqdgx2NJlieNy7ztG8=
Content-Disposition: inline
In-Reply-To: <20210601125712.GA4157739-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj@i>


--NNPfhi/moTf9NG6z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 01, 2021 at 09:57:12AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 01, 2021 at 02:03:33PM +1000, David Gibson wrote:
> > On Thu, May 27, 2021 at 03:48:47PM -0300, Jason Gunthorpe wrote:
> > > On Thu, May 27, 2021 at 02:58:30PM +1000, David Gibson wrote:
> > > > On Tue, May 25, 2021 at 04:52:57PM -0300, Jason Gunthorpe wrote:
> > > > > On Wed, May 26, 2021 at 12:56:30AM +0530, Kirti Wankhede wrote:
> > > > >=20
> > > > > > 2. iommu backed mdev devices for SRIOV where mdev device is cre=
ated per
> > > > > > VF (mdev device =3D=3D VF device) then that mdev device has sam=
e iommu
> > > > > > protection scope as VF associated to it.=20
> > > > >=20
> > > > > This doesn't require, and certainly shouldn't create, a fake grou=
p.
> > > >=20
> > > > It's only fake if you start with a narrow view of what a group is.=
=20
> > >=20
> > > A group is connected to drivers/iommu. A group object without *any*
> > > relation to drivers/iommu is just a complete fiction, IMHO.
> >=20
> > That might be where we differ.  As I've said, my group I'm primarily
> > meaning the fundamental hardware unit of isolation.  *Usually* that's
> > determined by the capabilities of an IOMMU, but in some cases it might
> > not be.  In either case, the boundaries still matter.
>=20
> As in my other email we absolutely need a group concept, it is just a
> question of how the user API is designed around it.
>=20
> > > The group mdev implicitly creates is just a fake proxy that comes
> > > along with mdev API. It doesn't do anything and it doesn't mean
> > > anything.
> >=20
> > But.. the case of multiple mdevs managed by a single PCI device with
> > an internal IOMMU also exists, and then the mdev groups are *not*
> > proxies but true groups independent of the parent device.  Which means
> > that the group structure of mdevs can vary, which is an argument *for*
> > keeping it, not against.
>=20
> If VFIO becomes more "vfio_device" centric then the vfio_device itself
> has some properties. One of those can be "is it inside a drivers/iommu
> group, or not?".
>=20
> If the vfio_device is not using a drivers/iommu IOMMU interface then
> it can just have no group at all - no reason to lie. This would mean
> that the device has perfect isolation.

When you say "not using a drivers/iommu IOMMU interface" do you
basically mean the device doesn't do DMA?  I can see some benefit to
that, but some drawbacks too.  The *main* form of isolation (or lack
thereof) that groups is about the IOMMU, but groups can also represent
other forms of isolation failure: e.g. a multifunction device, where
function 0 has some debug registers which affect other functions.
That's relevant whether or not any of those functions use DMA.

Now, we could represent those different sorts of isolation separately,
but at the time our thinking was that we should group together devices
that can't be safely isolated for *any* reason, since the practical
upshot is the same: you can't safely split those devices between
different owners.

> What I don't like is forcing certain things depending on how the
> vfio_device was created - for instance forcing a IOMMU group as part
> and forcing an ugly "SW IOMMU" mode in the container only as part of
> mdev_device.

I don't really see how this is depending on how the device is created.
The current VFIO model is that every device always belongs to a group
- but that group might be a singleton.  That seems less complicated to
me that some devices do and some don't have a group.

> These should all be properties of the vfio_device itself.
>=20
> Again this is all about the group fd - and how to fit in with the
> /dev/ioasid proposal from Kevin:
>=20
> https://lore.kernel.org/kvm/MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR1=
1MB1886.namprd11.prod.outlook.com/
>=20
> Focusing on vfio_device and skipping the group fd smooths out some
> rough edges.
>=20
> Code wise we are not quite there, but I have mapped out eliminating
> the group from the vfio_device centric API and a few other places it
> has crept in.
>=20
> The group can exist in the background to enforce security without
> being a cornerstone of the API design.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--NNPfhi/moTf9NG6z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC+vW0ACgkQbDjKyiDZ
s5IOsg//SaXn8DtoOss3fbhVvxiLeL2e9xl4aXIn0e0aMnU7+/E6Wshc3icrv+lC
RbBTFv2C/wMuKOi+ZSg7mfmyF2fdupI6jk0BX1fWZ1LNjHwZQI4ER4yvRmN25nOn
eJbPvSl/l8gyQzwzK4Fr05+USYY1N+uQ81jA7ok6K34Q35T7aBe1tvUic53jV5SQ
/Ezr1jCg7nGfobOVcVw0oZt0nNGE2WRT3WlPyAAcmgOKdW45Z/+9nH0tgmoCSKz+
kU8lO8if0vaOf+6xwdhltZhmcuiuzxVNTwmjfG4RvkzSzAAbkfopg7cpTo+y56du
5y0iJm3LL8SeIdfR9Fn2a95cnLsdiaTigwp7bBXR9fIRU88q6gDo6lmlLX5j4XoX
KuPULmWx6hc67XOBZctd3Z8GbSd02OkdfKOl+KC2SQNWaRnSujyIWfs4P/hkEp+l
JB+TQW7yBNVJHOorZCNuww11jPMgtoxwZLiTBnVnZ17t/vk7dsbKpyKYcUggyMME
57MHB3u73a457ZcDQSzJRkYlnNt5CY8ThRRf915x5uXAvb/OHHHkpDe4tI2pvuEs
98oAKDwDttXIhE2CBrp/CBct2k6d5ZwHKeqv0boM01FjjUWp/kyyWbeo5+PI8t1S
PhIr3XflfPANDRNp1Y81OGao2wUwg4qcE5KBXsLCC/vahPyd+18=
=e7fV
-----END PGP SIGNATURE-----

--NNPfhi/moTf9NG6z--
