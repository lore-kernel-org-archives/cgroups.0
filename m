From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 2 Apr 2021 07:30:23 +0000
Message-ID: <MWHPR11MB18866AB35A13A139262347FD8C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OXDwSVGuinNLD0v+qFjy2ozkCsQU3XD1qBtJfbpKEI=;
 b=IQ6nL5Je6NBN7yBkJGIDDMTL6lCaaftBcazseRUh5ptFy0YUM8djtTN1R+EQw6lFmVLg0uMS8S3CaUVfnripCt+FqEXOohNWJX3F4Vi4wkzBX/zPKWUVomOW88B+A5+jT2jgQamn6AadIPxF/nabe60aHXNK1DI0H7GeYvaJzyo=
In-Reply-To: <20210401160337.GJ1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Friday, April 2, 2021 12:04 AM
>=20
> On Thu, Apr 01, 2021 at 02:08:17PM +0000, Liu, Yi L wrote:
>=20
> > DMA page faults are delivered to root-complex via page request message
> and
> > it is per-device according to PCIe spec. Page request handling flow is:
> >
> > 1) iommu driver receives a page request from device
> > 2) iommu driver parses the page request message. Get the RID,PASID,
> faulted
> >    page and requested permissions etc.
> > 3) iommu driver triggers fault handler registered by device driver with
> >    iommu_report_device_fault()
>=20
> This seems confused.
>=20
> The PASID should define how to handle the page fault, not the driver.
>=20
> I don't remember any device specific actions in ATS, so what is the
> driver supposed to do?
>=20
> > 4) device driver's fault handler signals an event FD to notify userspac=
e to
> >    fetch the information about the page fault. If it's VM case, inject =
the
> >    page fault to VM and let guest to solve it.
>=20
> If the PASID is set to 'report page fault to userspace' then some
> event should come out of /dev/ioasid, or be reported to a linked
> eventfd, or whatever.
>=20
> If the PASID is set to 'SVM' then the fault should be passed to
> handle_mm_fault
>=20
> And so on.
>=20
> Userspace chooses what happens based on how they configure the PASID
> through /dev/ioasid.
>=20
> Why would a device driver get involved here?
>=20
> > Eric has sent below series for the page fault reporting for VM with pas=
sthru
> > device.
> > https://lore.kernel.org/kvm/20210223210625.604517-5-
> eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
>=20
> It certainly should not be in vfio pci. Everything using a PASID needs
> this infrastructure, VDPA, mdev, PCI, CXL, etc.
>=20

This touches an interesting fact:

The fault may be triggered in either 1st-level or 2nd-level page table,=20
when nested translation is enabled (in vSVA case). The 1st-level is bound=20
by the user space, which therefore needs to receive the fault event. The=20
2nd-level is managed by VFIO (or vDPA), which needs to fix the fault in=20
kernel (e.g. find HVA per faulting GPA, call handle_mm_fault and map=20
GPA->HPA to IOMMU). Yi's current proposal lets VFIO to register the=20
device fault handler, which then forward the event through /dev/ioasid=20
to userspace only if it is a 1st-level fault. Are you suggesting a pgtable-
centric fault reporting mechanism to separate handlers in each level,=20
i.e. letting VFIO register handler only for 2nd-level fault and then /dev/
ioasid register handler for 1st-level fault?

Thanks
Kevin

