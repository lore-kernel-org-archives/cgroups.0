From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 6 Apr 2021 09:15:46 -0300
Message-ID: <20210406121546.GL7405@nvidia.com>
References: <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <MWHPR11MB18866AB35A13A139262347FD8C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405233526.GD7405@nvidia.com>
 <MWHPR11MB18862BF4EA4DC0CFDE6CD2238C769@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAyWTpAGiBmIhJeujMEDNxR36LohagizGI7BWUhzgCo=;
 b=qIlL15XsQ02PtaeaYyl+7oAuoH8i6ae1nr+6e25M6efcJHloboiqE7XKI5lVX+zAVFYtkrlCcD/NJXseo84obNTzS3sgR7EVEKXO5y7O3tCVnV2F7KCRTR61/QgIGoxExqKu91OasfecrniCDqhXzZ6lAuOLNr89jxpZ0OEIcDg1gOjjVlCb35zp7ic+u2mvaj5z0Hy/fqtFqw4VF4apSCQG2AL02JxsTcYnfMRzCmiC3I1sgvoaBbaP0EFa9ngG3fMQuwHQhAcp6OKCqdDXQT8U5O+z7wuWFFr2O7xLpp2/C2bP64HwDBDD19JbqYOSaYOQjI7WyWQlQHK4SBFS6A==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18862BF4EA4DC0CFDE6CD2238C769-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Apr 06, 2021 at 12:37:35AM +0000, Tian, Kevin wrote:

> With nested translation it is GVA->GPA->HPA. The kernel needs to
> fix fault related to GPA->HPA (managed by VFIO/VDPA) while 
> handle_mm_fault only handles HVA->HPA. In this case, the 2nd-level
> page fault is expected to be delivered to VFIO/VDPA first which then
> find HVA related to GPA, call handle_mm_fault to fix HVA->HPA,
> and then call iommu_map to fix GPA->HPA in the IOMMU page table.
> This is exactly like how CPU EPT violation is handled.

No, it should all be in the /dev/ioasid layer not duplicated into
every user.

> > If the fault needs to be fixed in the guest, then it needs to be
> > delivered over /dev/ioasid in some way and injected into the
> > vIOMMU. VFIO and VDPA have nothing to do with vIOMMU driver in quemu.
> > 
> > You need to have an interface under /dev/ioasid to create both page
> > table levels and part of that will be to tell the kernel what VA is
> > mapped and how to handle faults.
> 
> VFIO/VDPA already have their own interface to manage GPA->HPA
> mappings. Why do we want to duplicate it in /dev/ioasid? 

They have their own interface to manage other types of HW, we should
not duplicate PASID programming into there too.

Jason
