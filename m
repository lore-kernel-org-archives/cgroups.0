From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 27 May 2021 16:06:20 -0300
Message-ID: <20210527190620.GJ1002214@nvidia.com>
References: <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box>
 <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <YK8l1mZ0NVggAVUO@yekko>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJQhFM0W1vXArj+sph79LQ7r+iuVf+Uxh/Ul1UCgAgM=;
 b=m7cT7Ltrc1bmBb+0dwbdDDJOE9nd1gqCKngpLyl2Cl7IWj8T8jKchd2RMhEJ9dy11IO71aQ2qeTLY6475T+ps5uWdyIIQqHw+drNp0Ot/gdiR/Bh2uuAK02MUlmQr0NhlORglaNdcFklPZa3W9ESJTY2U2X/Vtx/wVlXgFPwXkESaPwY5Xm7ef6Hb/UHVO1rHrRpoeODa1fRTm9xVAxIoly7d27H//G5SvqbbUMt+/no0SO38/Da6+tQjgPbnFa88twcDJxucuXtv2/ezsjrpjbnvXLDZ0NNPUYkczO+qnXGX8tsC8B8mvf+GvNxD7uFXhQTtIZKxDqnoy2QGUYiCA==
Content-Disposition: inline
In-Reply-To: <YK8l1mZ0NVggAVUO@yekko>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, May 27, 2021 at 02:53:42PM +1000, David Gibson wrote:

> > > If the physical device had a bug which meant the mdevs *weren't*
> > > properly isolated from each other, then those mdevs would share a
> > > group, and you *would* care about it.  Depending on how the isolation
> > > failed the mdevs might or might not also share a group with the parent
> > > physical device.
> > 
> > That isn't a real scenario.. mdevs that can't be isolated just
> > wouldn't be useful to exist
> 
> Really?  So what do you do when you discover some mdevs you thought
> were isolated actually aren't due to a hardware bug?  Drop support
> from the driver entirely?  In which case what do you say to the people
> who understandably complain "but... we had all the mdevs in one guest
> anyway, we don't care if they're not isolated"?

I've never said to eliminate groups entirely. 

What I'm saying is that all the cases we have for mdev today do not
require groups, but are forced to create a fake group anyhow just to
satisfy the odd VFIO requirement to have a group FD.

If some future mdev needs groups then sure, add the appropriate group
stuff.

But that doesn't effect the decision to have a VFIO group FD, or not.

> > > It ensures that they're parked at the moment the group moves from
> > > kernel to userspace ownership, but it can't prevent dpdk from
> > > accessing and unparking those devices via peer to peer DMA.
> > 
> > Right, and adding all this group stuff did nothing to alert the poor
> > admin that is running DPDK to this risk.
> 
> Didn't it?  Seems to me the admin that in order to give the group to
> DPDK, the admin had to find and unbind all the things in it... so is
> therefore aware that they're giving everything in it to DPDK.

Again, I've never said the *group* should be removed. I'm only
concerned about the *group FD*

When the admin found and unbound they didn't use the *group FD* in any
way.

> > You put the same security labels you'd put on the group to the devices
> > that consitute the group. It is only more tricky in the sense that the
> > script that would have to do this will need to do more than ID the
> > group to label but also ID the device members of the group and label
> > their char nodes.
> 
> Well, I guess, if you take the view that root is allowed to break the
> kernel.  I tend to prefer that although root can obviously break the
> kernel if they intend do, we should make it hard to do by accident -
> which in this case would mean the kernel *enforcing* that the devices
> in the group have the same security labels, which I can't really see
> how to do without an exposed group.

How is this "break the kernel"? It has nothing to do with the
kernel. Security labels are a user space concern.

Jason
