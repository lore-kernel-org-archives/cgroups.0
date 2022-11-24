From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] blk-throttle: Use more siutable time_after check
 for update slice_start
Date: Thu, 24 Nov 2022 21:02:03 +0800
Message-ID: <ba735734-cffe-18a9-8bb5-03f47c3c8018@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-12-shikemeng@huawei.com>
 <Y35mnXMNg8HeHXbb@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y35mnXMNg8HeHXbb-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



on 11/24/2022 2:29 AM, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 02:04:01PM +0800, Kemeng Shi wrote:
>> Use more siutable time_after check for update slice_start
> 
> Why is it more suitable?
There is no need to assign tg->slice_start[rw] to start when they are
equal already. So time_after seems more suitable here.

-- 
Best wishes
Kemeng Shi
