From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Sat, 8 May 2021 07:31:18 +0000
Message-ID: <MWHPR11MB18862452FD4172DCA70C89B88C569@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210421162307.GM1370958@nvidia.com>
        <20210421105451.56d3670a@redhat.com>    <20210421175203.GN1370958@nvidia.com>
        <20210421133312.15307c44@redhat.com>    <20210421230301.GP1370958@nvidia.com>
        <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210422121020.GT1370958@nvidia.com>
        <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210423114944.GF1370958@nvidia.com>
        <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210426123817.GQ1370958@nvidia.com>
        <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210428090625.5a05dae8@redhat.com>
        <MWHPR11MB1886E0A7897758AA7BE509058C579@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210507110614.7b8e6998@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftc+eb/EoO9EFb6GQNuUVZYAdBI/Nu/+QxkOv588uhM=;
 b=PlwpRFtAmyxTur7RKanrUNMNllsDB7BBi3u01Jc3XXFUvRATkPBVcRFbLi44rfLN1K8T2uUUSDpbLoEn86FIs39feydr99s+cz14hJLsSLkwz0YlnBUIxlev7dXk0BqpAV+BqZymkeygebRc/Z4gK84FElSRPWp9Q/hPIxBuWFQ=
In-Reply-To: <20210507110614.7b8e6998-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Sent: Saturday, May 8, 2021 1:06 AM
>=20
> > > Those are the main ones I can think of.  It is nice to have a simple
> > > map/unmap interface, I'd hope that a new /dev/ioasid interface wouldn=
't
> > > raise the barrier to entry too high, but the user needs to have the
> > > ability to have more control of their mappings and locked page
> > > accounting should probably be offloaded somewhere.  Thanks,
> > >
> >
> > Based on your feedbacks I feel it's probably reasonable to start with
> > a type1v2 semantics for the new interface. Locked accounting could
> > also start with the same VFIO restriction and then improve it
> > incrementally, if a cleaner way is intrusive (if not affecting uAPI).
> > But I didn't get the suggestion on "more control of their mappings".
> > Can you elaborate?
>=20
> Things like I note above, userspace cannot currently specify mapping
> granularity nor has any visibility to the granularity they get from the
> IOMMU.  What actually happens in the IOMMU is pretty opaque to the user
> currently.  Thanks,
>=20

It's much clearer. Based on all the discussions so far I'm thinking about
a staging approach when building the new interface, basically following
the model that Jason pointed out - generic stuff first, then platform=20
specific extension:

Phase 1: /dev/ioasid with core ingredients and vfio type1v2 semantics
    - ioasid is the software handle representing an I/O page table
    - uAPI accepts a type1v2 map/unmap semantics per ioasid
    - helpers for VFIO/VDPA to bind ioasid_fd and attach ioasids
    - multiple ioasids are allowed without nesting (vIOMMU, or devices
w/ incompatible iommu attributes)
    - an ioasid disallows any operation before it's attached to a device
    - an ioasid inherits iommu attributes from the 1st device attached
to it
    - userspace is expected to manage hardware restrictions and the
kernel only returns error when restrictions are broken
        * map/unmap on an ioasid will fail before every device in a group=20
is attached to it
        * ioasid attach will fail if the new device has incompatibile iommu
attribute as that of this ioasid
    - thus no group semantics in uAPI
    - no change to vfio container/group/type1 logic, for running existing
vfio applications
        * imply some duplication between vfio type1 and ioasid for some tim=
e
    - new uAPI in vfio to allow explicit opening of a device and then bindi=
ng
it to the ioasid_fd
        * possibly require each device exposed in /dev/vfio/
    - support both pdev and mdev

Phase 2: ioasid nesting
    - Allow bind/unbind_pgtable semantics per ioasid
    - Allow ioasid nesting=20
        * HW ioasid nesting if supported by platform
        * otherwise fall back to SW ioasid nesting (in-kernel shadowing)
    - iotlb invalidation per ioasid
    - I/O page fault handling per ioasid
    - hw_id is not exposed in uAPI. Vendor IOMMU driver decides
when/how hw_id is allocated and programmed properly

Phase3: optimizations and vendor extensions (order undefined, up to
the specific feature owner):
    - (Intel) ENQCMD support with hw_id exposure in uAPI
    - (ARM/AMD) RID-based pasid table assignment
    - (PPC) window-based iova management
    - Optimizations:
        * replace vfio type1 with a shim driver to use ioasid backend
        * mapping granularity
        * HW dirty page tracking
        * ...

Does above sounds a sensible plan? If yes we'll start working on=20
phase1 then...

Thanks
Kevin
