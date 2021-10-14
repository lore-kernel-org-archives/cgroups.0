From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 -next] blk-cgroup: synchoronize blkg creation against
 policy deactivation
Date: Thu, 14 Oct 2021 13:02:06 -1000
Message-ID: <YWi27oAU0v5v86eN@slm.duckdns.org>
References: <20211013124456.3186005-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=elTbg3LLUd0tVBsGRe2KL6JIDNTTkS+yo5Y7KpMBtaI=;
        b=cUpF41cCqBEdQM5Vy4oXPwRIalVbBy7qZLhMjEI1uIlTteb5LmN/H00giAunB22XcQ
         Rb1T6P5WxAbwd/9Z3VHFzv4bIkr+VLMZVbLZ5qYjwr4VTnONXCk+/+m3hgaIxZSS28Ll
         UPaRwwh3tga2xx+TEa/l+627I105dRlbE/h5kG91JTNhUTqK8VearSHYK2danHujFqv+
         /LCziI12wgBbNMkW2eLkVRb1OSr5fL8183BjyY9XTk2En4YutFwbN092cFqqBznkKIaJ
         UJ/2JRMxeZVoo716OzXfoHL3DgrprJ0Vc0zt8fiv7FwJKbKroFAVG8bG0XDtnjBVsbvs
         o9vQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211013124456.3186005-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: axboe@kernel.dk, paolo.valente@linaro.org, fchecconi@gmail.com, avanzini.arianna@gmail.com, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Wed, Oct 13, 2021 at 08:44:56PM +0800, Yu Kuai wrote:
> @@ -1401,6 +1406,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
>  	if (queue_is_mq(q))
>  		blk_mq_freeze_queue(q);
>  
> +	mutex_lock(&q->blkg_lock);
>  	spin_lock_irq(&q->queue_lock);

Given that deactivation drains q_usage_counter through
blk_mq_freeze_queue(), can't the blkg_conf_prep() just pin the usage count?

Thanks.

-- 
tejun
