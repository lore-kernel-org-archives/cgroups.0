From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 21 Apr 2021 20:03:01 -0300
Message-ID: <20210421230301.GP1370958@nvidia.com>
References: <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
 <20210415230732.GG1370958@nvidia.com>
 <20210416061258.325e762e@jacob-builder>
 <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHy9OoWejvcw0XJuDfiajqiWpMWOLWv8yaffxEbZQmo=;
 b=HO08NuFMflY8iUhDr6jteD79+aJmwBSp/cD9UhkqUykvqFaQ3egzYWtfrgXuNp3z9RWg5yGR9NT37q6fII33oijwi+kKFhpMQisD0PVfVD5k75vQbkCoqjIx+P8RzMKtVU7MRZNDTBOZBksuahNEzVo6XaLWIErewvgosEixQO1+BTocuJfoCd7Ubii8hhZEhrjhumBz2vXT8Y7KFZVAfhqqOAMdRMohgAIytGR3Wb+FRc8YNnV1ogaouge9G09qwP6txLvn9BGrtWY0xBnbZlU+A22aqco3DKTXLZ6yC63l7fqSOipGWb110iexQxSdOoCbFMEWhxLnPyHvwrbrdg==
Content-Disposition: inline
In-Reply-To: <20210421133312.15307c44-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Apr 21, 2021 at 01:33:12PM -0600, Alex Williamson wrote:

> > I still expect that VFIO_GROUP_SET_CONTAINER will be used to connect
> > /dev/{ioasid,vfio} to the VFIO group and all the group and device
> > logic stays inside VFIO.
> 
> But that group and device logic is also tied to the container, where
> the IOMMU backend is the interchangeable thing that provides the IOMMU
> manipulation for that container.

I think that is an area where the discussion would need to be focused.

I don't feel very prepared to have it in details, as I haven't dug
into all the group and iommu micro-operation very much.

But, it does seem like the security concept that VFIO is creating with
the group also has to be present in the lower iommu layer too.

With different subsystems joining devices to the same ioasid's we
still have to enforce the security propery the vfio group is creating.

> If you're using VFIO_GROUP_SET_CONTAINER to associate a group to a
> /dev/ioasid, then you're really either taking that group outside of
> vfio or you're re-implementing group management in /dev/ioasid. 

This sounds right.

> > Everything can be switched to ioasid_container all down the line. If
> > it wasn't for PPC this looks fairly simple.
> 
> At what point is it no longer vfio?  I'd venture to say that replacing
> the container rather than invoking a different IOMMU backend is that
> point.

sorry, which is no longer vfio?
 
> > Since getting rid of PPC looks a bit hard, we'd be stuck with
> > accepting a /dev/ioasid and then immediately wrappering it in a
> > vfio_container an shimming it through a vfio_iommu_ops. It is not
> > ideal at all, but in my look around I don't see a major problem if
> > type1 implementation is moved to live under /dev/ioasid.
> 
> But type1 is \just\ an IOMMU backend, not "/dev/vfio".  Given that
> nobody flinched at removing NVLink support, maybe just deprecate SPAPR
> now and see if anyone objects ;)

Would simplify this project, but I wonder :)

In any event, it does look like today we'd expect the SPAPR stuff
would be done through the normal iommu APIs, perhaps enhanced a bit,
which makes me suspect an enhanced type1 can implement SPAPR.

I say this because the SPAPR looks quite a lot like PASID when it has
APIs for allocating multiple tables and other things. I would be
interested to hear someone from IBM talk about what it is doing and
how it doesn't fit into today's IOMMU API.

It is very old and the iommu world has advanced tremendously lately,
maybe I'm too optimisitic?

> > We end up with a ioasid.h that basically has the vfio_iommu_type1 code
> > lightly recast into some 'struct iommu_container' and a set of
> > ioasid_* function entry points that follow vfio_iommu_driver_ops_type1:
> >   ioasid_attach_group
> >   ioasid_detatch_group
> >   ioasid_<something about user pages>
> >   ioasid_read/ioasid_write
> 
> Again, this looks like a vfio IOMMU backend.  What are we accomplishing
> by replacing /dev/vfio with /dev/ioasid versus some manipulation of
> VFIO_SET_IOMMU accepting a /dev/ioasid fd?

The point of all of this is to make the user api for the IOMMU
cross-subsystem. It is not a vfio IOMMU backend, it is moving the
IOMMU abstraction from VFIO into the iommu framework and giving the
iommu framework a re-usable user API.

My ideal outcome would be for VFIO to use only the new iommu/ioasid
API and have no iommu pluggability at all. The iommu subsystem
provides everything needed to VFIO, and provides it equally to VDPA
and everything else.

drivers/vfio/ becomes primarily about 'struct vfio_device' and
everything related to its IOCTL interface.

drivers/iommu and ioasid.c become all about a pluggable IOMMU
interface, including a uAPI for it.

IMHO it makes a high level sense, though it may be a pipe dream.

> > If we have this, and /dev/ioasid implements the legacy IOCTLs, then
> > /dev/vfio == /dev/ioasid and we can compile out vfio_fops and related
> > from vfio.c and tell ioasid.c to create /dev/vfio instead using the
> > ops it owns.
> 
> Why would we want /dev/ioasid to implement legacy ioctls instead of
> simply implementing an interface to allow /dev/ioasid to be used as a
> vfio IOMMU backend?

Only to make our own migration easier. I'd imagine everyone would want
to sit down and design this new clear ioasid API that can co-exist on
/dev/ioasid with the legacy once.

> The pseudo code above really suggests you do want to remove
> /dev/vfio/vfio, but this is only one of the IOMMU backends for vfio, so
> I can't quite figure out if we're talking past each other.

I'm not quite sure what you mean by "one of the IOMMU backends?" You
mean type1, right?
 
> As I expressed in another thread, type1 has a lot of shortcomings.  The
> mapping interface leaves userspace trying desperately to use statically
> mapped buffers because the map/unmap latency is too high.  We have
> horrible issues with duplicate locked page accounting across
> containers.  It suffers pretty hard from feature creep in various
> areas.  A new IOMMU backend is an opportunity to redesign some of these
> things.

Sure, but also those kinds of transformational things go alot better
if you can smoothly go from the old to the new and have technical
co-existance in side the kernel. Having a shim that maps the old APIs
to new APIs internally to Linux helps keep the implementation from
becoming too bogged down with compatibility.

> The IOMMU group also abstracts isolation and visibility relative to
> DMA.  For example, in a PCIe topology a multi-function device may not
> have isolation between functions, but each requester ID is visible to
> the IOMMU.  

Okay, I'm glad I have this all right in my head, as I was pretty sure
this was what the group was about.

My next question is why do we have three things as a FD: group, device
and container (aka IOMMU interface)?

Do we have container because the /dev/vfio/vfio can hold only a single
page table so we need to swap containers sometimes?

If we start from a clean sheet and make a sketch..

/dev/ioasid is the IOMMU control interface. It can create multiple
IOASIDs that have page tables and it can manipulate those page tables.
Each IOASID is identified by some number.

struct vfio_device/vdpa_device/etc are consumers of /dev/ioasid

When a device attaches to an ioasid userspace gives VFIO/VDPA the
ioasid FD and the ioasid # in the FD.

The security rule for isolation is that once a device is attached to a
/dev/ioasid fd then all other devices in that security group must be
attached to the same ioasid FD or left unused.

Thus /dev/ioasid also becomes the unit of security and the IOMMU
subsystem level becomes aware of and enforces the group security
rules. Userspace does not need to "see" the group

In sketch it would be like
  ioasid_fd = open("/dev/ioasid");
  vfio_device_fd = open("/dev/vfio/device0")
  vdpa_device_fd = open("/dev/vdpa/device0")
  ioctl(vifo_device_fd, JOIN_IOASID_FD, ioasifd)
  ioctl(vdpa_device_fd, JOIN_IOASID_FD, ioasifd)

  gpa_ioasid_id = ioctl(ioasid_fd, CREATE_IOASID, ..)
  ioctl(ioasid_fd, SET_IOASID_PAGE_TABLES, ..)

  ioctl(vfio_device, ATTACH_IOASID, gpa_ioasid_id)
  ioctl(vpda_device, ATTACH_IOASID, gpa_ioasid_id)

  .. both VDPA and VFIO see the guest physical map and the kernel has
     enough info that both could use the same IOMMU page table
     structure ..

  // Guest viommu turns off bypass mode for the vfio device
  ioctl(vfio_device, DETATCH_IOASID)
 
  // Guest viommu creates a new page table
  rid_ioasid_id = ioctl(ioasid_fd, CREATE_IOASID, ..)
  ioctl(ioasid_fd, SET_IOASID_PAGE_TABLES, ..)

  // Guest viommu links the new page table to the RID
  ioctl(vfio_device, ATTACH_IOASID, rid_ioasid_id)

The group security concept becomes implicit and hidden from the
uAPI. JOIN_IOASID_FD implicitly finds the device's group inside the
kernel and requires that all members of the group be joined only to
this ioasid_fd.

Essentially we discover the group from the device instead of the
device from the group.

Where does it fall down compared to the three FD version we have
today?

Jason
