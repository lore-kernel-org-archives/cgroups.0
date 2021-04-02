From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 2 Apr 2021 08:22:28 +0000
Message-ID: <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com> <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com> <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VusmaX7Q1WBEhTczFXap0omSnLIBW7wEZc8f3ATgVr0=;
 b=fKoh+xpWV++sSCesW9H+Kiz6H9HqMENFBsclT9RX3WL0/9D6qLgB2X6oKKpWTpGLas23B2VhQHMZpNYNx3VPtUD5BQn0P/pGm+3TO3PfC6OI7TQm/lv+i1Grl13Rnv9G9ZwHhiid9r73NU/9tEZfUThKSTENN00p7HOaP3wGMY0=
In-Reply-To: <20210330132830.GO2356281-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Tuesday, March 30, 2021 9:29 PM
>=20
> >
> > First, userspace may use ioasid in a non-SVA scenario where ioasid is
> > bound to specific security context (e.g. a control vq in vDPA) instead =
of
> > tying to mm. In this case there is no pgtable binding initiated from us=
er
> > space. Instead, ioasid is allocated from /dev/ioasid and then programme=
d
> > to the intended security context through specific passthrough framework
> > which manages that context.
>=20
> This sounds like the exact opposite of what I'd like to see.
>=20
> I do not want to see every subsystem gaining APIs to program a
> PASID. All of that should be consolidated in *one place*.
>=20
> I do not want to see VDPA and VFIO have two nearly identical sets of
> APIs to control the PASID.
>=20
> Drivers consuming a PASID, like VDPA, should consume the PASID and do
> nothing more than authorize the HW to use it.
>=20
> quemu should have general code under the viommu driver that drives
> /dev/ioasid to create PASID's and manage the IO mapping according to
> the guest's needs.
>=20
> Drivers like VDPA and VFIO should simply accept that PASID and
> configure/authorize their HW to do DMA's with its tag.
>=20

I agree with you on consolidating things in one place (especially for the
general SVA support). But here I was referring to an usage without=20
pgtable binding (Possibly Jason. W can say more here), where the=20
userspace just wants to allocate PASIDs, program/accept PASIDs to=20
various workqueues (device specific), and then use MAP/UNMAP=20
interface to manage address spaces associated with each PASID.=20
I just wanted to point out that the latter two steps are through=20
VFIO/VDPA specific interfaces.=20

Thanks
Kevin
