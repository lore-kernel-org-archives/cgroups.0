From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 16 Apr 2021 11:34:51 -0300
Message-ID: <20210416143451.GJ1370958@nvidia.com>
References: <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
 <20210415230732.GG1370958@nvidia.com>
 <b1492fd3-8ce2-1632-3b14-73d8d4356fd7@redhat.com>
 <20210416140524.GI1370958@nvidia.com>
 <f71c1e37-6466-e931-be1d-b9b36d785596@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4LNGlrRsxG9zQEEEZa6+Bne03W6a9ickZfs5pg8nSg=;
 b=Dj/KTy5udnJBo6o0ERzhVT8rnNlNXF87o9B/2QnIxCkwNbIvbHwyRZiU5OcA/58x/M7yj7xJfHFNaX8PG/NFXLa6BEvSJ28WLi+fDybdbxkk9hjkdEAy23TNM286MmdmlbPm5Ivf3v9OX5yyMbxl2zl8dZT1mAoCLtlra2qtZWiBDBugE5bp/4ZquUk2VP4kzYisjdQJgZ/KMsrWZdOjf/7vKrfEN5Gv9A+bc1xgYiSwiSfaOiawNiu1ZaD6NsnWNx32XwQ+FGwlUtZu/TGl/hJDPSBgitI0H38Bjn+UbF+5NjkSeOwks0d4yTLq26cZMlMm3VP2/hvKbAOI0k+Ydw==
Content-Disposition: inline
In-Reply-To: <f71c1e37-6466-e931-be1d-b9b36d785596-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, Apr 16, 2021 at 04:26:19PM +0200, Auger Eric wrote:

> This was largely done during several confs including plumber, KVM forum,
> for several years. Also API docs were shared on the ML. I don't remember
> any voice was raised at those moments.

I don't think anyone objects to the high level ideas, but
implementation does matter. I don't think anyone presented "hey we
will tunnel an uAPI through VFIO to the IOMMU subsystem" - did they?

Look at the fairly simple IMS situation, for example. This was
presented at plumbers too, and the slides were great - but the
implementation was too hacky. It required a major rework of the x86
interrupt handling before it was OK.

Jason
