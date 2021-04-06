From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Tue, 6 Apr 2021 09:35:17 +0800
Message-ID: <fa57bde5-472f-6e66-3521-bfac7d6e4f8d@redhat.com>
References: <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com> <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com> <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617672938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwZ8XyyzRZCBrGqzegCVhhjQ1Q2Ym617/sTrzH4w1XI=;
        b=byXv0wBgeKoPa1BWCNAXfxIERfEsfOqyFT0OZWsTnTkg3yTkyL8yWoOWO92DkZ46G4HAko
        vnFoH9bAJgA2C1QzdBMN3M4Bb11GhJ4Qt1jm/C5hKUWmjYN8jwIjTNJu6B9FkyUDb9ucRX
        s7pJJJkp1ODQ5MgnJ66A7hiLKJoEOng=
In-Reply-To: <20210405234230.GF7405@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>


=D4=DA 2021/4/6 =C9=CF=CE=E77:42, Jason Gunthorpe =D0=B4=B5=C0:
> On Fri, Apr 02, 2021 at 08:22:28AM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Tuesday, March 30, 2021 9:29 PM
>>>
>>>> First, userspace may use ioasid in a non-SVA scenario where ioasid is
>>>> bound to specific security context (e.g. a control vq in vDPA) instead=
 of
>>>> tying to mm. In this case there is no pgtable binding initiated from u=
ser
>>>> space. Instead, ioasid is allocated from /dev/ioasid and then programm=
ed
>>>> to the intended security context through specific passthrough framework
>>>> which manages that context.
>>> This sounds like the exact opposite of what I'd like to see.
>>>
>>> I do not want to see every subsystem gaining APIs to program a
>>> PASID. All of that should be consolidated in *one place*.
>>>
>>> I do not want to see VDPA and VFIO have two nearly identical sets of
>>> APIs to control the PASID.
>>>
>>> Drivers consuming a PASID, like VDPA, should consume the PASID and do
>>> nothing more than authorize the HW to use it.
>>>
>>> quemu should have general code under the viommu driver that drives
>>> /dev/ioasid to create PASID's and manage the IO mapping according to
>>> the guest's needs.
>>>
>>> Drivers like VDPA and VFIO should simply accept that PASID and
>>> configure/authorize their HW to do DMA's with its tag.
>>>
>> I agree with you on consolidating things in one place (especially for the
>> general SVA support). But here I was referring to an usage without
>> pgtable binding (Possibly Jason. W can say more here), where the
>> userspace just wants to allocate PASIDs, program/accept PASIDs to
>> various workqueues (device specific), and then use MAP/UNMAP
>> interface to manage address spaces associated with each PASID.
>> I just wanted to point out that the latter two steps are through
>> VFIO/VDPA specific interfaces.
> No, don't do that.
>
> VFIO and VDPA has no buisness having map/unmap interfaces once we have
> /dev/ioasid. That all belongs in the iosaid side.
>
> I know they have those interfaces today, but that doesn't mean we have
> to keep using them for PASID use cases, they should be replaced with a
> 'do dma from this pasid on /dev/ioasid' interface certainly not a
> 'here is a pasid from /dev/ioasid, go ahead and configure it youself'
> interface


So it looks like the PASID was bound to SVA in this design. I think it's=20
not necessairly the case:

1) PASID can be implemented without SVA, in this case a map/unmap=20
interface is still required
2) For the case that hypervisor want to do some mediation in the middle=20
for a virtqueue. e.g in the case of control vq that is implemented in=20
the VF/ADI/SF itself, the hardware virtqueue needs to be controlled by=20
Qemu, Though binding qemu's page table to cvq can work but it looks like=20
a overkill, a small dedicated buffers that is mapped for this PASID=20
seems more suitalbe.


>
> This is because PASID is *complicated* in the general case! For
> instance all the two level stuff you are talking about must not leak
> into every user!
>
> Jason


So do you mean the device should not expose the PASID confiugration API=20
to guest? I think it could happen if we assign the whole device and let=20
guest to configure it for nested VMs.

Thanks


>

