From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 11 May 2021 20:39:50 -0300
Message-ID: <20210511233950.GQ1002214@nvidia.com>
References: <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder>
 <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <MWHPR11MB1886E22D03B14EE0D5725CE08C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511143840.GL1002214@nvidia.com>
 <MWHPR11MB188601321993CA43E3058C4D8C539@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yFf9oBiF+IfeQtTwhzHIGoSytVOO+uNqoNQSTPubAo=;
 b=ZXKiuUMn9Afmbx0SEf4DdoBUcgj6Uh+kqktECMqUFL8nDOYHAzXTdBlSsj4FSXztevfyA9lsw1qfkm5MUrld7mq1zdVzjo5gQoMijiBdgybCF1r2ynBID/wTRwrqqPk6GH6KJaxxZeN+EncreNh1xLdwyxXOERc2mmEHCpiPJdVCSNkIZKwv1ugTxCs3DHqG+dAf84b8JsbBhCkyHZck/rQb0YjOPCCGr9fpf/2Vvxe2uBQkVzrD6D/cp+h2s/J9XHuAhjRDisYkn4sKE5ztsgqX+FVx4WNt7rxz3dPU8Y8mMM8lHO/dStquRdZULbT/wk6PxTJiz5JEqSctLYvvCQ==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188601321993CA43E3058C4D8C539@MWHPR11MB1886.namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, Li Zefan <lizefan@huawei.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Jonathan Corbet <corbet@lwn.net>, Jean-Philippe Brucker <jean-philippe@linaro.com>, LKML <linux-kernel@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Alex Williamson <alex.williamson@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Wu, Hao" <hao.wu@intel.com>, David Woodhouse <dwmw2@infradead.org>

On Tue, May 11, 2021 at 10:51:40PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, May 11, 2021 10:39 PM
> > 
> > On Tue, May 11, 2021 at 09:10:03AM +0000, Tian, Kevin wrote:
> > 
> > > 3) SRIOV, ENQCMD (Intel):
> > > 	- "PASID global" with host-allocated PASIDs;
> > > 	- PASID table managed by host (in HPA space);
> > > 	- all RIDs bound to this ioasid_fd use the global pool;
> > > 	- however, exposing global PASID into guest breaks migration;
> > > 	- hybrid scheme: split local PASID range and global PASID range;
> > > 	- force guest to use only local PASID range (through vIOMMU);
> > > 	- for ENQCMD, configure CPU to translate local->global;
> > > 	- for non-ENQCMD, setup both local/global pasid entries;
> > > 	- uAPI for range split and CPU pasid mapping:
> > >
> > >     // set to "PASID global"
> > >     ioctl(ioasid_fd, IOASID_SET_HWID_MODE, IOASID_HWID_GLOBAL);
> > >
> > >     // split local/global range, applying to all RIDs in this fd
> > >     // Example: local [0, 1024), global [1024, max)
> > >     // local PASID range is managed by guest and migrated as VM state
> > >     // global PASIDs are re-allocated and mapped to local PASIDs post
> > migration
> > >     ioctl(ioasid_fd, IOASID_HWID_SET_GLOBAL_MIN, 1024);
> > 
> > I'm still not sold that ranges are the best idea here, it just adds
> > more state that has to match during migration. Keeping the
> > global/local split per RID seems much cleaner to me
> 
> With ENQCMD the PASID is kept in CPU MSR, making it a process
> context within the guest. When a guest process is bound to two
> devices, the same local PASID must be usable on both devices.
> Having per RID split cannot guarantee it.

That is only for ENQCMD. All drivers know if they are ENQCMD
compatible drivers and can ensure they use the global allocator
consistently for their RIDs.

Basically each RID knows based on its kernel drivers if it is a local
or global RID and the ioasid knob can further fine tune this for any
other specialty cases.

> > It does need some user visible difference because SIOV/mdev is not
> > migratable. Only the kernel can select a PASID, userspace (and hence
> > the guest) shouldn't have the option to force a specific PASID as the
> > PASID space is shared across the entire RID to all VMs using the mdev.
> 
> not migratable only when you choose exposing host-allocated PASID
> into guest. However in the entire this proposal we actually virtualize
> PASIDs, letting the guest manage its own PASID space in all
> scenarios

PASID cannot be virtualized without also using ENQCMD.

A mdev that is using PASID without ENQCMD is non-migratable and this
needs to be make visiable in the uAPI.

Jason
