From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Tue, 11 May 2021 22:51:40 +0000
Message-ID: <MWHPR11MB188601321993CA43E3058C4D8C539@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder> <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com> <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <MWHPR11MB1886E22D03B14EE0D5725CE08C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511143840.GL1002214@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbHlBRAFJGFTLevQUSTmwuM5z1WZgVO7H6SFZJRM+n8=;
 b=Dm+tg0f6Vk7daHFG2I04Ibzq5BE+8E2MnGKsD9ItpIiWnbYaDc3+fFHOs+7m2qY5YQj8IeRqRy84Kal4uSne+OyuSrb3sQMJ4r9sFnEFOEJiU7lxKs4mQFIxfxUOGGcoIhplF/PvastYVWn0izuUpRHx/UmF+yfAVkl/rccNvxQ=
In-Reply-To: <20210511143840.GL1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Tuesday, May 11, 2021 10:39 PM
>=20
> On Tue, May 11, 2021 at 09:10:03AM +0000, Tian, Kevin wrote:
>=20
> > 3) SRIOV, ENQCMD (Intel):
> > 	- "PASID global" with host-allocated PASIDs;
> > 	- PASID table managed by host (in HPA space);
> > 	- all RIDs bound to this ioasid_fd use the global pool;
> > 	- however, exposing global PASID into guest breaks migration;
> > 	- hybrid scheme: split local PASID range and global PASID range;
> > 	- force guest to use only local PASID range (through vIOMMU);
> > 	- for ENQCMD, configure CPU to translate local->global;
> > 	- for non-ENQCMD, setup both local/global pasid entries;
> > 	- uAPI for range split and CPU pasid mapping:
> >
> >     // set to "PASID global"
> >     ioctl(ioasid_fd, IOASID_SET_HWID_MODE, IOASID_HWID_GLOBAL);
> >
> >     // split local/global range, applying to all RIDs in this fd
> >     // Example: local [0, 1024), global [1024, max)
> >     // local PASID range is managed by guest and migrated as VM state
> >     // global PASIDs are re-allocated and mapped to local PASIDs post
> migration
> >     ioctl(ioasid_fd, IOASID_HWID_SET_GLOBAL_MIN, 1024);
>=20
> I'm still not sold that ranges are the best idea here, it just adds
> more state that has to match during migration. Keeping the
> global/local split per RID seems much cleaner to me

With ENQCMD the PASID is kept in CPU MSR, making it a process
context within the guest. When a guest process is bound to two
devices, the same local PASID must be usable on both devices.
Having per RID split cannot guarantee it.

>=20
> This is also why I don't really like having the global/local be global
> to the ioasid either. It would be better to specify global/local as
> part of each VFIO_ATTACH_IOASID so each device is moved to the correct
> allocator.

this was my original thought. But for above reason this has to be
a global enforcement in this ioasid fd.

>=20
> > When considering SIOV/mdev there is no change to above uAPI sequence.
> > It's n/a for 1) as SIOV requires PASID table in HPA space, nor does it
> > cause any change to 3) regarding to the split range scheme. The only
> >  conceptual change is in 2), where although it's still "PASID per RID" =
the
> > PASIDs must be managed by host because the parent driver also allocates
> > PASIDs from per-RID space to mark mdev (RID+PASID). But this difference
> > doesn't change the uAPI flow - just treat user-provisioned PASID as 'vi=
rtual'
> > and then allocate a 'real' PASID at IOASID_SET_HWID. Later always use t=
he
> > real one when programming PASID entry (IOASID_BIND_PGTABLE) or
> device
> > PASID register (converted in the mediation path).
>=20
> It does need some user visible difference because SIOV/mdev is not
> migratable. Only the kernel can select a PASID, userspace (and hence
> the guest) shouldn't have the option to force a specific PASID as the
> PASID space is shared across the entire RID to all VMs using the mdev.

not migratable only when you choose exposing host-allocated PASID
into guest. However in the entire this proposal we actually virtualize
PASIDs, letting the guest manage its own PASID space in all scenarios
(being SR-IOV or SIOV) though the size of PASID space might be different.=20
The PASID chosen by guest may be used as the hw PASID when the=20
PASID space is delegated to guest (e.g. SR-IOV in scenario 1), or is=20
mapped to a different PASID allocated by guest (e.g. in this mdev=20
case or ENQCMD in scenario-3). From uAPI p.o.v the userspace just=20
needs to attach its own pasid to ioasid while the kernel will decide=20
the real hwid underlyingly (being same or different one). Migration=20
only needs cover guest-allocated PASIDs, with all host-side PASIDs=20
are hidden from userspace and reconstructed in the new machine=20
post migration (following common virtualization practice).

The only exception where we return host-allocated PASID to userspace
in scenario-3 is because Qemu needs such information to update CPU
PASID translation table through KVM. Earlier you suggested that this
must be explicitly done through userspace instead of implicit notification
between ioasid and kvm in kernel.

>=20
> I don't see any alternative to telling every part if the PASID is
> going to be used by ENQCMD or not, too many important decisions rest
> on this detail.
>=20
> Jason

Thanks
Kevin
