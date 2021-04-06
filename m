From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 6 Apr 2021 09:21:17 -0300
Message-ID: <20210406122117.GM7405@nvidia.com>
References: <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401114648.GX1463678@nvidia.com>
 <BN6PR11MB406858FAC3821B84CCC4D30DC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401131533.GD1463678@nvidia.com>
 <BN6PR11MB4068C1A040FF61B4A9ABBD9BC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134641.GG1463678@nvidia.com>
 <MWHPR11MB1886C0804A0240998C110EE58C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405233946.GE7405@nvidia.com>
 <MWHPR11MB18863645C2C63A89BBA200B08C769@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/oT54Q4k4wleDks1dCIGA4AFa6WWiYAjS6/HnKe9XU=;
 b=UlybRfqMAQUqtRfJ8RvtUDKpILTok1S7P1oNfnaOVOkv8ZEpOhEvl46J0G9yZZ5gtS9SS4v9zIel+QWKY4z3w1WQiGNkQFK8mp96mws7hq0SCvdOoy7QVYaJDdoMZaa+w5or491C4plnyCFM4OexSt5L6TVJ/qd/X7l+X2tRTTr5Gd293+Go/fX2Gfg4mTTA0BqlpxQ9RgNzVVSC/V6FmmPPSRTqkE2RlQmMBstkzcFUsWCWmPQvxpHyLpHThzj/L4mLK7Opjit/A8haRyGtR8KsbbbUSo/Y+BvQEt+59unyVIktyrKv3QKLdb14zfIeB+gMrkNLAzXsB7ANsaIL3w==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18863645C2C63A89BBA200B08C769-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Apr 06, 2021 at 01:02:05AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Tuesday, April 6, 2021 7:40 AM
> > 
> > On Fri, Apr 02, 2021 at 07:58:02AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > Sent: Thursday, April 1, 2021 9:47 PM
> > > >
> > > > On Thu, Apr 01, 2021 at 01:43:36PM +0000, Liu, Yi L wrote:
> > > > > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > > > Sent: Thursday, April 1, 2021 9:16 PM
> > > > > >
> > > > > > On Thu, Apr 01, 2021 at 01:10:48PM +0000, Liu, Yi L wrote:
> > > > > > > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > > > > > Sent: Thursday, April 1, 2021 7:47 PM
> > > > > > > [...]
> > > > > > > > I'm worried Intel views the only use of PASID in a guest is with
> > > > > > > > ENQCMD, but that is not consistent with the industry. We need to
> > see
> > > > > > > > normal nested PASID support with assigned PCI VFs.
> > > > > > >
> > > > > > > I'm not quire flow here. Intel also allows PASID usage in guest
> > without
> > > > > > > ENQCMD. e.g. Passthru a PF to guest, and use PASID on it without
> > > > > > ENQCMD.
> > > > > >
> > > > > > Then you need all the parts, the hypervisor calls from the vIOMMU,
> > and
> > > > > > you can't really use a vPASID.
> > > > >
> > > > > This is a diagram shows the vSVA setup.
> > > >
> > > > I'm not talking only about vSVA. Generic PASID support with arbitary
> > > > mappings.
> > > >
> > > > And how do you deal with the vPASID vs pPASID issue if the system has
> > > > a mix of physical devices and mdevs?
> > > >
> > >
> > > We plan to support two schemes. One is vPASID identity-mapped to
> > > pPASID then the mixed scenario just works, with the limitation of
> > > lacking of live migration support. The other is non-identity-mapped
> > > scheme, where live migration is supported but physical devices and
> > > mdevs should not be mixed in one VM if both expose SVA capability
> > > (requires some filtering check in Qemu).
> > 
> > That just becomes "block vPASID support if any device that
> > doesn't use ENQCMD is plugged into the guest"
> 
> The limitation is only for physical device. and in reality it is not that
> bad. To support live migration with physical device we anyway need 
> additional work to migrate the device state (e.g. based on Max's work), 
> then it's not unreasonable to also mediate guest programming of 
> device specific PASID register to enable vPASID (need to translate in
> the whole VM lifespan but likely is not a hot path).

IMHO that is pretty unreasonable.. More likely we end up with vPASID
tables in each migratable device like KVM has.

> > Which needs a special VFIO capability of some kind so qemu knows to
> > block it. This really needs to all be layed out together so someone
> > can understand it :(
> 
> Or could simply based on whether the VFIO device supports live migration.

You need to define affirmative caps that indicate that vPASID will be
supported by the VFIO device.

> > Why doesn't the siov cookbook explaining this stuff??
> > 
> > > We hope the /dev/ioasid can support both schemes, with the minimal
> > > requirement of allowing userspace to tag a vPASID to a pPASID and
> > > allowing mdev to translate vPASID into pPASID, i.e. not assuming that
> > > the guest will always use pPASID.
> > 
> > What I'm a unclear of is if /dev/ioasid even needs to care about
> > vPASID or if vPASID is just a hidden artifact of the KVM connection to
> > setup the translation table and the vIOMMU driver in qemu.
> 
> Not just for KVM. Also required by mdev, which needs to translate
> vPASID into pPASID when ENQCMD is not used.

Do we have any mdev's that will do this?

> should only care about the operations related to pPASID. VFIO could
> carry vPASID information to mdev.

It depends how common this is, I suppose

Jason
