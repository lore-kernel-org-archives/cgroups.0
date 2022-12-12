From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 8/9] block: fix null-pointer dereference in
 ioc_pd_init
Date: Mon, 12 Dec 2022 13:10:26 -1000
Message-ID: <Y5e04oKUEEBXqaar@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-9-linan122@huawei.com>
 <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
 <9ca2b7ab-7fd3-a9a3-12a6-021a78886b54@huaweicloud.com>
 <Y4h94m8QMPtS4xJV@slm.duckdns.org>
 <431dcb3f-4572-7fd0-9e5d-90b6c34d577c@huaweicloud.com>
 <Y4iCbuALBBGLODWI@slm.duckdns.org>
 <96487803-12cc-a694-0099-784106596fd1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pZDS6utjeiGgDa4ROrpBjFTGSUb0kKrpSXUgc52VtJQ=;
        b=UHxmfk1YIHXsZ85vl3BmRcLrv+A1Wp3ORhoNKMvbeYIUXxQ4ia3UjLJZKbeNpzf3ft
         PQrFrZEd5zgvcWqD2VNQxlOCIQtzLLs6fHCfeKAon4O6OKOA23xekPOnaoNTHHZ1wupA
         AOZ+YkdKvIoKQ5xbffbb4q6KJfp1BQT3cGhb5ywjnEgH+9PXk/AVhBOs0XATIRRLwkt3
         Wi/8WSCzOjyBTAOfyjs2giiLdVrQRhsv8mNdsWVl1WXZqe2BQr5U31iu1I5VPO/PsfIn
         L7QQipFlfPjM4sXnc/uLQCbhOnwaf8oZunAZU2sD4G8JV88hECgQVfv3v2adMDXzqJkH
         X6oA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <96487803-12cc-a694-0099-784106596fd1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Dec 05, 2022 at 05:32:17PM +0800, Yu Kuai wrote:
> 1) queue_lock is held to protect rq_qos_add() and rq_qos_del(), whlie
> it's not held to protect rq_qos_exit(), which is absolutely not safe
> because they can be called concurrently by configuring iocost and
> removing device.
> I'm thinking about holding the lock to fetch the list and reset
> q->rq_qos first:
> 
> diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
> index 88f0fe7dcf54..271ad65eebd9 100644
> --- a/block/blk-rq-qos.c
> +++ b/block/blk-rq-qos.c
> @@ -288,9 +288,15 @@ void rq_qos_wait(struct rq_wait *rqw, void
> *private_data,
> 
>  void rq_qos_exit(struct request_queue *q)
>  {
> -       while (q->rq_qos) {
> -               struct rq_qos *rqos = q->rq_qos;
> -               q->rq_qos = rqos->next;
> +       struct rq_qos *rqos;
> +
> +       spin_lock_irq(&q->queue_lock);
> +       rqos = q->rq_qos;
> +       q->rq_qos = NULL;
> +       spin_unlock_irq(&q->queue_lock);
> +
> +       while (rqos) {
>                 rqos->ops->exit(rqos);
> +               rqos = rqos->next;
>         }
>  }
> 
> 2) rq_qos_add() can still succeed after rq_qos_exit() is done, which
> will cause memory leak. Hence a checking is required beforing adding
> to q->rq_qos. I'm thinking about flag QUEUE_FLAG_DYING first, but the
> flag will not set if disk state is not marked GD_OWNS_QUEUE. Since
> blk_unregister_queue() is called before rq_qos_exit(), use the queue
> flag QUEUE_FLAG_REGISTERED should be OK.
> 
> For the current problem that device can be removed while initializing
> , I'm thinking about some possible solutions:
> 
> Since bfq is initialized in elevator initialization, and others are
> in queue initialization, such problem is only possible in iocost, hence
> it make sense to fix it in iocost:

So, iolatency is likely to switch to similar lazy init scheme, so we better
fix it in the rq_qos / core block layer.

...
> 3) Or is it better to fix it in the higher level? For example:
> add a new restriction that blkcg_deactivate_policy() should be called
> with blkcg_activate_policy() in pairs, and blkcg_deactivate_policy()
> will wait for blkcg_activate_policy() to finish. Something like:
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index ef4fef1af909..6266f702157f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1410,7 +1410,7 @@ int blkcg_activate_policy(struct request_queue *q,
>         struct blkcg_gq *blkg, *pinned_blkg = NULL;
>         int ret;
> 
> -       if (blkcg_policy_enabled(q, pol))
> +       if (WARN_ON_ONCE(blkcg_policy_enabled(q, pol)))
>                 return 0;
> 
>         if (queue_is_mq(q))
> @@ -1477,6 +1477,8 @@ int blkcg_activate_policy(struct request_queue *q,
>                 blkg_put(pinned_blkg);
>         if (pd_prealloc)
>                 pol->pd_free_fn(pd_prealloc);
> +       if (!ret)
> +               wake_up(q->policy_waitq);
>         return ret;
> 
>  enomem:
> @@ -1512,7 +1514,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
>         struct blkcg_gq *blkg;
> 
>         if (!blkcg_policy_enabled(q, pol))
> -               return;
> +               wait_event(q->policy_waitq, blkcg_policy_enabled(q, pol));
>    wait_event(q->xxx, blkcg_policy_enabled(q, pol));

Yeah, along this line but hopefully something simpler like a mutex.

Thanks.

-- 
tejun
