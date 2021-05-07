From: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 7 May 2021 11:14:58 -0700
Message-ID: <20210507181458.GA73499@otc-nc-03>
References: <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
 <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder>
 <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <20210507172051.GW1370958@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210507172051.GW1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, May 07, 2021 at 02:20:51PM -0300, Jason Gunthorpe wrote:
> On Thu, May 06, 2021 at 09:32:40AM -0700, Raj, Ashok wrote:
> 
> > For platforms that support ENQCMD, it is required to mandate PASIDs are
> > global across the entire system. Maybe its better to call them gPASID for
> > guest and hPASID for host. Short reason being gPASID->hPASID is a guest
> > wide mapping for ENQCMD and not a per-RID based mapping. (We covered that
> > in earlier responses)
> 
> I don't think it is actually ENQCMD that forces this, ENQCMD can use a
> per-RID PASID in the translation table as well.

When using ENQCMD the PASID that needs to be sent on the wire is picked
from an MSR setup by kernel. This is context switched along with the
process. So each process has only 1 PASID that can go out when using
ENQCMD. ENQCMD takes one mmio address specific to the acclerator and a
source for the descriptor. 

When one application is connecting to more than one accelerator since this
is MSR based filled in by the cpu instruction automaticaly requires both
accelerators to use the same PASID. 

Did you refer to this implementation? or something else?
> 
> You get forced here only based on the design of the vIOMMU
> communication channel. If the guest can demand any RID is attached to
> a specific guest determined PASID then the hypervisor must accommodate
> that.

True, but when we have guest using vSVM, and enabling vENQCMD the
requirement is the same inside a guest.
> 
> > > Which would be a different behavior than something like Intel's top
> > > level IOASID that doesn't claim all the PASIDs.
> > 
> > isn't this simple, if we can say ioasid allocator can provide 
> > 
> > - system wide PASID
> > - RID local PASID
> > 
> > Based on platform capabilities that require such differentiation?
> 
> I think at the uAPI level the callpaths that require allocating a
> PASID from a group of RIDs should be explicit in their intention and
> not implicitly rely on a certain allocator behavior.

The difficult part I see is, when one application establishes a path to one
acclerator, we have no knowledge if its going to connect to a second, third 
or such. I don't see how this can work reasonably well. What if PASIDx is allocated
for one, but the second RID its trying to attach already has this
PASID allocated? 

> 
> If you want to get a PASID that can be used with every RID on in your
> /dev/ioasid then ask for that exactly.

Correct, but how does guest through vIOMMU driver communicate that intent so uAPI
plumbing can do this? I mean architecturally via IOMMU interfaces? 


Cheers,
Ashok
