From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 12 May 2021 00:21:24 +0000
Message-ID: <MWHPR11MB188623FB741481D489D259798C529@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com> <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <MWHPR11MB1886E22D03B14EE0D5725CE08C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511143840.GL1002214@nvidia.com>
 <MWHPR11MB188601321993CA43E3058C4D8C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511233950.GQ1002214@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4OHOCCzWfjeTLJO++P6b1F+xs1LwTd11q0EmTgb8ww4=;
 b=ZR8guL5VR9yjD8FtuQmYH6U7QhhMNh/EEgH8vj4pf1kHHIT+QmP9PiFDYm2sBLiZRnb929eWsV24xydrHfOXw/MtqQS95ix9XL5+pWzjCgW6eFfzsLqHUBn+YdNGiCJ2zrV2AgGyYKHPrOIZ9MscDYCJ556Tm9zD8N8VUMd1P6Q=
In-Reply-To: <20210511233950.GQ1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Wednesday, May 12, 2021 7:40 AM
>=20
> On Tue, May 11, 2021 at 10:51:40PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > Sent: Tuesday, May 11, 2021 10:39 PM
> > >
> > > On Tue, May 11, 2021 at 09:10:03AM +0000, Tian, Kevin wrote:
> > >
> > > > 3) SRIOV, ENQCMD (Intel):
> > > > 	- "PASID global" with host-allocated PASIDs;
> > > > 	- PASID table managed by host (in HPA space);
> > > > 	- all RIDs bound to this ioasid_fd use the global pool;
> > > > 	- however, exposing global PASID into guest breaks migration;
> > > > 	- hybrid scheme: split local PASID range and global PASID range;
> > > > 	- force guest to use only local PASID range (through vIOMMU);
> > > > 	- for ENQCMD, configure CPU to translate local->global;
> > > > 	- for non-ENQCMD, setup both local/global pasid entries;
> > > > 	- uAPI for range split and CPU pasid mapping:
> > > >
> > > >     // set to "PASID global"
> > > >     ioctl(ioasid_fd, IOASID_SET_HWID_MODE, IOASID_HWID_GLOBAL);
> > > >
> > > >     // split local/global range, applying to all RIDs in this fd
> > > >     // Example: local [0, 1024), global [1024, max)
> > > >     // local PASID range is managed by guest and migrated as VM sta=
te
> > > >     // global PASIDs are re-allocated and mapped to local PASIDs po=
st
> > > migration
> > > >     ioctl(ioasid_fd, IOASID_HWID_SET_GLOBAL_MIN, 1024);
> > >
> > > I'm still not sold that ranges are the best idea here, it just adds
> > > more state that has to match during migration. Keeping the
> > > global/local split per RID seems much cleaner to me
> >
> > With ENQCMD the PASID is kept in CPU MSR, making it a process
> > context within the guest. When a guest process is bound to two
> > devices, the same local PASID must be usable on both devices.
> > Having per RID split cannot guarantee it.
>=20
> That is only for ENQCMD. All drivers know if they are ENQCMD
> compatible drivers and can ensure they use the global allocator
> consistently for their RIDs.
>=20
> Basically each RID knows based on its kernel drivers if it is a local
> or global RID and the ioasid knob can further fine tune this for any
> other specialty cases.

It's fine if you insist on this way. Then we leave it to userspace to
ensure same split range is used across devices when vIOMMU is
concerned. Please note such range split has to be enforced through
vIOMMU which (e.g. on VT-d) includes a register to report available
PASID space size (applying to all devices behind this vIOMMU) to=20
the guest. The kernel just follows per-RID split info. If anything broken,
the userspace just shoots its own foot.

>=20
> > > It does need some user visible difference because SIOV/mdev is not
> > > migratable. Only the kernel can select a PASID, userspace (and hence
> > > the guest) shouldn't have the option to force a specific PASID as the
> > > PASID space is shared across the entire RID to all VMs using the mdev=
.
> >
> > not migratable only when you choose exposing host-allocated PASID
> > into guest. However in the entire this proposal we actually virtualize
> > PASIDs, letting the guest manage its own PASID space in all
> > scenarios
>=20
> PASID cannot be virtualized without also using ENQCMD.
>=20
> A mdev that is using PASID without ENQCMD is non-migratable and this
> needs to be make visiable in the uAPI.
>=20

No. without ENQCMD the PASID must be programmed to a mdev MMIO
register. This operation is mediated then mdev driver can translate the
PASID from virtual to real.

Thanks
Kevin
