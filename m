From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 13 May 2021 10:59:38 -0300
Message-ID: <20210513135938.GG1002214@nvidia.com>
References: <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
 <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box>
 <20210428145622.GU1370958@nvidia.com> <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com> <YJy9o8uEZs42/qDM@yekko>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxUAgRWq6rQGjwNbnUqXypkAkkQ4cafn78SEI8kEswE=;
 b=AK6aHuSWIwgfikM0i2PZh2yJWU8VHz8ofU4eFWm5aZPmC2B5xhlfMGJcA4A38bHeKiQre3uL1yQKyLUmgX+oQ1d3V1izBVlvazEhVAn0e6EzPuRHbCvHN+SntRLf1kZAA42uNjZYx5Stch1+vn/bRQvAFXD0g99qqpbc3asA8W7C2gwy1ml8NgleCQIMWNp+cdvEMHhF47PXMiPT2P9A+OV66OtUQOPsuZC8TdEXs+jExwdyCRCvbXYiwdeqXiNSFEW4IxfnjH/i/3PGW2dcNZqKVhYf94cmTIwxKQWg9u9A5jdGehc3W561Tu+xCpsyb0osPBa1RtChFPkZyxNO2w==
Content-Disposition: inline
In-Reply-To: <YJy9o8uEZs42/qDM@yekko>
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
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, May 13, 2021 at 03:48:19PM +1000, David Gibson wrote:
> On Mon, May 03, 2021 at 01:15:18PM -0300, Jason Gunthorpe wrote:
> > On Thu, Apr 29, 2021 at 01:04:05PM +1000, David Gibson wrote:
> > > Again, I don't know enough about VDPA to make sense of that.  Are we
> > > essentially talking non-PCI virtual devices here?  In which case you
> > > could define the VDPA "bus" to always have one-device groups.
> > 
> > It is much worse than that.
> > 
> > What these non-PCI devices need is for the kernel driver to be part of
> > the IOMMU group of the underlying PCI device but tell VFIO land that
> > "groups don't matter"
> 
> I don't really see a semantic distinction between "always one-device
> groups" and "groups don't matter".  Really the only way you can afford
> to not care about groups is if they're singletons.

The kernel driver under the mdev may not be in an "always one-device"
group.

It is a kernel driver so the only thing we know and care about is that
all devices in the HW group are bound to kernel drivers.

The vfio device that spawns from this kernel driver is really a
"groups don't matter" vfio device because at the IOMMU layer it should
be riding on the physical group of the kernel driver.  At the VFIO
layer we no longer care about the group abstraction because the system
guarentees isolation in some other way.

The issue is a software one of tightly coupling IOMMU HW groups to
VFIO's API and then introducing an entire class of VFIO mdev devices
that no longer care about IOMMU HW groups at all.

Currently mdev tries to trick this by creating singleton groups, but
it is very ugly and very tightly coupled to a specific expectation of
the few existing mdev drivers. Trying to add PASID made it alot worse.

> Aside: I'm primarily using "group" to mean the underlying hardware
> unit, not the vfio construct on top of it, I'm not sure that's been
> clear throughout.

Sure, that is obviously fixed, but I'm not interested in that.

I'm interested in having a VFIO API that makes sense for vfio-pci
which has a tight coupling to the HW notion of a IOMMU and also vfio
mdev's that have no concept of a HW IOMMU group.

> So.. your model assumes that every device has a safe quiescent state
> where it won't do any harm until poked, whether its group is
> currently kernel owned, or owned by a userspace that doesn't know
> anything about it.

This is today's model, yes. When you run dpdk on a multi-group device
vfio already ensures that all the device groups remained parked and
inaccessible.
 
> At minimum this does mean that in order to use one device in the group
> you must have permission to use *all* the devices in the group -
> otherwise you may be able to operate a device you don't have
> permission to by DMAing to its registers from a device you do have
> permission to.

If the administator configures the system with different security
labels for different VFIO devices then yes removing groups makes this
more tricky as all devices in the group should have the same label.

Jason
