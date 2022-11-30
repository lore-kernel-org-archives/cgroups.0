From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 9/9] blk-iocost: fix walk_list corruption
Date: Wed, 30 Nov 2022 10:59:21 -1000
Message-ID: <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-10-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KIYpJVsaC2x+XnAlDSlXu4uym9M5TWj5fDbLd+7AM/E=;
        b=L3xnIn1wpdKuckgw3HI3r9z5iKC3uwdevPZfrmuw/b1jbfj8jdJZOVswk68vmHn21o
         GQIMOdSuBk3OSFNfE5YkGrKQYmOAJXxjZ/OOmypnCTW2dKtMhIwfS6REwkk1yvNj/S44
         J4LLD7cKy1OuyHR0nUgcwYERHY3LZ2sylZS9yV13BTl52i043eQ5AlmWFMaOVx5tO2kv
         BNcNqw1cIrppabgEjw6zABGeSWTQrfcTf82haH3t3cfS3MRe2qXlDHgp5Unhd3YgnDhR
         NtaZm7+cfOR/kyaayPzmtzqAGGYUauQcJxb2ozki3p6nIkj0vzpTRSq4i2r6NgotGDR3
         5oKg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-10-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Wed, Nov 30, 2022 at 09:21:56PM +0800, Li Nan wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Our test report a problem:
> 
> ------------[ cut here ]------------
> list_del corruption. next->prev should be ffff888127e0c4b0, but was ffff888127e090b0
> WARNING: CPU: 2 PID: 3117789 at lib/list_debug.c:62 __list_del_entry_valid+0x119/0x130
> RIP: 0010:__list_del_entry_valid+0x119/0x130
> RIP: 0010:__list_del_entry_valid+0x119/0x130
> Call Trace:
>  <IRQ>
>  iocg_flush_stat.isra.0+0x11e/0x230
>  ? ioc_rqos_done+0x230/0x230
>  ? ioc_now+0x14f/0x180
>  ioc_timer_fn+0x569/0x1640
> 
> We haven't reporduced it yet, but we think this is due to parent iocg is
> freed before child iocg, and then in ioc_timer_fn, walk_list is
> corrupted.
> 
> 1) Remove child cgroup can concurrent with remove parent cgroup, and
> ioc_pd_free for parent iocg can be called before child iocg. This can be
> fixed by moving the handle of walk_list to ioc_pd_offline, since that
> offline from child is ensured to be called before parent.

Which you already did in a previous patch, right?

> 2) ioc_pd_free can be triggered from both removing device and removing
> cgroup, this patch fix the problem by deleting timer before deactivating
> policy, so that free parent iocg first in this case won't matter.

Okay, so, yeah, css's pin parents but blkg's don't. I think the right thing
to do here is making sure that a child blkg pins its parent (and eventually
ioc).

> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  block/blk-iocost.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 710cf63a1643..d2b873908f88 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2813,13 +2813,14 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
>  {
>  	struct ioc *ioc = rqos_to_ioc(rqos);
>  
> +	del_timer_sync(&ioc->timer);
> +
>  	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
>  
>  	spin_lock_irq(&ioc->lock);
>  	ioc->running = IOC_STOP;
>  	spin_unlock_irq(&ioc->lock);
>  
> -	del_timer_sync(&ioc->timer);

I don't about this workaround. Let's fix properly?

-- 
tejun
