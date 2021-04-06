From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 6 Apr 2021 09:34:51 -0300
Message-ID: <20210406123451.GN7405@nvidia.com>
References: <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <MWHPR11MB1886CF7C11ECE0396A0215078C769@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=487PkQf+U8PXv/fDH1TQwHED0SCO9RSfHacBURVdHls=;
 b=P6DL8N7G73UXtTIo1xlCjX0yg0o4XiKraNCwtOrC8t2oGt7bOuafqCR4T9PP1S+ZLSZjjh+KmonGGCEVjUDgSj3LPGsUcTBsXlOBNbegxzu6XT6ELX5rLht9UaUq9hwlwXon7RF9YSiJ7SGaJ7AlushzKV1XAKi4MsDsT7om3DmrGjbqpM0XO3TFg92beQ4llfTgvh5xCOZBAqVjR54yxCvGlNGGmhQtmpbi20J4LQpUMSrFHjY4xBb3vCErinSgJev871zsuCfHbfI0sGcXUvXwb753gjaG56jK4YUH6F2l73JU7u9o/mObS21i+8Li1WoGk2ckxaUY0Yb7eOOgSQ==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886CF7C11ECE0396A0215078C769@MWHPR11MB1886.namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, Alex Williamson <alex.williamson@redhat.com>, "Raj, Ashok" <ashok.raj@intel.com>, Jonathan Corbet <corbet@lwn.net>, Jean-Philippe Brucker <jean-philippe@linaro.com>, LKML <linux-kernel@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Wu, Hao" <hao.wu@intel.com>, David Woodhouse <dwmw2@infradead.org>, Jason Wang <jasowang@redhat.com>

On Tue, Apr 06, 2021 at 01:27:15AM +0000, Tian, Kevin wrote:
> 
> and here is one example why using existing VFIO/VDPA interface makes
> sense. say dev1 (w/ sva) and dev2 (w/o sva) are placed in a single VFIO 
> container. 

Forget about SVA, it is an irrelevant detail of how a PASID is
configured.

> The container is associated to an iommu domain which contains a
> single 2nd-level page table, shared by both devices (when attached
> to the domain).

This level should be described by an ioasid.

> The VFIO MAP operation is applied to the 2nd-level
> page table thus naturally applied to both devices. Then userspace
> could use /dev/ioasid to further allocate IOASIDs and bind multiple
> 1st-level page tables for dev1, nested on the shared 2nd-level page
> table.

Because if you don't then we enter insane world where a PASID is being
created under /dev/ioasid but its translation path flows through setup
done by VFIO and the whole user API becomes an incomprehensible mess.

How will you even associate the PASID with the other translation??

The entire translation path for any ioasid or PASID should be defined
only by /dev/ioasid. Everything else is a legacy API.

> If following your suggestion then VFIO must deny VFIO MAP operations
> on sva1 (assume userspace should not mix sva1 and sva2 in the same
> container and instead use /dev/ioasid to map for sva1)? 

No, userspace creates an iosaid for the guest physical mapping and
passes this ioasid to VFIO PCI which will assign it as the first layer
mapping on the RID

When PASIDs are allocated the uAPI will be told to logically nested
under the first ioasid. When VFIO authorizes a PASID for a RID it
checks that all the HW rules are being followed.

If there are rules like groups of VFIO devices must always use the
same IOASID then VFIO will check these too (and realistically qemu
will have only one guest physical map ioasid anyhow)

There is no real difference between setting up an IOMMU table for a
(RID,PASID) tuple or just a RID. We can do it universally with
one interface for all consumers.

I wanted this when we were doing VDPA for the first time, now that we
are doing pasid and more difficult stuff I view it as essential.

Jason
