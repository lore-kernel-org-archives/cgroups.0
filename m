From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 7/9] blk-iocost: fix UAF in ioc_pd_free
Date: Wed, 30 Nov 2022 10:42:14 -1000
Message-ID: <Y4fAJpKcVL7Q9hgY@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-8-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gRiXbnbK/Q1F4+mT6/8iecEnTJ4rVIRUMTLO6vZSP0U=;
        b=a7uQvELPQf41UY3d1GLOaGp74BzQq3uslTfVIAR2Nz0P5TgkgJkSBC0HyZ0A5gDTLD
         tkuybQjLUVTgkCX92AibStZwbL/aoL5X5hKhcH/ABIe2b0lWsF+xTygcUMHPPEkpAZSU
         5eC7HSVOTKWKeVniYtE57w4dTbCqXah8gnylGrOi5cB0LMA8nVXQZxioQxh6YVfS9Vfe
         n/SyThpfeIeDhkq3HXqkVBAVig/27wyxaHkWjEWD5YRgXALdg4QEpKVaZy1hMnDDZ7Su
         Xjl+/slVMQ50UfzDJJAjEdjubt27rVSfNKU7Iur5CHSv42zIHMbkVckeCwlibg11BSjw
         BoLg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-8-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Nov 30, 2022 at 09:21:54PM +0800, Li Nan wrote:
> 	T1		     T2			T3
>   //delete device
>   del_gendisk
>    bdi_unregister
>     bdi_remove_from_list
>      synchronize_rcu_expedited
> 
> 		         //rmdir cgroup
> 		         blkcg_destroy_blkgs
> 		          blkg_destroy
> 		           percpu_ref_kill
> 		            blkg_release
> 		             call_rcu
>    rq_qos_exit
>     ioc_rqos_exit
>      kfree(ioc)
> 					   __blkg_release
> 					    blkg_free
> 					     blkg_free_workfn
> 					      pd_free_fn
> 					       ioc_pd_free
> 						spin_lock_irqsave
> 						 ->ioc is freed
> 
> Fix the problem by moving the operation on ioc in ioc_pd_free() to
> ioc_pd_offline(), and just free resource in ioc_pd_free() like iolatency
> and throttle.
> 
> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

I wonder what we really wanna do is pinning ioc while blkgs are still around
but I think this should work too.

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
