From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: don't allow the same type rq_qos add more than
 once
Date: Mon, 18 Jul 2022 09:22:47 -1000
Message-ID: <YtWzB6T7GBb7fiNe@slm.duckdns.org>
References: <20220718083646.67601-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L49cEqnvIqcH6kuvpQrqn6Zje6ktkAbRLUeIUPxx/7E=;
        b=AOJiH+SXnVmQJ+bGNsZclRXLODxNSpRAvPfO/VxS7r8q2g5X+8Xlta47Sl1pGHzkV+
         FwVS6nFN35kueD5zFoeT2Vv3mlbHyBS2eLHAXHY+HA81SCyD7KP1t86n3llHw0BDRhTg
         7ch/aSQGS5uqNET+mWyGr9MIsDr6aTo1b+6izOguOwAcCZPuG46lc3d9yq3pl2ncn2vD
         Viw2Q0xjJXJVjT2AMQBZ1fIMD63Tief5fi+JCPArIrudaYNEp/+tca6nW5kzvPHK8EvX
         OrRROGhSWJzS0qyYOUQQX6nlYAPRZP8RFAaRlfraANgBC65PrFNL+zLE+OpIUFOPlbpB
         kS5g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220718083646.67601-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666@bytedance.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello,

On Mon, Jul 18, 2022 at 04:36:46PM +0800, Jinke Han wrote:
> When the io.cost.qos file is written by two cpu concurrently, rq_qos may
> be added to one disk twice. In that case, there will be two iocs enabled
> and running on one disk. They own different iocgs on their active list.
> In the ioc_timer_fn function, because of the iocgs from two ioc have the
> same root iocg, the root iocg's walk_list may be overwritten by each
> other and this lead to list add/del corrutions in building or destorying
> the inner_walk list.
> 
> And so far, the blk-rq-qos framework works in case that one instance for
> one type rq_qos per queue by default. This patch make this explicit and
> also fix the crash above.

Ah, good catch. Looks great. Just a few nits below.

> Signed-off-by: hanjinke <hanjinke.666@bytedance.com>

Can you please use your full name in FIRST LAST form on the SOB line?

> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2886,7 +2886,12 @@ static int blk_iocost_init(struct request_queue *q)
>  	 * called before policy activation completion, can't assume that the
>  	 * target bio has an iocg associated and need to test for NULL iocg.
>  	 */
> -	rq_qos_add(q, rqos);
> +	ret = rq_qos_add(q, rqos);
> +	if (ret) {
> +		free_percpu(ioc->pcpu_stat);
> +		kfree(ioc);
> +		return ret;

Given that these get repeated for policy activation failure, it'd prolly be
better to factor them out at the end and use gotos and make all of the users
use the same pattern.

> +static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
>  {
>  	/*
>  	 * No IO can be in-flight when adding rqos, so freeze queue, which
> @@ -98,6 +98,8 @@ static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
>  	blk_mq_freeze_queue(q);
>  
>  	spin_lock_irq(&q->queue_lock);
> +	if (rq_qos_id(q, rqos->id))
> +		goto out;

Maybe rename the goto label to ebusy so that it's `goto ebusy`?

Other than the nits, please feel free to add

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
