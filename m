From: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 2 Apr 2021 12:46:55 +0000
Message-ID: <BN6PR11MB4068B9036B42149B67B91596C37A9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com> <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401115429.GY1463678@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vm7NTg3K0kFXE8D3AyfvDPNcSWG4w49e2zUafSmcjVM=;
 b=TGedR3cAugb/H7EiEWHu0lVhu+TBlyWHaAjxXXPiyOxKmoIz+z/7REdPsSj7AOz7yPyKQFkCqCFIFCMjltNIUc0yzkT1zzoeWs12j7KJw23cWn/nd5HCGtdnJNf/z0G3hsvVctyoY70wbA/Sx35H+/8bGEL66iB4fsHPfnjhfYQ=
In-Reply-To: <20210401115429.GY1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Jason,

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Thursday, April 1, 2021 7:54 PM
>=20
> On Thu, Apr 01, 2021 at 07:04:01AM +0000, Liu, Yi L wrote:
>=20
> > After reading your reply in https://lore.kernel.org/linux-
> iommu/20210331123801.GD1463678-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org/#t
> > So you mean /dev/ioasid FD is per-VM instead of per-ioasid, so above
> skeleton
> > doesn't suit your idea.
>=20
> You can do it one PASID per FD or multiple PASID's per FD. Most likely
> we will have high numbers of PASID's in a qemu process so I assume
> that number of FDs will start to be a contraining factor, thus
> multiplexing is reasonable.
>=20
> It doesn't really change anything about the basic flow.
>=20
> digging deeply into it either seems like a reasonable choice.
>=20
> > +-----------------------------+----------------------------------------=
-------+
> > |      userspace              |               kernel space             =
       |
> > +-----------------------------+----------------------------------------=
-------+
> > | ioasid_fd =3D                 | /dev/ioasid does below:              =
         |
> > | open("/dev/ioasid", O_RDWR);|   struct ioasid_fd_ctx {               =
       |
> > |                             |       struct list_head ioasid_list;    =
       |
> > |                             |       ...                              =
       |
> > |                             |   } ifd_ctx; // ifd_ctx is per ioasid_f=
d      |
>=20
> Sure, possibly an xarray not a list
>=20
> > +-----------------------------+----------------------------------------=
-------+
> > | ioctl(ioasid_fd,            | /dev/ioasid does below:                =
       |
> > |       ALLOC, &ioasid);      |   struct ioasid_data {                 =
       |
> > |                             |       ioasid_t ioasid;                 =
       |
> > |                             |       struct list_head device_list;    =
       |
> > |                             |       struct list_head next;           =
       |
> > |                             |       ...                              =
       |
> > |                             |   } id_data; // id_data is per ioasid  =
       |
> > |                             |                                        =
       |
> > |                             |   list_add(&id_data.next,              =
       |
> > |                             |            &ifd_ctx.ioasid_list);
> > |
>=20
> Yes, this should have a kref in it too
>=20
> > +-----------------------------+----------------------------------------=
-------+
> > | ioctl(device_fd,            | VFIO does below:                       =
       |
> > |       DEVICE_ALLOW_IOASID,  | 1) get ioasid_fd, check if ioasid_fd is=
 valid |
> > |       ioasid_fd,            | 2) check if ioasid is allocated from io=
asid_fd|
> > |       ioasid);              | 3) register device/domain info to /dev/=
ioasid |
> > |                             |    tracked in id_data.device_list      =
       |
> > |                             | 4) record the ioasid in VFIO's per-devi=
ce     |
> > |                             |    ioasid list for future security chec=
k      |
>=20
> You would provide a function that does steps 1&2 look at eventfd for
> instance.
>=20
> I'm not sure we need to register the device with the ioasid. device
> should incr the kref on the ioasid_data at this point.
>=20
> > +-----------------------------+----------------------------------------=
-------+
> > | ioctl(ioasid_fd,            | /dev/ioasid does below:                =
       |
> > |       BIND_PGTBL,           | 1) find ioasid's id_data               =
       |
> > |       pgtbl_data,           | 2) loop the id_data.device_list and tel=
l iommu|
> > |       ioasid);              |    give ioasid access to the devices
> > |
>=20
> This seems backwards, DEVICE_ALLOW_IOASID should tell the iommu to
> give the ioasid to the device.
>=20
> Here the ioctl should be about assigning a memory map from the the
> current
> mm_struct to the pasid
>=20
> > +-----------------------------+----------------------------------------=
-------+
> > | ioctl(ioasid_fd,            | /dev/ioasid does below:                =
       |
> > |       UNBIND_PGTBL,         | 1) find ioasid's id_data               =
       |
> > |       ioasid);              | 2) loop the id_data.device_list and tel=
l iommu|
> > |                             |    clear ioasid access to the devices  =
       |
>=20
> Also seems backwards. The ioctl here should be 'destroy ioasid' which
> wipes out the page table, halts DMA access and parks the PASID until
> all users are done.
>=20
> > +-----------------------------+----------------------------------------=
-------+
> > | ioctl(device_fd,            | VFIO does below:                       =
       |
> > |      DEVICE_DISALLOW_IOASID,| 1) check if ioasid is associated in VFI=
O's    |
> > |       ioasid_fd,            |    device ioasid list.                 =
       |
> > |       ioasid);              | 2) unregister device/domain info from  =
       |
> > |                             |    /dev/ioasid, clear in id_data.device=
_list  |
>=20
> This should disconnect the iommu and kref_put the ioasid_data

thanks for the comments, updated the skeleton a little bit, accepted your X=
array
and kref suggestion.

+-----------------------------+--------------------------------------------=
----+
|      userspace              |               kernel space                 =
    |
+-----------------------------+--------------------------------------------=
----+
| ioasid_fd =3D                 | /dev/ioasid does below:                  =
      |
| open("/dev/ioasid", O_RDWR);|   struct ioasid_fd_ctx {                   =
    |
|                             |        struct xarray xa;                   =
    |
|                             |       ...                                  =
    |
|                             |   } ifd_ctx; // ifd_ctx is per ioasid_fd   =
    |
+-----------------------------+--------------------------------------------=
----+
| ioctl(ioasid_fd,            | /dev/ioasid does below:                    =
    |
|       ALLOC, &ioasid);      |   struct ioasid_data {                     =
    |
|                             |       ioasid_t ioasid;                     =
    |
|                             |       refcount_t refs;                     =
    |
|                             |       ...                                  =
    |
|                             |   } id_data; // id_data is per ioasid      =
    |
|                             |                                            =
    |
|                             |   refcount_set(&id_data->refs, 1);         =
    |
+-----------------------------+--------------------------------------------=
----+
| ioctl(device_fd,            | VFIO does below:                           =
    |
|       DEVICE_ALLOW_IOASID,  | 1) get ioasid_fd, check if ioasid_fd is val=
id  |
|       ioasid_fd,            | 2) check if ioasid is allocated from ioasid=
_fd |
|       ioasid);              | 3) inr refcount on the ioasid              =
    |
|                             | 4) tell iommu to give the ioasid to the dev=
ice |
|                             |    by an iommu API. iommu driver needs to  =
    |
|                             |    store the ioasid/device info in a per   =
    |
|                             |    ioasid allow device list                =
    |
|                             | 5) record the ioasid in VFIO's per-device  =
    |
|                             |    ioasid list for future security check   =
    |
+-----------------------------+--------------------------------------------=
----+
| ioctl(ioasid_fd,            | /dev/ioasid does below:                    =
    |
|       BIND_PGTBL,           | 1) find ioasid's id_data                   =
    |
|       pgtbl_data,           | 2) call into iommu driver with ioasid, pgtb=
l   |
|       ioasid);              |    data, iommu driver setup the PASID entry=
[1] |
|                             |    with the ioasid and the pgtbl_data      =
    |
+-----------------------------+--------------------------------------------=
----+
| ioctl(ioasid_fd,            | /dev/ioasid does below:                    =
    |
|       CAHCE_INVLD,          | 1) find ioasid's id_data                   =
    |
|       inv_data,             | 2) call into iommu driver with ioasid, inv =
    |
|       ioasid);              |    data, iommu driver invalidates cache    =
    |
+-----------------------------+--------------------------------------------=
----+
| ioctl(ioasid_fd,            | /dev/ioasid does below:                    =
    |
|       UNBIND_PGTBL,         | 1) find ioasid's id_data                   =
    |
|       ioasid);              | 2) call into iommu driver with ioasid, iomm=
u   |
|                             |    driver destroy the PASID entry to block =
DMA |
|                             |    with this ioasid from device            =
    |
+-----------------------------+--------------------------------------------=
----+
| ioctl(device_fd,            | VFIO does below:                           =
    |
|      DEVICE_DISALLOW_IOASID,| 1) check if ioasid is associated in VFIO's =
    |
|       ioasid_fd,            |    device ioasid list                      =
    |
|       ioasid);              | 2) tell iommu driver to clear the device fr=
om  |
|                             |    its per-ioasid device allow list        =
    |
|                             | 3) put refcount on the ioasid              =
    |
+-----------------------------+--------------------------------------------=
----+
| ioctl(ioasid_fd,            | /dev/ioasid does below:                    =
    |
|       FREE, ioasid);        |  list_del(&id_data.next);                  =
    |
+-----------------------------+--------------------------------------------=
----+

[1] PASID entry is an entry in a per-device PASID table, this is where the
    page table pointer is stored. e.g. guest cr3 page table pointer. Setup
    PASID entry in a device's PASID table means the access is finally grant
    in IOMMU side.

I kept FREE as it seems to be more symmetric since there is an ALLOC
exposed to userspace. But yeah, I'm open with removing it all the same
if it's really unnecessary per your opinion.

Need your help again on an open.
The major purpose of this series is to support vSVA for guest based on
nested translation. And there is another usage case which is also based
on nested translation but don't have an ioasid. And still, it needs the
bind/unbind_pgtbl, cache_invalidation uAPI. It is gIOVA support. In this
usage, page table is a guest IOVA page table, VMM needs to bind this page
table to host and enabled nested translation, also needs to do cache
invalidation when guest IOVA page table has changes. It's very similar
with the page table bind of vSVA. Only difference is there is no ioasid
in the gIOVA case. Instead, gIOVA case requires device information. But
with regards to the uAPI reusing, need to fit gIOVA to /dev/ioasid model.
As of now, I think it may require user space passes a device FD to the
BIND/UNBIND_PGTBL and CAHCE_INVLD ioctl, then iommu driver can bind the
gIOVA page table to a correct device. Not sure if it looks good. Do you
have any suggestion on it?

[...]
> Include a sequence showing how the kvm FD is used to program the
> vPASID to pPASID table that ENQCMD uses.
>
> Show how dynamic authorization works based on requests from the
> guest's vIOMMU

I'd like to see if the updated skeleton suits your idea first, then
draw a more complete flow to show this.

Regards,
Yi Liu

> Jason
