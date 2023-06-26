From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v3 0/5] blk-wbt: minor fix and cleanup
Date: Mon, 26 Jun 2023 09:53:51 -0600
Message-ID: <168779483122.109817.4432808514358640761.b4-ty@kernel.dk>
References: <20230527010644.647900-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687794833; x=1690386833;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxYUiFwhtDVlTAVmP0i5cJapN3iCRWyez54K4Q3M5K0=;
        b=fdLOwHJv7E9Y9/oI7jGWPCAUo74FJC0T9kGCDMP3eKcy54hd6ejtYByg0NmOoIEdyr
         gj0afBnKBBbvcnvlJSD3tWZwAQK857zOub5M2aClWt8xZVL1eEu/MH3R3eNfCtShp8NK
         vzVrZP0lQhR8CvJ5TIK7Cs3q2y2rUoay2IjYw8OpjA7Qwe0AiARj7mTmz2FCvlMzjUnp
         KOV71fe4ad7eK13d6b8MlCIs0HqJLoGIwBH/rxN2f5CHWqmveJ63YVCcyPay8/+4K32z
         JnewvYc+JGyJ59T3v0VmPLUuvFOXAeDAPif976GY9jj1VlABIR08gifXKJBP4XXJNKDC
         cILQ==
In-Reply-To: <20230527010644.647900-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-jcswGhMUV9g@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


On Sat, 27 May 2023 09:06:39 +0800, Yu Kuai wrote:
> Changes in v3:
>  - patch 1 from v2 is sent separately, and it's removd from this series.
>  - add review tag for all the patches.
> 
> Changes in v2:
>  - make the code more readable for patch 1
>  - add a new attr_group that is only visible for rq based device
>  - explain in detail for patch 4
>  - add review tag for patch 2,3,5
> 
> [...]

Applied, thanks!

[1/5] blk-wbt: don't create wbt sysfs entry if CONFIG_BLK_WBT is disabled
      commit: 645a829e03384a235b3760959d4ebe420a0f2027
[2/5] blk-wbt: remove dead code to handle wbt enable/disable with io inflight
      commit: 71b8642e79f277459555629f2bea1a8d1fed307e
[3/5] blk-wbt: cleanup rwb_enabled() and wbt_disabled()
      commit: 06257fda83ebfd1c33fb992e41dba7be4e1184d4
[4/5] blk-iocost: move wbt_enable/disable_default() out of spinlock
      commit: eebc21d12f56c1e09a163abf91e351fa2a55a938
[5/5] blk-sysfs: add a new attr_group for blk_mq
      commit: 6d85ebf95c44e52337ca1d07f0db4b435d1e6762

Best regards,
-- 
Jens Axboe



