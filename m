From: Li Jinlin <lijinlin3@huawei.com>
Subject: Re: [PATCH v2] blk-iocost: fix shift-out-of-bounds in
 iocg_hick_delay()
Date: Tue, 29 Nov 2022 10:49:08 +0800
Message-ID: <2830bd58-0f53-fa54-58e5-e87225b1fdf1@huawei.com>
References: <20221128030413.882998-1-lijinlin3@huawei.com>
 <Y4US2vFmR4pnw08Z@slm.duckdns.org>
 <bbc5e21f-9e77-41bb-5763-36bd905b52a0@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <bbc5e21f-9e77-41bb-5763-36bd905b52a0@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>, Tejun Heo <tj@kernel.org>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, liuzhiqiang26@huawei.com, "yukuai (C)" <yukuai3@huawei.com>



On 2022/11/29 9:14, Yu Kuai wrote:
> Hi,
> 
> 在 2022/11/29 3:58, Tejun Heo 写道:
>> On Mon, Nov 28, 2022 at 11:04:13AM +0800, Li Jinlin wrote:
>>>       /* calculate the current delay in effect - 1/2 every second */
>>>       tdelta = now->now - iocg->delay_at;
>>>       if (iocg->delay)
>>> -        delay = iocg->delay >> div64_u64(tdelta, USEC_PER_SEC);
>>> +        delay = iocg->delay >>
>>> +            min_t(u64, div64_u64(tdelta, USEC_PER_SEC), 63);
>>
>> I replied earlier but the right thing to do here is setting delay to 0 if
>> the shift is >= 64.
> 
> Perhaps following change will make more sense?
> 
> @@ -1322,18 +1323,19 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
>  {
>         struct ioc *ioc = iocg->ioc;
>         struct blkcg_gq *blkg = iocg_to_blkg(iocg);
> -       u64 tdelta, delay, new_delay;
> +       u64 delay = 0;
> +       u64 new_delay;
>         s64 vover, vover_pct;
>         u32 hwa;
> 
>         lockdep_assert_held(&iocg->waitq.lock);
> 
>         /* calculate the current delay in effect - 1/2 every second */
> -       tdelta = now->now - iocg->delay_at;
> -       if (iocg->delay)
> +       if (iocg->delay && now->now > iocg->delay_at) {
> +               u64 tdelta = now->now - iocg->delay_at;
> +
>                 delay = iocg->delay >> div64_u64(tdelta, USEC_PER_SEC);
> -       else
> -               delay = 0;
> +       }
> 
I think "now->now > iocg->delay_at" is unnecessary, it is almost inevitable.

What about the following change for setting delay to 0 if the shift is >= 64.

@@ -1329,11 +1329,9 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
        lockdep_assert_held(&iocg->waitq.lock);

        /* calculate the current delay in effect - 1/2 every second */
-       tdelta = now->now - iocg->delay_at;
        if (iocg->delay)
-               delay = iocg->delay >> div64_u64(tdelta, USEC_PER_SEC);
-       else
-               delay = 0;
+               tdelta = div64_u64(now->now - iocg->delay_at, USEC_PER_SEC);
+       delay = (iocg->delay && tdelta < 64) ? iocg->delay >> tdelta : 0;

        /* calculate the new delay from the debt amount */
        current_hweight(iocg, &hwa, NULL);

Jinlin
Thanks.
>>
>> Thanks.
>>
> 
