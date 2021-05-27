From: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Thu, 27 May 2021 23:55:00 +0530
Message-ID: <2476b70c-9320-a49c-efa5-fb7027e1b572@nvidia.com>
References: <20210428145622.GU1370958@nvidia.com> <YIoiJRY3FM7xH2bH@yekko>
 <20210503161518.GM1370958@nvidia.com> <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com> <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com>
 <6b13399d-cf03-1e71-3624-c39d4d05e958@nvidia.com> <YK8nXKAJdfT5UVEu@yekko>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yHNJ/tHpoRmzUSCDLrlfwzUiIzLXw6x/NlDpR9tA5To=;
 b=KEsTRw5JhfE0s2RrUxdn8msH5OP6B2U0EW86gvU7ixZIdrBIUqNY+5CzeoLTvs/ccSX+/kLYfzerc2QrQilAOIH1SEuHo7VpGMVo+EPlSTlyMBiNOAAdZAG9i4eamBLT8cbaC+1SJPFztuFw2ZWq91qI3ZYhqQB1Ke4m2R9s4ySxg9bbpPtOY07QaMWtj8LBOTW5CtZNs2EaOkErwKftti1rCM1ZjXh66eLM5NJJqNLagESVVqby+TTgrUoUn0Vy3Jtg4ofBoXdlYN6RRM0IOPu3NIqf49QcYttx2QMykF4uh+OAhWbVo4LRM6JSr5+8TnWtzQ0MpSHRjX6ApjxIyQ==
In-Reply-To: <YK8nXKAJdfT5UVEu@yekko>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj@inte>



On 5/27/2021 10:30 AM, David Gibson wrote:
> On Wed, May 26, 2021 at 02:48:03AM +0530, Kirti Wankhede wrote:
>>
>>
>> On 5/26/2021 1:22 AM, Jason Gunthorpe wrote:
>>> On Wed, May 26, 2021 at 12:56:30AM +0530, Kirti Wankhede wrote:
>>>
>>>> 2. iommu backed mdev devices for SRIOV where mdev device is created per
>>>> VF (mdev device == VF device) then that mdev device has same iommu
>>>> protection scope as VF associated to it.
>>>
>>> This doesn't require, and certainly shouldn't create, a fake group.
>>>
>>> Only the VF's real IOMMU group should be used to model an iommu domain
>>> linked to a VF. Injecting fake groups that are proxies for real groups
>>> only opens the possibility of security problems like David is
>>> concerned with.
>>>
>>
>> I think this security issue should be addressed by letting mdev device
>> inherit its parent's iommu_group, i.e. VF's iommu_group here.
> 
> No, that doesn't work.  AIUI part of the whole point of mdevs is to
> allow chunks of a single PCI function to be handed out to different
> places, because they're isolated from each other not by the system
> IOMMU, but by a combination of MMU hardware in the hardware (e.g. in a
> GPU card) and software in the mdev driver. 

That's correct for non-iommu backed mdev devices.

> If mdevs inherited the
> group of their parent device they wouldn't count as isolated from each
> other, which they should.
> 

For iommu backed mdev devices for SRIOV, where there can be single mdev 
device for its parent, here parent device is VF, there can't be multiple 
mdev devices associated with that VF. In this case mdev can inherit the 
group of parent device.

Kirti
