From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 26 Apr 2021 09:38:17 -0300
Message-ID: <20210426123817.GQ1370958@nvidia.com>
References: <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOlurQmXmbDShxP4zI/UwwA0xTTiZnMgbw91KKw+w9Y=;
 b=pK7tjSDVxjWxR6OBPJP8VKdsxlAQbnRrbjt+npzKtVjTr5cMRt9EXhftMNvnApUZOHK1NMyzYfw3XzylK5w/DAImAF1yLXN7WLHpUMnobk1maWeRazoJS4U1N658hSj+Tcc1Sgrny4vF2NT9WuUKwdUtAd68pWTguRe877ab13+vUo4p9yPEtnC+M82n6ic4c7YfMRG3H82+xvfgWss2rskXWixT4j0A+taeGe1vky3dXb/hVA1W+QncsGpqRJj0e2rVS58Duwgmd6yWy22e29c/tLhTiYFdi/+psJdfOWisbEiZr5dfYqX44OBU23qzDQr8eheNAhmeGcSkima0jQ==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18861FE6982D73AFBF173E048C439-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sun, Apr 25, 2021 at 09:24:46AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Friday, April 23, 2021 7:50 PM
> >=20
> > On Fri, Apr 23, 2021 at 09:06:44AM +0000, Tian, Kevin wrote:
> >=20
> > > Or could we still have just one /dev/ioasid but allow userspace to cr=
eate
> > > multiple gpa_ioasid_id's each associated to a different iommu domain?
> > > Then the compatibility check will be done at ATTACH_IOASID instead of
> > > JOIN_IOASID_FD.
> >=20
> > To my mind what makes sense that that /dev/ioasid presents a single
> > IOMMU behavior that is basically the same. This may ultimately not be
> > what we call a domain today.
> >=20
> > We may end up with a middle object which is a group of domains that
> > all have the same capabilities, and we define capabilities in a way
> > that most platforms have a single group of domains.
> >=20
> > The key capability of a group of domains is they can all share the HW
> > page table representation, so if an IOASID instantiates a page table
> > it can be assigned to any device on any domain in the gruop of domains.
>=20
> Sorry that I didn't quite get it. If a group of domains can share the=20
> same page table then why not just attaching all devices under those
> domains into a single domain?

Sure, if that works. But you shouldn't have things like IOMMU_CACHE
create different domains or trigger different /dev/ioasid's

> to describe the HW page table. Ideally a new iommu domain should
> be created only when it's impossible to share an existing page table.=20
> Otherwise you'll get bad iotlb efficiency because each domain has its
> unique domain id (tagged in iotlb) then duplicated iotlb entries may
> exist even when a single page table is shared by those domains.

Right, fewer is better

> Or, can you elaborate what is the targeted usage by having a group of
> domains which all share the same page table?

You just need to have clear rule what what requires a new /dev/ioasid
FD - and if it maps to domains then great.

> Want to hear your opinion for one open here. There is no doubt that
> an ioasid represents a HW page table when the table is constructed by=20
> userspace and then linked to the IOMMU through the bind/unbind
> API. But I'm not very sure about whether an ioasid should represent=20
> the exact pgtable or the mapping metadata when the underlying=20
> pgtable is indirectly constructed through map/unmap API. VFIO does
> the latter way, which is why it allows multiple incompatible domains
> in a single container which all share the same mapping metadata.

I think VFIO's map/unmap is way too complex and we know it has bad
performance problems.=20

If /dev/ioasid is single HW page table only then I would focus on that
implementation and leave it to userspace to span different
/dev/ioasids if needed.

> OK, now I see where the disconnection comes from. In my context ioasid
> is the identifier that is actually used in the wire, but seems you treat =
it as=20
> a sw-defined namespace purely for representing page tables. We should=20
> clear this concept first before further discussing other details. =F0=9F=
=98=8A

There is no general HW requirement that every IO page table be
referred to by the same PASID and this API would have to support
non-PASID IO page tables as well. So I'd keep the two things
separated in the uAPI - even though the kernel today has a global
PASID pool.

> Then following your proposal, does it mean that we need another
> interface for allocating PASID? and since ioasid means different
> thing in uAPI and in-kernel API, possibly a new name is required to
> avoid confusion?

I would suggest have two ways to control the PASID

 1) Over /dev/ioasid allocate a PASID for an IOASID. All future PASID
    based usages of the IOASID will use that global PASID

 2) Over the device FD, when the IOASID is bound return the PASID that
    was selected. If the IOASID does not have a global PASID then the
    kernel is free to make something up. In this mode a single IOASID
    can have multiple PASIDs.

Simple things like DPDK can use #2 and potentially have better PASID
limits. hypervisors will most likely have to use #1, but it depends on
how their vIOMMU interface works.

I think the name IOASID is fine for the uAPI, the kernel version can
be called ioasid_id or something.

(also looking at ioasid.c, why do we need such a thin and odd wrapper
around xarray?)

Jason
