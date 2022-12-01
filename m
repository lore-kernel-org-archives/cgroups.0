From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 9/9] blk-iocost: fix walk_list corruption
Date: Thu, 1 Dec 2022 00:00:39 -1000
Message-ID: <Y4h7RxdT83g+zFN0@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-10-linan122@huawei.com>
 <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
 <c028dd77-cabf-edd6-c893-8ee24762ac8c@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RvAcF4yt3U38ulka5v5lZO8tAA6N2kN/9W8fhnuQ3DA=;
        b=PthsZ+Q8Y6NJRwPCIBP8MuFSXijY5REyP5RtsSO9OPxZiWTEKKwFMOos6DjWLQvBKM
         9+68aLFA2KJibeLzcXKW+TRr0f8kBeVJPCy/2qKzfHy90Fie4M+cp5nPkc4pk11SeAia
         jH57uge2Q/jZXwDKyyUdiowPc6qMj7ayVGHpMarZsh6DN2oGN8wu5NKo3Iqfpk4ydUIY
         gmi0PquZQL7ahFmfCvPlElkpeJ25wvgTILpt2DQBpdv8azUNSn4Cu5/LBB5hDW8mQ6bU
         yoe5DDNTuabeiXazVGv43j+CRYcNSOCynorXMDyO4wEWc21G3Ob/mnt/+/tlpaqSP8bC
         8inw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c028dd77-cabf-edd6-c893-8ee24762ac8c-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Dec 01, 2022 at 09:19:54AM +0800, Yu Kuai wrote:
> > > diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> > > index 710cf63a1643..d2b873908f88 100644
> > > --- a/block/blk-iocost.c
> > > +++ b/block/blk-iocost.c
> > > @@ -2813,13 +2813,14 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
> > >   {
> > >   	struct ioc *ioc = rqos_to_ioc(rqos);
> > > +	del_timer_sync(&ioc->timer);
> > > +
> > >   	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
> > >   	spin_lock_irq(&ioc->lock);
> > >   	ioc->running = IOC_STOP;
> > >   	spin_unlock_irq(&ioc->lock);
> > > -	del_timer_sync(&ioc->timer);
> > 
> > I don't about this workaround. Let's fix properly?
> 
> Ok, and by the way, is there any reason to delete timer after
> deactivate policy? This seems a litter wreid to me.

ioc->running is what controls whether the timer gets rescheduled or not. If
we don't shut that down, the timer may as well get rescheduled after being
deleted. Here, the only extra activation point is IO issue which shouldn't
trigger during rq_qos_exit, so the ordering shouldn't matter but this is the
right order for anything which can get restarted.

Thanks.

-- 
tejun
