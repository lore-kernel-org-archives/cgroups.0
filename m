From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 23 Apr 2021 08:57:23 -0300
Message-ID: <20210423115723.GG1370958@nvidia.com>
References: <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <MWHPR11MB1886A98D9176B5571530EF1D8C459@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlAnTfQCljtalKMXo9FjpVXRscswBe/yEvM3fPuOuPA=;
 b=OeRdD4ypTMzeN32v9UadwOWOOk3SJUJJ6quXlbHx7Q6ORjcEE4Oq0E9TgwfAR+fsqqxQei6yjddwX91qJ+EXLuES/A3ySyWp/El6yOG77tQd6Mnqwg12hr1J3vJHCThayAFo62mEIc+H8ca3uZlik2ldN6Q83HlNiioXMkqK0nargvnnDR6GRMzjl//uXjSxCPz+aWndf3uMPvKEwiKUnQ1ISnd8xRQjaMRk0l3DO7xUXO3WEp8hWlNlmppeMoYKQ2ctKMY5U3iC7n5gNMrR+SwEPM7kLG23wPvnh0TQTNeg9K917dGL1kEvJHbtwcC1puFRn5Kzx5osAmm5pGQlPw==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A98D9176B5571530EF1D8C459-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, Apr 23, 2021 at 10:31:46AM +0000, Tian, Kevin wrote:

> So your proposal sort of moves the entire container/group/domain 
> managment into /dev/ioasid and then leaves vfio only provide device
> specific uAPI. An ioasid represents a page table (address space), thus 
> is equivalent to the scope of VFIO container. Having the device join 
> an ioasid is equivalent to attaching a device to VFIO container, and 
> here the group integrity must be enforced. Then /dev/ioasid anyway 
> needs to manage group objects and their association with ioasid and 
> underlying iommu domain thus it's pointless to keep same logic within
> VFIO. Is this understanding correct?

Yes, I haven't thought of a way to define /dev/ioasid in a way that is
useful to VDPA/etc without all these parts.. If you come up with a
better idea do share.

> btw one remaining open is whether you expect /dev/ioasid to be 
> associated with a single iommu domain, or multiple. If only a single
> domain is allowed, the ioasid_fd is equivalent to the scope of VFIO
> container. 

See the prior email for a more complete set of thoughts on this.

> It is supposed to have only one gpa_ioasid_id since one iommu domain
> can only have a single 2nd level pgtable. Then all other ioasids,
> once allocated, must be nested on this gpa_ioasid_id to fit in the
> same domain. if a legacy vIOMMU is exposed (which disallows
> nesting), the userspace has to open an ioasid_fd for every group.
> This is basically the VFIO way. On the other hand if multiple
> domains is allowed, there could be multiple ioasid_ids each holding
> a 2nd level pgtable and an iommu domain (or a list of pgtables and
> domains due to incompatibility issue as discussed in another
> thread), and can be nested by other ioasids respectively. The
> application only needs to open /dev/ioasid once regardless of
> whether vIOMMU allows nesting, and has a single interface for ioasid
> allocation. Which way do you prefer to?

I have a feeling we want to have a single IOASID be usable in as many
contexts as possible - as many domains, devices and groups as we can
get away with.

The IOASID is the expensive object, it is the pagetable, it is
potentially a lot of memory. The API should be designed so we don't
have to have multiple copies of the same pagetable.

For this reason I think having multiple IOASID's in a single
/dev/ioasid container is the way to go.

To my mind the /dev/ioasid should be linked to a HW page table format
and any device/domain/group that uses that same HW page table format
can be joined to it. This implies we can have multiple domains under
/dev/ioasid, but there is a limitation on what domains can be grouped
together.

This probably does not match the exact IOMMU capability/domain model
we have today, so I present it as an inspirational goal. The other
tricky thing here will be to define small steps.. 

eg V1 may only allow one domain, but the uAPI will not reflect this as
we expect V2 will allow multiple domains..

Jason
