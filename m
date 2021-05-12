From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 12 May 2021 00:40:04 +0000
Message-ID: <MWHPR11MB1886C5A82E4846A86F4D31988C529@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <YJOZhPGheTSlHtQc@myrica> <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <MWHPR11MB1886E22D03B14EE0D5725CE08C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511143840.GL1002214@nvidia.com>
 <MWHPR11MB188601321993CA43E3058C4D8C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511233950.GQ1002214@nvidia.com>
 <MWHPR11MB188623FB741481D489D259798C529@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210512002515.GR1002214@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ol8tdKdXEMiUCLvEiPres2Ur7dwmUvIMjcVrRkVNYT4=;
 b=LqRuuxdhkOLWFORIjABHybYg8bb1PhALB4URXIcoT+dZ3WCBosTnDc9JPkUV7BCL8NXdNfeMWcShp1Ml4hu+LyHCQtBZfnMXOFUmblzfP12BikeKOLjb2rExwdcGgYAf/VZ8pVPB+3gBVIHX1sPY3tAz8nljUrjRMtYxBXcBvzI=
In-Reply-To: <20210512002515.GR1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Wednesday, May 12, 2021 8:25 AM
>=20
> On Wed, May 12, 2021 at 12:21:24AM +0000, Tian, Kevin wrote:
>=20
> > > Basically each RID knows based on its kernel drivers if it is a local
> > > or global RID and the ioasid knob can further fine tune this for any
> > > other specialty cases.
> >
> > It's fine if you insist on this way. Then we leave it to userspace to
> > ensure same split range is used across devices when vIOMMU is
> > concerned.
>=20
> I'm still confused why there is a split range needed.

a device could support both ENQCMD and non-ENQCMD submissions.

for ENQCMD path, CPU provides a PASID translation mechanism (from
guest PASID to host PASID)

for non-ENQCMD path, guest driver directly programs untranslated=20
guest PASID to the device MMIO register.

the host kernel only setups host PASID entry which is hwid for a said
ioasid page table.

If we don't split range, we have to assume guest PASID =3D=3D host PASID
otherwise non-ENQCMD path will fail. But expose host PASID to guest
breaks migration.

If we want to allow migration, then need support guest PASID !=3D host
PASID and make sure both entries point to the same page table so
ENQCMD (host PASID) and non-ENQCMD (guest PASID) can both work.
It requires range split to avoid conflict between host/guest PASIDs
in the same space.

>=20
> > Please note such range split has to be enforced through
> > vIOMMU which (e.g. on VT-d) includes a register to report available
> > PASID space size (applying to all devices behind this vIOMMU) to
> > the guest. The kernel just follows per-RID split info. If anything brok=
en,
> > the userspace just shoots its own foot.
>=20
> Is it because this specific vIOMMU protocol is limiting things?

When range split is enabled, we need a way to tell the guest about the
local range size so guest PASID is allocated only within this range. Then
we use vIOMMU to expose such information.

>=20
> > > > > It does need some user visible difference because SIOV/mdev is no=
t
> > > > > migratable. Only the kernel can select a PASID, userspace (and he=
nce
> > > > > the guest) shouldn't have the option to force a specific PASID as=
 the
> > > > > PASID space is shared across the entire RID to all VMs using the =
mdev.
> > > >
> > > > not migratable only when you choose exposing host-allocated PASID
> > > > into guest. However in the entire this proposal we actually virtual=
ize
> > > > PASIDs, letting the guest manage its own PASID space in all
> > > > scenarios
> > >
> > > PASID cannot be virtualized without also using ENQCMD.
> > >
> > > A mdev that is using PASID without ENQCMD is non-migratable and this
> > > needs to be make visiable in the uAPI.
> >
> > No. without ENQCMD the PASID must be programmed to a mdev MMIO
> > register. This operation is mediated then mdev driver can translate the
> > PASID from virtual to real.
>=20
> That is probably unworkable with real devices, but if you do this you
> need to explicitly expose the vPASID to the mdev API somehow, and still
> the device needs to declare if it supports this, and devices that
> don't should still work in a non-migratable mode.
>=20

It's not necessary. For real devices we use alias mapping for both guest/ho=
st
PASID as explained above. Then we can have the guest to always register its=
=20
vPASID with ioasid (just like map/unmap GPA to HVA), and then let host driv=
ers=20
to figure out whether that vPASID can be used as a real hwid. When it's con=
sidered
virtual and a real hwid is allocated by the host, the mapping is saved unde=
r this
ioasid to be queried by device drivers if translation is required.=20
=20
From this angle, the previous IOASID_SET_HWID possibly should be renamed=20
to IOASID_SET_USER_HWID.

Thanks
Kevin
