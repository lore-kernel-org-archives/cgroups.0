From: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 16 Apr 2021 16:26:19 +0200
Message-ID: <f71c1e37-6466-e931-be1d-b9b36d785596@redhat.com>
References: <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
 <20210415230732.GG1370958@nvidia.com>
 <b1492fd3-8ce2-1632-3b14-73d8d4356fd7@redhat.com>
 <20210416140524.GI1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618583199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1Hv2NbQ/MlDR82Y8nOIlqSLTEiVX08oupchgjJ9jRA=;
        b=O1rjioiI59LvC+S4nBSeMhvzoA5ceS7spb7jFCdkjrRNpFC6fI2SWlI3K6TOtlvalhf1eK
        N8JyO3WbCICOTkpav9TbWyRS8TN7sLxljNHIGja8vud0uQjveKKbJMfRJFUsKy+0WG39bV
        fUYD+aLmoTlKKHb4d/5H4oRLVS0daMQ=
In-Reply-To: <20210416140524.GI1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi,
On 4/16/21 4:05 PM, Jason Gunthorpe wrote:
> On Fri, Apr 16, 2021 at 03:38:02PM +0200, Auger Eric wrote:
> 
>> The redesign requirement came pretty late in the development process.
>> The iommu user API is upstream for a while, the VFIO interfaces have
>> been submitted a long time ago and under review for a bunch of time.
>> Redesigning everything with a different API, undefined at this point, is
>> a major setback for our work and will have a large impact on the
>> introduction of features companies are looking forward, hence our
>> frustration.
> 
> I will answer both you and Jacob at once.
> 
> This is uAPI, once it is set it can never be changed.
> 
> The kernel process and philosophy is to invest heavily in uAPI
> development and review to converge on the best uAPI possible.
> 
> Many past submissions have take a long time to get this right, there
> are several high profile uAPI examples.
> 
> Do you think this case is so special, or the concerns so minor, that it
> should get to bypass all of the normal process?

That's not my intent to bypass any process. I am just trying to
understand what needs to be re-designed and for what use case.
> 
> Ask yourself, is anyone advocating for the current direction on
> technical merits alone?
> 
> Certainly the patches I last saw where completely disgusting from a
> uAPI design perspective.
> 
> It was against the development process to organize this work the way
> it was done. Merging a wack of dead code to the kernel to support a
> uAPI vision that was never clearly articulated was a big mistake.
> 
> Start from the beginning. Invest heavily in defining a high quality
> uAPI. Clearly describe the uAPI to all stake holders.
This was largely done during several confs including plumber, KVM forum,
for several years. Also API docs were shared on the ML. I don't remember
any voice was raised at those moments.

 Break up the
> implementation into patch series without dead code. Make the
> patches. Remove the dead code this group has already added.
> 
> None of this should be a surprise. The VDPA discussion and related
> "what is a mdev" over a year ago made it pretty clear VFIO is not the
> exclusive user of "IOMMU in userspace" and that places limits on what
> kind of uAPIs expansion it should experience going forward.
Maybe clear for you but most probably not for many other stakeholders.

Anyway I do not intend to further argue and I will be happy to learn
from you and work with you, Jacob, Liu and all other stakeholders to
define a better integration.

Thanks

Eric
> 
> Jason
> 

