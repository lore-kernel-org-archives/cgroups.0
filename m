From: Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Mon, 10 May 2021 10:56:37 +0800
Message-ID: <b0b5b9b3-083e-1c77-276d-d6eef84806a6@linux.intel.com>
References: <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com> <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com> <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210428090625.5a05dae8@redhat.com>
 <MWHPR11MB1886E0A7897758AA7BE509058C579@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210507110614.7b8e6998@redhat.com>
 <MWHPR11MB18862452FD4172DCA70C89B88C569@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MWHPR11MB18862452FD4172DCA70C89B88C569-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On 5/8/21 3:31 PM, Tian, Kevin wrote:
>> From: Alex Williamson<alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Sent: Saturday, May 8, 2021 1:06 AM
>>
>>>> Those are the main ones I can think of.  It is nice to have a simple
>>>> map/unmap interface, I'd hope that a new /dev/ioasid interface wouldn't
>>>> raise the barrier to entry too high, but the user needs to have the
>>>> ability to have more control of their mappings and locked page
>>>> accounting should probably be offloaded somewhere.  Thanks,
>>>>
>>> Based on your feedbacks I feel it's probably reasonable to start with
>>> a type1v2 semantics for the new interface. Locked accounting could
>>> also start with the same VFIO restriction and then improve it
>>> incrementally, if a cleaner way is intrusive (if not affecting uAPI).
>>> But I didn't get the suggestion on "more control of their mappings".
>>> Can you elaborate?
>> Things like I note above, userspace cannot currently specify mapping
>> granularity nor has any visibility to the granularity they get from the
>> IOMMU.  What actually happens in the IOMMU is pretty opaque to the user
>> currently.  Thanks,
>>
> It's much clearer. Based on all the discussions so far I'm thinking about
> a staging approach when building the new interface, basically following
> the model that Jason pointed out - generic stuff first, then platform
> specific extension:
> 
> Phase 1: /dev/ioasid with core ingredients and vfio type1v2 semantics
>      - ioasid is the software handle representing an I/O page table

A trivial proposal, is it possible to use /dev/ioas? Conceptually, it's
an IO address space representation and has nothing to do with any ID.

Best regards,
baolu
