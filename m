From: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 7 May 2021 12:23:25 -0700
Message-ID: <20210507192325.GB73499@otc-nc-03>
References: <20210504231530.GE1370958@nvidia.com>
 <20210505102259.044cafdf@jacob-builder>
 <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder>
 <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <20210507172051.GW1370958@nvidia.com>
 <20210507181458.GA73499@otc-nc-03>
 <20210507182050.GX1370958@nvidia.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210507182050.GX1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ashok Raj <ashok.raj@intel.>

Hi Jason

- Removed lizefan's email due to bounces... 

On Fri, May 07, 2021 at 03:20:50PM -0300, Jason Gunthorpe wrote:
> On Fri, May 07, 2021 at 11:14:58AM -0700, Raj, Ashok wrote:
> > On Fri, May 07, 2021 at 02:20:51PM -0300, Jason Gunthorpe wrote:
> > > On Thu, May 06, 2021 at 09:32:40AM -0700, Raj, Ashok wrote:
> > > 
> > > > For platforms that support ENQCMD, it is required to mandate PASIDs are
> > > > global across the entire system. Maybe its better to call them gPASID for
> > > > guest and hPASID for host. Short reason being gPASID->hPASID is a guest
> > > > wide mapping for ENQCMD and not a per-RID based mapping. (We covered that
> > > > in earlier responses)
> > > 
> > > I don't think it is actually ENQCMD that forces this, ENQCMD can use a
> > > per-RID PASID in the translation table as well.
> > 
> > When using ENQCMD the PASID that needs to be sent on the wire is picked
> > from an MSR setup by kernel. This is context switched along with the
> > process. So each process has only 1 PASID that can go out when using
> > ENQCMD. ENQCMD takes one mmio address specific to the acclerator and a
> > source for the descriptor.
> 
> Oh. I forgot this also globally locked the PASID to a single
> MSR. Sigh. That makes the whole mechanism useless for anything except
> whole process SVA.

Is there another kind of SVA? Our mapping from that each process requires a
single mm, and PASID for SVM was a direct map from that. 

> 
> It also make it a general kernel problem and not just related to the
> vIOMMU scenario.
> 
> > > I think at the uAPI level the callpaths that require allocating a
> > > PASID from a group of RIDs should be explicit in their intention and
> > > not implicitly rely on a certain allocator behavior.
> > 
> > The difficult part I see is, when one application establishes a path
> > to one acclerator, we have no knowledge if its going to connect to a
> > second, third or such. I don't see how this can work reasonably
> > well. What if PASIDx is allocated for one, but the second RID its
> > trying to attach already has this PASID allocated?
> 
> You mean like some kind of vIOMMU hot plug?

Not vIOMMU hot plug. but an application opens accel1, does a bind to
allocate a PASID. What i meant was kernel has no information if this needs
to be a per-RID PASID, or a global PASID. Keeping this global solves the
other problems or more complex mechanisms to say "Reserve this PASID on all
accelerators" which seems pretty complicated to implement.

Now are we loosing anything by keeping the PASIDs global? 

As we discussed there is no security issue since the PASID table that hosts 
these PASIDs for SVM are still per-RID.  For e.g.

app establishes connection to accl1, allocates PASID-X
   RID for accel1 now has PASID-X and the process mm plummed 
later app also connects with accl2, now the PASID-X is plummed in for RID
of accel2.


> 
> > > If you want to get a PASID that can be used with every RID on in your
> > > /dev/ioasid then ask for that exactly.
> > 
> > Correct, but how does guest through vIOMMU driver communicate that intent so uAPI
> > plumbing can do this? I mean architecturally via IOMMU interfaces? 
> 
> I would have to ask for a PASID that has the property it needs. You
> are saying the property is even bigger than "usable on a group of
> RIDs" but is actually "global for every RID and IOMMU in the system so
> it can go into a MSR". Gross, but fine, ask for that explicitly when
> allocating the PASID.

If one process has a single mm, is that also gross? :-) So a single process
having a PASID is just an identifier for IOMMU. It just seems like what a
mm is for a process == PASID for SVM-IOMMU support.

The unanswered question is how do we plumb from vIOMMU without a custom
allocator to get a system wide PASID? 

The way it works today is if we have a custom allocator registered, that's
the mechanics to get PASIDs allocated. for Intel vIOMMU it happens to be a
global unique allocation. If a particular vIOMMU doesn't require, it does
not have vIOMMU interface, and those naturally get a guest local PASID name
space. (Im not sure if that's how the allocator works today, but I guess its
extensible to accomplish a RID local PASID if that's exactly what is
required)

Cheers,
Ashok
