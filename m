From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 7 May 2021 15:15:11 -0700
Message-ID: <20210507151511.612d1424@jacob-builder>
References: <20210505102259.044cafdf@jacob-builder>
        <20210505180023.GJ1370958@nvidia.com>
        <20210505130446.3ee2fccd@jacob-builder>
        <YJOZhPGheTSlHtQc@myrica>
        <20210506122730.GQ1370958@nvidia.com>
        <20210506163240.GA9058@otc-nc-03>
        <20210507172051.GW1370958@nvidia.com>
        <20210507181458.GA73499@otc-nc-03>
        <20210507182050.GX1370958@nvidia.com>
        <20210507192325.GB73499@otc-nc-03>
        <20210507192810.GY1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210507192810.GY1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

Hi Jason,

On Fri, 7 May 2021 16:28:10 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> > The unanswered question is how do we plumb from vIOMMU without a custom
> > allocator to get a system wide PASID?   
> 
> PASID allocation is part of the iommu driver, it really shouldn't be
> global.
> 
In the current code, the pluggable custom allocator *is* part of the iommu
vendor driver. If it decides the allocation is global then it should be
suitable for the platform since there will never be a VT-d IOMMU on another
vendor's platform.

It is true that the default allocator is global which suites the current
needs. I am just wondering if we are solving a problem does not exist yet.

> When the architecture code goes to allocate a single PASID for the
> mm_struct it should flag that allocation request with a 'must work for
> all RIDs flag' and the iommu driver should take care of it. That might
> mean the iommu driver consults a global static xarray, or maybe it
> does a hypercall, but it should be done through that API, not a side
> care global singleton.
Why do we need to flag the allocation every time if on a platform *every*
PASID can potentially be global? At the time of allocation, we don't know
if the PASID will be used for a shared (ENQCMD) or a dedicated workqueue.

Thanks,

Jacob
