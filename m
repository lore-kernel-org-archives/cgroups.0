From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 31 Mar 2021 14:31:48 -0300
Message-ID: <20210331173148.GN1463678@nvidia.com>
References: <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <20210329155526.2ad791a9@jacob-builder>
 <20210330134313.GP2356281@nvidia.com>
 <20210330171041.70f2d7d0@jacob-builder>
 <20210331122805.GC1463678@nvidia.com>
 <20210331093457.753512d4@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvuoyXnpUpGAsZ/jLIeEpJ+ywWHGEHmghfuuM3cvyZk=;
 b=i/jGObYyQhbJacVe+Jk1gx+MRTM/7lymrearON1zC8J2WvXGeYetmY62dZeDrW5eFWODcsMvrWsKi9q+LDotPxe4u/hmg6pzEWiWRWHc5hqPV0IaYNRldqTezjctiSQekDJ7dZIvFYr36iLVrT1KNn0oFNWyBK6p7dpIr89UEnApPObuNNIogbqSMqwW19lk5w6ZrDQRB88GJKoQwK9+FXDxgwLN8d6PM96sqqd0Z73fYfSolITryRHhs+PXXZpqjvz0TBYoFtUv6qrnpwMZQf0ufUPAWQHU6N9wPdeHTkjCtRnJgsfyoWZ8JZ8i1qzG/o1wvXyojzstDYoGTTGNSA==
Content-Disposition: inline
In-Reply-To: <20210331093457.753512d4@jacob-builder>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Mar 31, 2021 at 09:34:57AM -0700, Jacob Pan wrote:

> "3.3 PASID translation
> To support PASID isolation for Shared Work Queues used by VMs, the CPU must
> provide a way for the PASID to be communicated to the device in the DMWr
> transaction. On Intel CPUs, the CPU provides a PASID translation table in
> the vCPUs virtual machine control structures. During ENQCMD/ENQCMDS
> instruction execution in a VM, the PASID translation table is used by the
> CPU to replace the guest PASID in the work descriptor with a host PASID
> before the descriptor is sent to the device.3.3 PASID translation"

Yikes, a special ENQCMD table in the hypervisor!

Still, pass the /dev/ioasid into a KVM IOCTL and tell it to populate
this table. KVM only adds to the table when userspace presents a
/dev/ioasid FD.

> > Doesn't work submission go either to the mdev driver or through the
> > secure PASID of #1?
> 
> No, once a PASID is bound with IOMMU, KVM, and the mdev, work
> submission is all done in HW.  But I don't think this will change
> for either uAPI design.

The big note here is "only for things that use ENQCMD" and that is
basically nothing these days.

> > Everything should revolve around the /dev/ioasid FD. qemu should pass
> > it to all places that need to know about PASID's in the VM.
> 
> I guess we need to extend KVM interface to support PASIDs. Our original
> intention was to avoid introducing new interfaces.

New features need new interfaces, especially if there is a security
sensitivity! KVM should *not* automatically opt into security
sensitive stuff without being explicitly told what to do.

Here you'd need to authorized *two* things for IDXD:
 - The mdev needs to be told it is allowed to use PASID, this tells
   the IOMMU driver to connect the pci device under the mdev
 - KVM needs to be told to populate a vPASID to the 'ENQCMD'
   security table translated to a physical PASID.

If qemu doesn't explicitly enable the ENQCMD security table it should
be *left disabled* by KVM - even if someone else is using PASID in the
same process. And the API should be narrow like this just to the
EQNCMD table as who knows what will come down the road, or how it will
work.

Having a PASID wrongly leak out into the VM would be a security
disaster. Be explicit.

> > We should try to avoid hidden behind the scenes kernel
> > interconnections between subsystems.
> > 
> Can we? in case of exception. Since all these IOCTLs are coming from the
> unreliable user space, we must deal all exceptions.
>
> For example, when user closes /dev/ioasid FD before (or w/o) unbind IOCTL
> for VFIO, KVM, kernel must do cleanup and coordinate among subsystems.
> In this patchset, we have a per mm(ioasid_set) notifier to inform mdev, KVM
> to clean up and drop its refcount. Do you have any suggestion on this?

The ioasid should be a reference counted object.

When the FD is closed, or the ioasid is "destroyed" it just blocks DMA
and parks the PASID until *all* places release it. Upon a zero
refcount the PASID is recycled for future use.

The duration between unmapping the ioasid and releasing all HW access
will have HW see PCIE TLP errors due to the blocked access. If
userspace messes up the order it is fine to cause this. We already had
this dicussion when talking about how to deal with process exit in the
simple SVA case.

> Let me try to paraphrase, you are suggesting common helper code and data
> format but still driver specific storage of the mapping, correct?

The driver just needs to hold the datastructure in its memory.

Like an xarray, the driver can have an xarray inside its struct
device, but the xarray library provides all the implementation.

Jason
