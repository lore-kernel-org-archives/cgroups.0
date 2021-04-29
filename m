From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 28 Apr 2021 21:21:49 -0300
Message-ID: <20210429002149.GZ1370958@nvidia.com>
References: <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wf0FFjCU92BRz2ovOAkN3QZk/lQx+XcNXHCwnSKh++g=;
 b=GaacGmeHXHXdN4305GmDC9fhEkaja/py8uRlvHrEEwwsKUMTiybDxh/0Iwtluf1yOx3zhjjUc4wDpDKLd26gXqzTyGExzjDDxOiC0EAHHEs7CXlL+UCCNf8VqmFpyOTSquC9dXGqVbI0CuuzsgEVOhS1f9r+y+xW6DZsheGh+FaRmMYY2BENJaXAErnJJaAXaz+eWKvuT2CI+FJN+6d2nl1WgHaNDv8281oumsOQNxMu1lbeOLLmW4AkbBiTUBVvUViqWzTm1CxEvIyk9v1YwhnIZajir2Ia5lWNZn4h3IVfgS4e2WgixF4HKs2hVkt3WtA3rW+bx10eMhwNTYO1xQ==
Content-Disposition: inline
In-Reply-To: <YIi5G4Wg/hpFqNdX-l+x2Y8Cxqc4e6aEkudXLsA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Apr 28, 2021 at 11:23:39AM +1000, David Gibson wrote:

> Yes.  My proposed model for a unified interface would be that when you
> create a new container/IOASID, *no* IOVAs are valid.

Hurm, it is quite tricky. All IOMMUs seem to have a dead zone around
the MSI window, so negotiating this all in a general way is not going
to be a very simple API.

To be general it would be nicer to say something like 'I need XXGB of
IOVA space' 'I need 32 bit IOVA space' etc and have the kernel return
ranges that sum up to at least that big. Then the kernel can do its
all its optimizations.

I guess you are going to say that the qemu PPC vIOMMU driver needs
more exact control..

> I expect we'd need some kind of query operation to expose limitations
> on the number of windows, addresses for them, available pagesizes etc.

Is page size an assumption that hugetlbfs will always be used for backing
memory or something?

> > As an ideal, only things like the HW specific qemu vIOMMU driver
> > should be reaching for all the special stuff.
> 
> I'm hoping we can even avoid that, usually.  With the explicitly
> created windows model I propose above, it should be able to: qemu will
> create the windows according to the IOVA windows the guest platform
> expects to see and they either will or won't work on the host platform
> IOMMU.  If they do, generic maps/unmaps should be sufficient.  If they
> don't well, the host IOMMU simply cannot emulate the vIOMMU so you're
> out of luck anyway.

It is not just P9 that has special stuff, and this whole area of PASID
seems to be quite different on every platform

If things fit very naturally and generally then maybe, but I've been
down this road before of trying to make a general description of a
group of very special HW. It ended in tears after 10 years when nobody
could understand the "general" API after it was Frankenstein'd up with
special cases for everything. Cautionary tale

There is a certain appeal to having some
'PPC_TCE_CREATE_SPECIAL_IOASID' entry point that has a wack of extra
information like windows that can be optionally called by the viommu
driver and it remains well defined and described.

Jason
