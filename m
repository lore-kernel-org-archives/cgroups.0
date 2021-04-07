From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 7 Apr 2021 09:20:42 -0300
Message-ID: <20210407122042.GF7405@nvidia.com>
References: <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <MWHPR11MB1886CF7C11ECE0396A0215078C769@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210406123451.GN7405@nvidia.com>
 <MWHPR11MB1886CB8F558C6C17F921F77F8C759@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+EaUTINRKnm9T9DTyulX+UCeIXY3iZPhGqqGXHeVcQ=;
 b=MJyAg4fy00qxK3oKqZR3mJ3vyzAmC+0IqekYn2jZbwe8lrXTgEc6onXQ1nU8iO+HPsnI6wk92uKH5g2r/lkzE+ez1IamweaLgfo4J2MAnTgurejobZq6WX9Ufs9KNJAA94jdOrIjmDvQlZlldyrDWX8xkdRAOfdHEMo4EfS8J6OLLNg7gs50vO5PbSNIPdlNVe2ftm8r8CGD66SOaVn7uf+QimEUVHXYoQ25HROT1YW6Bc18Aj9CkFRe8knlOqkGLyGhaogyRFU6JrQakcm1bGhwaUdsUEif4faQLQWEp2kObRcKN3XGfk1aOzGbqev+auRKGe8fyCIXTpaHyGSDlw==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886CB8F558C6C17F921F77F8C759-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 07, 2021 at 02:08:33AM +0000, Tian, Kevin wrote:

> > Because if you don't then we enter insane world where a PASID is being
> > created under /dev/ioasid but its translation path flows through setup
> > done by VFIO and the whole user API becomes an incomprehensible mess.
> > 
> > How will you even associate the PASID with the other translation??
> 
> PASID is attached to a specific iommu domain (created by VFIO/VDPA), which
> has GPA->HPA mappings already configured. If we view that mapping as an
> attribute of the iommu domain, it's reasonable to have the userspace-bound
> pgtable through /dev/ioasid to nest on it.

A user controlled page table should absolutely not be an attribute of
a hidden kernel object, nor should two parts of the kernel silently
connect to each other via a hidden internal objects like this.

Security is important - the kind of connection must use some explicit
FD authorization to access shared objects, not be made implicit!

IMHO this direction is a dead end for this reason.

> > The entire translation path for any ioasid or PASID should be defined
> > only by /dev/ioasid. Everything else is a legacy API.
> > 
> > > If following your suggestion then VFIO must deny VFIO MAP operations
> > > on sva1 (assume userspace should not mix sva1 and sva2 in the same
> > > container and instead use /dev/ioasid to map for sva1)?
> > 
> > No, userspace creates an iosaid for the guest physical mapping and
> > passes this ioasid to VFIO PCI which will assign it as the first layer
> > mapping on the RID
> 
> Is it an dummy ioasid just for providing GPA mappings for nesting purpose
> of other IOASIDs? Then we waste one per VM?

Generic ioasid's are "free" they are just software constructs in the
kernel.

> > When PASIDs are allocated the uAPI will be told to logically nested
> > under the first ioasid. When VFIO authorizes a PASID for a RID it
> > checks that all the HW rules are being followed.
> 
> As I explained above, why cannot we just use iommu domain to connect 
> the dots? 

Security.

> Every passthrough framework needs to create an iommu domain
> first. and It needs to support both devices w/ PASID and devices w/o
> PASID.  For devices w/o PASID it needs to invent its own MAP
> interface anyway.  

No, it should consume a ioasid from /dev/ioasid, use a common ioasid
map interface and assign that ioasid to a RID.

Don't get so fixated on PASID as a special case

> Then why do we bother creating another MAP interface through
> /dev/ioasid which not only duplicates but also creating transition
> burden between two set of MAP interfaces when the guest turns on/off
> the pasid capability on the device?

Don't transition. Always use the new interface. qemu detects the
kernel supports /dev/ioasid and *all iommu page table configuration*
goes through there. VFIO and VDPA APIs become unused for iommu
configuration.

> 'universally' upon from which angle you look at this problem. From IOASID
> p.o.v possibly yes, but from device passthrough p.o.v. it's the opposite
> since the passthrough framework needs to handle devices w/o PASID anyway
> (or even for device w/ PASID it could send traffic w/o PASID) thus 'universally'
> makes more sense if the passthrough framework can use one interface of its
> own to manage GPA mappings for all consumers (apply to the case when a
> PASID is allowed/authorized).

You correctly named it /dev/ioasid, it is a generic way to allocate,
manage and assign IOMMU page tables, which when generalized, only some
of which may consume a limited PASID.

RID and RID,PASID are the same thing, just a small difference in how
they match TLPs.

Jason
