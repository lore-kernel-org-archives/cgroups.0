From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Thu, 22 Apr 2021 08:34:32 +0000
Message-ID: <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
 <20210415230732.GG1370958@nvidia.com> <20210416061258.325e762e@jacob-builder>
 <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com> <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com> <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTRQjvBUow9ClYUu/AzdEWAbRPAAYuUIs5sE+/ekHMs=;
 b=V1H1mYF6qeR1byZ6eXav+k/CbaFQok7ixqCVoVgd3Ed6Q0g8hAxx8HwvEwS5KaDPaAtRebgfGFg483lyseBf62RWJmLXrA+/WSWlti5k6xrlCgXKNS8RfFk8SHlGwl0fdtm1q0ZpPkfQDofwoK+duyXtPKsRW4kw4cWl8o86u8o=
In-Reply-To: <20210421230301.GP1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Thursday, April 22, 2021 7:03 AM
>=20
> > The pseudo code above really suggests you do want to remove
> > /dev/vfio/vfio, but this is only one of the IOMMU backends for vfio, so
> > I can't quite figure out if we're talking past each other.
>=20
> I'm not quite sure what you mean by "one of the IOMMU backends?" You
> mean type1, right?

I think Alex meant that type1 is one of the IOMMU backends in VFIO (type1,
type1v2, tce, tce_v2, noiommu, etc.) which are all configured through=20
/dev/vfio/vfio. If we are just moving type1 to /dev/ioasid, the justificati=
on
is not sufficient by replacing /dev/vfio/vfio with /dev/ioasid, at least in
this transition phase (before all iommu bits are consolidated in /dev/ioasi=
d
in your ideal outcome).

>=20
> > As I expressed in another thread, type1 has a lot of shortcomings.  The
> > mapping interface leaves userspace trying desperately to use statically
> > mapped buffers because the map/unmap latency is too high.  We have
> > horrible issues with duplicate locked page accounting across
> > containers.  It suffers pretty hard from feature creep in various
> > areas.  A new IOMMU backend is an opportunity to redesign some of these
> > things.
>=20
> Sure, but also those kinds of transformational things go alot better
> if you can smoothly go from the old to the new and have technical
> co-existance in side the kernel. Having a shim that maps the old APIs
> to new APIs internally to Linux helps keep the implementation from
> becoming too bogged down with compatibility.

The shim layer could be considered as a new iommu backend in VFIO,
which connects VFIO iommu ops to the internal helpers in drivers/ioasid.
In this case then we don't need to replicate the VFIO uAPI through
/dev/ioasid. Instead the new interface just supports new uAPI. An old
VFIO userspace still opens /dev/vfio/vfio to conduct iommu operations
which implicitly goes to drivers/ioasid. A new VFIO userspace uses=20
/dev/vfio/vfio to join ioasid_fd and then use new uAPIs through /dev/
ioasid to manage iommu pgtables, as you described below.

>=20
> > The IOMMU group also abstracts isolation and visibility relative to
> > DMA.  For example, in a PCIe topology a multi-function device may not
> > have isolation between functions, but each requester ID is visible to
> > the IOMMU.
>=20
> Okay, I'm glad I have this all right in my head, as I was pretty sure
> this was what the group was about.
>=20
> My next question is why do we have three things as a FD: group, device
> and container (aka IOMMU interface)?
>=20
> Do we have container because the /dev/vfio/vfio can hold only a single
> page table so we need to swap containers sometimes?

Yes, one container can hold only a single page table. When vIOMMU is
exposed, VFIO requires each device/group in different containers to
support per-device address space (before nested translation is supported),
which is switched between GPA and gIOVA when bypass mode is turned=20
on/off for a given device.

Another tricky thing is that a container may be linked to multiple iommu
domains in VFIO, as devices in the container may locate behind different
IOMMUs with inconsistent capability (commit 1ef3e2bc). In this case=20
more accurately one container can hold a single address space, which could
be replayed into multiple page tables (with exact same mappings). I'm not
sure whether this is something that could be simplified (or not supported)
in the new interface. In the end each pgtable operation is per iommu domain
in the iommu layer. I wonder where we want to maintain the relationship
between the ioasid_fd and associated iommu domains.

>=20
> If we start from a clean sheet and make a sketch..
>=20
> /dev/ioasid is the IOMMU control interface. It can create multiple
> IOASIDs that have page tables and it can manipulate those page tables.
> Each IOASID is identified by some number.
>=20
> struct vfio_device/vdpa_device/etc are consumers of /dev/ioasid
>=20
> When a device attaches to an ioasid userspace gives VFIO/VDPA the
> ioasid FD and the ioasid # in the FD.
>=20
> The security rule for isolation is that once a device is attached to a
> /dev/ioasid fd then all other devices in that security group must be
> attached to the same ioasid FD or left unused.
>=20
> Thus /dev/ioasid also becomes the unit of security and the IOMMU
> subsystem level becomes aware of and enforces the group security
> rules. Userspace does not need to "see" the group
>=20
> In sketch it would be like
>   ioasid_fd =3D open("/dev/ioasid");
>   vfio_device_fd =3D open("/dev/vfio/device0")
>   vdpa_device_fd =3D open("/dev/vdpa/device0")
>   ioctl(vifo_device_fd, JOIN_IOASID_FD, ioasifd)
>   ioctl(vdpa_device_fd, JOIN_IOASID_FD, ioasifd)
>=20
>   gpa_ioasid_id =3D ioctl(ioasid_fd, CREATE_IOASID, ..)
>   ioctl(ioasid_fd, SET_IOASID_PAGE_TABLES, ..)
>=20
>   ioctl(vfio_device, ATTACH_IOASID, gpa_ioasid_id)
>   ioctl(vpda_device, ATTACH_IOASID, gpa_ioasid_id)
>=20
>   .. both VDPA and VFIO see the guest physical map and the kernel has
>      enough info that both could use the same IOMMU page table
>      structure ..
>=20
>   // Guest viommu turns off bypass mode for the vfio device
>   ioctl(vfio_device, DETATCH_IOASID)
>=20
>   // Guest viommu creates a new page table
>   rid_ioasid_id =3D ioctl(ioasid_fd, CREATE_IOASID, ..)
>   ioctl(ioasid_fd, SET_IOASID_PAGE_TABLES, ..)
>=20
>   // Guest viommu links the new page table to the RID
>   ioctl(vfio_device, ATTACH_IOASID, rid_ioasid_id)

Just to confirm. Above flow is for current map/unmap flavor as what
VFIO/vDPA do today. Later when nested translation is supported,
there is no need to detach gpa_ioasid_fd. Instead, a new cmd will
be introduced to nest rid_ioasid_fd on top of gpa_ioasid_fd:

ioctl(ioasid_fd, NEST_IOASIDS, rid_ioasid_id, gpa_ioasid_id);
ioctl(ioasid_fd, BIND_PGTABLE, rid_ioasid_id, ...);

and vSVA will follow the same flow:

ioctl(ioasid_fd, NEST_IOASIDS, sva_ioasid_id, gpa_ioasid_id);
ioctl(ioasid_fd, BIND_PGTABLE, sva_ioasid_id, ...);

Does it match your mind when expanding /dev/ioasid to support
vSVA and other new usages?

>=20
> The group security concept becomes implicit and hidden from the
> uAPI. JOIN_IOASID_FD implicitly finds the device's group inside the
> kernel and requires that all members of the group be joined only to
> this ioasid_fd.
>=20
> Essentially we discover the group from the device instead of the
> device from the group.
>=20
> Where does it fall down compared to the three FD version we have
> today?
>=20

I also feel hiding group from uAPI is a good thing and is interested in
the rationale behind for explicitly managing group in vfio (which is
essentially the same boundary as provided by iommu group), e.g. for=20
better user experience when group security is broken?=20

Thanks
Kevin
