From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 24 May 2021 20:37:44 -0300
Message-ID: <20210524233744.GT1002214@nvidia.com>
References: <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
 <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box>
 <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FR6laYgpF9b95HZa9CNu+FrgxJqikDB0LQ7EyvD1SXA=;
 b=WioYrFyq6TDd0rJSB/lufkSLX4cBRO7UpPGYeEKYR41MY3irwINBc4DkMKQddsir47D0w756SKEJmSgTrTnmRVMf1HYNuT4SUz5aYLAKcR8zD/5/aP+/rBJWqP83YrpSqe/ncz48QcZH2Nbhb3yYHElXj5g3jU+R3JeIY2DQ4V7TAE3KB6aJZEuxSTVm7NcY22N2Kf0ae/4yk3jWAy/Jbo4671QI6sbtdHKNs+HceCilxErwvgyV6Ynlhay0dRNnvWXKjtc+Br8TTN+fKs3pXvQz0gqXwEqz+z8c2/GuRvDZKd+7FBBkH2RwqFUHeeO2ECqQXhMzPsiN4FXU/F7whQ==
Content-Disposition: inline
In-Reply-To: <YKtbWo7PwIlXjFIV@yekko>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, May 24, 2021 at 05:52:58PM +1000, David Gibson wrote:

> > > I don't really see a semantic distinction between "always one-device
> > > groups" and "groups don't matter".  Really the only way you can afford
> > > to not care about groups is if they're singletons.
> > 
> > The kernel driver under the mdev may not be in an "always one-device"
> > group.
> 
> I don't really understand what you mean by that.

I mean the group of the mdev's actual DMA device may have multiple
things in it.
 
> > It is a kernel driver so the only thing we know and care about is that
> > all devices in the HW group are bound to kernel drivers.
> > 
> > The vfio device that spawns from this kernel driver is really a
> > "groups don't matter" vfio device because at the IOMMU layer it should
> > be riding on the physical group of the kernel driver.  At the VFIO
> > layer we no longer care about the group abstraction because the system
> > guarentees isolation in some other way.
> 
> Uh.. I don't really know how mdevs are isolated from each other.  I
> thought it was because the physical device providing the mdevs
> effectively had an internal IOMMU (or at least DMA permissioning) to
> isolate the mdevs, even though the physical device may not be fully
> isolated.
> 
> In that case the virtual mdev is effectively in a singleton group,
> which is different from the group of its parent device.

That is one way to view it, but it means creating a whole group
infrastructure and abusing the IOMMU stack just to create this
nonsense fiction. We also abuse the VFIO container stuff to hackily
create several different types pf IOMMU uAPIs for the mdev - all of
which are unrelated to drivers/iommu.

Basically, there is no drivers/iommu thing involved, thus is no really
iommu group, for mdev it is all a big hacky lie.

> If the physical device had a bug which meant the mdevs *weren't*
> properly isolated from each other, then those mdevs would share a
> group, and you *would* care about it.  Depending on how the isolation
> failed the mdevs might or might not also share a group with the parent
> physical device.

That isn't a real scenario.. mdevs that can't be isolated just
wouldn't be useful to exist

> > This is today's model, yes. When you run dpdk on a multi-group device
> > vfio already ensures that all the device groups remained parked and
> > inaccessible.
> 
> I'm not really following what you're saying there.
> 
> If you have a multi-device group, and dpdk is using one device in it,
> VFIO *does not* (and cannot) ensure that other devices in the group
> are parked and inaccessible.  

I mean in the sense that no other user space can open those devices
and no kernel driver can later be attached to them.

> It ensures that they're parked at the moment the group moves from
> kernel to userspace ownership, but it can't prevent dpdk from
> accessing and unparking those devices via peer to peer DMA.

Right, and adding all this group stuff did nothing to alert the poor
admin that is running DPDK to this risk.

> > If the administator configures the system with different security
> > labels for different VFIO devices then yes removing groups makes this
> > more tricky as all devices in the group should have the same label.
> 
> That seems a bigger problem than "more tricky".  How would you propose
> addressing this with your device-first model?

You put the same security labels you'd put on the group to the devices
that consitute the group. It is only more tricky in the sense that the
script that would have to do this will need to do more than ID the
group to label but also ID the device members of the group and label
their char nodes.

Jason
