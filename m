From: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Thu, 1 Apr 2021 14:08:17 +0000
Message-ID: <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFuA5/QeuJCFioCyUFaV/Plim1BRp3FYkUDyZm2u+XM=;
 b=JC5p7wl5hhnHL7WfZBquMNLPHbMEJA0EEeoxBkQxPvdK8WOSsBWPzTulH20ipJPFBe40IYXORmSRpEM4of8RySWeuSQ5YLE/h1T1igw8mUOOPLW8jN4AxHRXYx9FbCYRO6T1g6RMUD9FpPMRCZfNzaAPsnRPxXiRH6d4Dn2f00w=
In-Reply-To: <20210401134236.GF1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Thursday, April 1, 2021 9:43 PM
> 
> On Thu, Apr 01, 2021 at 01:38:46PM +0000, Liu, Yi L wrote:
> > > From: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > Sent: Thursday, April 1, 2021 8:05 PM
> > [...]
> > >
> > > Also wondering about:
> > >
> > > * Querying IOMMU nesting capabilities before binding page tables
> (which
> > >   page table formats are supported?). We were planning to have a VFIO
> cap,
> > >   but I'm guessing we need to go back to the sysfs solution?
> >
> > I think it can also be with /dev/ioasid.
> 
> Sure, anything to do with page table formats and setting page tables
> should go through ioasid.
> 
> > > * Invalidation, probably an ioasid_fd ioctl?
> >
> > yeah, if we are doing bind/unbind_pagtable via ioasid_fd, then yes,
> > invalidation should go this way as well. This is why I worried it may
> > fail to meet the requirement from you and Eric.
> 
> Yes, all manipulation of page tables, including removing memory ranges, or
> setting memory ranges to trigger a page fault behavior should go
> through here.
> 
> > > * Page faults, page response. From and to devices, and don't necessarily
> > >   have a PASID. But needed by vdpa as well, so that's also going through
> > >   /dev/ioasid?
> >
> > page faults should still be per-device, but the fault event fd may be stored
> > in /dev/ioasid. page response would be in /dev/ioasid just like invalidation.
> 
> Here you mean non-SVA page faults that are delegated to userspace to
> handle?

no, just SVA page faults. otherwise, no need to let userspace handle.

> 
> Why would that be per-device?
>
> Can you show the flow you imagine?

DMA page faults are delivered to root-complex via page request message and
it is per-device according to PCIe spec. Page request handling flow is:

1) iommu driver receives a page request from device
2) iommu driver parses the page request message. Get the RID,PASID, faulted
   page and requested permissions etc.
3) iommu driver triggers fault handler registered by device driver with
   iommu_report_device_fault()
4) device driver's fault handler signals an event FD to notify userspace to
   fetch the information about the page fault. If it's VM case, inject the
   page fault to VM and let guest to solve it.

Eric has sent below series for the page fault reporting for VM with passthru
device.
https://lore.kernel.org/kvm/20210223210625.604517-5-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

Regards,
Yi Liu

> Jason
