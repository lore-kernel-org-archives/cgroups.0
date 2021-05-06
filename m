From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 6 May 2021 09:27:30 -0300
Message-ID: <20210506122730.GQ1370958@nvidia.com>
References: <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504084148.4f61d0b5@jacob-builder>
 <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
 <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder>
 <YJOZhPGheTSlHtQc@myrica>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pUnM+SoblgyZbKXGB2OAUHX8JozGAwl5FN3Tsj9wolY=;
 b=N6RKjJGv7FOBoEEGq39G6c/AJnzsTqSVxNB9XLw640NwdpxZUw+hnDX8icQlJq2n4USKfx9g1qwoDbdErQajsSMOQZ9iwEjMiWyaFRIzBlUGLiSh+PtJe9XpqaE67tI7Kuhp3IvT77mrMXyFxnkw4GYVbdW69fuP2B5r7YfVP/9pixhAYHoQYV9vT2s++U4DRPws08jKjhEkuDtZi3g1Hp2nYK57Ez4L0fSy7FXcsKBmh81WUINGBiOgNyQebVt5f0C2X+jsV1vzJi1YPS5hdHtfRgCgoouGq6nyoSV8Y/ij2g0skryCB7b3+mI2d/05ig/9b1GniDe/i6MU6BW8BQ==
Content-Disposition: inline
In-Reply-To: <YJOZhPGheTSlHtQc@myrica>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, May 06, 2021 at 09:23:48AM +0200, Jean-Philippe Brucker wrote:
> On Wed, May 05, 2021 at 01:04:46PM -0700, Jacob Pan wrote:
> > > > For ARM, since the guest owns the per device PASID table. There is no
> > > > need to allocate PASIDs from the host nor the hypervisor. Without SWQ,
> > > > there is no need for global PASID/SSID either. So PASID being global
> > > > for ARM is for simplicity in case of host PASID/SSID.  
> > > 
> > > It isn't clear how ARM can support PASID and mdev but that is an
> > > unrelated issue..
> > > 
> > AFAIK, the current SMMU device assignment is per RID, since only one stage2
> > page tables per RID, not per PASID. This is equivalent to the older VT-d
> > spec. prior to scalable mode.
> 
> Yes that's right. Since SMMUv3 has a single level-2 page table per RID, it
> doesn't support assigning level-1 page tables to guests for mdevs (sub-VF
> devices). So no PASIDs for mdevs, which also means each guest has its own
> PASID space and the host doesn't track guest PASIDs.

Basically it means when the guest's top level IOASID is created for
nesting that IOASID claims all PASID's on the RID and excludes any
PASID IOASIDs from existing on the RID now or in future.

Which would be a different behavior than something like Intel's top
level IOASID that doesn't claim all the PASIDs.

Lots of little special flags in here :|

Jason
