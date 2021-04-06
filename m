From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Tue, 6 Apr 2021 00:37:35 +0000
Message-ID: <MWHPR11MB18862BF4EA4DC0CFDE6CD2238C769@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <MWHPR11MB18866AB35A13A139262347FD8C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405233526.GD7405@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyw4OneNeXJqKL9NBPjmYCJ76IrpWZauWPyDllAWzuw=;
 b=Ppiujj22mWzJhwmUmkyj2GExLjOqXidQIHb3RhngltsxJYEe3cwtXI5ZhNjARtW1c4XFHlZMvZF19UXPMgfuZWS18Om7iMMY9KGtB1Hxlk8L3OhTR3ixXNVSxKZndEm5i+Rp+ciGNr1CH5zpcvUJV9JpVCaKW+hmYK/VDhaXEQ8=
In-Reply-To: <20210405233526.GD7405-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Tuesday, April 6, 2021 7:35 AM
>=20
> On Fri, Apr 02, 2021 at 07:30:23AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > Sent: Friday, April 2, 2021 12:04 AM
> > >
> > > On Thu, Apr 01, 2021 at 02:08:17PM +0000, Liu, Yi L wrote:
> > >
> > > > DMA page faults are delivered to root-complex via page request
> message
> > > and
> > > > it is per-device according to PCIe spec. Page request handling flow=
 is:
> > > >
> > > > 1) iommu driver receives a page request from device
> > > > 2) iommu driver parses the page request message. Get the RID,PASID,
> > > faulted
> > > >    page and requested permissions etc.
> > > > 3) iommu driver triggers fault handler registered by device driver =
with
> > > >    iommu_report_device_fault()
> > >
> > > This seems confused.
> > >
> > > The PASID should define how to handle the page fault, not the driver.
> > >
> > > I don't remember any device specific actions in ATS, so what is the
> > > driver supposed to do?
> > >
> > > > 4) device driver's fault handler signals an event FD to notify user=
space
> to
> > > >    fetch the information about the page fault. If it's VM case, inj=
ect the
> > > >    page fault to VM and let guest to solve it.
> > >
> > > If the PASID is set to 'report page fault to userspace' then some
> > > event should come out of /dev/ioasid, or be reported to a linked
> > > eventfd, or whatever.
> > >
> > > If the PASID is set to 'SVM' then the fault should be passed to
> > > handle_mm_fault
> > >
> > > And so on.
> > >
> > > Userspace chooses what happens based on how they configure the PASID
> > > through /dev/ioasid.
> > >
> > > Why would a device driver get involved here?
> > >
> > > > Eric has sent below series for the page fault reporting for VM with
> passthru
> > > > device.
> > > > https://lore.kernel.org/kvm/20210223210625.604517-5-
> > > eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
> > >
> > > It certainly should not be in vfio pci. Everything using a PASID need=
s
> > > this infrastructure, VDPA, mdev, PCI, CXL, etc.
> > >
> >
> > This touches an interesting fact:
> >
> > The fault may be triggered in either 1st-level or 2nd-level page table,
> > when nested translation is enabled (in vSVA case). The 1st-level is bou=
nd
> > by the user space, which therefore needs to receive the fault event. Th=
e
> > 2nd-level is managed by VFIO (or vDPA), which needs to fix the fault in
> > kernel (e.g. find HVA per faulting GPA, call handle_mm_fault and map
> > GPA->HPA to IOMMU). Yi's current proposal lets VFIO to register the
> > device fault handler, which then forward the event through /dev/ioasid
> > to userspace only if it is a 1st-level fault. Are you suggesting a pgta=
ble-
> > centric fault reporting mechanism to separate handlers in each level,
> > i.e. letting VFIO register handler only for 2nd-level fault and then /d=
ev/
> > ioasid register handler for 1st-level fault?
>=20
> This I'm struggling to understand. /dev/ioasid should handle all the
> faults cases, why would VFIO ever get involved in a fault? What would
> it even do?
>=20
> If the fault needs to be fixed in the hypervisor then it is a kernel
> fault and it does handle_mm_fault. This absolutely should not be in
> VFIO or VDPA

With nested translation it is GVA->GPA->HPA. The kernel needs to
fix fault related to GPA->HPA (managed by VFIO/VDPA) while=20
handle_mm_fault only handles HVA->HPA. In this case, the 2nd-level
page fault is expected to be delivered to VFIO/VDPA first which then
find HVA related to GPA, call handle_mm_fault to fix HVA->HPA,
and then call iommu_map to fix GPA->HPA in the IOMMU page table.
This is exactly like how CPU EPT violation is handled.

>=20
> If the fault needs to be fixed in the guest, then it needs to be
> delivered over /dev/ioasid in some way and injected into the
> vIOMMU. VFIO and VDPA have nothing to do with vIOMMU driver in quemu.
>=20
> You need to have an interface under /dev/ioasid to create both page
> table levels and part of that will be to tell the kernel what VA is
> mapped and how to handle faults.

VFIO/VDPA already have their own interface to manage GPA->HPA
mappings. Why do we want to duplicate it in /dev/ioasid?=20

Thanks
Kevin
