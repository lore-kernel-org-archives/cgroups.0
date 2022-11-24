From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/11] blk-throttle: Limit whole system if root group is
 configured when on the default hierarchy
Date: Thu, 24 Nov 2022 19:47:15 +0800
Message-ID: <2c477253-eb89-260f-adde-5850d749b000@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-2-shikemeng@huawei.com>
 <Y35UVRg0tTfsTdrB@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y35UVRg0tTfsTdrB-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



on 11/24/2022 1:11 AM, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 02:03:51PM +0800, Kemeng Shi wrote:
>> Quoted from comment in throtl_pd_init: "If on the default hierarchy, we
>> switch to properly hierarchical behavior where limits on a given
>> throtl_grp are applied to the whole subtree rather than just the group
>> itself. e.g. If 16M read_bps limit is set on the root group, the whole
>> system can' exceed 16M for the device."
> 
> On the default hierarchy (cgroup2), the throttle interface files don't exist
> in the root cgroup. In general, cgroup doesn't wanna be in the business of
> restricting resources at the system level.
Hi, Tejun. Thanks for review. If restricting is not needed anymore, the stale
comment "e.g. If 16M read_bps limit is set on the root group, the whole system
can' exceed 16M for the device." may better be remove. I will remove this
in next version.


-- 
Best wishes
Kemeng Shi
