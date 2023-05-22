From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-6.4/block] block/rq_qos: protect rq_qos apis with a
 new lock
Date: Mon, 22 May 2023 10:59:31 -1000
Message-ID: <ZGvXs8zmXcxsxL9D@slm.duckdns.org>
References: <20230414084008.2085155-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684789174; x=1687381174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REd5LAfz4pnrlWJeTXd7TNxPZb5If45Ls7fcUl4wW74=;
        b=lRz3eawJzzyIYWWtoGkyPPVw4Nh3+OLy6jFJMU+raeIShsezJRKl644EXFjT8VXibp
         HtJYoF9JEJBg1ClhPIoL6RiIcabDVfxMQPhGwQIHtkl7W0bHy7yjiwWYtoFH9LBHhYOU
         JEiONdLbci65yJjPkYqVHntuJUL81Tsa0epXl5zHQ1Oe8SuyaMT1EvhdvIUB2HjHhQHl
         Vs28CO3mP8kL3yjk9PfS8QV4l6+YVEYuPDyAMycXEGEcuUDzt+xC/uWjuHpt/UNCHrz/
         BYyWPHtO5gNxmtmuteRhpakBhlwavqOtp7CZh4twewBcTdi8yL/m+ozPxlptx9Fyn0o1
         tmQg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230414084008.2085155-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Apr 14, 2023 at 04:40:08PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> commit 50e34d78815e ("block: disable the elevator int del_gendisk")
> move rq_qos_exit() from disk_release() to del_gendisk(), this will
> introduce some problems:
> 
> 1) If rq_qos_add() is triggered by enabling iocost/iolatency through
>    cgroupfs, then it can concurrent with del_gendisk(), it's not safe to
>    write 'q->rq_qos' concurrently.
> 
> 2) Activate cgroup policy that is relied on rq_qos will call
>    rq_qos_add() and blkcg_activate_policy(), and if rq_qos_exit() is
>    called in the middle, null-ptr-dereference will be triggered in
>    blkcg_activate_policy().
> 
> 3) blkg_conf_open_bdev() can call blkdev_get_no_open() first to find the
>    disk, then if rq_qos_exit() from del_gendisk() is done before
>    rq_qos_add(), then memory will be leaked.
> 
> This patch add a new disk level mutex 'rq_qos_mutex':
> 
> 1) The lock will protect rq_qos_exit() directly.
> 
> 2) For wbt that doesn't relied on blk-cgroup, rq_qos_add() can only be
>    called from disk initialization for now because wbt can't be
>    destructed until rq_qos_exit(), so it's safe not to protect wbt for
>    now. Hoever, in case that rq_qos dynamically destruction is supported
>    in the furture, this patch also protect rq_qos_add() from wbt_init()
>    directly, this is enough because blk-sysfs already synchronize
>    writers with disk removal.
> 
> 3) For iocost and iolatency, in order to synchronize disk removal and
>    cgroup configuration, the lock is held after blkdev_get_no_open()
>    from blkg_conf_open_bdev(), and is released in blkg_conf_exit().
>    In order to fix the above memory leak, disk_live() is checked after
>    holding the new lock.
> 
> Fixes: 50e34d78815e ("block: disable the elevator int del_gendisk")
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
