From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 27 May 2021 15:48:47 -0300
Message-ID: <20210527184847.GI1002214@nvidia.com>
References: <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com>
 <YK8m9jNuvEzlXWlu@yekko>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6//VIa2BaCGORurVByXULwENHNPJ5o8kKLVhL9oep4=;
 b=G6k51McGj8dCrzwErU9L0DAuzhCGK5S7HJdexv2Kn5+STdw5i0ahy7GgCjO1X8iHt3M/IItxXvAIQ358C0I4vT2VRu5LU8EGDMPjLmRuD1h6X0PTYVvmMuzHFnEoUt7IDeWT2XAr8MkI+iffBqInjIvUSpDCReC75fCtRM6jzxUsePhSLBfq/SPcnqGvbiRSCyBNAz7577YCbp8FgIZohSI9b7MTlu23MBXSTwUrG8nkC40PPXrfnXBAaHckufyeulLZ1JgottQIy6my++06S0tl/Tsym9zzlNrF2OHZv2BKaDnUpmVKbnytHxAhWOjO7CwZa9j+SrGnjb5aANMZuA==
Content-Disposition: inline
In-Reply-To: <YK8m9jNuvEzlXWlu@yekko>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj@i>

On Thu, May 27, 2021 at 02:58:30PM +1000, David Gibson wrote:
> On Tue, May 25, 2021 at 04:52:57PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 26, 2021 at 12:56:30AM +0530, Kirti Wankhede wrote:
> > 
> > > 2. iommu backed mdev devices for SRIOV where mdev device is created per
> > > VF (mdev device == VF device) then that mdev device has same iommu
> > > protection scope as VF associated to it. 
> > 
> > This doesn't require, and certainly shouldn't create, a fake group.
> 
> It's only fake if you start with a narrow view of what a group is. 

A group is connected to drivers/iommu. A group object without *any*
relation to drivers/iommu is just a complete fiction, IMHO.

> > Only the VF's real IOMMU group should be used to model an iommu domain
> > linked to a VF. Injecting fake groups that are proxies for real groups
> > only opens the possibility of security problems like David is
> > concerned with.
> 
> It's not a proxy for a real group, it's a group of its own.  If you
> discover that (due to a hardware bug, for example) the mdev is *not*

What Kirti is talking about here is the case where a mdev is wrapped
around a VF and the DMA isolation stems directly from the SRIOV VF's
inherent DMA isolation, not anything the mdev wrapper did.

The group providing the isolation is the VF's group.

The group mdev implicitly creates is just a fake proxy that comes
along with mdev API. It doesn't do anything and it doesn't mean
anything.

> properly isolated from its parent PCI device, then both the mdev
> virtual device *and* the physical PCI device are in the same group.
> Groups including devices of different types and on different buses
> were considered from the start, and are precedented, if rare.

This is far too theoretical for me. A security broken mdev is
functionally useless.

We don't need to support it, and we don't need complicated software to
model it.

Jason
