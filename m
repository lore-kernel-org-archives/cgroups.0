From: Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 26 May 2021 00:56:30 +0530
Message-ID: <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
References: <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box> <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box> <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko> <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko> <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko> <20210524233744.GT1002214@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQ2rh5R80Fu86zeJeWHYHobMTDww4dFTkVxhue1JBiA=;
 b=ZB3aRVBFgL8Sx3UaZrotBW7y3o8YtuAcS4TiVrsvMriFhqb/+dQHkQGnrCw8KIKIeEv3oPCM2rGxadSsGMtSUo32jU7CxysDG9Q//elNyakiTXr//NKGrmp8jJjzlqHAuL8saX4+6eWxHdjHz4bXadZmiKVuluK5HX+3UMHLlbE8toAZ4an9P6IENODkvfxm73KmrScV07GTMnNFpHRN0t+mWqD9aAhoAJdSaOMGNtQSkPJCr0pMUiokGNcVQyon5SuZpdeJ/b+XNd8I0y/wLGLxPSgm55N4UfrWsWTN05QqxqVxkMoNakL2Vp6zPEgVFoSjuyUvmVD4NEFPYMM0ig==
In-Reply-To: <20210524233744.GT1002214@nvidia.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jason Gunthorpe <jgg@nvidia.com>, David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan <jacob.jun.pan@linux.intel.com>, Auger Eric <eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, "Tian, Kevin" <kevin.tian@intel.com>, LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jean-Philippe Brucker <jean-philippe@linaro.com>, Jonathan Corbet <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>, "Wu, Hao" <hao.wu@intel.com>



On 5/25/2021 5:07 AM, Jason Gunthorpe wrote:
> On Mon, May 24, 2021 at 05:52:58PM +1000, David Gibson wrote:
> 
>>>> I don't really see a semantic distinction between "always one-device
>>>> groups" and "groups don't matter".  Really the only way you can afford
>>>> to not care about groups is if they're singletons.
>>>
>>> The kernel driver under the mdev may not be in an "always one-device"
>>> group.
>>
>> I don't really understand what you mean by that.
> 
> I mean the group of the mdev's actual DMA device may have multiple
> things in it.
>   
>>> It is a kernel driver so the only thing we know and care about is that
>>> all devices in the HW group are bound to kernel drivers.
>>>
>>> The vfio device that spawns from this kernel driver is really a
>>> "groups don't matter" vfio device because at the IOMMU layer it should
>>> be riding on the physical group of the kernel driver.  At the VFIO
>>> layer we no longer care about the group abstraction because the system
>>> guarentees isolation in some other way.
>>
>> Uh.. I don't really know how mdevs are isolated from each other.  I
>> thought it was because the physical device providing the mdevs
>> effectively had an internal IOMMU (or at least DMA permissioning) to
>> isolate the mdevs, even though the physical device may not be fully
>> isolated.
>>
>> In that case the virtual mdev is effectively in a singleton group,
>> which is different from the group of its parent device.
> 

That's correct.

> That is one way to view it, but it means creating a whole group
> infrastructure and abusing the IOMMU stack just to create this
> nonsense fiction.

I really didn't get how this abuse the IOMMU stack.
mdev can be used in 3 different ways:
1. non-iommu backed mdev devices where mdev vendor driver takes care to
DMA map (iommu_map) and isolation is through device hardware internal
MMU. Here vfio_iommu_type1 module provides a way to validate and pin
pages required by mdev device for DMA mapping. Then IOMMU mapping is
done by mdev vendor driver which is owner driver of physical device.

2. iommu backed mdev devices for SRIOV where mdev device is created per
VF (mdev device == VF device) then that mdev device has same iommu
protection scope as VF associated to it. Here mdev device is virtual
device which uses features of mdev and represents underlying VF device,
same as vfio-pci but with additional mdev features.

3. iommu backed mdev devices for PASID with aux feature. I would not
comment on this, there has been a long discussion on this.

I don't think this is abusing IOMMU stack, atleast for 1 and 2 above.

Thanks,
Kirti


> We also abuse the VFIO container stuff to hackily
> create several different types pf IOMMU uAPIs for the mdev - all of
> which are unrelated to drivers/iommu.
> 
> Basically, there is no drivers/iommu thing involved, thus is no really
> iommu group, for mdev it is all a big hacky lie.
> 
>> If the physical device had a bug which meant the mdevs *weren't*
>> properly isolated from each other, then those mdevs would share a
>> group, and you *would* care about it.  Depending on how the isolation
>> failed the mdevs might or might not also share a group with the parent
>> physical device.
> 
> That isn't a real scenario.. mdevs that can't be isolated just
> wouldn't be useful to exist
> 
>>> This is today's model, yes. When you run dpdk on a multi-group device
>>> vfio already ensures that all the device groups remained parked and
>>> inaccessible.
>>
>> I'm not really following what you're saying there.
>>
>> If you have a multi-device group, and dpdk is using one device in it,
>> VFIO *does not* (and cannot) ensure that other devices in the group
>> are parked and inaccessible.
> 
> I mean in the sense that no other user space can open those devices
> and no kernel driver can later be attached to them.
> 
>> It ensures that they're parked at the moment the group moves from
>> kernel to userspace ownership, but it can't prevent dpdk from
>> accessing and unparking those devices via peer to peer DMA.
> 
> Right, and adding all this group stuff did nothing to alert the poor
> admin that is running DPDK to this risk.
> 
>>> If the administator configures the system with different security
>>> labels for different VFIO devices then yes removing groups makes this
>>> more tricky as all devices in the group should have the same label.
>>
>> That seems a bigger problem than "more tricky".  How would you propose
>> addressing this with your device-first model?
> 
> You put the same security labels you'd put on the group to the devices
> that consitute the group. It is only more tricky in the sense that the
> script that would have to do this will need to do more than ID the
> group to label but also ID the device members of the group and label
> their char nodes.
> 
> Jason
> 
