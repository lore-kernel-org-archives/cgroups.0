From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 8 Apr 2021 08:41:13 -0300
Message-ID: <20210408114113.GN7405@nvidia.com>
References: <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <MWHPR11MB1886CF7C11ECE0396A0215078C769@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210406123451.GN7405@nvidia.com>
 <MWHPR11MB1886CB8F558C6C17F921F77F8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210407122042.GF7405@nvidia.com>
 <MWHPR11MB1886AEAE97A9E6972C63CACF8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48OHsp5mI3yQn9DHcjJ1PrziL5UqaHpzIRwLXkKu7z0=;
 b=eHaPZOGQChk9LAHLgFwQD7YeZuLpMvNdeyclyCf7PB2H4FY7mAjGNyAp7qO0UO6KK+5AgDh1WrBY/2ZIimgmxDh1B38HLLStt1FjSV6mn4qmMB1QDKZjtlI1xwbWO5c2PeW2y2XMrUBVtdZ1oCXMNkzwZ3LDY6FybWDl9/brPgvQ2yvnEtCyocJQs1WQXF5soAHdnch8E5O+gJiwayiVFaOKsOjgbexxddaVlBxQT7yEnQTq4PjHmTYHSlMcxw0GOCCCGD76njQxYXp+8sjhAIWzuu4Z5htTQqNdjA0sbhqAzykjShPpDIztYCzULHzZVAHwlLkx+4wvNhfIxuwoag==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886AEAE97A9E6972C63CACF8C759-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 07, 2021 at 11:50:02PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Wednesday, April 7, 2021 8:21 PM
> >=20
> > On Wed, Apr 07, 2021 at 02:08:33AM +0000, Tian, Kevin wrote:
> >=20
> > > > Because if you don't then we enter insane world where a PASID is be=
ing
> > > > created under /dev/ioasid but its translation path flows through se=
tup
> > > > done by VFIO and the whole user API becomes an incomprehensible
> > mess.
> > > >
> > > > How will you even associate the PASID with the other translation??
> > >
> > > PASID is attached to a specific iommu domain (created by VFIO/VDPA),
> > which
> > > has GPA->HPA mappings already configured. If we view that mapping as =
an
> > > attribute of the iommu domain, it's reasonable to have the userspace-
> > bound
> > > pgtable through /dev/ioasid to nest on it.
> >=20
> > A user controlled page table should absolutely not be an attribute of
> > a hidden kernel object, nor should two parts of the kernel silently
> > connect to each other via a hidden internal objects like this.
> >=20
> > Security is important - the kind of connection must use some explicit
> > FD authorization to access shared objects, not be made implicit!
> >=20
> > IMHO this direction is a dead end for this reason.
> >=20
>=20
> Could you elaborate what exact security problem is brought with this=20
> approach? Isn't ALLOW_PASID the authorization interface for the
> connection?

If the kernel objects don't come out of FDs then no.

> Is it really the only practice in Linux that any new feature has to be
> blocked as long as a refactoring work is identified?=20

The practice is to define uAPIs that make sense and have a good chance
to be supported over a long time period, as the software evolves, not
to hacky hacky a gaint uAPI mess just to get some feature out the
door.=20

This proposal as it was oringial shown is exactly the kind of hacky
hacky uapi nobody wants to see. Tunneling an IOMMU uapi through a
whole bunch of other FDs is completely nutz.

Intel should basically be investing most of its time building a robust
and well designed uAPI here, and don't complain that the community is
not doing Intel's job for free.

> Don't people accept any balance between enabling new features and
> completing refactoring work through a staging approach, as long as
> we don't introduce an uAPI specifically for the staging purpose? =E2=98=B9

Since this is all uapi I don't see it as applicable here.

Jason
