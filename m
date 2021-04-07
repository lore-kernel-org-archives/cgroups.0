From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 7 Apr 2021 08:17:50 +0000
Message-ID: <MWHPR11MB1886A7E4C6F3E3A81240517B8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder> <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder> <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <fa57bde5-472f-6e66-3521-bfac7d6e4f8d@redhat.com>
 <20210406124251.GO7405@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQFXd0Ztxf4n+0ZhWQnNR6RE0AxFwFoKz0KzltMML8A=;
 b=OSyg3TLz9GFm2HnC9GGvMcGQ/JHQIuQxedaMdsOIovSC/LF3Ag09YdM5ehWnaApQ6j3s6RXgIY8LX53qv3VN4JrXvNDLKNWtvipO6xACKL8NCyu/qTqesU+6oDPhkpFqFe5sncRC2c9WVWiaGvlchr1PY3okc9j+EyBREP6kd1U=
In-Reply-To: <20210406124251.GO7405-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Jason Gunthorpe
> Sent: Tuesday, April 6, 2021 8:43 PM
>=20
> On Tue, Apr 06, 2021 at 09:35:17AM +0800, Jason Wang wrote:
>=20
> > > VFIO and VDPA has no buisness having map/unmap interfaces once we
> have
> > > /dev/ioasid. That all belongs in the iosaid side.
> > >
> > > I know they have those interfaces today, but that doesn't mean we hav=
e
> > > to keep using them for PASID use cases, they should be replaced with =
a
> > > 'do dma from this pasid on /dev/ioasid' interface certainly not a
> > > 'here is a pasid from /dev/ioasid, go ahead and configure it youself'
> > > interface
> >
> > So it looks like the PASID was bound to SVA in this design. I think it'=
s not
> > necessairly the case:
>=20
> No, I wish people would stop talking about SVA.
>=20
> SVA and vSVA are a very special narrow configuration of a PASID. There
> are lots of other PASID configurations! That is the whole point, a
> PASID is complicated, there are many configuration scenarios, they
> need to be in one place with a very clearly defined uAPI
>=20

I feel it also makes sense to allow a subsystem to specify which configurat=
ions
are permitted when allowing a PASID on its device, e.g. excluding things li=
ke
GPA mappings that existing subsystems (VFIO/VDPA) already handle well:

- Share GPA mappings between multiple devices (w/ or w/o PASID) for=20
better IOTLB efficiency;

- Share GPA mappings between transactions w/ PASID and transactions w/o
PASID from the same device (e.g. GPU) for better IOTLB efficiency;

- Use the same page table for GPA mappings before and after the guest=20
turns on/off the PASID capability;

All above are given as long as we continue to let VFIO/VDPA manage the
iommu domain and associated GPA mappings for PASID. The IOMMU driver=20
already ensures a nested PASID entry linking to the established GPA paging=
=20
structure of the domain when the 1st-level pgtable is bound through=20
/dev/ioasid.=20

In contrast, above merits are lost if forcing a model where GPA mappings
for PASID must be constructed through /dev/ioasid, as this will lead to
multiple paging structures for the same GPA mappings implying worse=20
IOTLB usage and unnecessary cost of invalidations.

Therefore, I envision a scheme where the subsystem could specify=20
permitted PASID configurations when doing ALLOW_PASID, and then=20
userspace queries per-PASID capability to learn which operations
are allowed, e.g.:

1) To enable vSVA, VFIO/VDPA allows pgtable binding and related invalidatio=
n/
fault ops through /dev/ioasid;

2) for vDPA control vq usage, no configuration is allowed through /dev/ioas=
id;

3) for new subsystem which doesn't carry any legacy or similar usage as=20
VFIO/VDPA, it could permit all configurations through /dev/ioasid including=
=20
1st-level binding and 2nd-level mapping ops;

This approach also allows us to grow the uAPI in a staging approach. Now=20
focus on 1) and 2) as VFIO/VDPA are the only two users for now with good
legacy to cover the GPA mappings. More ops can be introduced for 3) when=20
there is a real example to show what exact ops are required for such a new=
=20
subsystem.

Is this a good strategy to move forward?

btw this discussion was raised when discussing the I/O page fault handling
process. Currently the IOMMU layer implements a per-device fault reporting
mechanism, which requires VFIO to register a handler to receive all faults=
=20
on its device and then forwards to ioasid if it's due to 1st-level. Possibl=
y it=20
makes more sense to convert it into a per-pgtable reporting scheme, and=20
then the owner of each pgtable should register its own handler. It means
for 1) VFIO will register a 2nd-level pgtable handler while /dev/ioasid
will register a 1st-level pgtable handler, while for 3) /dev/ioasid will re=
gister=20
handlers for both 1st-level and 2nd-level pgtable. Jean? also want to know=
=20
your thoughts... =20

Thanks
Kevin
