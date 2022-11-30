From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 8/9] block: fix null-pointer dereference in
 ioc_pd_init
Date: Wed, 30 Nov 2022 10:50:27 -1000
Message-ID: <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-9-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HY7HR+jxU6TKM04v8zsj6/Dqk0zLgSsOGTMBo35NxdY=;
        b=BP6ht7VEuPlqXkYDyD/Uy4Vfo9GZIQRn2NXCSz31myYLsS/qsm4c23xVx7FpBTlxCA
         Mr6yS7bSbO79UEnQYaajN846XpciQ/Dx3c82KEzkU1+FF7b9JAKqjn3U+iRH6ocXglja
         6qxlpvDHVlMAiqeX6pn57vP31gsUzuBJgcZ27+YDDI56REblo/n8ZFXvq5jG9F17zWFx
         9pSC5Kvn1zOUkaSY3dCXlpy2c2odJBfBI5PxT7DGYQX6IiasEmjB5wxXIgbn9HKndMFe
         TvQaedBj+0RUPVdLc/2trbZiy3bTD6Q4ZVfd+Uic6WfxL86VANrSHyVXe2CkucO3OcHa
         OCPg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-9-linan122@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Wed, Nov 30, 2022 at 09:21:55PM +0800, Li Nan wrote:
> Remove block device when iocost is initializing may cause
> null-pointer dereference:
> 
> 	CPU1				   CPU2
>   ioc_qos_write
>    blkcg_conf_open_bdev
>     blkdev_get_no_open
>      kobject_get_unless_zero
>     blk_iocost_init
>      rq_qos_add
>   					del_gendisk
>   					 rq_qos_exit
>   					  q->rq_qos = rqos->next
>   					   //iocost is removed from q->roqs
>       blkcg_activate_policy
>        pd_init_fn
>         ioc_pd_init
>   	 ioc = q_to_ioc(blkg->q)
>  	  //cant find iocost and return null
> 
> Fix problem by moving rq_qos_exit() to disk_release(). ioc_qos_write() get
> bd_device.kobj in blkcg_conf_open_bdev(), so disk_release will not be
> actived until iocost initialization is complited.

I think it'd be better to make del_gendisk wait for these in-flight
operations because this might fix the above particular issue but now all the
policies are exposed to request_queue in a state it never expected before.

del_gendisk() is quiescing the queue around rq_qos_exit(), so maybe we can
piggyback on that and update blkcg_conf_open_bdev() to provide such
exclusion?

Thanks.

-- 
tejun
