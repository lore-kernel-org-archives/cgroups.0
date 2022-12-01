From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 9/9] blk-iocost: fix walk_list corruption
Date: Thu, 1 Dec 2022 00:29:11 -1000
Message-ID: <Y4iB97kcdKHEQP86@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-10-linan122@huawei.com>
 <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
 <c028dd77-cabf-edd6-c893-8ee24762ac8c@huaweicloud.com>
 <Y4h7RxdT83g+zFN0@slm.duckdns.org>
 <de04965e-1341-3053-0f4b-395b8390d00c@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q0yvFuHBJfRIpQvKHdUxBRA6+MC7NXxIM6ZLed908Mg=;
        b=jnaT62SdRfAmhvoMq4Z06tsiQjuTmLKUVCirP+nkHORlRzdErj6ufu5pb0uIJJlIBD
         5odOKusGLj7GLS/2OGCFrwhOioJLUfiBcCj1gaaHRbSeSDYaoSmk3m0QhnQ/iuaa9Hzw
         M4x4WiPzAfdSzjuOz9v3FimEerbjpgfr3rGvV/ELh5MRcM5OgsVe948XKOI1yuJz63IC
         PyMgP2bncRqEdSJg/5CFrSn+Ogy9xdjWqcrIAlkZC7ohRK1PODJ4uegtDYSp9eJ/f10e
         /F+riMH2OzCXjsANfrNwW4UozF3v7RiHFrm55N7DuOLvOeUpc3vZJb4RWXAVQhQhLSQQ
         KGCg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <de04965e-1341-3053-0f4b-395b8390d00c-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Dec 01, 2022 at 06:14:32PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2022/12/01 18:00, Tejun Heo 写道:
> > On Thu, Dec 01, 2022 at 09:19:54AM +0800, Yu Kuai wrote:
> > > > > diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> > > > > index 710cf63a1643..d2b873908f88 100644
> > > > > --- a/block/blk-iocost.c
> > > > > +++ b/block/blk-iocost.c
> > > > > @@ -2813,13 +2813,14 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
> > > > >    {
> > > > >    	struct ioc *ioc = rqos_to_ioc(rqos);
> > > > > +	del_timer_sync(&ioc->timer);
> > > > > +
> > > > >    	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
> > > > >    	spin_lock_irq(&ioc->lock);
> > > > >    	ioc->running = IOC_STOP;
> > > > >    	spin_unlock_irq(&ioc->lock);
> > > > > -	del_timer_sync(&ioc->timer);
> > > > 
> > > > I don't about this workaround. Let's fix properly?
> > > 
> > > Ok, and by the way, is there any reason to delete timer after
> > > deactivate policy? This seems a litter wreid to me.
> > 
> > ioc->running is what controls whether the timer gets rescheduled or not. If
> > we don't shut that down, the timer may as well get rescheduled after being
> > deleted. Here, the only extra activation point is IO issue which shouldn't
> > trigger during rq_qos_exit, so the ordering shouldn't matter but this is the
> > right order for anything which can get restarted.
> 
> Thanks for the explanation.
> 
> I'm trying to figure out how to make sure child blkg pins it's parent,
> btw, do you think following cleanup make sense?

It's on you to explain why any change that you're suggesting is better and
safe. I know it's not intentional but you're repeatedly suggesting operation
reorderings in code paths which are really sensitive to ordering at least
seemingly without putting much effort into thinking through the side
effects. This costs disproportionate amount of review bandwidth, and
increases the chance of new subtle bugs. Can you please slow down a bit and
be more deliberate?

Thanks.

-- 
tejun
