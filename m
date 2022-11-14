From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Mon, 14 Nov 2022 12:07:45 -1000
Message-ID: <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MWARFSddCBGf3aDJ1ajp1vvhpqhBLlESZgXSjfkXOvE=;
        b=Rj3+QSD9G8LsBjjcl+TZ+GbTq/H+NRXDvqWs514daNHR6TDjwFkYDPf1p7/YOF7hO6
         Tb+lHshVBcpxKv2DQ1iH59S8BS+QoFNTkf1gRW2LnSsr8EkGAL351/5lMZioGE7gAVT+
         Uv9bbkWdcUahORFNMt6ilxcyZ+7jjA0wayeIGf9nKRcJjikKX7tI6XB2R/4AJhHWaumP
         Blb+W0FP+SPDMTFOyNx335xcG/5z/pQcPEBZ80MC0OyrPSAltOXYzi6RRjUOfGYqpwAN
         5ZRxTO930TiFg4XjmFKFIujDHdHsJ4gFbylwG7bIzdOJvbwo4FXiC2D46TLjfpQTVEdl
         1ogQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221104023938.2346986-5-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Nov 04, 2022 at 10:39:37AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> match_u64() is called inside ioc->lock, which causes smatch static
> checker warnings:
> 
> block/blk-iocost.c:3211 ioc_qos_write() warn: sleeping in atomic context
> block/blk-iocost.c:3240 ioc_qos_write() warn: sleeping in atomic context
> block/blk-iocost.c:3407 ioc_cost_model_write() warn: sleeping in atomic
> context
> 
> Fix the problem by introducing a mutex and using it while prasing input
> params.

It bothers me that parsing an u64 string requires a GFP_KERNEL memory
allocation.

> @@ -2801,9 +2806,11 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
>  {
>  	struct ioc *ioc = rqos_to_ioc(rqos);
>  
> +	mutex_lock(&ioc->params_mutex);
>  	spin_lock_irq(&ioc->lock);
>  	ioc_refresh_params(ioc, false);
>  	spin_unlock_irq(&ioc->lock);
> +	mutex_unlock(&ioc->params_mutex);
>  }

Aren't the params still protected by ioc->lock? Why do we need to grab both?

Any chance I can persuade you into updating match_NUMBER() helpers to not
use match_strdup()? They can easily disable irq/preemption and use percpu
buffers and we won't need most of this patchset.

Thanks.

-- 
tejun
