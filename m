From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 5 May 2021 19:21:20 -0300
Message-ID: <20210505222120.GM1370958@nvidia.com>
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
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2Dr2AfpdUpdq9csMR9KxAzmzXD1M2n3+AilvtRKQzI=;
 b=msOlANKY0aCIEPYZdRVrnlIHSheRbMI2icZ13dCoTtKgHqlLzUI3lTyCUnJnhFY0/X+W6pBhFhNPHwy/vdhsO4vM/4deb8FmHInBn3r4FC3m8c+wgN5CeXZZM481YP4X8j56ucc09zpmGCGS8uwawnHJx5juUZTDfGDOiMO//2XVg8aX1p40wHUrKeFTeao27i4+Vc7DzSbq+r0OEnYw99Q1pXHI4jKCLVLIiSDOK+KbDjlKZn3nOkxDAbkYBVSMQFdebWuNRzF0ljpB299dV05B9DCt04w+sCair+x5Ysat1JWolniG/E3t4CzOoDRXMPDrl/XrjIQdAJu5S/C4vA==
Content-Disposition: inline
In-Reply-To: <20210505130446.3ee2fccd@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, May 05, 2021 at 01:04:46PM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Wed, 5 May 2021 15:00:23 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, May 05, 2021 at 10:22:59AM -0700, Jacob Pan wrote:
> > 
> > > Global and pluggable are for slightly separate reasons.
> > > - We need global PASID on VT-d in that we need to support shared
> > > workqueues (SWQ). E.g. One SWQ can be wrapped into two mdevs then
> > > assigned to two VMs. Each VM uses its private guest PASID to submit
> > > work but each guest PASID must be translated to a global (system-wide)
> > > host PASID to avoid conflict. Also, since PASID table storage is per
> > > PF, if two mdevs of the same PF are assigned to different VMs, the
> > > PASIDs must be unique.  
> > 
> > From a protocol perspective each RID has a unique PASID table, and
> > RIDs can have overlapping PASIDs.
> > 
> True, per RID or per PF as I was referring to.
> 
> > Since your SWQ is connected to a single RID the requirement that
> > PASIDs are unique to the RID ensures they are sufficiently unique.
> > 
> True, but one process can submit work to multiple mdevs from different
> RIDs/PFs. One process uses one PASID and PASID translation table is per VM.
> The same PASID is used for all the PASID tables of each RID.

If the model is "assign this PASID to this RID" then yes, there is a
big problem keeping everything straight that can only be solved with a
global table.

But if the model is "give me a PASID for this RID" then it isn't such
a problem.

Basically trying to enforce a uniform PASID for an IOASID across all
RIDs attached to it is not such a nice choice.

> > That is fine, but all this stuff should be inside the Intel vIOMMU
> > driver not made into a global resource of the entire iommu subsystem.
> > 
> Intel vIOMMU has to use a generic uAPI to allocate PASID so the generic
> code need to have this option. I guess you are saying we should also have a
> per RID allocation option in addition to global?

There always has to be a RID involvement for the PASID, for security,
this issue really boils down to where the PASID lives.

If you need the PASID attached to the IOASID then it has to be global
because the IOASID can be attached to any RID and must keep the same
PASID.

If the PASID is learned when the IOASID is attached to a RID then the
PASID is more flexible and isn't attached to the IOASID.

Honestly I'm a little leary to bake into a UAPI a specific HW choice
that Intel made here.

I would advise making the "attach a global PASID to this IOASID"
operation explicit and opt into for case that actually need it.

Which implies the API to the iommu driver should be more like:

  'assign an IOASID to this RID and return the PASID'
  'reserve a PASID from every RID'
  'assign an IOASID to this RID and use this specific PASID'

In all cases the scope of those operations are completely local to a
certain IOMMU driver - 'reserver a PASID from every RID' is really
every RID that driver can operate on.

So it is hard to see why the allocator should be a global resource and
not something that is part of the iommu driver exclusively.

Jason
