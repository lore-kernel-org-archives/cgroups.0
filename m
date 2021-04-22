From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 22 Apr 2021 17:00:24 -0300
Message-ID: <20210422200024.GC1370958@nvidia.com>
References: <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpI3uhw2idxvllqb0b1WkVBppdZyY4wvA+Jrv6UhY1U=;
 b=fKgcVqCdyqCpiValgGc/Jaq/WZeBPs1zcFx93cdDLFGYCtcuycqa95glEgHfAMjhxBAZs1EkLxudXjiqubXQviyOBOV8iEnWXdfdRpxYhxu7xDqC8Uljw24myqlEev7sOC0eQvG2opzXLC6ytQbaTgsD0bfUWyZYB8OTpG31wLQ9MNeUIDLFNJ63audeTyzslprl8eO8mKYRtKXbFsoyZmvNZs+YdXm8VC4fKOAznB6TEs3KaavATQuqORpKv/zNmr7Ip//aLEcjB0IPUUWv2TxVPr5t4msGDnb/643q91KZ7ZQIvpXqPdx8WIWMwIXD5KmKgN3dJZ6X1mbyO0zfOQ==
Content-Disposition: inline
In-Reply-To: <20210422133747.23322269@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Auger Eric <eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, "Tian, Kevin" <kevin.tian@intel.com>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, David

On Thu, Apr 22, 2021 at 01:37:47PM -0600, Alex Williamson wrote:

> If by "classic" you mean conventional PCI bus, then this is much worse
> than simply "at risk".  The IOMMU cannot differentiate devices behind a
> PCIe-to-PCI bridge, so the moment you turn on the IOMMU context for the
> NIC, the address space for your HBA is pulled out from under it.  

Yes, I understand this, but this is fine and not really surprising if
the HD device is just forced to remain "unusued"

To my mind the bigger issue is the NIC now has access to the HD and
nobody really raised an alarm unless the HD happened to have a kernel
driver bound.

> the vfio world, the NIC and HBA are grouped and managed together, the
> user cannot change the IOMMU context of a group unless all of the
> devices in the group are "viable", ie. they are released from any host
> drivers.

Yes, I don't propose to change any of that, I just suggest to make the
'change the IOMMU context" into "join a /dev/ioasid fd"

All devices in the group have to be joined to the same ioasid or, with
the flag, left "unused" with no kernel driver. 

This is the same viability test VFIO is doing now, just moved slightly
in the programming flow.

> vfio users are extremely aware of grouping, they understand the model,
> if not always the reason for the grouping.  You only need to look at
> r/VFIO to find various lsgroup scripts and kernel patches to manipulate
> grouping.  The visibility to the user is valuable imo.

I don't propose to remove visibility, sysfs and the lsgroup scripts
should all still be there.

I'm just acknowledging reality that the user command line experiance
we have is focused on single BDFs not on groups. The user only sees
the group idea when things explode, so why do we have it as such an
integral part of the programming model?

> >    ioctl(vifo_device_fd, JOIN_IOASID_FD, ioasifd)
> >    [..]
> >    ioctl(vfio_device, ATTACH_IOASID, gpa_ioasid_id) == ENOPERM
> > 
> > I would feel comfortable if the ATTACH_IOASID fails by default if all
> > devices in the group have not been joined to the same ioasidfd.
> 
> And without a group representation to userspace, how would a user know
> to resolve that?

Userspace can continue to read sysfs files that show the group
relation.

I'm only talking about the group char device and FD.

> So the group still exist in sysfs, they just don't have vfio
> representations?  An implicit grouping does what, automatically unbind
> the devices, so an admin gives a user access to the NIC but their HBA
> device disappears because they were implicitly linked?  

It does exactly the same thing as opening the VFIO group FD and
instantiating a single device FD does today.

Most software, like dpdk, automatically deduces the VFIO group from
the commandline BDF, I'm mainly suggesting we move that deduction from
userspace software to kernel software.

> basis ownership on the group, if a user owns the group but the group is
> not viable because a device is still bound to another kernel driver,
> the use can't do anything.  Implicitly snarfing up subtly affected
> devices is bad.

The user would get an /dev/ioasid join failure just like they get a
failure from VFIO_GROUP_SET_CONTAINER (?) today that reflects the
group is not viable.

Otherwise what is the alternative?

How do we model the VFIO group security concept to something like
VDPA?

How do you reconcile the ioasid security model with the VFIO container
and group FDs?

Jason
