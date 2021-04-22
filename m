From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 22 Apr 2021 14:57:15 -0300
Message-ID: <20210422175715.GA1370958@nvidia.com>
References: <20210415230732.GG1370958@nvidia.com>
 <20210416061258.325e762e@jacob-builder>
 <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yb1aRpNEsh8C/J64KYqsXeSiReMbtJNViHW3mYjyygQ=;
 b=Hf8tfLudgLcsinkKlb2RmSryevjB4O07IP8SYh3GGlHqI+u9sUSVyTRX5MvhLD4LbWggSyyBu1gWU4UY8EaClbJqbwbLbAsC1ibhsnpGE28n0AgLNhTWePJ6FLZx4WCjmTnRmBjCfWvRr7VwpWOKUIZ0OHrQyI2FT8sr6eoaOfmpdcB3ClvTWziSmqRsPiYz3tdK3jfOuv1oPb1O+uE/N8HNkd9hAuW3c0GOOD7m8QwO0ZRzu0Za5MfyHw7uc3re3FB2qqU2izQGn0BUxj8EkoVkKzd8bSkR3hhqYy/0K5ueh39SiSYm4Qv+X5clh5bvWI/V8hiTNfRpla2DdrLy1g==
Content-Disposition: inline
In-Reply-To: <20210422111337.6ac3624d@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Auger Eric <eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, "Tian, Kevin" <kevin.tian@intel.com>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, David

On Thu, Apr 22, 2021 at 11:13:37AM -0600, Alex Williamson wrote:
> I'm suggesting that if we're replacing the container/group model with
> an ioasid then we're effectively creating a new thing that really only
> retains the vfio device uapi.

Yes, I think that is a fair assessment, but not necessarily bad.

The VFIO device uAPI is really the thing that is unique to VFIO and
cannot be re-used anyplace else, in my assesment this is what vfio
*is*, and the series I've been working on make it more obvious how
broad that statement really is.

> > In any event, it does look like today we'd expect the SPAPR stuff
> > would be done through the normal iommu APIs, perhaps enhanced a bit,
> > which makes me suspect an enhanced type1 can implement SPAPR.
> 
> David Gibson has argued for some time that SPAPR could be handled via a
> converged type1 model.  We has mapped that out at one point,
> essentially a "type2", but neither of us had any bandwidth to pursue it.

Cool! Well, let's put a pin in it, I don't think revising SPAPR should
be a pre-condition for anything here - but we can all agree than an
ideal world would be able to access SPAPR functionality from
devices/iommu and /dev/ioasid

And it would be nice to map this out enough to provide enough
preperation in the new /dev/ioasid uAPI. For instance I saw the only
SPAPR specific stuff in DPDK was to preset the IOVA range that the
IOASID would support. This would be trivial to add and may have
benifits to other IOMMUS by reducing the number of translation levels
or somethign.
 
> Right, but I don't see that implies it cannot work within the vfio
> IOMMU model.  Currently when an IOMMU is set, the /dev/vfio/vfio
> container becomes a conduit for file ops from the container to be
> forwarded to the IOMMU.  But that's in part because the user doesn't
> have another object to interact with the IOMMU.  It's entirely possible
> that with an ioasid shim, the user would continue to interact directly
> with the /dev/ioasid fd for IOMMU manipulation and only use
> VFIO_SET_IOMMU to associate a vfio container to that ioasid.

I am looking at this in two directions, the first is if we have
/dev/ioasid how do we connect it to VFIO? And here I aruge we need new
device IOCTLs and ideally a VFIO world that does not have a vestigial
container FD at all.

This is because /dev/ioasid will have to be multi-IOASID and it just
does not fit well into the VFIO IOMMU pluggable model at all - or at
least trying to make it fit will defeat the point of having it in the
first place.

This does not seem to be a big deal - the required device IOCTLs
should be small and having two code paths isn't going to be an
exploding complexity.

The second direction is how do we keep /dev/vfio/vfio entire uAPI
without duplicating a lot of code. There is where building a ioasid
back end or making ioasid == vfio are areas to look at.

> vfio really just wants to be able to attach groups to an address space
> to consider them isolated, everything else about the IOMMU API could
> happen via a new ioasid file descriptor representing that context, ie.
> vfio handles the group ownership and device access, ioasid handles the
> actual mappings.

Right, exactly.
 
> > Do we have container because the /dev/vfio/vfio can hold only a single
> > page table so we need to swap containers sometimes?
> 
> The container represents an IOMMU address space, which can be shared by
> multiple groups, where each group may contain one or more devices.
> Swapping a container would require releasing all the devices (the user
> cannot have access to a non-isolated device), then a group could be
> moved from one container to another.

So, basically, the answer is yes.

Having the container FD hold a single IOASID forced the group FD to
exist because we can't maintain the security object of a group in the
container FD if the work flow is to swap the container FD.

Here what I suggest is to merge the group security and the multiple
"IOMMU address space" concept into one FD. The /dev/ioasid would have
multiple page tables objects within it called IOASID'd and each IOASID
effectively represents what /dev/vfio/vfio does today.

We can assign any device joined to a /dev/ioasid FD to any IOASID inside
that FD, dynamically.

> > The security rule for isolation is that once a device is attached to a
> > /dev/ioasid fd then all other devices in that security group must be
> > attached to the same ioasid FD or left unused.
> 
> Sounds like a group...  Note also that if those other devices are not
> isolated from the user's device, the user could manipulate "unused"
> devices via DMA.  So even unused devices should be within the same
> IOMMU context... thus attaching groups to IOMMU domains.

That is a very interesting point. So, say, in the classic PCI bus
world if I have a NIC and HD on my PCI bus and both are in the group,
I assign the NIC to a /dev/ioasid & VFIO then it is possible to use
the NIC to access the HD via DMA

And here you want a more explicit statement that the HD is at risk by
using the NIC?

Honestly, I'm not sure the current group FD is actually showing that
very strongly - though I get the point it is modeled in the sysfs and
kind of implicit in the API - we evolved things in a way where most
actual applications are taking in a PCI BDF from the user, not a group
reference. So the actual security impact seems lost on the user.

Along my sketch if we have:

   ioctl(vifo_device_fd, JOIN_IOASID_FD, ioasifd)
   [..]
   ioctl(vfio_device, ATTACH_IOASID, gpa_ioasid_id) == ENOPERM

I would feel comfortable if the ATTACH_IOASID fails by default if all
devices in the group have not been joined to the same ioasidfd.

So in the NIC&HD example the application would need to do:

   ioasid_fd = open("/dev/ioasid");
   nic_device_fd = open("/dev/vfio/device0")
   hd_device_fd = open("/dev/vfio/device1")
   
   ioctl(nic_device_fd, JOIN_IOASID_FD, ioasifd)
   ioctl(hd_device_fd, JOIN_IOASID_FD, ioasifd)
   [..]
   ioctl(nice_device, ATTACH_IOASID, gpa_ioasid_id) == SUCCESS

Now the security relation is forced by the kernel to be very explicit.

However to keep current semantics, I'd suggest a flag on
JOIN_IOASID_FD called "IOASID_IMPLICIT_GROUP" which has the effect of
allowing the ATTACH_IOASID to succeed without the user having to
explicitly join all the group devices. This is analogous to the world
we have today of opening the VFIO group FD but only instantiating one
device FD.

In effect the ioasid FD becomes the group and the numbered IOASID's
inside the FD become the /dev/vfio/vfio objects - we don't end up with
fewer objects in the system, they just have different uAPI
presentations.

I'd envision applications like DPDK that are BDF centric to use the
first API with some '--allow-insecure-vfio' flag to switch on the
IOASID_IMPLICIT_GROUP. Maybe good applications would also print:
  "Danger Will Robinson these PCI BDFs [...] are also at risk"
When the switch is used by parsing the sysfs

> > Thus /dev/ioasid also becomes the unit of security and the IOMMU
> > subsystem level becomes aware of and enforces the group security
> > rules. Userspace does not need to "see" the group
> 
> What tools does userspace have to understand isolation of individual
> devices without groups?

I think we can continue to show all of this group information in sysfs
files, it just doesn't require application code to open a group FD.

This becomes relavent the more I think about it - elmininating the
group and container FD uAPI by directly creating the device FD also
sidesteps questions about how to model these objects in a /dev/ioasid
only world. We simply don't have them at all so the answer is pretty
easy.

Jason
