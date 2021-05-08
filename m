From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Sat, 8 May 2021 09:56:59 +0000
Message-ID: <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504084148.4f61d0b5@jacob-builder> <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder> <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder> <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com> <20210506163240.GA9058@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxj1YXgPrxwGs+XWI8P0mgV1q4GSN84WI50RW4x0jIM=;
 b=WGoIkIEeUBLIVmeXolDJ9qCzyCTWA7ji3OoRfW6kvkrT/kw5+jE8R6TcHkSPWbUXmJ6us48Odnuxglm6hIOlhECjGmQ8GDKKr0hvBs1p1qHhnHKMwPWBYzS2744F3MtynxrbD1MnpCtoCyyQsJram8qLaSH66al98xwMBGPvpWs=
In-Reply-To: <20210506163240.GA9058@otc-nc-03>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Raj, Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Sent: Friday, May 7, 2021 12:33 AM
>=20
> > Basically it means when the guest's top level IOASID is created for
> > nesting that IOASID claims all PASID's on the RID and excludes any
> > PASID IOASIDs from existing on the RID now or in future.
>=20
> The way to look at it this is as follows:
>=20
> For platforms that do not have a need to support shared work queue model
> support for ENQCMD or similar, PASID space is naturally per RID. There is=
 no
> complication with this. Every RID has the full range of PASID's and no ne=
ed
> for host to track which PASIDs are allocated now or in future in the gues=
t.
>=20
> For platforms that support ENQCMD, it is required to mandate PASIDs are
> global across the entire system. Maybe its better to call them gPASID for
> guest and hPASID for host. Short reason being gPASID->hPASID is a guest
> wide mapping for ENQCMD and not a per-RID based mapping. (We covered
> that
> in earlier responses)
>=20
> In our current implementation we actually don't separate this space, and
> gPASID =3D=3D hPASID. The iommu driver enforces that by using the custom
> allocator and the architected interface that allows all guest vIOMMU
> allocations to be proxied to host. Nothing but a glorified hypercall like
> interface. In fact some OS's do use hypercall to get a hPASID vs using
> the vCMD style interface.
>=20

After more thinking about the new interface, I feel gPASID=3D=3DhPASID=20
actually causes some confusion in uAPI design. In concept an ioasid
is not active until it's attached to a device, because it's just an ID
if w/o a device. So supposedly an ioasid should reject all user commands
before attach. However an guest likely asks for a new gPASID before
attaching it to devices and vIOMMU. if gPASID=3D=3DhPASID then Qemu=20
must request /dev/ioasid to allocate a hw_id for an ioasid which hasn't=20
been attached to any device, with the assumption on kernel knowledge=20
that this hw_id is from an global allocator w/o dependency on any=20
device. This doesn't sound a clean design, not to say it also conflicts=20
with live migration.

Want to hear your and Jason's opinion about an alternative option to=20
remove such restriction thus allowing gPASID!=3DhPASID.

gPASID!=3DhPASID has a problem when assigning a physical device which=20
supports both shared work queue (ENQCMD with PASID in MSR)=20
and dedicated work queue (PASID in device register) to a guest
process which is associated to a gPASID. Say the host kernel has setup
the hPASID entry with nested translation though /dev/ioasid. For=20
shared work queue the CPU is configured to translate gPASID in MSR=20
into **hPASID** before the payload goes out to the wire. However=20
for dedicated work queue the device MMIO register is directly mapped=20
to and programmed by the guest, thus containing a **gPASID** value
implying DMA requests through this interface will hit IOMMU faults
due to invalid gPASID entry. Having gPASID=3D=3DhPASID is a simple=20
workaround here. mdev doesn't have this problem because the
PASID register is in emulated control-path thus can be translated
to hPASID manually by mdev driver.

Along this story one possible option is having both gPASID and hPASID=20
entries pointing to the same paging structure, sort of making gPASID
an aliasing hw_id to hPASID. Then we also need to make sure gPASID
range not colliding with hPASID range for this RID. Something like
below:

In the beginning Qemu specifies a minimal ID (say 1024) that hPASIDs=20
must be allocated beyond (sort of delegating [0, 1023] of this RID to
userspace):
	ioctl(ioasid_fd, SET_IOASID_MIN_HWID, 1024);

The guest still uses vIOMMU interface or hypercall to allocate gPASIDs.
Upon such request, Qemu returns a gPASID from [0, 1023] to guest=20
and also allocates a new ioasid from /dev/ioasid. there is no hw_id=20
allocated at this step:
	ioasid =3D ioctl(ioasid_fd, ALLOC_IOASID);

hw_id (hPASID) is allocated when attaching ioasid to the said device:
	ioctl(device_fd, VFIO_ATTACH_IOASID, ioasid);

Then gPASID is provided as an aliasing hwid to this ioasid:
	ioctl(device_fd, VFIO_ALIASING_IOASID, ioasid, gPASID);

Starting from this point the kernel should make sure that any ioasid
operation should be applied to both gPASID and hPASID for this RID=20
(entry setup, tear down, etc.)  and both PASID entries point to the same
paging structures. When a page fault happens, the IOMMU driver=20
should also link a fault from either PASID back to the associated ioasid.=20

As explained earlier this aliasing requirement only applies to physical
devices on Intel platform. We may either have mdev ignore such=20
aliasing request, or have vfio device to report whether aliasing is allowed=
.

This is sort of a hybrid model. the gPASID range is reserved locally
in per-RID pasid space and delegated to userspace, while the hPASIDs=20
are still managed globally and not exposed to userspace.

Does it sound a cleaner approach (still w/ some complexity) compared
to the restrictions of having gPASID=3D=3DhPASID?

Thanks
Kevin
