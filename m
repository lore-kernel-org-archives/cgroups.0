From: Liu Yi L <yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Sat, 8 May 2021 15:06:17 +0800
Message-ID: <20210508150617.1e357fcf@yiliu-dev>
References: <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210426123817.GQ1370958@nvidia.com>
        <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210504084148.4f61d0b5@jacob-builder>
        <20210504180050.GB1370958@nvidia.com>
        <20210504151154.02908c63@jacob-builder>
        <20210504231530.GE1370958@nvidia.com>
        <20210505102259.044cafdf@jacob-builder>
        <20210505180023.GJ1370958@nvidia.com>
        <20210505130446.3ee2fccd@jacob-builder>
        <20210505222120.GM1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210505222120.GM1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jason,

On Wed, 5 May 2021 19:21:20 -0300, Jason Gunthorpe wrote:

> On Wed, May 05, 2021 at 01:04:46PM -0700, Jacob Pan wrote:
> > Hi Jason,
> > 
> > On Wed, 5 May 2021 15:00:23 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> >   
> > > On Wed, May 05, 2021 at 10:22:59AM -0700, Jacob Pan wrote:
> > >   
> > > > Global and pluggable are for slightly separate reasons.
> > > > - We need global PASID on VT-d in that we need to support shared
> > > > workqueues (SWQ). E.g. One SWQ can be wrapped into two mdevs then
> > > > assigned to two VMs. Each VM uses its private guest PASID to submit
> > > > work but each guest PASID must be translated to a global (system-wide)
> > > > host PASID to avoid conflict. Also, since PASID table storage is per
> > > > PF, if two mdevs of the same PF are assigned to different VMs, the
> > > > PASIDs must be unique.    
> > > 
> > > From a protocol perspective each RID has a unique PASID table, and
> > > RIDs can have overlapping PASIDs.
> > >   
> > True, per RID or per PF as I was referring to.
> >   
> > > Since your SWQ is connected to a single RID the requirement that
> > > PASIDs are unique to the RID ensures they are sufficiently unique.
> > >   
> > True, but one process can submit work to multiple mdevs from different
> > RIDs/PFs. One process uses one PASID and PASID translation table is per VM.
> > The same PASID is used for all the PASID tables of each RID.  
> 
> If the model is "assign this PASID to this RID" then yes, there is a
> big problem keeping everything straight that can only be solved with a
> global table.
> 
> But if the model is "give me a PASID for this RID" then it isn't such
> a problem.

Let me double confirm if I'm understanding you correctly. So your suggestion
is to have a per-RID PASID namespace, which can be maintainer by IOMMU driver.
right? Take native SVM usage as an example, everytime a process is bound with
a device, a PASID within this RID will be allocated. Am I correct so far?

If yes, then there is a case in which IOTLB efficiency is really low. Let's ay
there is a process bound with multiple devices(RIDs) and has different PASIDs
allocated for each RID. In such case, the PASID values are different for each
RID. As most vendor will do, PASID will be used to tag IOTLB entries. So in such
case, here will be multiple IOTLB entries for a single VA->PA mapping. And the
number of such duplicate IOTLB entries increases linearly per the number of the
device number. Seems not good from performance perspective.

> 
> Basically trying to enforce a uniform PASID for an IOASID across all
> RIDs attached to it is not such a nice choice.
> 
> > > That is fine, but all this stuff should be inside the Intel vIOMMU
> > > driver not made into a global resource of the entire iommu subsystem.
> > >   
> > Intel vIOMMU has to use a generic uAPI to allocate PASID so the generic
> > code need to have this option. I guess you are saying we should also have a
> > per RID allocation option in addition to global?  
> 
> There always has to be a RID involvement for the PASID, for security,
> this issue really boils down to where the PASID lives.
> 
> If you need the PASID attached to the IOASID then it has to be global
> because the IOASID can be attached to any RID and must keep the same
> PASID.
> 
> If the PASID is learned when the IOASID is attached to a RID then the
> PASID is more flexible and isn't attached to the IOASID.
> 
> Honestly I'm a little leary to bake into a UAPI a specific HW choice
> that Intel made here.
> 
> I would advise making the "attach a global PASID to this IOASID"
> operation explicit and opt into for case that actually need it.
> 
> Which implies the API to the iommu driver should be more like:
> 
>   'assign an IOASID to this RID and return the PASID'
>   'reserve a PASID from every RID'
>   'assign an IOASID to this RID and use this specific PASID'
> 
> In all cases the scope of those operations are completely local to a
> certain IOMMU driver - 'reserver a PASID from every RID' is really
> every RID that driver can operate on.

Also, this reservation will be failed if the PASID happens to be occupied
by previous usage. As the PASID translation table is per-VM, ENQCMD in VM
will be a problem under such PASID management model.

> 
> So it is hard to see why the allocator should be a global resource and
> not something that is part of the iommu driver exclusively.
> 
> Jason

-- 
Regards,
Yi Liu
