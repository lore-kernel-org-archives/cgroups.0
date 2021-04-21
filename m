From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 21 Apr 2021 14:52:03 -0300
Message-ID: <20210421175203.GN1370958@nvidia.com>
References: <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
 <20210415230732.GG1370958@nvidia.com>
 <20210416061258.325e762e@jacob-builder>
 <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpSJ5skAT76bfSWLlCPUo8FROtI5wdyyLtOzDx3PG20=;
 b=UGpu6HypLD1mw7A7rXMV7M6oEt+0YiEmgoR+4+NtDG9h8lcgV8yPlBmHQOerJRReiHjx+ui0MHJVR3u4AYFSMFbNZ4oN7cPmH3GIS4o2dTGJVj/keWP9b3zTm9zKVb8NIO9fUS3hPQLkK4/4GwUYVkuNX4Gm200rq0BaL7CkAWib06qhDWOSMou82mOm5wzcHbPkw/HQKZvT7jAaT26eRCNvpukviHXTW2sKcs/lqyiwHrgxjnTTEMuI+2XFGUhO/steh3WGhUuQLhiQp5F4kKaRuY4e3bmrL5WXaZTk7ILwoJg2QGxBYnES6s15zErlTyOXrLYTHZ2/d3iEv6kTtg==
Content-Disposition: inline
In-Reply-To: <20210421105451.56d3670a-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Apr 21, 2021 at 10:54:51AM -0600, Alex Williamson wrote:

> That's essentially replacing vfio-core, where I think we're more

I am only talking about /dev/vfio here which is basically the IOMMU
interface part.

I still expect that VFIO_GROUP_SET_CONTAINER will be used to connect
/dev/{ioasid,vfio} to the VFIO group and all the group and device
logic stays inside VFIO.

The appeal of unifying /dev/{ioasid,vfio} to a single fops is that it
cleans up vfio a lot - we don't have to have two different code paths
where one handles a vfio_container and the other a ioasid_container
and the all the related different iommu ops and so on.

Everything can be switched to ioasid_container all down the line. If
it wasn't for PPC this looks fairly simple.

Since getting rid of PPC looks a bit hard, we'd be stuck with
accepting a /dev/ioasid and then immediately wrappering it in a
vfio_container an shimming it through a vfio_iommu_ops. It is not
ideal at all, but in my look around I don't see a major problem if
type1 implementation is moved to live under /dev/ioasid.

For concreteness if we look at the set container flow with ioasid I'd
say something like:

vfio_group_fops_unl_ioctl()
 VFIO_GROUP_SET_CONTAINER
  vfio_group_set_container()
     if (f.file->f_op == &vfio_fops) {
          // Use a real vfio_container and vfio_iommu_driver
          driver->ops->attach_group()
             tce_iommu_attach_group()
     }

     if (ioasid_container = ioasid_get_from_fd(container_fd)) {
         // create a dummy vfio_container and use the ioasid driver
	 container = kzalloc()
         container->iommu_driver = ioasid_shim
         driver->ops->attach_group()
             ioasid_shim_attach_group(ioasid_container, ...)
                 ioasid_attach_group()
                     // What used to be vfio_iommu_attach_group()

Broadly all the ops vfio need go through the ioasid_shim which relays
them to the generic ioasid API.

We end up with a ioasid.h that basically has the vfio_iommu_type1 code
lightly recast into some 'struct iommu_container' and a set of
ioasid_* function entry points that follow vfio_iommu_driver_ops_type1:
  ioasid_attach_group
  ioasid_detatch_group
  ioasid_<something about user pages>
  ioasid_read/ioasid_write

If we have this, and /dev/ioasid implements the legacy IOCTLs, then
/dev/vfio == /dev/ioasid and we can compile out vfio_fops and related
from vfio.c and tell ioasid.c to create /dev/vfio instead using the
ops it owns.

This is a very long winded way of saying ideally we'd do
approximately:
  git mv drivers/vfio/vfio_iommu_type1.c drivers/ioasid/ioasid.c

As the first step. Essentially we declare that what is type1 is really
the user interface to the internal kernel IOMMU kAPI, which has been
steadily evolving since type1 was created 10 years ago.

> The interface of making that selection might change to accept an
> external /dev/ioasid file descriptor, of course.  Maybe you can
> elaborate on how the vfio device and group uAPI live (or not) in
> this new scheme were /dev/ioasid is the primary interface.  Thanks,

They say in vfio. You'd still open a group and you'd still pass in
either /dev/vfio or /dev/ioasid to define the container

Though, completely as an unrelated aside, I admit to not entirely
understanding why the group is the central element of the uAPI.

It is weird that the vfio "drivers" all work on the struct vfio_device
(at least after my series), and it has a file_operations presence via
vfio_device_fops, but instead of struct vfio_device directly having a
'struct device' and cdev to access the FD we get it through a group FD
and agroup chardev via VFIO_GROUP_GET_DEVICE_FD

If we were to revise this, and I don't see a huge reason to do so, I
would put a struct device and cdev in struct vfio_device, attach the
vfio_device directly to the ioasid and then forget about the group, at
least as uapi, completely.

Or at least I don't see where that gets into trouble, but I'm not too
familiar with the multi-vfio in a process scenario..

Jason
