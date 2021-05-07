From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 7 May 2021 16:28:10 -0300
Message-ID: <20210507192810.GY1370958@nvidia.com>
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
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eVjCnUgZG7bFLmsZKWvgm7S8rn2sXFPZXQoCVymeG00=;
 b=k2WAm4fe+IZN4bIbGEwyc82oRA3VuBby5YbZt83mpkRqSLjbRJuuLQCFdS6gF4H+BYQUhe68IqBLMGEfnznNMFkU0Idl3r3Rt7mileBbn1CFiVaFj2EmG6wlsuMSl7bSziqAhXmxSjsFQCIOSzjEYshEzzR9/USkB77YXW6MM66amQyGle5banOJtK3Ey6DdxNFzVGwBtv3zyganR+FchxTZsbDm3X81+BURJyx3CblbR8JfVbq8NpmsmyMEPK95ChRHQfVd2xWFesai0am+v7Nni763h4rCyHkjkPe3WBZH7j7YiIQpYol7R/WuZBW2+XqdvnmVWihZl7hGEmZwJQ==
Content-Disposition: inline
In-Reply-To: <20210507192325.GB73499@otc-nc-03>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, May 07, 2021 at 12:23:25PM -0700, Raj, Ashok wrote:
> Hi Jason
> 
> - Removed lizefan's email due to bounces... 
> 
> On Fri, May 07, 2021 at 03:20:50PM -0300, Jason Gunthorpe wrote:
> > On Fri, May 07, 2021 at 11:14:58AM -0700, Raj, Ashok wrote:
> > > On Fri, May 07, 2021 at 02:20:51PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, May 06, 2021 at 09:32:40AM -0700, Raj, Ashok wrote:
> > > > 
> > > > > For platforms that support ENQCMD, it is required to mandate PASIDs are
> > > > > global across the entire system. Maybe its better to call them gPASID for
> > > > > guest and hPASID for host. Short reason being gPASID->hPASID is a guest
> > > > > wide mapping for ENQCMD and not a per-RID based mapping. (We covered that
> > > > > in earlier responses)
> > > > 
> > > > I don't think it is actually ENQCMD that forces this, ENQCMD can use a
> > > > per-RID PASID in the translation table as well.
> > > 
> > > When using ENQCMD the PASID that needs to be sent on the wire is picked
> > > from an MSR setup by kernel. This is context switched along with the
> > > process. So each process has only 1 PASID that can go out when using
> > > ENQCMD. ENQCMD takes one mmio address specific to the acclerator and a
> > > source for the descriptor.
> > 
> > Oh. I forgot this also globally locked the PASID to a single
> > MSR. Sigh. That makes the whole mechanism useless for anything except
> > whole process SVA.
> 
> Is there another kind of SVA? Our mapping from that each process requires a
> single mm, and PASID for SVM was a direct map from that. 

There are lots of potential applications for something like ENQCMD
that are not whole process SVA. Linking it to a single PASID basically
nukes any other use of it unfortunately.

> > I would have to ask for a PASID that has the property it needs. You
> > are saying the property is even bigger than "usable on a group of
> > RIDs" but is actually "global for every RID and IOMMU in the system so
> > it can go into a MSR". Gross, but fine, ask for that explicitly when
> > allocating the PASID.
> 
> If one process has a single mm, is that also gross? :-) So a single process
> having a PASID is just an identifier for IOMMU. It just seems like what a
> mm is for a process == PASID for SVM-IOMMU support.
> 
> The unanswered question is how do we plumb from vIOMMU without a custom
> allocator to get a system wide PASID? 

PASID allocation is part of the iommu driver, it really shouldn't be
global.

When the architecture code goes to allocate a single PASID for the
mm_struct it should flag that allocation request with a 'must work for
all RIDs flag' and the iommu driver should take care of it. That might
mean the iommu driver consults a global static xarray, or maybe it
does a hypercall, but it should be done through that API, not a side
care global singleton.

Jason
