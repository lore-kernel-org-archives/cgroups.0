From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 4 May 2021 20:15:30 -0300
Message-ID: <20210504231530.GE1370958@nvidia.com>
References: <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504084148.4f61d0b5@jacob-builder>
 <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLArOltAOURLFEyuzKk6PJmJ0pfXnOd1SuIahF/sRjY=;
 b=GxRbyVPgdwFtFgyoa4wQA4EGmiWBYPbCwRFPeyYyDyHnYYs/0SoQNe05NHcqaTQdCwt0MNwkNwSz+3DA00sgo2LL0XQRYLm/IMfzyp47L8kdCzbr9GOr5uncuADU3gd8QRy8ms1qHi0OWFPw9L/QyLZL1FGNJykfnzUnHjgjHQR5Crsi/G2a1pH7Qm+I3XhlTdJHHbwuqNQyDSlxmlqSzVk4h7gSXu+1gADhLaXgcFLtO74je+YNnHdnvsZGARjWvCxdxwJFW4gVkIAg36d6rqPXkokwhyZJdKHWkerXxPDDPsDszRX8hkW3qJeR5JvnOa3L1vc0r4xk/RL4YNAmCw==
Content-Disposition: inline
In-Reply-To: <20210504151154.02908c63@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, May 04, 2021 at 03:11:54PM -0700, Jacob Pan wrote:

> > It is a weird way to use xarray to have a structure which
> > itself is just a wrapper around another RCU protected structure.
> > 
> > Make the caller supply the ioasid_data memory, embedded in its own
> > element, get rid of the void * and rely on XA_ZERO_ENTRY to hold
> > allocated but not active entries.
> > 
> Let me try to paraphrase to make sure I understand. Currently
> struct ioasid_data is private to the iasid core, its memory is allocated by
> the ioasid core.
> 
> You are suggesting the following:
> 1. make struct ioasid_data public
> 2. caller allocates memory for ioasid_data, initialize it then pass it to
> ioasid_alloc to store in the xarray
> 3. caller will be responsible for setting private data inside ioasid_data
> and do call_rcu after update if needed.

Basically, but you probably won't need a "private data" once the
caller has this struct as it can just embed it in whatever larger
struct makes sense for it and use container_of/etc

I didn't look too closely at the whole thing though. Honestly I'm a
bit puzzled why we need a pluggable global allocator framework.. The
whole framework went to some trouble to isolate everything into iommu
drivers then that whole design is disturbed by this global thing.

Jason
