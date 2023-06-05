From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blk-iocost: use spin_lock_irqsave in
 adjust_inuse_and_calc_cost
Date: Mon, 5 Jun 2023 08:04:57 -1000
Message-ID: <ZH4jya9ksKbHEf7s@slm.duckdns.org>
References: <20230527091904.3001833-1-linan666@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685988300; x=1688580300;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t2136RPrE8cIqKFm6zKV8pbC6YzWjr8qGOFW6BAbSLU=;
        b=JlVEo8WjgnOT89+kJYMSrKxEpAoprSjV4/2bNXjFC/7jh3lUEN0ff4hOOeUv+EgfOu
         wGmYHMvrCFJo18+Lj0Ff3lCTRgDTsp+dprXa8SKYXVV0oqA63oDU4WYJNhOnhZnp4cjP
         Nos7N88L+AFufa1BC/J3cKCMwyjRwdfaAxaILKfVDPEiAc5CLuTex8Y9LjPEsY7ISPIU
         OZqcON9mDAoMNWeba1eD72jSl3NYCWJI8Wju+vbW/BsvCfj93bf5jaSyBLt2jv1+VOzo
         KPlDGWq9wwdAcA4AcrMCq5fiaqK4S0SYH3qSnABSs2xiDx1PiBSoF0SFkKQW8FHC3ygB
         GmVQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230527091904.3001833-1-linan666@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linan666@huaweicloud.com
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linan122@huawei.com, yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com

On Sat, May 27, 2023 at 05:19:04PM +0800, linan666@huaweicloud.com wrote:
> From: Li Nan <linan122@huawei.com>
> 
> adjust_inuse_and_calc_cost() use spin_lock_irq() and IRQ will be enabled
> when unlock. DEADLOCK might happen if we have held other locks and disabled
> IRQ before invoking it.
> 
> Fix it by using spin_lock_irqsave() instead, which can keep IRQ state
> consistent with before when unlock.
...
> Fixes: b0853ab4a238 ("blk-iocost: revamp in-period donation snapbacks")
> Signed-off-by: Li Nan <linan122@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
