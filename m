From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/11] blk-throttle: remove unnecessary check for
 validation of limit index
Date: Thu, 24 Nov 2022 20:58:50 +0800
Message-ID: <95ff6d32-7f4e-8ae3-8c95-4ce8ff111330@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-10-shikemeng@huawei.com>
 <Y35nG1CguzXf0GX8@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y35nG1CguzXf0GX8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



on 11/24/2022 2:31 AM, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 02:03:59PM +0800, Kemeng Shi wrote:
>> We always keep limit index valid as following:
>> Max limit is always valid and low limit can only be invalidated in
>> blk_throtl_update_limit_valid. Each time low limit may become invalid
>> after blk_throtl_update_limit_valid is called, we will check and make
>> sure current limit index is valid.
>>
>> It's reasonable to always keep limit index valid, so we can remove this
>> check.
> 
> It's not obvious to me that it's correct and I'm not sure what we're gaining
> by removing this while risking subtle breakages.
I will remove this patch in next version.

-- 
Best wishes
Kemeng Shi
