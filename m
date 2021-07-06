From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: prevent rcu_sched detected stalls warnings
 while iterating blkgs
Date: Tue, 6 Jul 2021 07:56:30 -1000
Message-ID: <YOSZTpTtKz2wyFO3@mtj.duckdns.org>
References: <20210702040444.1917834-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XG//MamfUR6shTS4467vh766S9Op+itGfSMIx5as4Hs=;
        b=Ls3/wMIo360OeFOWB9ZaFy0FI3Zy4NCEqHG750gNi1+cgEu6ATJuCAO0N3O4PC592I
         fjFOsLmWhQboZoCSSq37rZrmmuU2LmYz9T2k7z++Th5GFxufHJoC3QFQpU6EKvpuU/Pv
         dL9NLTMEyU/vaz3QWeFesiy1nhn+9Vb9YjODUTLWRHvqPhlfCuV/uhej9/Po6RdjvVR0
         ozTF3hL1a7ZGy6nqzdTvHsCf0mJ+PbSlFzP4Rp9CVuG5LMO65lfrm+heU6qVeRDHqp8u
         iWv9VHZSYdUL/IMUmIQIttykWLZ6Xwq4G/J74aOCILk2XbidF1Gj+g+wS31pQFHo7ewI
         /LXw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210702040444.1917834-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello, Yu.

On Fri, Jul 02, 2021 at 12:04:44PM +0800, Yu Kuai wrote:
> blkcg_activate_policy() and blkcg_deactivate_policy() might have the
> same problem, fix them the same way.

Given that these are basically only called from module init/exit paths,
let's leave them alone for now.

> +#define BLKG_BATCH_OP_NUM 64

Can we do BLKG_DESTRY_BATCH_SIZE instead?

>  static void blkg_destroy_all(struct request_queue *q)
>  {
>  	struct blkcg_gq *blkg, *n;
> +	int count = BLKG_BATCH_OP_NUM;
>  
> +restart:
>  	spin_lock_irq(&q->queue_lock);
>  	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
>  		struct blkcg *blkcg = blkg->blkcg;
> @@ -430,6 +434,17 @@ static void blkg_destroy_all(struct request_queue *q)
>  		spin_lock(&blkcg->lock);
>  		blkg_destroy(blkg);
>  		spin_unlock(&blkcg->lock);
> +
> +		/*
> +		 * in order to avoid holding the spin lock for too long, release
> +		 * it when a batch of blkgs are destroyed.
> +		 */
> +		if (!(--count)) {
> +			count = BLKG_BATCH_OP_NUM;
> +			spin_unlock_irq(&q->queue_lock);
> +			cond_resched();
> +			goto restart;
> +		}
>  	}

This part looks good otherwise.

Thanks.

-- 
tejun
