From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 11 May 2021 21:25:15 -0300
Message-ID: <20210512002515.GR1002214@nvidia.com>
References: <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <MWHPR11MB1886E22D03B14EE0D5725CE08C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511143840.GL1002214@nvidia.com>
 <MWHPR11MB188601321993CA43E3058C4D8C539@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210511233950.GQ1002214@nvidia.com>
 <MWHPR11MB188623FB741481D489D259798C529@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMSZFvU8qZDP0H5FQuurn4Yqnfl6o3plyNnSza9qP28=;
 b=QYUQJVDQjOgzjQE97iWTIyLjP9gV7DrO3PzXBe6erXgf70P12NN+bgwkMqSOnBQx15je1R9fkBxqqk1YfC6Dv2lP3rrbvNQCGKlJfd+H/AYcGerv30ne3IQFQPnZyjQ87clQNKfV/IfLdItbpamhPJ9vaNcPfUTKV1jH+mUgzN6ferboYDepH0u+7fXs1StemW7jJMP10j175EGFIBL93/GesZNSQbK+ioMYgUsodx4Jdc89LU2O/MHN9raS7Rb5g1fbPUdHGdI/vbY4jO20afxJdafbDnzR/RbmtlC+Vnle+BGc9NT5k6TlZ7YYr1dPr6mUouqXFLZfaNp68pK8+Q==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB188623FB741481D489D259798C529@MWHPR11MB1886.namprd11.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, Li Zefan <lizefan@huawei.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>, Jonathan Corbet <corbet@lwn.net>, Jean-Philippe Brucker <jean-philippe@linaro.com>, LKML <linux-kernel@vger.kernel.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, Alex Williamson <alex.williamson@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "Wu, Hao" <hao.wu@intel.com>, David Woodhouse <dwmw2@infradead.org>

On Wed, May 12, 2021 at 12:21:24AM +0000, Tian, Kevin wrote:

> > Basically each RID knows based on its kernel drivers if it is a local
> > or global RID and the ioasid knob can further fine tune this for any
> > other specialty cases.
> 
> It's fine if you insist on this way. Then we leave it to userspace to
> ensure same split range is used across devices when vIOMMU is
> concerned. 

I'm still confused why there is a split range needed.

> Please note such range split has to be enforced through
> vIOMMU which (e.g. on VT-d) includes a register to report available
> PASID space size (applying to all devices behind this vIOMMU) to 
> the guest. The kernel just follows per-RID split info. If anything broken,
> the userspace just shoots its own foot.

Is it because this specific vIOMMU protocol is limiting things?

> > > > It does need some user visible difference because SIOV/mdev is not
> > > > migratable. Only the kernel can select a PASID, userspace (and hence
> > > > the guest) shouldn't have the option to force a specific PASID as the
> > > > PASID space is shared across the entire RID to all VMs using the mdev.
> > >
> > > not migratable only when you choose exposing host-allocated PASID
> > > into guest. However in the entire this proposal we actually virtualize
> > > PASIDs, letting the guest manage its own PASID space in all
> > > scenarios
> > 
> > PASID cannot be virtualized without also using ENQCMD.
> > 
> > A mdev that is using PASID without ENQCMD is non-migratable and this
> > needs to be make visiable in the uAPI.
> 
> No. without ENQCMD the PASID must be programmed to a mdev MMIO
> register. This operation is mediated then mdev driver can translate the
> PASID from virtual to real.

That is probably unworkable with real devices, but if you do this you
need to explicitly expose the vPASID to the mdev API somehow, and still
the device needs to declare if it supports this, and devices that
don't should still work in a non-migratable mode.

Jason
