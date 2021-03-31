From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 31 Mar 2021 15:33:24 -0300
Message-ID: <20210331183324.GR1463678@nvidia.com>
References: <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <20210329155526.2ad791a9@jacob-builder>
 <20210330134313.GP2356281@nvidia.com>
 <20210330171041.70f2d7d0@jacob-builder>
 <20210331122805.GC1463678@nvidia.com>
 <20210331093457.753512d4@jacob-builder>
 <20210331173148.GN1463678@nvidia.com>
 <20210331112030.174e77b0@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYZRs2QksBNC78z+UTsQttx7YMW9PTlD6PmKAEmWUjM=;
 b=qUCqD3hJhFhUN/QFxhRxACSOam6RJaBh/Xt44ruQTiWQpmehE9hBK8wyK92IlhPZLUpKFPc48/Oot983CJx6SFPa5H+grHPrkq7Er1HFR3Kr7bSrdgVl2YcEm0yLakgjI1JR/1PQZvjViJNFXtcvxhQMc77yEUu+KoJ59PXaNh6ME182P/Lnhkg3rAmVO0XaIk+3XlJ2z2qcbAyjNvx24CWNtGsHmAVUIhqbQEUq51GdqqqMotz3R/YGyNnBTq71SUR2p43n1rW82PHcbMI3Pj38PIQJUM0LLDFvKePi++E18OjyhekGCW4ZMUyGy4k90nuP31zys8DSbwunyJeJ2w==
Content-Disposition: inline
In-Reply-To: <20210331112030.174e77b0@jacob-builder>
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

On Wed, Mar 31, 2021 at 11:20:30AM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Wed, 31 Mar 2021 14:31:48 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > > > We should try to avoid hidden behind the scenes kernel
> > > > interconnections between subsystems.
> > > >   
> > > Can we? in case of exception. Since all these IOCTLs are coming from the
> > > unreliable user space, we must deal all exceptions.
> > >
> > > For example, when user closes /dev/ioasid FD before (or w/o) unbind
> > > IOCTL for VFIO, KVM, kernel must do cleanup and coordinate among
> > > subsystems. In this patchset, we have a per mm(ioasid_set) notifier to
> > > inform mdev, KVM to clean up and drop its refcount. Do you have any
> > > suggestion on this?  
> > 
> > The ioasid should be a reference counted object.
> > 
> yes, this is done in this patchset.
> 
> > When the FD is closed, or the ioasid is "destroyed" it just blocks DMA
> > and parks the PASID until *all* places release it. Upon a zero
> > refcount the PASID is recycled for future use.
> > 
> Just to clarify, you are saying (when FREE happens before proper
> teardown) there is no need to proactively notify all users of the IOASID to
> drop their reference. Instead, just wait for the other parties to naturally
> close and drop their references. Am I understanding you correctly?

Yes. What are receivers going to do when you notify them anyhow? What
will a mdev do? This is how you get into they crazy locking problems.

It is an error for userspace to shutdown like this, recover sensibly
and don't crash the kernel. PCIe error TLPs are expected, supress
them. That is what we decided on the mmu notifier discussion.

> I feel having the notifications can add two values:
> 1. Shorten the duration of errors (as you mentioned below), FD close can
> take a long and unpredictable time. e.g. FD shared.

Only if userspace exits in some uncontrolled way. In a controlled exit
it can close all the FDs in the right order.

It is OK if userspace does something weird and ends up with disabled
IOASIDs. It shouldn't do that if it cares.

> 2. Provide teardown ordering among PASID users. i.e. vCPU, IOMMU, mdev.

This is a hard ask too, there is no natural ordering here I can see,
obviously we want vcpu, mdev, iommu for qemu but that doesn't seem to
fall out unless we explicitly hard wire it into the kernel.

Doesn't kvm always kill the vCPU first based on the mmu notifier
shooting down all the memory? IIRC this happens before FD close?

> > The duration between unmapping the ioasid and releasing all HW access
> > will have HW see PCIE TLP errors due to the blocked access. If
> > userspace messes up the order it is fine to cause this. We already had
> > this dicussion when talking about how to deal with process exit in the
> > simple SVA case.
> Yes, we have disabled fault reporting during this period. The slight
> differences vs. the simple SVA case is that KVM is also involved and there
> might be an ordering requirement to stop vCPU first.

KVM can continue to use the PASIDs, they are parked and DMA is
permanently blocked. When KVM reaches a natural point in its teardown
it can release them.

If you have to stop the vcpu from a iommu notifier you are in the
crazy locking world I mentioned. IMHO don't create exciting locking
problems just to avoid PCI errors in uncontrolled shutdown.

Suppress the errors instead.

Jason
