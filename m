From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 5 Apr 2021 20:42:30 -0300
Message-ID: <20210405234230.GF7405@nvidia.com>
References: <20210319124645.GP2356281@nvidia.com>
 <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1RQeoDaVVHz6tzdTwIHAww8PRvtuS0cmUnaKDvh6LI=;
 b=j2KiEIywQUSWO8QrYNXGpMwyJOLyKsl1OUQBMKwUEYz/30kn60QGFk59gpe/Uz6EjA0wgNMGrLgVFADl0pbnD3q48Q0q8gCEddCCZBweEM9ulugWwSDUVZvcmXLQuRev26XroeDcQGNHLeIMOolY9NIR6vOC+Z8saqgVS5SfwkzZT3ODIWLKvACvw0W+QdmRICh7geqVPYbwJDFa23CvTiOC1xVyI25vu45F6Ejv/bbXCTxorNdIOKlrYaWLP0OBZRb9Vdu5gbv9NPXxXakMLWEB15SEkz6UMRsXW0Tj+YYR6OqcMk7N0gm+o3aHF/JQf/q8mfmEMwAIj21F8IyiHA==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, Apr 02, 2021 at 08:22:28AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Tuesday, March 30, 2021 9:29 PM
> > 
> > >
> > > First, userspace may use ioasid in a non-SVA scenario where ioasid is
> > > bound to specific security context (e.g. a control vq in vDPA) instead of
> > > tying to mm. In this case there is no pgtable binding initiated from user
> > > space. Instead, ioasid is allocated from /dev/ioasid and then programmed
> > > to the intended security context through specific passthrough framework
> > > which manages that context.
> > 
> > This sounds like the exact opposite of what I'd like to see.
> > 
> > I do not want to see every subsystem gaining APIs to program a
> > PASID. All of that should be consolidated in *one place*.
> > 
> > I do not want to see VDPA and VFIO have two nearly identical sets of
> > APIs to control the PASID.
> > 
> > Drivers consuming a PASID, like VDPA, should consume the PASID and do
> > nothing more than authorize the HW to use it.
> > 
> > quemu should have general code under the viommu driver that drives
> > /dev/ioasid to create PASID's and manage the IO mapping according to
> > the guest's needs.
> > 
> > Drivers like VDPA and VFIO should simply accept that PASID and
> > configure/authorize their HW to do DMA's with its tag.
> > 
> 
> I agree with you on consolidating things in one place (especially for the
> general SVA support). But here I was referring to an usage without 
> pgtable binding (Possibly Jason. W can say more here), where the 
> userspace just wants to allocate PASIDs, program/accept PASIDs to 
> various workqueues (device specific), and then use MAP/UNMAP 
> interface to manage address spaces associated with each PASID. 
> I just wanted to point out that the latter two steps are through 
> VFIO/VDPA specific interfaces. 

No, don't do that.

VFIO and VDPA has no buisness having map/unmap interfaces once we have
/dev/ioasid. That all belongs in the iosaid side.

I know they have those interfaces today, but that doesn't mean we have
to keep using them for PASID use cases, they should be replaced with a
'do dma from this pasid on /dev/ioasid' interface certainly not a
'here is a pasid from /dev/ioasid, go ahead and configure it youself'
interface

This is because PASID is *complicated* in the general case! For
instance all the two level stuff you are talking about must not leak
into every user!

Jason
