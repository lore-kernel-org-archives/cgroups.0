From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 10 May 2021 20:45:00 -0300
Message-ID: <20210510234500.GI1002214@nvidia.com>
References: <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <20210510152502.GA90095@otc-nc-03>
 <20210510153111.GB1002214@nvidia.com>
 <20210510162212.GB90095@otc-nc-03>
 <20210510163956.GD1002214@nvidia.com>
 <20210510152854.793ee594@jacob-builder>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7YvY3ghFZVy/MxSq55DpMslbyjZ5dtdU4r62kwxoiA=;
 b=Yq7gr1UXvocILLOd/cAZX/SeIuPRzT2nlY8iA2gHlK+T+O8REUIqM67sUydNMVMQ1W2hCWb6JmMxghjM0z54FI4m7H1TN+MmpPrZuvc91T3D7OUUM/YSBkQK3Y3wc0NYxo371BOxHUkl1GX4ETN277n93RAqLwYT8EPrjuu4MdizO7soom8G1mFQbnWh7tHbmCMR6ekWFwFKOS+Rtgsi49w+nbw8SjtLnbrFzd4uil/1SJn8Ccig0q76mz9Fdqk8oi2s+WZg1RqRmFMUIBZAAt/J3diEuPzIQ0enSyKYgVSDuwjQLLg5zOgSPRN28KS+C8q54Zc2sR06Dc5XL5kWYg==
Content-Disposition: inline
In-Reply-To: <20210510152854.793ee594@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, May 10, 2021 at 03:28:54PM -0700, Jacob Pan wrote:

> To satisfy your "give me a PASID for this RID" proposal, can we just use
> the RID's struct device as the token? Also add a type field to explicitly
> indicate global vs per-set(per-RID). i.e.

You've got it backwards, the main behavior should be to allocate PASID
per RID.

The special behavior is to bundle a bunch of PASIDs into a grouping
and then say the PASID number space is shared between all the group
members. 

/dev/ioasid should create and own this grouping either implicitly or
explicitly. Jumping ahead to in-kernel APIs has missed the critical
step of defining the uAPI and all the behaviors together in a
completed RFC proposal.

Jason
