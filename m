From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Tue, 11 May 2021 09:10:03 +0000
Message-ID: <MWHPR11MB1886E22D03B14EE0D5725CE08C539@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder> <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder> <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com> <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ry7toOJ219gcXsK/gZLY3pxGSnprkLFqVd1XYoF+5+I=;
 b=T8GtLyq95awciJXYhHkD4Jzk8KflKR1u2JbYdZxPuPbWwj3vw663VEodFL8nk13M0a8Gj65JNvAd3mo8hpFAc6a/MDNvPYSr+AoBdjLxSwbWxLER0y4VjOqU6ziPI+D81ilnHVmSCHyT3Qo15KdnVEd91dbi6G2OMXYULTJfEz4=
In-Reply-To: <20210510123729.GA1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Jason Gunthorpe
> Sent: Monday, May 10, 2021 8:37 PM
>=20
[...]=20
> > gPASID!=3DhPASID has a problem when assigning a physical device which
> > supports both shared work queue (ENQCMD with PASID in MSR)
> > and dedicated work queue (PASID in device register) to a guest
> > process which is associated to a gPASID. Say the host kernel has setup
> > the hPASID entry with nested translation though /dev/ioasid. For
> > shared work queue the CPU is configured to translate gPASID in MSR
> > into **hPASID** before the payload goes out to the wire. However
> > for dedicated work queue the device MMIO register is directly mapped
> > to and programmed by the guest, thus containing a **gPASID** value
> > implying DMA requests through this interface will hit IOMMU faults
> > due to invalid gPASID entry. Having gPASID=3D=3DhPASID is a simple
> > workaround here. mdev doesn't have this problem because the
> > PASID register is in emulated control-path thus can be translated
> > to hPASID manually by mdev driver.
>=20
> This all must be explicit too.
>=20
> If a PASID is allocated and it is going to be used with ENQCMD then
> everything needs to know it is actually quite different than a PASID
> that was allocated to be used with a normal SRIOV device, for
> instance.
>=20
> The former case can accept that the guest PASID is virtualized, while
> the lattter can not.
>=20
> This is also why PASID per RID has to be an option. When I assign a
> full SRIOV function to the guest then that entire RID space needs to
> also be assigned to the guest. Upon migration I need to take all the
> physical PASIDs and rebuild them in another hypervisor exactly as is.
>=20
> If you force all RIDs into a global PASID pool then normal SRIOV
> migration w/PASID becomes impossible. ie ENQCMD breaks everything else
> that should work.
>=20
> This is why you need to sort all this out and why it feels like some
> of the specs here have been mis-designed.
>=20
> I'm not sure carving out ranges is really workable for migration.
>=20
> I think the real answer is to carve out entire RIDs as being in the
> global pool or not. Then the ENQCMD HW can be bundled together and
> everything else can live in the natural PASID per RID world.
>=20

OK. Here is the revised scheme by making it explicitly.

There are three scenarios to be considered:

1) SR-IOV (AMD/ARM):
	- "PASID per RID" with guest-allocated PASIDs;
	- PASID table managed by guest (in GPA space);
	- the entire PASID space delegated to guest;
	- no need to explicitly register guest-allocated PASIDs to host;
	- uAPI for attaching PASID table:

    // set to "PASID per RID"
    ioctl(ioasid_fd, IOASID_SET_HWID_MODE, IOASID_HWID_LOCAL);

    // When Qemu captures a new PASID table through vIOMMU;
    pasidtbl_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
    ioctl(device_fd, VFIO_ATTACH_IOASID, pasidtbl_ioasid);

    // Set the PASID table to the RID associated with pasidtbl_ioasid;
    ioctl(ioasid_fd, IOASID_SET_PASID_TABLE, pasidtbl_ioasid, gpa_addr);

2) SR-IOV, no ENQCMD (Intel):
	- "PASID per RID" with guest-allocated PASIDs;
	- PASID table managed by host (in HPA space);
	- the entire PASID space delegated to guest too;
	- host must be explicitly notified for guest-allocated PASIDs;
	- uAPI for binding user-allocated PASIDs:

    // set to "PASID per RID"
    ioctl(ioasid_fd, IOASID_SET_HWID_MODE, IOASID_HWID_LOCAL);

    // When Qemu captures a new PASID allocated through vIOMMU;
    pgtbl_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
    ioctl(device_fd, VFIO_ATTACH_IOASID, pgtbl_ioasid);

    // Tell the kernel to associate pasid to pgtbl_ioasid in internal struc=
ture;
    // &pasid being a pointer due to a requirement in scenario-3
    ioctl(ioasid_fd, IOASID_SET_HWID, pgtbl_ioasid, &pasid);

    // Set guest page table to the RID+pasid associated to pgtbl_ioasid
    ioctl(ioasid_fd, IOASID_BIND_PGTABLE, pgtbl_ioasid, gpa_addr);

3) SRIOV, ENQCMD (Intel):
	- "PASID global" with host-allocated PASIDs;
	- PASID table managed by host (in HPA space);
	- all RIDs bound to this ioasid_fd use the global pool;
	- however, exposing global PASID into guest breaks migration;
	- hybrid scheme: split local PASID range and global PASID range;
	- force guest to use only local PASID range (through vIOMMU);
	- for ENQCMD, configure CPU to translate local->global;
	- for non-ENQCMD, setup both local/global pasid entries;
	- uAPI for range split and CPU pasid mapping:

    // set to "PASID global"
    ioctl(ioasid_fd, IOASID_SET_HWID_MODE, IOASID_HWID_GLOBAL);

    // split local/global range, applying to all RIDs in this fd
    // Example: local [0, 1024), global [1024, max)
    // local PASID range is managed by guest and migrated as VM state
    // global PASIDs are re-allocated and mapped to local PASIDs post migra=
tion
    ioctl(ioasid_fd, IOASID_HWID_SET_GLOBAL_MIN, 1024);

    // When Qemu captures a new local_pasid allocated through vIOMMU;
    pgtbl_ioasid =3D ioctl(ioasid_fd, IOASID_ALLOC);
    ioctl(device_fd, VFIO_ATTACH_IOASID, pgtbl_ioasid);

    // Tell the kernel to associate local_pasid to pgtbl_ioasid in internal=
 structure;
    // Due to HWID_GLOBAL, the kernel also allocates a global_pasid from th=
e
    // global pool. From now on, every hwid related operations must be appl=
ied
    // to both PASIDs for this page table;
    // global_pasid is returned to userspace in the same field as local_pas=
id;
    ioctl(ioasid_fd, IOASID_SET_HWID, pgtbl_ioasid, &local_pasid);

    // Qemu then registers local_pasid/global_pasid pair to KVM for setting=
 up
    // CPU PASID translation table;
    ioctl(kvm_fd, KVM_SET_PASID_MAPPING, local_pasid, global_pasid);

    // Set guest page table to the RID+{local_pasid, global_pasid} associat=
ed=20
    // to pgtbl_ioasid;
    ioctl(ioasid_fd, IOASID_BIND_PGTABLE, pgtbl_ioasid, gpa_addr);

-----
Notes:

I tried to keep common commands in generic format for all scenarios, while
introducing new commands for usage-specific requirement. Everything is
made explicit now.=20

The userspace has sufficient information to choose its desired scheme based=
=20
on vIOMMU types and platform information (e.g. whether ENQCMD is exposed=20
in virtual CPUID, whether assigned devices support DMWr, etc.).=20

Above example assumes one RID per bound page table, because vIOMMU
identifies new guest page tables per-RID. If there are other usages requiri=
ng
multiple RIDs per page table, SET_HWID/BIND_PGTABLE could accept
another device_handle parameter to specify which RID is targeted for this
operation.

When considering SIOV/mdev there is no change to above uAPI sequence.=20
It's n/a for 1) as SIOV requires PASID table in HPA space, nor does it
cause any change to 3) regarding to the split range scheme. The only
 conceptual change is in 2), where although it's still "PASID per RID" the=
=20
PASIDs must be managed by host because the parent driver also allocates=20
PASIDs from per-RID space to mark mdev (RID+PASID). But this difference=20
doesn't change the uAPI flow - just treat user-provisioned PASID as 'virtua=
l'=20
and then allocate a 'real' PASID at IOASID_SET_HWID. Later always use the=20
real one when programming PASID entry (IOASID_BIND_PGTABLE) or device=20
PASID register (converted in the mediation path).

If all above can work reasonably, we even don't need the special VCMD=20
interface in VT-d for guest to allocate PASIDs from host. Just always let
the guest to manage its PASIDs (with restriction of available local PASIDs)=
,
being a global allocator or per-RID allocator. the vIOMMU side just stick
to the per-RID emulation according to the spec.=20

Thanks
Kevin

