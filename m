From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/11] blk-throttle: correct calculation of wait time in
 tg_may_dispatch
Date: Thu, 24 Nov 2022 20:10:03 +0800
Message-ID: <fdf1aa87-b459-172a-f3f0-31afcb696c76@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-5-shikemeng@huawei.com>
 <Y35kELlFkI/BtkqC@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y35kELlFkI/BtkqC-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
on 11/24/2022 2:18 AM, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 02:03:54PM +0800, Kemeng Shi wrote:
>> If bps and iops both reach limit, we always return bps wait time as
>> tg_within_iops_limit is after "tg_within_bps_limit(tg, bio, bps_limit) &&"
>> and will not be called if tg_within_bps_limit return true.
Here is a mistake, the right word should be:
tg_within_iops_limit is after "tg_within_bps_limit(tg, bio, bps_limit) &&"
and will not be called if tg_within_bps_limit return *false*.
> Maybe it's obvious but it'd be better to explain "why" this change is being
> made.
In C language, When executing "if (expression1 && expression2)" and
expression1 return false, the expression2 may not be executed.
For "tg_within_bps_limit(tg, bio, bps_limit, &bps_wait) &&
tg_within_iops_limit(tg, bio, iops_limit, &iops_wait))", if bps is
limited, tg_within_bps_limit will return false and
tg_within_iops_limit will not be called. So even bps and iops are
both limited, iops_wait will not be calculated and is zero here.
So wait time of bps is always returned.
>> @@ -939,8 +926,9 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
>>  				jiffies + tg->td->throtl_slice);
>>  	}
>>  
>> -	if (tg_within_bps_limit(tg, bio, bps_limit, &bps_wait) &&
>> -	    tg_within_iops_limit(tg, bio, iops_limit, &iops_wait)) {
>> +	bps_wait = tg_within_bps_limit(tg, bio, bps_limit);
>> +	iops_wait = tg_within_iops_limit(tg, bio, iops_limit);
>> +	if (bps_wait + iops_wait == 0) {
>>  		if (wait)
>>  			*wait = 0;
>>  		return true;
> 
> So, max_wait is supposed to be maximum in the whole traversal path in the
> tree, not just the max value in this tg, so after this, the code should be
> changed to sth like the following, right?
> 
>         max_wait = max(max, max(bps_wait, iops_wait));
> 
> Thanks.
> 

-- 
Best wishes
Kemeng Shi
