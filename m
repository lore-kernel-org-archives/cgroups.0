From: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 5 May 2021 14:28:53 +1000
Message-ID: <7e5c2276-ca1c-a8af-c15f-72a7c83c8bfa@ozlabs.ru>
References: <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com> <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box> <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box> <20210429002149.GZ1370958@nvidia.com>
 <YIol9p3z8BTWFRh8@yekko> <20210503160530.GL1370958@nvidia.com>
 <YJDFj+sAv41JRIo4@yekko> <20210504181537.GC1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dkfLmEwUYBpgZ3VRNqk3l0eUK71c8qK9M3LO8M6K/A4=;
        b=j/2/x3IGENqBt1eM/uTRys9FwUAyOd7d1CPrhgnUeDqkdWgk208eetcKGgAwQm0ClS
         807Quye1hCoirriQHZ8jB6fGbUq8JRjgdvApCO7Sk2LBzgsemv98xXqPqhRBtNTYFbQ2
         c+pvRacMoE5zUBhZlKz1Zp/I3sP37UVPa/SyFRnF0O9Vv0+UUbY2fjviPRN77nwLubJm
         WkGzNUwF7P0ucQPk4Bw8kKF/DF8Lt/l4gAxFgApBd4DtEkMPmr//4N1veXHtU6pvce11
         I2Ygs6SMbnq3+EW7szo7yKB9Z6UagEOZuXHkUZLToFvlJwesJGEXi2KI7w4v+L0cFgNN
         jqBg==
Content-Language: en-US
In-Reply-To: <20210504181537.GC1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>



On 05/05/2021 04:15, Jason Gunthorpe wrote:
> On Tue, May 04, 2021 at 01:54:55PM +1000, David Gibson wrote:
>> On Mon, May 03, 2021 at 01:05:30PM -0300, Jason Gunthorpe wrote:
>>> On Thu, Apr 29, 2021 at 01:20:22PM +1000, David Gibson wrote:
>>>>> There is a certain appeal to having some
>>>>> 'PPC_TCE_CREATE_SPECIAL_IOASID' entry point that has a wack of extra
>>>>> information like windows that can be optionally called by the viommu
>>>>> driver and it remains well defined and described.
>>>>
>>>> Windows really aren't ppc specific.  They're absolutely there on x86
>>>> and everything else as well - it's just that people are used to having
>>>> a window at 0..<something largish> that you can often get away with
>>>> treating it sloppily.
>>>
>>> My point is this detailed control seems to go on to more than just
>>> windows. As you say the vIOMMU is emulating specific HW that needs to
>>> have kernel interfaces to match it exactly.
>>
>> It's really not that bad.  The case of emulating the PAPR vIOMMU on
>> something else is relatively easy, because all updates to the IO page
>> tables go through hypercalls.  So, as long as the backend IOMMU can
>> map all the IOVAs that the guest IOMMU can, then qemu's implementation
>> of those hypercalls just needs to put an equivalent mapping in the
>> backend, which it can do with a generic VFIO_DMA_MAP.
> 
> So you also want the PAPR vIOMMU driver to run on, say, an ARM IOMMU?


This is a good feature in general when let's say there is a linux 
supported device which has a proprietary device firmware update tool 
which only exists as an x86 binary and your hardware is not x86 - 
running qemu + vfio in full emulation would provide a way to run the 
tool to update a physical device.


-- 
Alexey
