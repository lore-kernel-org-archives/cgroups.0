From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/11] blk-throttle: Fix that bps of child could exceed
 bps limited in parent
Date: Thu, 24 Nov 2022 19:49:23 +0800
Message-ID: <d102136f-5a2a-fade-bce9-1c7550599331@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-3-shikemeng@huawei.com>
 <Y35h9SmFeEJtBNgM@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y35h9SmFeEJtBNgM-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



on 11/24/2022 2:09 AM, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 02:03:52PM +0800, Kemeng Shi wrote:
>> @@ -964,10 +963,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
>>  	unsigned int bio_size = throtl_bio_data_size(bio);
>>  
>>  	/* Charge the bio to the group */
>> -	if (!bio_flagged(bio, BIO_BPS_THROTTLED)) {
>> -		tg->bytes_disp[rw] += bio_size;
>> -		tg->last_bytes_disp[rw] += bio_size;
>> -	}
>> +	tg->bytes_disp[rw] += bio_size;
>> +	tg->last_bytes_disp[rw] += bio_size;
> 
> Are you sure this isn't gonna lead to double accounting? IIRC, the primary
> purpose of this flag is avoiding duplicate accounting of bios which end up
> going through the throttling path multiple times for whatever reason and
> we've had numerous breakages around it.
Sorry for the mistake, this change does lead to double accounting.
> To address the problem you're describing in this patch, wouldn't it make
> more sense to set the flag only when the bio traversed the entire tree
> rather than after each tg?
I will address the problem in this way in next version. Thanks for the
advice.

-- 
Best wishes
Kemeng Shi
