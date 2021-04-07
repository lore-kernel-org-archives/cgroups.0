From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 7 Apr 2021 02:08:33 +0000
Message-ID: <MWHPR11MB1886CB8F558C6C17F921F77F8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder> <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder> <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <MWHPR11MB1886CF7C11ECE0396A0215078C769@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210406123451.GN7405@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYNLOue8ViC5Xongpu43C4H6SAvo+nlYV6d8yzF/GyY=;
 b=UU8K7aFA38h2bS8OD/sQL3cBrrqM5Bsx5DsGhhtSXjNcRl0nyzer056lA3Ee94ubyhtL9dUH9A7EnQhvBJmrJPf4qtasFjshECFVwptXIV3g/oCMcdLkQ/A4Ue8JtIlKMLqCMfaMHL187onSf4a3/YWO8Y8/hbip/n3tizy0dAw=
In-Reply-To: <20210406123451.GN7405-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Tuesday, April 6, 2021 8:35 PM
>=20
> On Tue, Apr 06, 2021 at 01:27:15AM +0000, Tian, Kevin wrote:
> >
> > and here is one example why using existing VFIO/VDPA interface makes
> > sense. say dev1 (w/ sva) and dev2 (w/o sva) are placed in a single VFIO
> > container.
>=20
> Forget about SVA, it is an irrelevant detail of how a PASID is
> configured.
>=20
> > The container is associated to an iommu domain which contains a
> > single 2nd-level page table, shared by both devices (when attached
> > to the domain).
>=20
> This level should be described by an ioasid.
>=20
> > The VFIO MAP operation is applied to the 2nd-level
> > page table thus naturally applied to both devices. Then userspace
> > could use /dev/ioasid to further allocate IOASIDs and bind multiple
> > 1st-level page tables for dev1, nested on the shared 2nd-level page
> > table.
>=20
> Because if you don't then we enter insane world where a PASID is being
> created under /dev/ioasid but its translation path flows through setup
> done by VFIO and the whole user API becomes an incomprehensible mess.
>=20
> How will you even associate the PASID with the other translation??

PASID is attached to a specific iommu domain (created by VFIO/VDPA), which
has GPA->HPA mappings already configured. If we view that mapping as an
attribute of the iommu domain, it's reasonable to have the userspace-bound
pgtable through /dev/ioasid to nest on it.


>=20
> The entire translation path for any ioasid or PASID should be defined
> only by /dev/ioasid. Everything else is a legacy API.
>=20
> > If following your suggestion then VFIO must deny VFIO MAP operations
> > on sva1 (assume userspace should not mix sva1 and sva2 in the same
> > container and instead use /dev/ioasid to map for sva1)?
>=20
> No, userspace creates an iosaid for the guest physical mapping and
> passes this ioasid to VFIO PCI which will assign it as the first layer
> mapping on the RID

Is it an dummy ioasid just for providing GPA mappings for nesting purpose
of other IOASIDs? Then we waste one per VM?

>=20
> When PASIDs are allocated the uAPI will be told to logically nested
> under the first ioasid. When VFIO authorizes a PASID for a RID it
> checks that all the HW rules are being followed.

As I explained above, why cannot we just use iommu domain to connect=20
the dots? Every passthrough framework needs to create an iommu domain
first. and It needs to support both devices w/ PASID and devices w/o PASID.
For devices w/o PASID it needs to invent its own MAP interface anyway.
Then why do we bother creating another MAP interface through /dev/ioasid
which not only duplicates but also creating transition burden between=20
two set of MAP interfaces when the guest turns on/off the pasid capability
on the device?

>=20
> If there are rules like groups of VFIO devices must always use the
> same IOASID then VFIO will check these too (and realistically qemu
> will have only one guest physical map ioasid anyhow)
>=20
> There is no real difference between setting up an IOMMU table for a
> (RID,PASID) tuple or just a RID. We can do it universally with
> one interface for all consumers.
>=20

'universally' upon from which angle you look at this problem. From IOASID
p.o.v possibly yes, but from device passthrough p.o.v. it's the opposite
since the passthrough framework needs to handle devices w/o PASID anyway
(or even for device w/ PASID it could send traffic w/o PASID) thus 'univers=
ally'
makes more sense if the passthrough framework can use one interface of its
own to manage GPA mappings for all consumers (apply to the case when a
PASID is allowed/authorized).

Thanks
Kevin
