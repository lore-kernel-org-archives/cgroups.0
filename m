From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 15 Apr 2021 20:07:32 -0300
Message-ID: <20210415230732.GG1370958@nvidia.com>
References: <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQAb58lwgyE+plmuAkfcQ1sPEzNXE19zU0nknw5tjs0=;
 b=mlfGdLlcOxgpclL093Ex0D98Trzl6JzDNoAfOL1XBR+gkJdaZNfXk7WLjTnDPBPlRswQmeXoQG2/ZOLSVpEeh0leUuUSa/1MZAsiohJhTJvL8O+Yv6WJ91STJxt1jKUNo/cnHkHKIUOMxfdiHgsGKkL3xn0gxUP2wfrmtRd70qWrAwI0tLva1YMUVyKr85JJCLD7+ddaqSfx4yvZDOCIWeSm6PsFS3hEWlgjgDjrNLMWRbiUVf18lg6V6TH8yANCuu91HWe3m/NMBk9JEiHDOiDpP2PP5VdWfwaNCW/+34OP9rhhuKh2IUtQOsHTwsjnQZcqch3CPv3sJtdIy6VaTg==
Content-Disposition: inline
In-Reply-To: <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Apr 15, 2021 at 03:11:19PM +0200, Auger Eric wrote:
> Hi Jason,
> 
> On 4/1/21 6:03 PM, Jason Gunthorpe wrote:
> > On Thu, Apr 01, 2021 at 02:08:17PM +0000, Liu, Yi L wrote:
> > 
> >> DMA page faults are delivered to root-complex via page request message and
> >> it is per-device according to PCIe spec. Page request handling flow is:
> >>
> >> 1) iommu driver receives a page request from device
> >> 2) iommu driver parses the page request message. Get the RID,PASID, faulted
> >>    page and requested permissions etc.
> >> 3) iommu driver triggers fault handler registered by device driver with
> >>    iommu_report_device_fault()
> > 
> > This seems confused.
> > 
> > The PASID should define how to handle the page fault, not the driver.
> 
> In my series I don't use PASID at all. I am just enabling nested stage
> and the guest uses a single context. I don't allocate any user PASID at
> any point.
> 
> When there is a fault at physical level (a stage 1 fault that concerns
> the guest), this latter needs to be reported and injected into the
> guest. The vfio pci driver registers a fault handler to the iommu layer
> and in that fault handler it fills a circ bugger and triggers an eventfd
> that is listened to by the VFIO-PCI QEMU device. this latter retrives
> the faault from the mmapped circ buffer, it knowns which vIOMMU it is
> attached to, and passes the fault to the vIOMMU.
> Then the vIOMMU triggers and IRQ in the guest.
> 
> We are reusing the existing concepts from VFIO, region, IRQ to do that.
> 
> For that use case, would you also use /dev/ioasid?

/dev/ioasid could do all the things you described vfio-pci as doing,
it can even do them the same way you just described.

Stated another way, do you plan to duplicate all of this code someday
for vfio-cxl? What about for vfio-platform? ARM SMMU can be hooked to
platform devices, right?

I feel what you guys are struggling with is some choice in the iommu
kernel APIs that cause the events to be delivered to the pci_device
owner, not the PASID owner.

That feels solvable.

Jason
