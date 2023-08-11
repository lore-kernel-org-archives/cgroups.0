From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Fri, 11 Aug 2023 08:12:55 -0600
Message-ID: <169176317573.160467.10047297090390573799.b4-ty@kernel.dk>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691763177; x=1692367977;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWMKdnKHrY3LQ9ReS3XwKKHFwVtuTf0+tBs6vf39oT8=;
        b=ad3sF0Wk5FwYKsnJyn8rp/uYplx8QvXFTFPuX6slqoJ0rG30m4ydbRabAgWupwzr2Z
         fJLRWDJfTkQ285jQMj9pZsCSsuA44QfT3n8X0C6dQUywz0sn20GuiibBH1DGHxLA42nN
         sbe6hNOUgCr1DytcXdi2vDecqymQiQxBnOwgxNs/pKbTu4g/debR3e+YYNjHhVf/lwir
         oI6oAj1aSxFpru89EKB7n5+rsHcfJl0d9Nz3NaCtmejMDecbr/+6NZZib0ViFYl+lMc4
         qNeugB6bCtbZTKQakX72trtAZGMnHdaaNuT6zmY21JxCGjgX848GQqaRFBYy1I8Gw2m4
         ZEHg==
In-Reply-To: <20230810035111.2236335-1-lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


On Thu, 10 Aug 2023 11:51:11 +0800, Li Lingfeng wrote:
> Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
> a mutex named "init_mutex" in blk_iolatency_try_init for the race
> condition of initializing RQ_QOS_LATENCY.
> Now a new lock has been add to struct request_queue by commit a13bd91be223
> ("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
> held in blkg_conf_open_bdev before calling blk_iolatency_init.
> So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
> remove it.
> 
> [...]

Applied, thanks!

[1/1] block: remove init_mutex and open-code blk_iolatency_try_init
      commit: 4eb44d10766ac0fae5973998fd2a0103df1d3fe1

Best regards,
-- 
Jens Axboe



