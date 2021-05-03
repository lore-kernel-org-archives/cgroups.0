From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 3 May 2021 13:15:18 -0300
Message-ID: <20210503161518.GM1370958@nvidia.com>
References: <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
 <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box>
 <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsrcXyE5y/ppPoLuMeJMZjpz7sz6aBREBdV0KXEjuBU=;
 b=fhriCLjytOTxefQIyrhGbxw7ejvgWd6ZiYWgmDDMtZmMV+6Eg1P1xNKxzjQjFlePEh+GiE9mBTQcq9+FODgn2LFTkGJC9Xs7TnlOQMV6l6oa+zoNY91QrQUW/BU9clqqtSjtcAMG6LMbaTgJWtsL8UMbkWPdNeEjN2q85vGCgqPcHUkvxWHbhbKk1wWNa5kVqYryQj5IvWMG7zrkBxUXmeBphrY97cAu2M2JPvsDTHqAiynJ98SKRdJxHuJTT+7hEfwQcD4We1tdsYjfwpp9Fc0TG0N3aEE28TW6T7gg37HAL9kpVHvCQoI8CEfgo50XOrMjiCqAG8/csCkNHDhhRQ==
Content-Disposition: inline
In-Reply-To: <YIoiJRY3FM7xH2bH@yekko>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Apr 29, 2021 at 01:04:05PM +1000, David Gibson wrote:
> Again, I don't know enough about VDPA to make sense of that.  Are we
> essentially talking non-PCI virtual devices here?  In which case you
> could define the VDPA "bus" to always have one-device groups.

It is much worse than that.

What these non-PCI devices need is for the kernel driver to be part of
the IOMMU group of the underlying PCI device but tell VFIO land that
"groups don't matter"

Today mdev tries to fake this by using singleton iommu groups, but it
is really horrible and direcly hacks up the VFIO IOMMU code to
understand these special cases. Intel was proposing more special
hacking in the VFIO IOMMU code to extend this to PASID.

When we get to a /dev/ioasid this is all nonsense. The kernel device
driver is going to have to tell drivers/iommu exactly what kind of
ioasid it can accept, be it a PASID inside a kernel owned group, a SW
emulated 'mdev' ioasid, or whatever.

In these cases the "group" idea has become a fiction that just creates
a pain. "Just reorganize VDPA to do something insane with the driver
core so we can create a dummy group to satisfy an unnecessary uAPI
restriction" is not a very compelling argument.

So if the nonsensical groups goes away for PASID/mdev, where does it
leave the uAPI in other cases?

> I don't think simplified-but-wrong is a good goal.  The thing about
> groups is that if they're there, you can't just "not care" about them,
> they affect you whether you like it or not.

You really can. If one thing claims the group then all the other group
devices become locked out.

The main point to understand is that groups are NOT an application
restriction! It is a whole system restriction that the operator needs
to understand and deal with. This is why things like dpdk don't care
about the group at all - there is nothing they can do with the
information.

If the operator says to run dpdk on a specific device then the
operator is the one that has to deal with all the other devices in the
group getting locked out.

At best the application can make it more obvious that the operator is
doing something dangerous, but the current kernel API doesn't seem to
really support that either.

Jason

