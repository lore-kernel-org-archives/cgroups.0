From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 4 May 2021 08:41:48 -0700
Message-ID: <20210504084148.4f61d0b5@jacob-builder>
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
        <20210426123817.GQ1370958@nvidia.com>
        <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MWHPR11MB188625137D5B7423822396C88C409-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jacob.jun.pan@l

Hi Kevin,

On Wed, 28 Apr 2021 06:34:11 +0000, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
wrote:

> > 
> > (also looking at ioasid.c, why do we need such a thin and odd wrapper
> > around xarray?)
> >   
> 
> I'll leave it to Jean and Jacob.
I am not sure whether you are referring to the current ioasid.c or the
changes proposed in this patchset. I added a per VM/ioasid_set
(also per /dev/ioasid fd) xarray to store guest-host PASID mapping.

The current code has a xarray for the allocators.

struct ioasid_allocator_data {
	struct ioasid_allocator_ops *ops;
	struct list_head list;
	struct list_head slist;
#define IOASID_ALLOCATOR_CUSTOM BIT(0) /* Needs framework to track results */
	unsigned long flags;
	struct xarray xa;
	struct rcu_head rcu;
};

Could you elaborate?

Thanks,

Jacob
