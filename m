From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] blk-cgroup: prevent rcu_sched detected stalls
 warnings in blkg_destroy_all()
Date: Wed, 25 Nov 2020 07:32:48 -0500
Message-ID: <X75O8BNVSX3ZE86w@mtj.duckdns.org>
References: <20201121083420.3857433-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H3aqrBY6oYhCd62SVodU601+HB4mzl3pG4lUcfT04Cg=;
        b=m8eiXGIffxTQcl9qWmpoUZgBsSzJBJL+g8a+25Jt5FKxrq5reTIQJIvOqHam06ytUT
         +AVBi6gElJoegN0PJweNe4OCeUoDzFODyFHPyIln49wZ5mShP7YmWW3JcvzSHisvU3RY
         HvY920z0TDVKvZHVGUl0hW04u6KPVUTYgkRsiSfEQ5wXOQlIapC1e1DPv6ahx8onYMVI
         RK3uA/nnhPE9+aELC01Cnp4okGEgdmF1asc72P2GBtujVywjnmfE22z+BSjYMM6mL8Q6
         c9LsElOYkPJODDqa7BlptGqmUGWMtnSAY3T7eNQCvLF8h3PLrE397W3APYrR+NuKSx2g
         3d/g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201121083420.3857433-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiaoxu5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello,

Thanks for the fix. A couple comments below.

On Sat, Nov 21, 2020 at 04:34:20PM +0800, Yu Kuai wrote:
> +#define BLKG_DESTROY_BATH 4096

I think you meant BLKG_DESTROY_BATCH.

>  static void blkg_destroy_all(struct request_queue *q)
>  {
>  	struct blkcg_gq *blkg, *n;
> +	int count = BLKG_DESTROY_BATH;

But might as well just write 4096 here.

>  	spin_lock_irq(&q->queue_lock);
>  	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
>  		struct blkcg *blkcg = blkg->blkcg;
>  
> +		/*
> +		 * If the list is too long, the loop can took a long time,
> +		 * thus relese the lock for a while when a batch of blkcg
> +		 * were destroyed.
> +		 */
> +		if (!(--count)) {
> +			count = BLKG_DESTROY_BATH;
> +			spin_unlock_irq(&q->queue_lock);
> +			cond_resched();
> +			spin_lock_irq(&q->queue_lock);

You can't continue iteration after dropping both locks. You'd have to jump
out of loop and start list_for_each_entry_safe() again.

> +		}
>  		spin_lock(&blkcg->lock);
>  		blkg_destroy(blkg);
>  		spin_unlock(&blkcg->lock);

Thanks.

-- 
tejun
