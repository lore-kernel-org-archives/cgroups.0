From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next 0/4] blk-cgroup: synchronize del_gendisk() with
 configuring cgroup policy
Date: Mon, 19 Dec 2022 10:55:57 -1000
Message-ID: <Y6DP3aOSad8+D1yY@slm.duckdns.org>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NakfROSMki8cV2nnpMoQ1MJIRum6ZgALihcXreebAZQ=;
        b=P9vTDBW4Z9V3T+vz64KijYP0mRwH/VSJa3JCdcPiIQ8AckWvIFsGQVP9FZKvi0ENkr
         1iFYZCLDOJljki+cWdV2+/aQdMYLTHmsVq0uLQ8/VGQcQORfO1eTRB4xyZi/viWROc1H
         Zpm2AvuHS8iRTJngk6WIbwIDOjlMe7N9wHr2/MPlcTPD8bUALFqvER4S0Cq4/zhB5RNG
         2nRPGHMhjgP99prOQ3hUchptv3SsOS/A+CYtVYvc5w55arPw+hxIrkBXcdSVD5wwonlD
         8LkK2tpGZVXLH58UsGQ1HdFqMn1ZcCj7+IJPojJSk3Qr5+CxgUnLSfzAUwBMBQwnPE8e
         IFaQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Hello,

On Sat, Dec 17, 2022 at 11:09:04AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> iocost is initialized when it's configured the first time, and iocost
> initializing can race with del_gendisk(), which will cause null pointer
> dereference:
> 
> t1				t2
> ioc_qos_write
>  blk_iocost_init
>   rq_qos_add
>   				del_gendisk
>   				 rq_qos_exit
>   				 //iocost is removed from q->roqs
>   blkcg_activate_policy
>    pd_init_fn
>     ioc_pd_init
>      ioc = q_to_ioc(blkg->q)
>      //can't find iocost and return null
> 
> And iolatency is about to switch to the same lazy initialization.
> 
> This patchset fix this problem by synchronize rq_qos_add() and
> blkcg_activate_policy() with rq_qos_exit().

So, the patchset seems a bit overly complicated to me. What do you think
about the following?

* These init/exit paths are super cold path, just protecting them with a
  global mutex is probably enough. If we encounter a scalability problem,
  it's easy to fix down the line.

* If we're synchronizing this with a mutex anyway, no need to grab the
  queue_lock, right? rq_qos_add/del/exit() can all just hold the mutex.

* And we can keep the state tracking within rq_qos. When rq_qos_exit() is
  called, mark it so that future adds will fail - be that a special ->next
  value a queue flag or whatever.

Thanks.

-- 
tejun
