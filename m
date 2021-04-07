From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 7 Apr 2021 16:36:54 -0300
Message-ID: <20210407193654.GG282464@nvidia.com>
References: <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <fa57bde5-472f-6e66-3521-bfac7d6e4f8d@redhat.com>
 <20210406124251.GO7405@nvidia.com>
 <MWHPR11MB1886A7E4C6F3E3A81240517B8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YG39ZtnTuyn5uBOa@myrica>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=euujbp5ifWbE/nYFGO+RbLm5+vvP3TSgbVZNDwFKczM=;
 b=THDHycEP+i9Xg0ob2ax4wnW29tB8MYSz8ME+Iz03t8lRsJi5fk1gIVnw11IiL0vii8NBFZa0agCwg2a0PVWQXxmHneNftOAPqyez3zATYiFaFiCdnrhcWLMmU8/s4Ric+v/dTd8NI6CxUQVWUz42QNkMwkA7S/xdlOcMywTOMy5+NMM4ymUNFx5xj3lvqrApRO0lIhAjHdBxk0IFRSWswrHIojxhogFThhT1uOWoYYJ29CaaebB87wKP4V3/sm9naEk8ZE14+oIbtCU2+zTzNuHaL0Xv60iFYuX7ASsrIrHuUaPlE1x9cphpiS29pMQgFe1cmsueOv10XDo1+oTymA==
Content-Disposition: inline
In-Reply-To: <YG39ZtnTuyn5uBOa@myrica>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Apr 07, 2021 at 08:43:50PM +0200, Jean-Philippe Brucker wrote:

> * Get a container handle out of /dev/ioasid (or /dev/iommu, really.)
>   No operation available since we don't know what the device and IOMMU
>   capabilities are.
>
> * Attach the handle to a VF. With VFIO that would be
>   VFIO_GROUP_SET_CONTAINER. That causes the kernel to associate an IOMMU
>   with the handle, and decide which operations are available.

Right, this is basically the point, - the VFIO container (/dev/vfio)
and the /dev/ioasid we are talking about have a core of
similarity. ioasid is the generalized, modernized, and cross-subsystem
version of the same idea. Instead of calling it "vfio container" we
call it something that evokes the idea of controlling the iommu.

The issue is to seperate /dev/vfio generic functionality from vfio and
share it with every subsystem.

It may be that /dev/vfio and /dev/ioasid end up sharing a lot of code,
with a different IOCTL interface around it. The vfio_iommu_driver_ops
is not particularly VFIOy.

Creating /dev/ioasid may primarily start as a code reorganization
exercise.

> * With a map/unmap vIOMMU (or shadow mappings), a single translation level
>   is supported. With a nesting vIOMMU, we're populating the level-2
>   translation (some day maybe by binding the KVM page tables, but
>   currently with map/unmap ioctl).
> 
>   Single-level translation needs single VF per container. 

Really? Why?

Jason
