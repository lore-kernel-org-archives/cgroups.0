From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] blk-cgroup: Add NULL check of pd_alloc_fn in
 blkcg_activate_policy
Date: Tue, 11 Oct 2022 09:23:45 +0800
Message-ID: <c62a8944-093f-8534-106c-51b159696008@huawei.com>
References: <20221010023859.11896-1-shikemeng@huawei.com>
 <20221010023859.11896-4-shikemeng@huawei.com>
 <Y0SAneaJadYJwAkr@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y0SAneaJadYJwAkr-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



on 10/11/2022 4:29 AM, Tejun Heo wrote:
> On Mon, Oct 10, 2022 at 10:38:58AM +0800, Kemeng Shi wrote:
>> Function blkcg_policy_register only make sure pd_alloc_fn and pd_free_fn in
>> pairs, so pd_alloc_fn could be NULL in registered blkcg_policy. Check NULL
>> before use for pd_alloc_fn in blkcg_activate_policy to avoid protential
>> NULL dereference.
>>
>> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  block/blk-cgroup.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index 463c568d3e86..fc083c35dc42 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -1404,6 +1404,9 @@ int blkcg_activate_policy(struct request_queue *q,
>>  	if (blkcg_policy_enabled(q, pol))
>>  		return 0;
>>  
>> +	if (pol->pd_alloc_fn == NULL)
>> +		return -EINVAL;
> 
> This isn't the only place this function is called, so the above won't
> achieve much. Given that this is rather trivially noticeable and all the
> current users do implement pd_alloc_fn, I'm not sure we need to update this
> now.
Thanks for review. The rest call of this function will always protect by
blkcg_policy_enabled while policy only can be enabled if new added NULL
check is passed. So the new added NULL check enough.

By the way, the policy enable/disable work is direct call to
__set_bit(pol->plid, q->blkcg_pols) in blkcg_policy_enabled
and __clear_bit(pol->plid, q->blkcg_pols) in blkcg_deactivate_policy
which is not intuitive. Is it a good idea to add function
blkcg_policy_enable and blkcg_policy_disable to improve readability?

> 
> Thanks.
> 

-- 
Best wishes
Kemeng Shi
