From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 16 Apr 2021 11:05:24 -0300
Message-ID: <20210416140524.GI1370958@nvidia.com>
References: <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
 <20210415230732.GG1370958@nvidia.com>
 <b1492fd3-8ce2-1632-3b14-73d8d4356fd7@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0NgyUKoUtcHRz74mviqvi9/LcKudual4GKXJDqQC5c=;
 b=Cz3z0QxDUMf2fWt5ha2QRgfG/61V3tNtxPcXrBifbBL/VCfYY/Z3di26sFm+JgcODnivN1w7i6AsqpQ///WGv0Goe4icuw2VZaC7IB8Rajy91RL/NGNDpQ5p/BrFlWnbv2vwXJAdKO8vY6n4XVn/aT92ZF+Tq7I+BK99O8lWFC6+D3rHa9/FIzL4OMlkC00arktCJicR8/JeDXbWP42YZsoMNTekiobH5VzMtDo7bPP3vF6zU0oQq/QFmV9UNpF0pvFCGu/1RRLxhPl32oFqMUX2lvUhUVQ4GthBzuRA0rEHLPC+13otjTh64x6L2Et448Zl6I6JXjH6bnBKhCFeXw==
Content-Disposition: inline
In-Reply-To: <b1492fd3-8ce2-1632-3b14-73d8d4356fd7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, Apr 16, 2021 at 03:38:02PM +0200, Auger Eric wrote:

> The redesign requirement came pretty late in the development process.
> The iommu user API is upstream for a while, the VFIO interfaces have
> been submitted a long time ago and under review for a bunch of time.
> Redesigning everything with a different API, undefined at this point, is
> a major setback for our work and will have a large impact on the
> introduction of features companies are looking forward, hence our
> frustration.

I will answer both you and Jacob at once.

This is uAPI, once it is set it can never be changed.

The kernel process and philosophy is to invest heavily in uAPI
development and review to converge on the best uAPI possible.

Many past submissions have take a long time to get this right, there
are several high profile uAPI examples.

Do you think this case is so special, or the concerns so minor, that it
should get to bypass all of the normal process?

Ask yourself, is anyone advocating for the current direction on
technical merits alone?

Certainly the patches I last saw where completely disgusting from a
uAPI design perspective.

It was against the development process to organize this work the way
it was done. Merging a wack of dead code to the kernel to support a
uAPI vision that was never clearly articulated was a big mistake.

Start from the beginning. Invest heavily in defining a high quality
uAPI. Clearly describe the uAPI to all stake holders. Break up the
implementation into patch series without dead code. Make the
patches. Remove the dead code this group has already added.

None of this should be a surprise. The VDPA discussion and related
"what is a mdev" over a year ago made it pretty clear VFIO is not the
exclusive user of "IOMMU in userspace" and that places limits on what
kind of uAPIs expansion it should experience going forward.

Jason
