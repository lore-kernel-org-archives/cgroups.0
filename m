From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 30 Mar 2021 10:43:13 -0300
Message-ID: <20210330134313.GP2356281@nvidia.com>
References: <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <20210329155526.2ad791a9@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQZ3yU6L6mhMe9nejkBp/Bqv223Gaj1HrOxUg5nE3pc=;
 b=IcntDo6o8TCXtJfNw+AwdI81ftfw/18UPjCtmdziKabU/d6KFiLfwo0tz2+NgTRvTjkeiU77AxyZfQjyPc+TOz2h/kvnavnw2AJBMw13n1kA1NP8fB2sWo4YgjwHwru1RbGVgmI3Ti/yfCETi12xwY+/hjxVdxYIwPK6BsbtMIP2Y+q3dv54zpZFMbAzeqkGc/rBvxnSAkFhgNzDIXMt2otKyID5FeoHHVVDSzr/younDEMCEzXHxYMqDhmWbgYDGznTzYIA37xq8EPD6AMxtrqw2kr6e9H2P05ge3wl5YiyVIJB3eJhCCtFPGeP1iAaAy9rnjGWcZiv3D8qlmssuA==
Content-Disposition: inline
In-Reply-To: <20210329155526.2ad791a9@jacob-builder>
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

On Mon, Mar 29, 2021 at 03:55:26PM -0700, Jacob Pan wrote:

> In one of the earlier discussions, I was made aware of some use cases (by
> AMD, iirc) where PASID can be used w/o IOMMU. That is why I tried to keep
> ioasid a separate subsystem. Other than that, I don't see an issue
> combining the two.

That sounds like nonsense. A freshly created ioasid should have *NO
DMA*. Every access to it should result in a PCI error until a mapping
for the address space is defined. It is called IO *address space* for
a reason.

So, what exactly do you do with a PASID without an IOMMU? You
certainly can't expose it through this interface because you can't
establish the first requirement of *NO DMA*.

While there may be an interesting use case, it looks to be kernel-only
and not relavent here.

> it matters when it comes to which interface to choose. Use /dev/ioasid to
> allocate if PASID value cannot be hidden. Use some other interface for bind
> current and allocate if a PASID is not visible to the user.

I just view it as a shortcut, it has less to do with "hidden" and more
to do if the shortcut is a valuable savings. If you swap four ioctls
with one ioctl I'd say that is not enough of a win <shrug>
 
> Yes, I think we are on the same page. For example, today's uacce or idxd
> driver creates a hidden PASID when user does open(), where a new WQ is
> provisioned and bound to current mm. This is the case where /dev/ioasid is
> not needed.

So that is a probelm for uacce, they shouldn't have created PASIDs at
open() time, there is no option to customize what is happening there.

> Sorry, I am not following. In the doc, I have an example to show the
> ioasid_set to VM/mm mapping. We use mm as the ioasid_set token to identify
> who the owner of an IOASID is. i.e. who allocated the IOASID. Non-owner
> cannot perform bind page table or free operations.

As I said to Kevin this seems very over complicated.

Access to the /dev/ioasid FD is the only authorization the kernel
needs.

> Yes, each PF/VF has its own PASID table. The device can do whatever
> it wants as long as the PASID is present in the table. Programming of the
> pIOMMU PASID table entry, however, is controlled by the host.
> 
> IMHO, there are two levels of security here:
> 1. A PASID can only be used by a secure context
> 2. A device can only use allowed PASIDs (PASID namespace is system-wide but
> PASID table storage is per PF/VF)
> 
> IOASID set is designed for #1.

#1 sounds like the mdev case, and as I said to Kevin each and every
mdev needs its own allow'd PASID list. There is no need for an ioasid
set to implement that.

> > If a device is sharing a single PCI function with different security
> > contexts (eg vfio mdev) then the device itself is responsible to
> > ensure that only the secure interface can program a PASID and a less
> > secure context can never self-enroll. 
> 
> If two mdevs from the same PF dev are assigned to two VMs, the PASID
> table will be shared. IOASID set ensures one VM cannot program another VM's
> PASIDs. I assume 'secure context' is per VM when it comes to host PASID.

No, the mdev device driver must enforce this directly. It is the one
that programms the physical shared HW, it is the one that needs a list
of PASID's it is allowed to program *for each mdev*

ioasid_set doesn't seem to help at all, certainly not as a concept
tied to /dev/ioasid.

> No. the mdev driver consults with IOASID core When the guest programs a
> guest PASID on to he mdev. VDCM driver does a lookup:
> host_pasid = ioasid_find_by_spid(ioasid_set, guest_pasid);

This is the wrong layering. Tell the mdev device directly what it is
allowed to do. Do not pollute the ioasid core with security stuff.

> > I'd say you shoul have a single /dev/ioasid per VM and KVM should
> > attach to that - it should get all the global events/etc that are not
> > device specific.
> > 
> You mean a single /dev/ioasid FD per VM and KVM? I think that is what we
> are doing in this set. A VM process can only open /dev/ioasid once, then
> use the FD for allocation and pass the PASID for bind page table etc.

Yes, I think that is reasonable.

Tag all the IOCTL's with the IOASID number.
 
> > Not sure what guest-host PASID means, these have to be 1:1 for device
> > assignment to work - why would use something else for mdev?
> > 
> We have G-H PASID translation. They don't have to be 1:1.
> IOASID Set Private ID (SPID) is intended as a generic solution for guest PASID.
> Could you review the secion Section: IOASID Set Private ID (SPID) in the
> doc patch?

Again this only works for MDEV? How would you do translation for a
real PF/VF?

So when you 'allow' a mdev to access a PASID you want to say:
 Allow Guest PASID A, map it to host PASID B on this /dev/ioasid FD

?

That seems like a good helper library to provide for drivers to use,
but it should be a construct entirely contained in the driver.

> We also had some slides from last year. Slide 3s-6 mostly.
> https://static.sched.com/hosted_files/kvmforum2020/9f/KVM_forum_2020_PASID_MGMT_Yi_Jacob_final.pdf

I think you are trying to put too much into a giant ioasid
core. Responsibility needs to rest in more logical places, it will
simplify everything.

Jason
