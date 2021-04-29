From: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Thu, 29 Apr 2021 10:54:27 +0200
Message-ID: <0d1d0240-865e-c4f0-7b3b-41ac8ae2e550@redhat.com>
References: <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com> <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com> <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619686484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJmZaciikGlYP7vXYgk4XTNBBfK7yKCOZZwkCAQl4Oc=;
        b=YHFHI9xACbtR4P1V1SaFn2SRJDmJZKZ8oDP26JmzuOd2CjjrActiOoTVLsM7+ndQJbqVrI
        My5izHPVkDvlaHAoRWnJUvoUqTS7pa4NrM5tP2YNNrFo/0hPsn+bG7oQU9RKAmp7AIzMZd
        lAB6Z1NSL2dswlShpWpIB6kGTav1r6o=
In-Reply-To: <20210423114944.GF1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi,

On 4/23/21 1:49 PM, Jason Gunthorpe wrote:
> On Fri, Apr 23, 2021 at 09:06:44AM +0000, Tian, Kevin wrote:
> 
>> Or could we still have just one /dev/ioasid but allow userspace to create
>> multiple gpa_ioasid_id's each associated to a different iommu domain? 
>> Then the compatibility check will be done at ATTACH_IOASID instead of 
>> JOIN_IOASID_FD.
> 
> To my mind what makes sense that that /dev/ioasid presents a single
> IOMMU behavior that is basically the same. This may ultimately not be
> what we call a domain today.
> 
> We may end up with a middle object which is a group of domains that
> all have the same capabilities, and we define capabilities in a way
> that most platforms have a single group of domains.
> 
> The key capability of a group of domains is they can all share the HW
> page table representation, so if an IOASID instantiates a page table
> it can be assigned to any device on any domain in the gruop of domains.
> 
> If you try to say that /dev/ioasid has many domains and they can't
> have their HW page tables shared then I think the implementation
> complexity will explode.
> 
>> This does impose one burden to userspace though, to understand the 
>> IOMMU compatibilities and figure out which incompatible features may
>> affect the page table management (while such knowledge is IOMMU
>> vendor specific) and then explicitly manage multiple /dev/ioasid's or 
>> multiple gpa_ioasid_id's.
> 
> Right, this seems very hard in the general case..
>  
>> Alternatively is it a good design by having the kernel return error at
>> attach/join time to indicate that incompatibility is detected then the 
>> userspace should open a new /dev/ioasid or creates a new gpa_ioasid_id
>> for the failing device upon such failure, w/o constructing its own 
>> compatibility knowledge?
> 
> Yes, this feels workable too
> 
>>> This means qemue might have multiple /dev/ioasid's if the system has
>>> multiple incompatible IOMMUs (is this actually a thing?) The platform
>>
>> One example is Intel platform with igd. Typically there is one IOMMU
>> dedicated for igd and the other IOMMU serving all the remaining devices.
>> The igd IOMMU may not support IOMMU_CACHE while the other one
>> does.
> 
> If we can do as above the two domains may be in the same group of
> domains and the IOMMU_CACHE is not exposed at the /dev/ioasid level.
> 
> For instance the API could specifiy IOMMU_CACHE during attach, not
> during IOASID creation.
> 
> Getting all the data model right in the API is going to be trickiest
> part of this.
> 
>> yes, e.g. in vSVA both devices (behind divergence IOMMUs) are bound
>> to a single guest process which has an unique PASID and 1st-level page
>> table. Earlier incompatibility example is only for 2nd-level.
> 
> Because when we get to here, things become inscrutable as an API if
> you are trying to say two different IOMMU presentations can actually
> be nested.
> 
>>> Sure.. The tricky bit will be to define both of the common nested
>>> operating modes.
>>>
>>>   nested_ioasid = ioctl(ioasid_fd, CREATE_NESTED_IOASID,  gpa_ioasid_id);
>>>   ioctl(ioasid_fd, SET_NESTED_IOASID_PAGE_TABLES, nested_ioasid, ..)
>>>
>>>    // IOMMU will match on the device RID, no PASID:
>>>   ioctl(vfio_device, ATTACH_IOASID, nested_ioasid);
>>>
>>>    // IOMMU will match on the device RID and PASID:
>>>   ioctl(vfio_device, ATTACH_IOASID_PASID, pasid, nested_ioasid);
>>
>> I'm a bit confused here why we have both pasid and ioasid notations together.
>> Why not use nested_ioasid as pasid directly (i.e. every pasid in nested mode
>> is created by CREATE_NESTED_IOASID)?
> 
> The IOASID is not a PASID, it is just a page table.
> 
> A generic IOMMU matches on either RID or (RID,PASID), so you should
> specify the PASID when establishing the match.
> 
> IOASID only specifies the page table.
> 
> So you read the above as configuring the path
> 
>   PCI_DEVICE -> (RID,PASID) -> nested_ioasid -> gpa_ioasid_id -> physical
> 
> Where (RID,PASID) indicate values taken from the PCI packet.
> 
> In principle the IOMMU could also be commanded to reuse the same
> ioasid page table with a different PASID:
> 
>   PCI_DEVICE_B -> (RID_B,PASID_B) -> nested_ioasid -> gpa_ioasid_id -> physical
> 
> This is impossible if the ioasid == PASID in the API.
> 
>> Below I list different scenarios for ATTACH_IOASID in my view. Here 
>> vfio_device could be a real PCI function (RID), or a subfunction device 
>> (RID+def_ioasid). 
> 
> What is RID+def_ioasid? The IOMMU does not match on IOASID's.
> 
> A subfunction device always need to use PASID, or an internal IOMMU,
> confused what you are trying to explain?
> 
>> If the whole PASID table is delegated to the guest in ARM case, the guest
>> can select its own PASIDs w/o telling the hypervisor. 
> 
> The hypervisor has to route the PASID's to the guest at some point - a
> guest can't just claim a PASID unilaterally, that would not be secure.
AFAIU On ARM the stage 2 table is uniquely defined per RID and the PASID
space is local to the RID. in other words all PASIDs used along with a
given RID share the same stage 2 page table. So the minimum granularity
for guest assignment still is the RID and not the PASID (there is no
scalable mode on ARM). on x86, with scalable mode, each RID/PASID can
have different stage1/stage2 tables which make the minimum granularity
for guest device assignment the PASID.

So on ARM the guest can allocate PASIDs without interfering with the
host. We just need to make sure the PASID table format and max entries
matches the capability of the HW.

If the min granularity for guest assignment were the RID/PASID
effectively a guest could steal all the PASIDs for a given RID.

Thanks

Eric
> 
> If it is not done with per-PASID hypercalls then the hypervisor has to
> route all PASID's for a RID to the guest and /dev/ioasid needs to have
> a nested IOASID object that represents this connection - ie it points
> to the PASID table of the guest vIOMMU or something.
> 
> Remember this all has to be compatible with mdev's too and without
> hypercalls to create PASIDs that will be hard: mdev sharing a RID and
> slicing the physical PASIDs can't support a 'send all PASIDs to the
> guest' model, or even a 'the guest gets to pick the PASID' option.
> 
> Jason
> 

