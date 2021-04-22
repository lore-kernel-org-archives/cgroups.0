From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 22 Apr 2021 09:10:20 -0300
Message-ID: <20210422121020.GT1370958@nvidia.com>
References: <20210415230732.GG1370958@nvidia.com>
 <20210416061258.325e762e@jacob-builder>
 <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeZlekQPQn37lMdede0eVSjq/MRzoRbjxrpbSDohj7s=;
 b=lraMJk8/2sgD9Vt3FhmJKC3pKQyeqZiFR/iPJ/XBvtK8kU7uwDo8ncLi3QKGrKaEz8vNCUTbPZ/fI+C1qpaobJ0i22ZqnD1gdyRtspKRYNw4bYuiLhw+roZSAjpQZ/9JkkAJR51RLdH4iRYW7tETi99Q5BRVn0u4oFCv7gQlxX2SCnr49auoITokGfkj5EtTri/tCYTlBqTfZotLFWN5lQrEOv+uI6KIgVBVxc+kMeE/jCGr6E2qj47jDQHr3rBwlr5nIQqG9nPtNScKTn9TdlZqqtzkrIH6vY3Zvjc35qPBF9CbHBCL272fFQ0psU7cancn2blPW4OcmrTaFIYrPw==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Auger Eric <eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>

On Thu, Apr 22, 2021 at 08:34:32AM +0000, Tian, Kevin wrote:

> The shim layer could be considered as a new iommu backend in VFIO,
> which connects VFIO iommu ops to the internal helpers in
> drivers/ioasid.

It may be the best we can do because of SPAPR, but the ideal outcome
should be to remove the entire pluggable IOMMU stuff from vfio
entirely and have it only use /dev/ioasid

We should never add another pluggable IOMMU type to vfio - everything
should be done through drives/iommu now that it is much more capable.

> Another tricky thing is that a container may be linked to multiple iommu
> domains in VFIO, as devices in the container may locate behind different
> IOMMUs with inconsistent capability (commit 1ef3e2bc). 

Frankly this sounds over complicated. I would think /dev/ioasid should
select the IOMMU when the first device is joined, and all future joins
must be compatible with the original IOMMU - ie there is only one set
of IOMMU capabilities in a /dev/ioasid.

This means qemue might have multiple /dev/ioasid's if the system has
multiple incompatible IOMMUs (is this actually a thing?) The platform
should design its IOMMU domains to minimize the number of
/dev/ioasid's required.

Is there a reason we need to share IOASID'd between completely
divergance IOMMU implementations? I don't expect the HW should be able
to physically share page tables??

That decision point alone might be the thing that just says we can't
ever have /dev/vfio/vfio == /dev/ioasid

> Just to confirm. Above flow is for current map/unmap flavor as what
> VFIO/vDPA do today. Later when nested translation is supported,
> there is no need to detach gpa_ioasid_fd. Instead, a new cmd will
> be introduced to nest rid_ioasid_fd on top of gpa_ioasid_fd:

Sure.. The tricky bit will be to define both of the common nested
operating modes.

  nested_ioasid = ioctl(ioasid_fd, CREATE_NESTED_IOASID,  gpa_ioasid_id);
  ioctl(ioasid_fd, SET_NESTED_IOASID_PAGE_TABLES, nested_ioasid, ..)

   // IOMMU will match on the device RID, no PASID:
  ioctl(vfio_device, ATTACH_IOASID, nested_ioasid);

   // IOMMU will match on the device RID and PASID:
  ioctl(vfio_device, ATTACH_IOASID_PASID, pasid, nested_ioasid);

Notice that ATTACH (or bind, whatever) is always done on the
vfio_device FD. ATTACH tells the IOMMU HW to link the PCI BDF&PASID to
a specific page table defined by an IOASID.

I expect we have many flavours of IOASID tables, eg we have normal,
and 'nested with table controlled by hypervisor'. ARM has 'nested with
table controlled by guest' right? So like this?

  nested_ioasid = ioctl(ioasid_fd, CREATE_DELGATED_IOASID,
                   gpa_ioasid_id, <some kind of viommu_id>)
  // PASID now goes to <viommu_id>
  ioctl(vfio_device, ATTACH_IOASID_PASID, pasid, nested_ioasid);

Where <viommu_id> is some internal to the guest handle of the viommu
page table scoped within gpa_ioasid_id? Like maybe it is GPA of the
base of the page table?

The guest can't select its own PASIDs without telling the hypervisor,
right?

> I also feel hiding group from uAPI is a good thing and is interested in
> the rationale behind for explicitly managing group in vfio (which is
> essentially the same boundary as provided by iommu group), e.g. for 
> better user experience when group security is broken? 

Indeed, I can see how things might have just evolved into this, but if
it has a purpose it seems pretty hidden.
we need it or not seems pretty hidden.

Jason
