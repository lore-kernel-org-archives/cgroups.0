From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 7 Apr 2021 08:58:26 -0300
Message-ID: <20210407115826.GE7405@nvidia.com>
References: <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <fa57bde5-472f-6e66-3521-bfac7d6e4f8d@redhat.com>
 <20210406124251.GO7405@nvidia.com>
 <MWHPR11MB1886A7E4C6F3E3A81240517B8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASMzTQ06ZilZBgO6QcthJXnUhhreqa1GJVMJtajmXI8=;
 b=RDL4pFBzruUBowT42rFcVDiUjGgauJRlHEiGY3koTieBmvILpSvHvr4A1Paov5ZwuqMXWKf9YtqrEzYkozSXmbrqfAFB9DUJnViICiZPdoiBoi1zkO02QSUoM7q86Ceroi/A4vS02MI5FolAAc7i8nsH3N/CsF8Vv4wxqe2K2wA/V7T1/1ZRkhaZ9Qyf09baeG36dXzlbD00YmejttOHAA91yqcxo7TVgzaIhOHCwRZd0axFVlFh+pRH1PRuZoY54cRSGy4qJZoAHhnYceXxDYDW+wNKISYl+kW0VoR2VsPdo4KUUlZ4UN8WjZwZRRFFYr91lV20Nt4r2KFPOH//yg==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A7E4C6F3E3A81240517B8C759-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Apr 07, 2021 at 08:17:50AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe
> > Sent: Tuesday, April 6, 2021 8:43 PM
> > 
> > On Tue, Apr 06, 2021 at 09:35:17AM +0800, Jason Wang wrote:
> > 
> > > > VFIO and VDPA has no buisness having map/unmap interfaces once we
> > have
> > > > /dev/ioasid. That all belongs in the iosaid side.
> > > >
> > > > I know they have those interfaces today, but that doesn't mean we have
> > > > to keep using them for PASID use cases, they should be replaced with a
> > > > 'do dma from this pasid on /dev/ioasid' interface certainly not a
> > > > 'here is a pasid from /dev/ioasid, go ahead and configure it youself'
> > > > interface
> > >
> > > So it looks like the PASID was bound to SVA in this design. I think it's not
> > > necessairly the case:
> > 
> > No, I wish people would stop talking about SVA.
> > 
> > SVA and vSVA are a very special narrow configuration of a PASID. There
> > are lots of other PASID configurations! That is the whole point, a
> > PASID is complicated, there are many configuration scenarios, they
> > need to be in one place with a very clearly defined uAPI
> > 
> 
> I feel it also makes sense to allow a subsystem to specify which configurations
> are permitted when allowing a PASID on its device

huh? why?

> e.g. excluding things like
> GPA mappings that existing subsystems (VFIO/VDPA) already handle well:

They don't "handle well", they have some historical baggage that is no
longer suitable for the complexity this area has in the modern world.

Forget about the existing APIs and replace them in /dev/ioasid.

> - Share GPA mappings between multiple devices (w/ or w/o PASID) for 
> better IOTLB efficiency;
>
> - Share GPA mappings between transactions w/ PASID and transactions w/o
> PASID from the same device (e.g. GPU) for better IOTLB efficiency;
> 
> - Use the same page table for GPA mappings before and after the guest 
> turns on/off the PASID capability;

All of these are cases you need to design the /dev/ioasid to handle.

It is pretty clear to me that you'll need non-PASID IOASID's as
well.

Ideally a generic IOASID would just be a page table and it doesn't
crystalize into a RID or RID,PASID routing until devices are attached
to it.

Since IOASID can be nested the only thing that makes any sense is for
each level of the nest to be visible under /dev/ioasid. 

What a complete mess it would be if vfio-pci owns the GPA table,
/dev/ioasid has a nested PASID, and vfio-mdev is running a mdev on top
of that PASID.

> All above are given as long as we continue to let VFIO/VDPA manage the
> iommu domain and associated GPA mappings for PASID.

So don't do that. Don't I keep saying this weird split is making a
horrible mess?

You can't reasonably build the complex PASID scenarios you talk about
above unless the entire translation path is owned by one entity:
/dev/ioasid.

You need to focus on figuring out what that looks like then figure out
how to move VDPA and VFIO to consume /dev/ioasid for all of their
translation instead of open-coding half-baked internal versions.

Jason
