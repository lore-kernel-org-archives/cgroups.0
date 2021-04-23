From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 23 Apr 2021 08:49:44 -0300
Message-ID: <20210423114944.GF1370958@nvidia.com>
References: <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yjqj8DFTUQYaP+5cPIjgpWdEnqBxZ3mnBWfTOtXUvNw=;
 b=baPgaxSLOnl16tLJs1ZJCsGnEbqts+n7rWFKZiE/LlYRWFEcRcse0qjr55aaqxgdXs9WmH+BrY8PJjgi5go/eIhOGemIsvTOZCrX2Tht+bWJHvHUeh++W9i/hA2AVdeGIyCcEHTpw4nLaQ3Ayxf/0mQfLlALKrcdJmwAantzD7IBYhjExQyWTZaatZST4egXuHH4hzZD/J1AvwtV+s6/BVodsg7uYmKUtvAU8wPne7phLYTec7f395/FA90yJ7TQzfCDgrMZSVbFJgN0HNyI6/x1+MGsz04jQqZxGecB/qf8c6B+/pSkgEj/KlvA5+edHKdwypkeDOr4qqx5E5gE6A==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Auger Eric <eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>

On Fri, Apr 23, 2021 at 09:06:44AM +0000, Tian, Kevin wrote:

> Or could we still have just one /dev/ioasid but allow userspace to create
> multiple gpa_ioasid_id's each associated to a different iommu domain? 
> Then the compatibility check will be done at ATTACH_IOASID instead of 
> JOIN_IOASID_FD.

To my mind what makes sense that that /dev/ioasid presents a single
IOMMU behavior that is basically the same. This may ultimately not be
what we call a domain today.

We may end up with a middle object which is a group of domains that
all have the same capabilities, and we define capabilities in a way
that most platforms have a single group of domains.

The key capability of a group of domains is they can all share the HW
page table representation, so if an IOASID instantiates a page table
it can be assigned to any device on any domain in the gruop of domains.

If you try to say that /dev/ioasid has many domains and they can't
have their HW page tables shared then I think the implementation
complexity will explode.

> This does impose one burden to userspace though, to understand the 
> IOMMU compatibilities and figure out which incompatible features may
> affect the page table management (while such knowledge is IOMMU
> vendor specific) and then explicitly manage multiple /dev/ioasid's or 
> multiple gpa_ioasid_id's.

Right, this seems very hard in the general case..
 
> Alternatively is it a good design by having the kernel return error at
> attach/join time to indicate that incompatibility is detected then the 
> userspace should open a new /dev/ioasid or creates a new gpa_ioasid_id
> for the failing device upon such failure, w/o constructing its own 
> compatibility knowledge?

Yes, this feels workable too

> > This means qemue might have multiple /dev/ioasid's if the system has
> > multiple incompatible IOMMUs (is this actually a thing?) The platform
> 
> One example is Intel platform with igd. Typically there is one IOMMU
> dedicated for igd and the other IOMMU serving all the remaining devices.
> The igd IOMMU may not support IOMMU_CACHE while the other one
> does.

If we can do as above the two domains may be in the same group of
domains and the IOMMU_CACHE is not exposed at the /dev/ioasid level.

For instance the API could specifiy IOMMU_CACHE during attach, not
during IOASID creation.

Getting all the data model right in the API is going to be trickiest
part of this.

> yes, e.g. in vSVA both devices (behind divergence IOMMUs) are bound
> to a single guest process which has an unique PASID and 1st-level page
> table. Earlier incompatibility example is only for 2nd-level.

Because when we get to here, things become inscrutable as an API if
you are trying to say two different IOMMU presentations can actually
be nested.

> > Sure.. The tricky bit will be to define both of the common nested
> > operating modes.
> > 
> >   nested_ioasid = ioctl(ioasid_fd, CREATE_NESTED_IOASID,  gpa_ioasid_id);
> >   ioctl(ioasid_fd, SET_NESTED_IOASID_PAGE_TABLES, nested_ioasid, ..)
> > 
> >    // IOMMU will match on the device RID, no PASID:
> >   ioctl(vfio_device, ATTACH_IOASID, nested_ioasid);
> > 
> >    // IOMMU will match on the device RID and PASID:
> >   ioctl(vfio_device, ATTACH_IOASID_PASID, pasid, nested_ioasid);
> 
> I'm a bit confused here why we have both pasid and ioasid notations together.
> Why not use nested_ioasid as pasid directly (i.e. every pasid in nested mode
> is created by CREATE_NESTED_IOASID)?

The IOASID is not a PASID, it is just a page table.

A generic IOMMU matches on either RID or (RID,PASID), so you should
specify the PASID when establishing the match.

IOASID only specifies the page table.

So you read the above as configuring the path

  PCI_DEVICE -> (RID,PASID) -> nested_ioasid -> gpa_ioasid_id -> physical

Where (RID,PASID) indicate values taken from the PCI packet.

In principle the IOMMU could also be commanded to reuse the same
ioasid page table with a different PASID:

  PCI_DEVICE_B -> (RID_B,PASID_B) -> nested_ioasid -> gpa_ioasid_id -> physical

This is impossible if the ioasid == PASID in the API.

> Below I list different scenarios for ATTACH_IOASID in my view. Here 
> vfio_device could be a real PCI function (RID), or a subfunction device 
> (RID+def_ioasid). 

What is RID+def_ioasid? The IOMMU does not match on IOASID's.

A subfunction device always need to use PASID, or an internal IOMMU,
confused what you are trying to explain?

> If the whole PASID table is delegated to the guest in ARM case, the guest
> can select its own PASIDs w/o telling the hypervisor. 

The hypervisor has to route the PASID's to the guest at some point - a
guest can't just claim a PASID unilaterally, that would not be secure.

If it is not done with per-PASID hypercalls then the hypervisor has to
route all PASID's for a RID to the guest and /dev/ioasid needs to have
a nested IOASID object that represents this connection - ie it points
to the PASID table of the guest vIOMMU or something.

Remember this all has to be compatible with mdev's too and without
hypercalls to create PASIDs that will be hard: mdev sharing a RID and
slicing the physical PASIDs can't support a 'send all PASIDs to the
guest' model, or even a 'the guest gets to pick the PASID' option.

Jason
