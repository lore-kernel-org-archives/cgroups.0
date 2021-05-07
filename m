From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 7 May 2021 14:20:51 -0300
Message-ID: <20210507172051.GW1370958@nvidia.com>
References: <20210504084148.4f61d0b5@jacob-builder>
 <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
 <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder>
 <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LS3+uvJmeFN39QS9MK57Q2TVTgfZKoPo2fFubvNSmyw=;
 b=sWZ7QvP8WoCtNtg+Sk+VERfzP6U2ZZ64/LRP8wWlTvbJfpgdGBYOAZwy74gJ/SOjkyT0yivVzhAlO/AhBY8LMMZntvfS2ksUNXLQs53cFuDU/9YklIs8Rv4W8ClULaJSWCASlV4L/PZSRan9lK1RGsUGGsEpipThjMgzI6xg1S5Rw3F3LIJHn7MacEfUH+6yjoF7Ot/Buu0CPya9bR2JM3dMajrmjk8FBy+86mGwUSoLcj8peaAb880pcuB9PXB1BZfJNuJs/E3MpJa4ur7w3U2RJCJh9xOEdqmCpx0TXyKpWVoAKa29FqnwTP5EKFUjK4w6JS+wpwjnmMWWa7tmmQ==
Content-Disposition: inline
In-Reply-To: <20210506163240.GA9058@otc-nc-03>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, May 06, 2021 at 09:32:40AM -0700, Raj, Ashok wrote:

> For platforms that support ENQCMD, it is required to mandate PASIDs are
> global across the entire system. Maybe its better to call them gPASID for
> guest and hPASID for host. Short reason being gPASID->hPASID is a guest
> wide mapping for ENQCMD and not a per-RID based mapping. (We covered that
> in earlier responses)

I don't think it is actually ENQCMD that forces this, ENQCMD can use a
per-RID PASID in the translation table as well.

You get forced here only based on the design of the vIOMMU
communication channel. If the guest can demand any RID is attached to
a specific guest determined PASID then the hypervisor must accommodate
that.

> > Which would be a different behavior than something like Intel's top
> > level IOASID that doesn't claim all the PASIDs.
> 
> isn't this simple, if we can say ioasid allocator can provide 
> 
> - system wide PASID
> - RID local PASID
> 
> Based on platform capabilities that require such differentiation?

I think at the uAPI level the callpaths that require allocating a
PASID from a group of RIDs should be explicit in their intention and
not implicitly rely on a certain allocator behavior.

If you want to get a PASID that can be used with every RID on in your
/dev/ioasid then ask for that exactly.

It makes the uAPI much more understandable to be explicit.

Jason
