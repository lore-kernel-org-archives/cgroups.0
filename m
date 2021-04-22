From: Liu Yi L <yi.l.liu@linux.intel.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 22 Apr 2021 20:55:05 +0800
Message-ID: <20210422205505.75f086f8@yiliu-dev>
References: <20210401134236.GF1463678@nvidia.com>
        <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
        <20210401160337.GJ1463678@nvidia.com>
        <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
        <20210415230732.GG1370958@nvidia.com>
        <20210416061258.325e762e@jacob-builder>
        <20210416094547.1774e1a3@redhat.com>
        <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
        <20210421162307.GM1370958@nvidia.com>
        <20210421105451.56d3670a@redhat.com>
        <20210421175203.GN1370958@nvidia.com>
        <20210421133312.15307c44@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20210421133312.15307c44@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alex Williamson <alex.williamson@redhat.com>
Cc: yi.l.liu@intel.com, Jason Gunthorpe <jgg@nvidia.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, "Tian, Kevin" <kevin.tian@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Jonathan Corbet <corbet@lwn.net>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Wu, Hao" <hao.wu@intel.com>, David Woodhouse <dwmw2@infradead.org>

On Wed, 21 Apr 2021 13:33:12 -0600, Alex Williamson wrote:

> On Wed, 21 Apr 2021 14:52:03 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Apr 21, 2021 at 10:54:51AM -0600, Alex Williamson wrote:
> >   
> > > That's essentially replacing vfio-core, where I think we're more    
> > 
> > I am only talking about /dev/vfio here which is basically the IOMMU
> > interface part.
> > 
> > I still expect that VFIO_GROUP_SET_CONTAINER will be used to connect
> > /dev/{ioasid,vfio} to the VFIO group and all the group and device
> > logic stays inside VFIO.  
> 
> But that group and device logic is also tied to the container, where
> the IOMMU backend is the interchangeable thing that provides the IOMMU
> manipulation for that container.  If you're using
> VFIO_GROUP_SET_CONTAINER to associate a group to a /dev/ioasid, then
> you're really either taking that group outside of vfio or you're
> re-implementing group management in /dev/ioasid.  I'd expect the
> transition point at VFIO_SET_IOMMU.

per my understanding, transiting at the VFIO_SET_IOMMU point makes more
sense as VFIO can still have the group and device logic, which is the key
concept of group granularity isolation for userspace direct access.

-- 
Regards,
Yi Liu
