From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 6 May 2021 09:22:22 -0300
Message-ID: <20210506122222.GP1370958@nvidia.com>
References: <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504084148.4f61d0b5@jacob-builder>
 <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
 <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder>
 <20210505222120.GM1370958@nvidia.com>
 <20210505232319.GA5087@otc-nc-03>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyhDd1vrMGxrArRcbqrysudGQz5qpeVhUNpvpg2w6FM=;
 b=JbHEwSe4DaJvYUG05GX7gANS52d+VrOMOIrl1SEDGbLfwsVUs79GijkU9ExMtAO8hi8Kh483i9W5NuM9KfLV6rQTWbr2pzYr+EXorQ8YkmoKpTzm2ROO55U/cmJRfJJU1Z27EzgUGv1TOPONnhkakGZael3IqGzXx+9VBhkI2pc5wzY3UVMIKxlI8n0gcPwI1PQKygz0XvfTNVLqVVyPLimBWSX1Ree6wxGrKzqk+UKfJgrIsqmfPSySVhg5kIj3hpc0+mRy29DZiONj7H+ZQVwIkB83m4S7T9U27s6kw1ZWUtAkYflH5LXzEu7tZA0kfzk5ATVPj7FzGI+hnSbgOA==
Content-Disposition: inline
In-Reply-To: <20210505232319.GA5087@otc-nc-03>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, May 05, 2021 at 04:23:19PM -0700, Raj, Ashok wrote:
> > Which implies the API to the iommu driver should be more like:
> > 
> >   'assign an IOASID to this RID and return the PASID'
> >   'reserve a PASID from every RID'
> 
> I don't think this has any decent change of success. Its rather round about
> way to get a global PASID namespace.
> 
> >   'assign an IOASID to this RID and use this specific PASID'
> 
> This seems a bit complicated. Another way to specify this.

Maybe, but I don't like that the driver-based iommu API has been
corrupted by injecting a global 'first driver to claim it'
resource. It is not properly layered anymore.

Jason
