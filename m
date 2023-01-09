From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Mon, 9 Jan 2023 08:23:34 -1000
Message-ID: <Y7xbpidpq7+DqJan@slm.duckdns.org>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-2-yukuai1@huaweicloud.com>
 <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
 <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
 <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NgVKC3NmcxxKrnQWmSerqqDaGhLOMoPMCbrmW5GVKVk=;
        b=qewQu0vk4Nwlo4LFhzKWR6EMnRJh/XhktdhcuuMLJzHXnLsWf8U7fgWVovAVzLQgLe
         DeAEVAeyCjNwGPETUlQL6Nb17w8G/1bsiS/0/qc7clbmBVPMWLaVQ9JljHwXzt5cJA2+
         aSxCPG8HvjEcZvwjL+wRu1fZKx1Qx/DpAB/9v4gjX+99NiJv/8/866g3KaKAM6DAehOY
         7TbHUhRsPDtNNqHcqjxNHyGFPqMQ6WIhMiuFxm0AjfzwupH8ibQAs/oPDTIPyoHYIMsx
         1GpJDL5vWZJu1nQq+wpHacVi3pRyjumovgtqe7jEPXeDvyWSmldn+4FUP6xZBBocggZx
         rWLA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hello,

On Mon, Jan 09, 2023 at 09:32:46AM +0800, Yu Kuai wrote:
> >   59b57717fff8 ("blkcg: delay blkg destruction until after writeback has finished")
> >   d866dbf61787 ("blkcg: rename blkcg->cgwb_refcnt to ->online_pin and always use it")
> 
> These two commits are applied for three years, I don't check the details
> yet but they seem can't guarantee that no io will be handled by
> rq_qos_throttle() after pd_offline_fn(), because I just reproduced this
> in another problem:
> 
> f02be9002c48 ("block, bfq: fix null pointer dereference in bfq_bio_bfqg()")
> 
> User thread can issue async io, and io can be throttled by
> blk-throttle(not writeback), then user thread can exit and cgroup can be
> removed before such io is dispatched to rq_qos_throttle.

I see.

> > After the above two commits, ->pd_offline_fn() is called only after all
> > possible writebacks are complete, so it shouldn't allow mass escapes to
> > root. With writebacks out of the picture, it might be that there can be no
> > further IOs once ->pd_offline_fn() is called too as there can be no tasks
> > left in it and no dirty pages, but best to confirm that.
> > 
> > So, yeah, the original approach you took should work although I'm not sure
> > the patches that you added to make offline blkg to bypass are necessary
> > (that also contributed to my assumption that there will be more IOs on those
> > blkg's). Have you seen more IOs coming down the pipeline after offline? If
> > so, can you dump some backtraces and see where they're coming from?
> 
> Currently I'm sure such IOs can come from blk-throttle, and I'm not sure
> yet but I also suspect io_uring can do this.

Yeah, that's unfortunate. There are several options here:

1. Do what you originally suggested - bypass to root after offline. I feel
   uneasy about this. Both iolatency and throtl clear their configs on
   offline but that's punting to the parent. For iocost it'd be bypassing
   all controls, which can actually be exploited.

2. Make all possible IO issuers use blkcg_[un]pin_online() and shift the
   iocost shutdown to pd_offline_fn(). This likely is the most canonical
   solution given the current situation but it's kinda nasty to add another
   layer of refcnting all over the place.

3. Order blkg free so that parents are never freed before children. You did
   this by adding refcnts in iocost but shouldn't it be possible to simply
   shift blkg_put(blkg->parent) in __blkg_release() to blkg_free_workfn()?

#3 seems the most logical to me. What do you thinK?

Thanks.

-- 
tejun
