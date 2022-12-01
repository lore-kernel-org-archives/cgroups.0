From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next v2 8/9] block: fix null-pointer dereference in
 ioc_pd_init
Date: Thu, 1 Dec 2022 00:31:10 -1000
Message-ID: <Y4iCbuALBBGLODWI@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-9-linan122@huawei.com>
 <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
 <9ca2b7ab-7fd3-a9a3-12a6-021a78886b54@huaweicloud.com>
 <Y4h94m8QMPtS4xJV@slm.duckdns.org>
 <431dcb3f-4572-7fd0-9e5d-90b6c34d577c@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lC4h75dh+3IE6iSBYmQlNa7ll+YBh2sVpnAtr9WVaso=;
        b=ByAibcDVmt0W60dpTosow7EH8me0TGKi/eAI5Q9Gl9tW3HldQqJ+STDuyGLZKEHYt5
         EkpSGrBvOhXN1tpEbZOtx3srwDQqvvwAOaZ9ecOEaTYOoARoNQjZdrhH5V6WrPI0SZag
         6Y3BBsvFy7GVPIeyXZfOqAFKJa8sSbBYZRV7VfdzEVw1i0Iv02CJbW22NFsrmFt7mPUD
         Em/4mvLH+4Jdn/eoxHuhu9hncj5SQ2QLM9wmt0noqqCbyKEtDMnlM/ff3Dq2lzCplqGb
         gq/uzYiNUAEJn//sorb8I+sbppA4HfKd5LA2lb2UdttoLs0w1Kcje7BU5LYvhxPIr9Vs
         OE6Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <431dcb3f-4572-7fd0-9e5d-90b6c34d577c@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Li Nan <linan122@huawei.com>, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On Thu, Dec 01, 2022 at 06:23:16PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2022/12/01 18:11, Tejun Heo 写道:
> > On Thu, Dec 01, 2022 at 10:12:13AM +0800, Yu Kuai wrote:
> > > 1) By mentioning that "del_gendisk() is quiescing the queue", do you
> > > suggest to add rcu_read_lock()? This seems wrong because blk_iocost_init
> > > requires memory allocation.
> > 
> > Quiescing uses SRCU so that should be fine but I'm not sure whether this is
> > the right one to piggyback on. Jens should have a better idea.
> > 
> > Thanks.
> > 
> 
> Currently SRCU is used if BLK_MQ_F_BLOCKING set, otherwise RCU is used.
> 
> dispatch:
> #define __blk_mq_run_dispatch_ops(q, check_sleep, dispatch_ops) \
> do {                                                            \
>         if ((q)->tag_set->flags & BLK_MQ_F_BLOCKING) {          \
>                 int srcu_idx;                                   \
>                                                                 \
>                 might_sleep_if(check_sleep);                    \
>                 srcu_idx = srcu_read_lock((q)->tag_set->srcu);  \
>                 (dispatch_ops);                                 \
>                 srcu_read_unlock((q)->tag_set->srcu, srcu_idx); \
>         } else {                                                \
>                 rcu_read_lock();                                \
>                 (dispatch_ops);                                 \
>                 rcu_read_unlock();                              \
>         }                                                       \
> } while (0)
> 
> quiesce:
> void blk_mq_wait_quiesce_done(struct blk_mq_tag_set *set)
> {
>         if (set->flags & BLK_MQ_F_BLOCKING)
>                 synchronize_srcu(set->srcu);
>         else
>                 synchronize_rcu();
> }

Oh I see. Unfortunately, I don't know what to do off the top of my head.

Thanks.

-- 
tejun
