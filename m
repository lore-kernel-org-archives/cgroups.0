From: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 26 May 2021 02:48:03 +0530
Message-ID: <6b13399d-cf03-1e71-3624-c39d4d05e958@nvidia.com>
References: <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box> <20210428145622.GU1370958@nvidia.com>
 <YIoiJRY3FM7xH2bH@yekko> <20210503161518.GM1370958@nvidia.com>
 <YJy9o8uEZs42/qDM@yekko> <20210513135938.GG1002214@nvidia.com>
 <YKtbWo7PwIlXjFIV@yekko> <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RG+TkWyAjgSfV57JTYBN5pfP9qi8Aer6pL70Iw1rpRc=;
 b=FLxNl4gntkYbUALm1qMFLZkQDuzm9x8AEpHHvFDu8F4xdDQT7csGgwLVECogKcF1Zay+1gG846omCt2RZm9SUBb4lQR0lMLLt8uoejDpg1t4bcWHg+laA0eregegOJCLZipIQKiJuPDXwZ28QV9OiyKO0WR826Y1PSp57DF9VO0qlVbGUtgkptcCAzBZeOQ0Ieb63Z3Rw8+cgqT+u4fA9QzNOzTYEcVtvV2fylgLSqYaIT/N21AIMrB4HicKcTDEwcRHrzMDYzXvdKcPW6il8sfzt5ktufenjzPbVZsbw5fWAoVfedHakZiQvQ7RIXxbOfxljpJ75Uvu/Gohg6kO9w==
In-Reply-To: <20210525195257.GG1002214-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <asho>



On 5/26/2021 1:22 AM, Jason Gunthorpe wrote:
> On Wed, May 26, 2021 at 12:56:30AM +0530, Kirti Wankhede wrote:
> 
>> 2. iommu backed mdev devices for SRIOV where mdev device is created per
>> VF (mdev device == VF device) then that mdev device has same iommu
>> protection scope as VF associated to it.
> 
> This doesn't require, and certainly shouldn't create, a fake group.
> 
> Only the VF's real IOMMU group should be used to model an iommu domain
> linked to a VF. Injecting fake groups that are proxies for real groups
> only opens the possibility of security problems like David is
> concerned with.
> 

I think this security issue should be addressed by letting mdev device 
inherit its parent's iommu_group, i.e. VF's iommu_group here.

Kirti

> Max's series approaches this properly by fully linking the struct
> pci_device of the VF throughout the entire VFIO scheme, including the
> group and container, while still allowing override of various VFIO
> operations.
> 
> Jason
> 
