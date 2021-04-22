From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 22 Apr 2021 20:39:50 -0300
Message-ID: <20210422233950.GD1370958@nvidia.com>
References: <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iB5Kt4p6bg0a+d63wgL5lVG55BdNhOWkIwQ+H4WNsMc=;
 b=XWklfpTHcLlF5BwnQvIeisNAt6eEt/JQ45aP+xXb/JuyJalCHbbXTS0pFS4J+6BGaXtcO5BMIyiEpAoKDTeF9ft6cNRE9DpdsZxuvXg+ValLaJxLIy/kDrsure+AlK5tVg+NcTCZptlpL/L9919IhhqKltmTbu0Yzz8yiB5Rlx0WqDXmVoo3rWoCxmKELUH4dpJtS5/1AkuzneHla2Cg/qlqoh6zcXJ/hcwW1BVkP2RsFDcYSvtIKWqGmblluOSSvQ9NKc0xzgv3s3gzgkCaRlcBUQWE5KmpKM4qXXh6UzFRwo5nOO6/IG8Lp8MXI1OQQ/u1bmq6QB7oH13i7lqUBg==
Content-Disposition: inline
In-Reply-To: <20210422163808.2d173225-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David

On Thu, Apr 22, 2021 at 04:38:08PM -0600, Alex Williamson wrote:

> Because it's fundamental to the isolation of the device?  What you're
> proposing doesn't get around the group issue, it just makes it implicit
> rather than explicit in the uapi.

I'm not even sure it makes it explicit or implicit, it just takes away
the FD.

There are four group IOCTLs, I see them mapping to /dev/ioasid follows:
 VFIO_GROUP_GET_STATUS - 
   + VFIO_GROUP_FLAGS_CONTAINER_SET is fairly redundant
   + VFIO_GROUP_FLAGS_VIABLE could be in a new sysfs under
     kernel/iomm_groups, or could be an IOCTL on /dev/ioasid
       IOASID_ALL_DEVICES_VIABLE

 VFIO_GROUP_SET_CONTAINER -
   + This happens implicitly when the device joins the IOASID
     so it gets moved to the vfio_device FD:
      ioctl(vifo_device_fd, JOIN_IOASID_FD, ioasifd)

 VFIO_GROUP_UNSET_CONTAINER -
   + Also moved to the vfio_device FD, opposite of JOIN_IOASID_FD

 VFIO_GROUP_GET_DEVICE_FD -
   + Replaced by opening /dev/vfio/deviceX
     Learn the deviceX which will be the cdev sysfs shows as:
      /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/vfio/deviceX/dev
    Open /dev/vfio/deviceX

> > How do we model the VFIO group security concept to something like
> > VDPA?
> 
> Is it really a "VFIO group security concept"?  We're reflecting the
> reality of the hardware, not all devices are fully isolated.  

Well, exactly.

/dev/ioasid should understand the group concept somehow, otherwise it
is incomplete and maybe even security broken.

So, how do I add groups to, say, VDPA in a way that makes sense? The
only answer I come to is broadly what I outlined here - make
/dev/ioasid do all the group operations, and do them when we enjoin
the VDPA device to the ioasid.

Once I have solved all the groups problems with the non-VFIO users,
then where does that leave VFIO? Why does VFIO need a group FD if
everyone else doesn't?

> IOMMU group.  This is the reality that any userspace driver needs to
> play in, it doesn't magically go away because we drop the group file
> descriptor.  

I'm not saying it does, I'm saying it makes the uAPI more regular and
easier to fit into /dev/ioasid without the group FD.

> It only makes the uapi more difficult to use correctly because
> userspace drivers need to go outside of the uapi to have any idea
> that this restriction exists.  

I don't think it makes any substantive difference one way or the
other.

With the group FD: the userspace has to read sysfs, find the list of
devices in the group, open the group fd, create device FDs for each
device using the name from sysfs.

Starting from a BDF the general pseudo code is
 group_path = readlink("/sys/bus/pci/devices/BDF/iommu_group")
 group_name = basename(group_path)
 group_fd = open("/dev/vfio/"+group_name)
 device_fd = ioctl(VFIO_GROUP_GET_DEVICE_FD, BDF);

Without the group FD: the userspace has to read sysfs, find the list
of devices in the group and then open the device-specific cdev (found
via sysfs) and link them to a /dev/ioasid FD.

Starting from a BDF the general pseudo code is:
 device_name = first_directory_of("/sys/bus/pci/devices/BDF/vfio/")
 device_fd = open("/dev/vfio/"+device_name)
 ioasidfd = open("/dev/ioasid")
 ioctl(device_fd, JOIN_IOASID_FD, ioasidfd)

These two routes can have identical outcomes and identical security
checks.

In both cases if userspace wants a list of BDFs in the same group as
the BDF it is interested in:
   readdir("/sys/bus/pci/devices/BDF/iommu_group/devices")

It seems like a very small difference to me.

I still don't see how the group restriction gets surfaced to the
application through the group FD. The applications I looked through
just treat the group FD as a step on their way to get the device_fd.

Jason
