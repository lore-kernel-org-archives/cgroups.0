From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 23 Apr 2021 09:06:44 +0000
Message-ID: <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210415230732.GG1370958@nvidia.com>
 <20210416061258.325e762e@jacob-builder> <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com> <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com> <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZY/fsiSco6i483sTBPZUc1lvSlDhpfwkAWclbYetwIU=;
 b=YcIzM+HCHEbybzrsmwXq6+AKyobvUYWj+NycfZlTiSWBoX7F0Yde0GVE1yKg2J2ugLr6/5XUGbIeeNNqYnF0kyuF48+qgZwytd9FnWwrap8IjmrxxWIvwUMBunPDDYshYma03UZBGaSqz+lVMbhq8NBZ4ABra5SRUlUaK3rzfIk=
In-Reply-To: <20210422121020.GT1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> Sent: Thursday, April 22, 2021 8:10 PM
>=20
> On Thu, Apr 22, 2021 at 08:34:32AM +0000, Tian, Kevin wrote:
>=20
> > Another tricky thing is that a container may be linked to multiple iomm=
u
> > domains in VFIO, as devices in the container may locate behind differen=
t
> > IOMMUs with inconsistent capability (commit 1ef3e2bc).
>=20
> Frankly this sounds over complicated. I would think /dev/ioasid should
> select the IOMMU when the first device is joined, and all future joins
> must be compatible with the original IOMMU - ie there is only one set
> of IOMMU capabilities in a /dev/ioasid.

Or could we still have just one /dev/ioasid but allow userspace to create
multiple gpa_ioasid_id's each associated to a different iommu domain?=20
Then the compatibility check will be done at ATTACH_IOASID instead of=20
JOIN_IOASID_FD.

This does impose one burden to userspace though, to understand the=20
IOMMU compatibilities and figure out which incompatible features may
affect the page table management (while such knowledge is IOMMU
vendor specific) and then explicitly manage multiple /dev/ioasid's or=20
multiple gpa_ioasid_id's.

Alternatively is it a good design by having the kernel return error at=20
attach/join time to indicate that incompatibility is detected then the=20
userspace should open a new /dev/ioasid or creates a new gpa_ioasid_id
for the failing device upon such failure, w/o constructing its own=20
compatibility knowledge?

>=20
> This means qemue might have multiple /dev/ioasid's if the system has
> multiple incompatible IOMMUs (is this actually a thing?) The platform

One example is Intel platform with igd. Typically there is one IOMMU
dedicated for igd and the other IOMMU serving all the remaining devices.
The igd IOMMU may not support IOMMU_CACHE while the other one
does.

> should design its IOMMU domains to minimize the number of
> /dev/ioasid's required.
>=20
> Is there a reason we need to share IOASID'd between completely
> divergance IOMMU implementations? I don't expect the HW should be able
> to physically share page tables??

yes, e.g. in vSVA both devices (behind divergence IOMMUs) are bound
to a single guest process which has an unique PASID and 1st-level page
table. Earlier incompatibility example is only for 2nd-level.

>=20
> That decision point alone might be the thing that just says we can't
> ever have /dev/vfio/vfio =3D=3D /dev/ioasid

yes, unless we adopt the vfio scheme, i.e. implicitly managing incompatible=
=20
iommu domains in /dev/ioasid.

>=20
> > Just to confirm. Above flow is for current map/unmap flavor as what
> > VFIO/vDPA do today. Later when nested translation is supported,
> > there is no need to detach gpa_ioasid_fd. Instead, a new cmd will
> > be introduced to nest rid_ioasid_fd on top of gpa_ioasid_fd:
>=20
> Sure.. The tricky bit will be to define both of the common nested
> operating modes.
>=20
>   nested_ioasid =3D ioctl(ioasid_fd, CREATE_NESTED_IOASID,  gpa_ioasid_id=
);
>   ioctl(ioasid_fd, SET_NESTED_IOASID_PAGE_TABLES, nested_ioasid, ..)
>=20
>    // IOMMU will match on the device RID, no PASID:
>   ioctl(vfio_device, ATTACH_IOASID, nested_ioasid);
>=20
>    // IOMMU will match on the device RID and PASID:
>   ioctl(vfio_device, ATTACH_IOASID_PASID, pasid, nested_ioasid);

I'm a bit confused here why we have both pasid and ioasid notations togethe=
r.
Why not use nested_ioasid as pasid directly (i.e. every pasid in nested mod=
e
is created by CREATE_NESTED_IOASID)?

Below I list different scenarios for ATTACH_IOASID in my view. Here=20
vfio_device could be a real PCI function (RID), or a subfunction device=20
(RID+def_ioasid). The vfio_device could be attached to a gpa_ioasid=20
(RID in guest view, no nesting), a nested_ioasid (RID in guest view, nestin=
g)=20
or a nested_ioasid (RID+PASID in guest view, nesting).=20

// IOMMU will match on the device RID, no nesting, no PASID:
ioctl(vfio_device, ATTACH_IOASID, gpa_ioasid);

// IOMMU will match on the device (RID+def_ioasid), no nesting, no PASID:
ioctl(vfio_subdevice, ATTACH_IOASID, gpa_ioasid);

// IOMMU will match on the device RID, nesting, no PASID:
ioctl(vfio_device, ATTACH_IOASID, nested_ioasid);

// IOMMU will match on the device (RID+def_ioasid), nesting, no PASID:
ioctl(vfio_subdevice, ATTACH_IOASID, nested_ioasid);

// IOMMU will match on the device (RID+nested_ioasid), nesting, PASID:
ioctl(vfio_device, ATTACH_IOASID_PASID, nested_ioasid);

// IOMMU will match on the device (RID+nested_ioasid), nesting, PASID:
ioctl(vfio_subdevice, ATTACH_IOASID_PASID, nested_ioasid);

>=20
> Notice that ATTACH (or bind, whatever) is always done on the
> vfio_device FD. ATTACH tells the IOMMU HW to link the PCI BDF&PASID to
> a specific page table defined by an IOASID.
>=20
> I expect we have many flavours of IOASID tables, eg we have normal,
> and 'nested with table controlled by hypervisor'. ARM has 'nested with
> table controlled by guest' right? So like this?
>=20
>   nested_ioasid =3D ioctl(ioasid_fd, CREATE_DELGATED_IOASID,
>                    gpa_ioasid_id, <some kind of viommu_id>)
>   // PASID now goes to <viommu_id>
>   ioctl(vfio_device, ATTACH_IOASID_PASID, pasid, nested_ioasid);
>=20
> Where <viommu_id> is some internal to the guest handle of the viommu
> page table scoped within gpa_ioasid_id? Like maybe it is GPA of the
> base of the page table?
>=20
> The guest can't select its own PASIDs without telling the hypervisor,
> right?
>=20

If the whole PASID table is delegated to the guest in ARM case, the guest
can select its own PASIDs w/o telling the hypervisor. I haven't thought
carefully about a clean way to support this scheme, e.g. if mandating=20
guest to always allocate PASIDs through hypervisor even in this case
would it make the uAPI simpler...

Thanks
Kevin
