From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: check blkcg policy is enabled in
 blkg_create()
Date: Wed, 13 Oct 2021 19:47:23 +0800
Message-ID: <68bd1b2c-f4a6-664c-0812-30cb458d0f15@huawei.com>
References: <20211008072720.797814-1-yukuai3@huawei.com>
 <YWRxi2OaIHhG9rOc@slm.duckdns.org>
 <9d9ac88b-43e6-5b50-bc0b-98ad4704eca5@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9d9ac88b-43e6-5b50-bc0b-98ad4704eca5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2021/10/12 9:39, yukuai (C) wrote:
> On 2021/10/12 1:16, Tejun Heo wrote:
>> On Fri, Oct 08, 2021 at 03:27:20PM +0800, Yu Kuai wrote:
>>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>>> index eb48090eefce..00e1d97621ea 100644
>>> --- a/block/blk-cgroup.c
>>> +++ b/block/blk-cgroup.c
>>> @@ -226,6 +226,20 @@ struct blkcg_gq *blkg_lookup_slowpath(struct 
>>> blkcg *blkcg,
>>>   }
>>>   EXPORT_SYMBOL_GPL(blkg_lookup_slowpath);
>>> +static void blkg_check_pd(struct request_queue *q, struct blkcg_gq 
>>> *blkg)
>>> +{
>>> +    int i;
>>> +
>>> +    for (i = 0; i < BLKCG_MAX_POLS; i++) {
>>> +        struct blkcg_policy *pol = blkcg_policy[i];
>>> +
>>> +        if (blkg->pd[i] && !blkcg_policy_enabled(q, pol)) {
>>> +            pol->pd_free_fn(blkg->pd[i]);
>>> +            blkg->pd[i] = NULL;
>>> +        }
>>> +    }
>>> +}
>>> +
>>>   /*
>>>    * If @new_blkg is %NULL, this function tries to allocate a new one as
>>>    * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on 
>>> return.
>>> @@ -252,6 +266,9 @@ static struct blkcg_gq *blkg_create(struct blkcg 
>>> *blkcg,
>>>           goto err_free_blkg;
>>>       }
>>> +    if (new_blkg)
>>> +        blkg_check_pd(q, new_blkg);
>>> +
>>
>> Can't this happen the other way around too? ie. Linking a pd which 
>> doesn't
>> have an entry for a policy which got enabled inbetween? And what if an
>> existing policy was de-registered and another policy got the policy id
>> inbetween? I think the correct solution here would be synchronizing 
>> alloc -
>> create blocks against policy deactivation rather than trying to patch an
>> allocated blkg later. Deactivation being a really slow path, there are
>> plenty of options. The main challenge would making it difficult to make
>> mistakes with, I guess.
> 
> For the case policy was de-registered, I think there won't be a problem
> because pd_init_fn() is not called yet, and the blkg is not at
> blkg_list, it's fine to use this blkg for the new policy.
> 
> For the case policy got enabled inbetween, the problem is that the pd
> still doesn't have an entry for the policy, perhaps we can call
> pd_alloc_fn() additionally in blkg_create?
> 
> If checking the blkg in blkg_create() is not a good solution, and we
> decide to synchronize alloc-create blkg against policy deactivation.
> Since only bfq policy can be deactivated or activated while queue is
> not dying, and queue is freezed during activation and deactivation,
> can we get a q->q_usage_counter and put it after blkg_create() is done
> to prevent concurrent bfq policy activation and deactivation?

Just found that blkcg_deactivate_policy() will call
blk_mq_freeze_queue(), thus get q->q_usage_counter is wrong...

Thanks,
Kuai
