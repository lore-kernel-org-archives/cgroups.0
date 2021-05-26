From: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 26 May 2021 23:40:02 +0530
Message-ID: <6f9dad1a-4e15-1703-d6f4-1b51b7fde15a@nvidia.com>
References: <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box> <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box> <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko> <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko> <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko> <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525165252.6959d9da.alex.williamson@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0XVL//L5kNQF28/pBy3nYSAekRS7X1lV3wJ+fMoxx0=;
 b=XRNirzhA8xtJfqbBIvAtnrux6Cv1pxx16UQKPiE5+EYvW+Z6Ltjci1aJNx21oE4C63VyVtr9FfU1Y0Vq97694G0kb7jMim9B1Z72kGlvCVeL1fFg9pVDqQmT5yeX2sCap0YDCkwNdrKm2+c5bQthdlfLJdEmLA/gEI6recFkVBUaYLBc2MSqBHLlemgXZaqxfxC4FIQzJVkR9PInBbG4Wq+ivAGjpwMY756wOO24VQCQ+Xl2osR8zX3QHjcYX4pOaVz+Ml0o5WA0mNyAdI3hNUYfjQC96lFRqL9xbE8QAw+6+y0UuDf/uIrrnE4HSHUQusW4hkiDeFRZhrazkoJjpQ==
In-Reply-To: <20210525165252.6959d9da.alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>



On 5/26/2021 4:22 AM, Alex Williamson wrote:
> On Wed, 26 May 2021 00:56:30 +0530
> Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> On 5/25/2021 5:07 AM, Jason Gunthorpe wrote:
>>> On Mon, May 24, 2021 at 05:52:58PM +1000, David Gibson wrote:
>>>    
>>>>>> I don't really see a semantic distinction between "always one-device
>>>>>> groups" and "groups don't matter".  Really the only way you can afford
>>>>>> to not care about groups is if they're singletons.
>>>>>
>>>>> The kernel driver under the mdev may not be in an "always one-device"
>>>>> group.
>>>>
>>>> I don't really understand what you mean by that.
>>>
>>> I mean the group of the mdev's actual DMA device may have multiple
>>> things in it.
>>>      
>>>>> It is a kernel driver so the only thing we know and care about is that
>>>>> all devices in the HW group are bound to kernel drivers.
>>>>>
>>>>> The vfio device that spawns from this kernel driver is really a
>>>>> "groups don't matter" vfio device because at the IOMMU layer it should
>>>>> be riding on the physical group of the kernel driver.  At the VFIO
>>>>> layer we no longer care about the group abstraction because the system
>>>>> guarentees isolation in some other way.
>>>>
>>>> Uh.. I don't really know how mdevs are isolated from each other.  I
>>>> thought it was because the physical device providing the mdevs
>>>> effectively had an internal IOMMU (or at least DMA permissioning) to
>>>> isolate the mdevs, even though the physical device may not be fully
>>>> isolated.
>>>>
>>>> In that case the virtual mdev is effectively in a singleton group,
>>>> which is different from the group of its parent device.
>>>    
>>
>> That's correct.
>>
>>> That is one way to view it, but it means creating a whole group
>>> infrastructure and abusing the IOMMU stack just to create this
>>> nonsense fiction.
>>
>> I really didn't get how this abuse the IOMMU stack.
>> mdev can be used in 3 different ways:
>> 1. non-iommu backed mdev devices where mdev vendor driver takes care to
>> DMA map (iommu_map) and isolation is through device hardware internal
>> MMU. Here vfio_iommu_type1 module provides a way to validate and pin
>> pages required by mdev device for DMA mapping. Then IOMMU mapping is
>> done by mdev vendor driver which is owner driver of physical device.
>>
>> 2. iommu backed mdev devices for SRIOV where mdev device is created per
>> VF (mdev device == VF device) then that mdev device has same iommu
>> protection scope as VF associated to it. Here mdev device is virtual
>> device which uses features of mdev and represents underlying VF device,
>> same as vfio-pci but with additional mdev features.
> 
> What features would those be?  There are no mdev specific parts of the
> vfio uAPI.
> 
> The mdev device is a virtual device, by why it it virtual in this case?
> Aren't we effectively assigning the VF itself (mdev device == VF device)
> with a bunch of extra support code to fill in the gaps of the VF
> implementing the complete device model in hardware?
> 
> We're effectively creating this virtual device, creating a fake IOMMU
> group, and trying to create this association of this virtual device to
> the real VF in order to shoehorn it into the mdev model.  What do we
> get from that model other than lifecycle management (ie. type selection)
> and re-use of a bunch of code from the driver supporting the 1) model
> above?
> 

Yes, the lifecycle management which is in mdev is not in vfio-pci variant.

> This specific model seems better served by a device specific peer
> driver to vfio-pci (ie. a "vfio-pci variant").  You effectively already
> have the code for this driver, it's just in the format of an mdev
> driver rather than a vfio "bus driver".  The work Jason references
> relative to Max aims to make these kinds of drivers easier to implement
> through re-use of vfio-pci code.
> 
> There are certainly other solutions we could come up with for selecting
> a specific device type for a vfio-pci variant driver to implement other
> than pretending this model actually belongs in mdev, right?  Thanks,
> 

Sure and would like to see type selection mechanism to be implemented in 
vfio-pci variant.

Thanks,
Kirti

