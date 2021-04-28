From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 28 Apr 2021 09:06:25 -0600
Message-ID: <20210428090625.5a05dae8@redhat.com>
References: <20210421162307.GM1370958@nvidia.com>
        <20210421105451.56d3670a@redhat.com>
        <20210421175203.GN1370958@nvidia.com>
        <20210421133312.15307c44@redhat.com>
        <20210421230301.GP1370958@nvidia.com>
        <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210422121020.GT1370958@nvidia.com>
        <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210423114944.GF1370958@nvidia.com>
        <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210426123817.GQ1370958@nvidia.com>
        <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619622401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zftD9DhX6kilajc1JR4rVj986eWNpAry/j1BY289hak=;
        b=hgFD573rUh+oesLvdXbzGIy/8q6kPzFSpBuHxo+WSR9nQEfRCck1GW3T+CyF7fEZivn76B
        e7m+blkffwg9ZqGzr8q7tpTRBISxX0O4JBC4NSS/SgWOHNftzsDFTawcrP/f8SnihnAWgR
        mrlF2kcrPdXzuG4+oMvDrqVAF+yqcFE=
In-Reply-To: <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Auger Eric <eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>

On Wed, 28 Apr 2021 06:34:11 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, April 26, 2021 8:38 PM
> >   
> [...]
> > > Want to hear your opinion for one open here. There is no doubt that
> > > an ioasid represents a HW page table when the table is constructed by
> > > userspace and then linked to the IOMMU through the bind/unbind
> > > API. But I'm not very sure about whether an ioasid should represent
> > > the exact pgtable or the mapping metadata when the underlying
> > > pgtable is indirectly constructed through map/unmap API. VFIO does
> > > the latter way, which is why it allows multiple incompatible domains
> > > in a single container which all share the same mapping metadata.  
> > 
> > I think VFIO's map/unmap is way too complex and we know it has bad
> > performance problems.  
> 
> Can you or Alex elaborate where the complexity and performance problem
> locate in VFIO map/umap? We'd like to understand more detail and see how 
> to avoid it in the new interface.


The map/unmap interface is really only good for long lived mappings,
the overhead is too high for things like vIOMMU use cases or any case
where the mapping is intended to be dynamic.  Userspace drivers must
make use of a long lived buffer mapping in order to achieve performance.

The mapping and unmapping granularity has been a problem as well,
type1v1 allowed arbitrary unmaps to bisect the original mapping, with
the massive caveat that the caller relies on the return value of the
unmap to determine what was actually unmapped because the IOMMU use of
superpages is transparent to the caller.  This led to type1v2 that
simply restricts the user to avoid ever bisecting mappings.  That still
leaves us with problems for things like virtio-mem support where we
need to create initial mappings with a granularity that allows us to
later remove entries, which can prevent effective use of IOMMU
superpages.

Locked page accounting has been another constant issue.  We perform
locked page accounting at the container level, where each container
accounts independently.  A user may require multiple containers, the
containers may pin the same physical memory, but be accounted against
the user once per container.

Those are the main ones I can think of.  It is nice to have a simple
map/unmap interface, I'd hope that a new /dev/ioasid interface wouldn't
raise the barrier to entry too high, but the user needs to have the
ability to have more control of their mappings and locked page
accounting should probably be offloaded somewhere.  Thanks,

Alex

