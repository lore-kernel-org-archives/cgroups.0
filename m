From: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 10/10] blk-throttle: avoid dead code in
 throtl_hierarchy_can_upgrade
Date: Thu, 1 Dec 2022 09:36:06 +0800
Message-ID: <7a72b0b5-f534-f7aa-85c0-f1b97646f81c@huaweicloud.com>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-11-shikemeng@huawei.com>
 <Y4fMyEo0dxPl/Kt1@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y4fMyEo0dxPl/Kt1-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi, Tejun
on 12/1/2022 5:36 AM, Tejun Heo wrote:
> On Tue, Nov 29, 2022 at 11:01:47AM +0800, Kemeng Shi wrote:
>> Function throtl_hierarchy_can_upgrade will always return from while loop,
>> so the return outside while loop is never reached. Break the loop when
>> we traverse to root as throtl_hierarchy_can_downgrade do to avoid dead
>> code.
> 
> I don't know why this is an improvement.
> 
I just found that the "return false" outside of the while loop is never
executed which may be not reached by code coverage test. Of course,
we can simply remove this "return false", but I found a similar function
throtl_hierarchy_can_upgrade which has no such problem. So I avoid
unreachable code as throtl_hierarchy_can_upgrade do.
Is this make sense to you? If not, I will remove this patch in next
version.

Thanks.
-- 
Best wishes
Kemeng Shi

